require 'rails_helper'

describe PosSubsets do

  it "#eo_by_oll" do
    expect(PosSubsets.eo_by_oll(:m10)).to eq('7')
    expect(PosSubsets.eo_by_oll(:m20)).to eq('0')
    expect(PosSubsets.eo_by_oll(:m30)).to eq('7')
    expect(PosSubsets.eo_by_oll(:m40)).to eq('2')
  end

  it '#oll_by_co_eo' do
    expect(PosSubsets.oll_by_co_eo(:D, :'7')).to eq('m41')
    expect(PosSubsets.oll_by_co_eo(:b, :'9')).to eq('m6')
    expect(PosSubsets.oll_by_co_eo(:B, :'1')).to eq('m13')

  end

  it '#ep_type_by_cop' do
    expect(PosSubsets.ep_type_by_cop(:Ao)).to eq(:upper)
    expect(PosSubsets.ep_type_by_cop(:Eb)).to eq(:upper)
    expect(PosSubsets.ep_type_by_cop(:Ad)).to eq(:lower)
    expect(PosSubsets.ep_type_by_cop(:Gf)).to eq(:lower)
    expect(PosSubsets.ep_type_by_cop('invalid')).to eq(nil)
    expect(PosSubsets.ep_type_by_cop(nil)).to eq(nil)
  end
end