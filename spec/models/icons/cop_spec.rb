require 'rails_helper'

RSpec.describe Icons::Cop do
  it 'grid contains all positions once' do
    grid_count = Hash.new(0)
    real_count = Hash.new(0)

    Icons::Cop.grid.flatten.each { |pos|  grid_count[pos.code] += 1 if pos }
    Icons::Cop::ALL.each { |cpos|  real_count[cpos.code] += 1}

    expect(grid_count).to eq(real_count)
  end

  it 'has the right arrows' do
    expect(Icons::Cop.by_code(:Bz).arrows).to eq([:F])
    expect(Icons::Cop.by_code(:Dx).arrows).to eq([:L])
    expect(Icons::Cop.by_code(:EE).arrows).to eq([:D])
    expect(Icons::Cop.by_code(:B).arrows).to eq([])
  end
end