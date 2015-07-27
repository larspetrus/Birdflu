require 'rails_helper'

RSpec.describe EpIcons do
  it 'grid contains all positions once' do
    grid_count = Hash.new(0)
    real_count = Hash.new(0)

    EpIcons.grid.flatten.each { |pos|  grid_count[pos.code] += 1 if pos }
    EpIcons::ALL.each { |cpos|  real_count[cpos.code] += 1}

    expect(grid_count).to eq(real_count)
  end
  
  it 'makes arrows' do
    expect(EpIcons.by_code('1335').arrows.sort).to eq([:F2R, :L2F, :R2L])
    expect(EpIcons.by_code('5555').arrows.sort).to eq([:BdF, :LdR])
    expect(EpIcons.by_code('3711').arrows.sort).to eq([:BdR])
    expect(EpIcons.by_code('7373').arrows.sort).to eq([:BdL, :FdR])
  end
end