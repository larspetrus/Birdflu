require 'rails_helper'

describe Seeder do

  it 'db has expected columns' do
    # If the columns have changed, the seed files are likely useless.
    expect(Position.columns.map(&:name)).to eq(%w(id ll_code weight best_alg_id cop oll eo ep optimal_alg_length co cp mirror_id inverse_id main_position_id pov_offset))
    expect(RawAlg.columns.map(&:name)).to eq(%w(id length position_id u_setup specialness _speed _moves))
    expect(ComboAlg.columns.map(&:name)).to eq(%w(id alg1_id alg2_id combined_alg_id encoded_data position_id))
  end
end