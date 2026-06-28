# frozen_string_literal: true

# I write and load the data for `db/seeds.rb`
class Seeder
  SEED_DIR = Dir.pwd + '/seed_data'

  WCA_USERS_FILE    = SEED_DIR+'/wca_users_sample.csv'
  POSITIONS_FILE    = SEED_DIR+'/positions.csv'
  RAW_ALG_BULK_FILE = SEED_DIR+'/raw_alg_bulk.csv'
  RAW_ALG_EXTRA_FILE= SEED_DIR+'/raw_alg_extra.csv'
  COMBO_ALG_FILE    = SEED_DIR+'/combo_alg_bulk.csv'


  def self.write # This is meant to run on Lars' machine
    execute("COPY (SELECT * FROM positions) TO '#{POSITIONS_FILE}'")

    last_bulk_id = RawAlg.where(length: 13).pluck(:id).max
    execute("COPY (SELECT * FROM raw_algs WHERE id <= (#{last_bulk_id})) TO '#{RAW_ALG_BULK_FILE}'")

    top_few_per_pos = []
    Position.real.each do |pos|
      top_few_per_pos += RawAlg.where(position_id: pos.id).order(:length).limit(2).pluck(:id)
      top_few_per_pos += RawAlg.where(position_id: pos.id).order(:_speed).limit(2).pluck(:id)
    end

    # Ensure RawAlg.name has the same names as prod
    first_of_each_length = %w(F1 G1 H1 I1 J1 K1 L1 M1 O1 P1 Q1).map{|name| RawAlg.id(name) }

    last_length8_alg = RawAlg.id(:I1)-1
    combo_alg_where = "alg1_id <= #{last_length8_alg} AND alg2_id <= #{last_length8_alg}"
    combo_ra_ids = ComboAlg.where(combo_alg_where).pluck(:combined_alg_id)

    extra_ids = (top_few_per_pos + first_of_each_length + combo_ra_ids).uniq.sort.select{|id| id > last_bulk_id }

    execute("COPY (SELECT * FROM raw_algs WHERE id in (#{extra_ids.join(',')})) TO '#{RAW_ALG_EXTRA_FILE}'")

    execute("COPY (SELECT * FROM combo_algs WHERE #{combo_alg_where}) TO '#{COMBO_ALG_FILE}'")
  end

  def self.load
    t1 = Time.now
    puts "Loading seed data"

    if WcaUser.count == 0
      copy_from_stdin("COPY wca_users (id, wca_db_id, wca_id, full_name, created_at, updated_at) FROM STDIN", WCA_USERS_FILE)
      puts "- WcaUsers loaded: #{Util.duration_to_s(t1)}"
    end

    if Position.count == 0
      copy_from_stdin("COPY positions (id, ll_code, weight, best_alg_id, cop, oll, eo, ep, optimal_alg_length, co, cp, mirror_id, inverse_id, main_position_id, pov_offset) FROM STDIN", POSITIONS_FILE)
      puts "- Positions loaded: #{Util.duration_to_s(t1)}"
    end

    if RawAlg.count == 0
      copy_from_stdin("COPY raw_algs (id, length, position_id, u_setup, specialness, _speed, _moves) FROM STDIN", RAW_ALG_BULK_FILE)
      copy_from_stdin("COPY raw_algs (id, length, position_id, u_setup, specialness, _speed, _moves) FROM STDIN", RAW_ALG_EXTRA_FILE)
      puts "- Raw algs loaded: #{Util.duration_to_s(t1)}"
    end

    if ComboAlg.count == 0
      copy_from_stdin("COPY combo_algs (id, alg1_id, alg2_id, combined_alg_id, encoded_data, position_id) FROM STDIN", COMBO_ALG_FILE)
      puts "- Combo algs loaded: #{Util.duration_to_s(t1)}"
    end

    [WcaUser, Position, RawAlg, ComboAlg].each { |model_class| ActiveRecord::Base.connection.reset_pk_sequence!(model_class.table_name)}
  end

  def self.execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.copy_from_stdin(sql, file_path)
    conn = ActiveRecord::Base.connection.raw_connection
    conn.copy_data(sql) do
      File.open(file_path, 'r') do |f|
        while chunk = f.read(65536)
          conn.put_copy_data(chunk)
        end
      end
    end
  end
end