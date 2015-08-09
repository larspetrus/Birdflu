require 'rails_helper'

RSpec.describe Icons::Ep do
  it 'grid contains all positions once' do
    grid_count = Hash.new(0)
    real_count = Hash.new(0)

    Icons::Ep.grid.flatten.each { |pos|  grid_count[pos.code] += 1 if pos }
    Icons::Ep::ALL.each { |cpos|  real_count[cpos.code] += 1}

    expect(grid_count).to eq(real_count)
  end
  
  it 'makes arrows' do
    expect(Icons::Ep.by_code('1335').arrows.sort).to eq([:F2L, :L2R, :R2F])
    expect(Icons::Ep.by_code('5555').arrows.sort).to eq([:BdF, :LdR])
    expect(Icons::Ep.by_code('3711').arrows.sort).to eq([:BdR])
    expect(Icons::Ep.by_code('7373').arrows.sort).to eq([:BdL, :FdR])
  end
end