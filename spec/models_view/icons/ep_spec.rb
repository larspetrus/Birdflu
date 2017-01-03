require 'rails_helper'

RSpec.describe Icons::Ep do
  it 'grid contains all positions once' do
    grid_count = Hash.new(0)
    real_count = Hash.new(0)

    Icons::Ep.grid({}).flatten.each { |pos|  grid_count[pos.code] += 1 if pos }
    grid_count[:''] += 1
    Icons::Ep::ALL.each { |cpos|  real_count[cpos.code] += 1}

    expect(grid_count).to eq(real_count)
  end
  
  it 'makes arrows' do
    expect(Icons::Ep.by_code('E').arrows.sort).to eq([:F2L, :L2R, :R2F])
    expect(Icons::Ep.by_code('B').arrows.sort).to eq([:BdF, :LdR])
    expect(Icons::Ep.by_code('e').arrows.sort).to eq([:BdR])
    expect(Icons::Ep.by_code('C').arrows.sort).to eq([:BdL, :FdR])
  end
end