# frozen_string_literal: true

# Transfer data from one DB to another. In practice, from my dev box to the production server.
# Crucially, it preserves ids.
#
# This probably doesn't work for all data types and not for strings containing quotes, but it's
# good for the tables I use it for. It detects quote problems, but not unusual data types.

require 'csv'

class DbTransfer

  NULL_CODE = "N@LL"

  def self.write_new_data(model_class, old_max_id)
    file_name = Time.now.strftime("DB_Trf_#{model_class.table_name}_#{old_max_id}_%b%d_%H-%M.csv")
    column_names = model_class.columns.map(&:name)

    CSV.open(file_name, "wb") do |csv|
      csv << [model_class.name, old_max_id] # line 1
      csv << column_names                   # line 2

      model_class.where('id > ?', old_max_id).find_each do |model_obj|
        values = column_names.map { |column| model_obj[column] || NULL_CODE }
        raise "Single quote detected: #{values}" if values.join.include?("'")
        csv << values
      end

      puts "Wrote #{file_name}"
    end

  end

  def self.load_data(filename, for_real = false)
    line = 0
    model_class = nil
    column_names = nil
    next_log = 100
    CSV.foreach(filename) do |row|
      line += 1

      if line == 1
        model_class = Object.const_get(row[0])
        max_id = row[1].to_i

        if max_id != model_class.maximum(:id)
          msg  = "Max id doesn't match. Expected: #{max_id}. Actual: #{model_class.maximum(:id)}"
          if for_real
            raise msg
          else
            puts msg
          end
        end
      elsif line == 2
        column_names = row
        if column_names != model_class.columns.map(&:name)
          raise "Column names don't match. Expected: #{column_names}. Actual: #{model_class.columns.map(&:name)}"
        end

        puts "#{filename} looks valid. Starting transfer."
      else
        values = row.map{|value| value == NULL_CODE ? 'NULL' : "'#{value}'"}
        sql = "INSERT INTO #{model_class.table_name} (#{column_names.join(",")}) VALUES (#{values.join(',')})"
        if for_real
          ActiveRecord::Base.connection.execute(sql)
          if line == next_log+2
            puts "Inserted #{next_log} records"
            next_log *= 2
          end
        else
          puts sql
        end
      end
    end
    puts "Handled #{line} lines in #{filename}"
  end

end