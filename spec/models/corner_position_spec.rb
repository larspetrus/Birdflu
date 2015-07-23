require 'rails_helper'

RSpec.describe CornerPosition do
  it 'grid contains all positions once' do
    grid_count = Hash.new(0)
    real_count = Hash.new(0)

    CornerPosition.grid.flatten.each { |pos|  grid_count[pos.code] += 1 if pos }
    CornerPosition::ALL.each { |cpos|  real_count[cpos.code] += 1}

    expect(grid_count).to eq(real_count)
  end
end