# frozen_string_literal: true

raw_alg_count = RawAlg.count
combo_alg_count = ComboAlg.count

if raw_alg_count > 0 || combo_alg_count > 0
  raise "DB is not empty. db/seeds.rb won't run! RawAlgs: #{raw_alg_count} rows. ComboAlgs: #{combo_alg_count} rows."
end

Seeder.load

PositionStats.generate_all