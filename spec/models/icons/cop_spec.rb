require 'rails_helper'

RSpec.describe Icons::Cop do
  it 'grid contains all positions once' do
    grid_count = Hash.new(0)
    real_count = Hash.new(0)

    Icons::Cop.grid.flatten.each { |pos|  grid_count[pos.code] += 1 if pos }
    grid_count[:''] += 1
    Icons::Cop::ALL.each { |cpos|  real_count[cpos.code] += 1}

    expect(grid_count).to eq(real_count)
  end

  it 'has the right arrows' do
    expect(Icons::Cop.by_code(:Bf).arrows).to eq([:F])
    expect(Icons::Cop.by_code(:Dl).arrows).to eq([:L])
    expect(Icons::Cop.by_code(:Ed).arrows).to eq([:D])
    expect(Icons::Cop.by_code(:Bo).arrows).to eq([])
  end
end