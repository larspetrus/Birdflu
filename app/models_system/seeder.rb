# frozen_string_literal: true

# I write and load the data for `db/seeds.rb`
class Seeder
  SEED_DIR = Dir.pwd + '/seed_data'

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

    if Position.count == 0
      execute("COPY positions FROM '#{POSITIONS_FILE}'")
      puts "- Positions loaded: #{Util.duration_to_s(t1)}"
    end

    execute("COPY raw_algs FROM '#{RAW_ALG_BULK_FILE}'")
    execute("COPY raw_algs FROM '#{RAW_ALG_EXTRA_FILE}'")
    puts "- Raw algs loaded: #{Util.duration_to_s(t1)}"

    execute("COPY combo_algs FROM '#{COMBO_ALG_FILE}'")
    puts "- Combo algs loaded: #{Util.duration_to_s(t1)}"

    [Position, RawAlg, ComboAlg].each { |model_class| ActiveRecord::Base.connection.reset_pk_sequence!(model_class.table_name)}
  end

  def self.execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end