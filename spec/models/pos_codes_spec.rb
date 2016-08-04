require 'rails_helper'

describe PosCodes do

  it "#eo_by_oll" do
    expect(PosCodes.eo_by_oll(:m10)).to eq('7')
    expect(PosCodes.eo_by_oll(:m20)).to eq('0')
    expect(PosCodes.eo_by_oll(:m30)).to eq('7')
    expect(PosCodes.eo_by_oll(:m40)).to eq('2')
  end

  it '#oll_by_co_eo' do
    expect(PosCodes.oll_by_co_eo(:D, :'7')).to eq('m41')
    expect(PosCodes.oll_by_co_eo(:b, :'9')).to eq('m6')
    expect(PosCodes.oll_by_co_eo(:B, :'1')).to eq('m13')
  end

  it '#ep_type_by_cp' do
    expect(PosCodes.ep_type_by_cp(:o)).to eq(:upper)
    expect(PosCodes.ep_type_by_cp(:b)).to eq(:upper)
    expect(PosCodes.ep_type_by_cp(:d)).to eq(:lower)
    expect(PosCodes.ep_type_by_cp(:f)).to eq(:lower)
    expect(PosCodes.ep_type_by_cp('invalid')).to eq(:both)
    expect(PosCodes.ep_type_by_cp(nil)).to eq(:both)
  end

  it '#ep_by_cp' do
    expect(PosCodes.ep_by_cp(:o)).to eq(Icons::Ep.upper_codes)
    expect(PosCodes.ep_by_cp(:d)).to eq(Icons::Ep.lower_codes)
    expect(PosCodes.ep_by_cp(nil)).to eq(Icons::Ep.upper_codes + Icons::Ep.lower_codes)
  end

  it 'valid_for' do
    expect(PosCodes.valid_for(:co)).to eq(%w(A B C D E F G b))
    expect(PosCodes.valid_for(:cp)).to eq(%w(b d f l o r))
    expect(PosCodes.valid_for(:eo)).to eq(%w(0 1 2 4 6 7 8 9))
    expect(PosCodes.valid_for(:ep)).to eq(%w(A B C D E F G H I J K L a b c d e f g h i j k l))
  end
end