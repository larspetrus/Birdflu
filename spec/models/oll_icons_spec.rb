require 'rails_helper'

RSpec.describe OllIcons, :type => :model do
  it 'color' do
    o25 = OllIcons.new(:o25, 'OLL 25', %w(U U B U U L U U))

    expect(o25.name).to eq('OLL 25')
    expect(o25.code).to eq(:o25)
    expect(o25.colors[:ULB_U]).to eq('oll-color')
    expect(o25.colors[:ULB_L]).to eq(nil)
  end

  it 'find object by code' do
    expect(OllIcons.by_code(:m42).code).to eq(:m42)
    expect(OllIcons.by_code('m24').code).to eq(:m24)
  end
end
