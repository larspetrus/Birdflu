require 'rails_helper'

RSpec.describe Icons::Eo, :type => :model do
  it 'grid contains all positions once' do
    grid_count = Hash.new(0)
    real_count = Hash.new(0)

    Icons::Eo.grid.flatten.each { |pos|  grid_count[pos.code] += 1 if pos }
    grid_count[:''] += 1
    Icons::Eo::ALL.each { |cpos|  real_count[cpos.code] += 1}

    expect(grid_count).to eq(real_count)
  end
end
