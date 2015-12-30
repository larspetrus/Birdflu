require 'rails_helper'

describe PosSubsets do

  describe ".as_params" do
    it 'clicked: #cop or #oll resets everything else' do
      expect(PosSubsets.new({clicked:'#cop', cop:'Bf', oll:'m13',co:'', cp:'', eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'Bf', oll:'',   co:'B',cp:'f',eo:'', ep:''})
      expect(PosSubsets.new({clicked:'#oll', cop:'Bf', oll:'m13',co:'', cp:'', eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'',   oll:'m13',co:'B',cp:'', eo:'1',ep:''})
      # except when erased
      expect(PosSubsets.new({clicked:'#cop', cop:'',oll:'m13',co:'B',cp:'f',eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'',oll:'',   co:'', cp:'', eo:'4',ep:'h' })
      expect(PosSubsets.new({clicked:'#oll', cop:'Bf',oll:'',co:'B',cp:'b',eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'',  oll:'',co:'',cp:'b',eo:'' ,ep:'h'})
    end

    it 'computes cop and oll' do
      expect(PosSubsets.new({clicked:'#cp', cop:''  ,oll:'',co:'A',cp:'o',eo:'',ep:''}).as_params).to eq(
                                           {cop:'Ao',oll:'',co:'A',cp:'o',eo:'',ep:''})
      expect(PosSubsets.new({clicked:'#eo', cop:'',oll:''   ,co:'G',cp:'',eo:'4',ep:''}).as_params).to eq(
                                           {cop:'',oll:'m22',co:'G',cp:'',eo:'4',ep:''})
      expect(PosSubsets.new({clicked:'#co', cop:''  ,oll:''   ,co:'G',cp:'o',eo:'8',ep:''}).as_params).to eq(
                                           {cop:'Go',oll:'m47',co:'G',cp:'o',eo:'8',ep:''})
    end

    it 'removes incompatible ep (when needed)' do
      expect(PosSubsets.new({clicked:'#cp', cop:'Dr',oll:'m42',co:'D',cp:'r',eo:'8',ep:'E'}).as_params).to eq(
                                           {cop:'Dr',oll:'m42',co:'D',cp:'r',eo:'8',ep:''})
      expect(PosSubsets.new({clicked: '#cp', cop: 'Bb',oll:'m3',co:'B',cp:'',eo:'0',ep:'C'}).as_params).to eq(
                                            {cop: '',  oll:'m3',co:'B',cp:'',eo:'0',ep:'C'})
    end

    it "misc" do
      expect(PosSubsets.new({}).as_params).to eq({})

      no_click_params = {cop: '', oll: 'm3', co: 'B', cp: '', eo: '0', ep: ''}
      expect(PosSubsets.new(no_click_params).as_params).to eq(no_click_params)
    end
  end

  it '.where' do
    expect(PosSubsets.new({cop: '', oll: 'm3', co: 'B', cp: '', eo: '0', ep: ''}).where).to eq({oll: 'm3', co: 'B', eo: '0'})
    expect(PosSubsets.new({cop: '', oll: '', co: '', cp: '', eo: '', ep: ''}).where).to eq({})
  end

  it 'reload' do
    expect(PosSubsets.new({cop:'Ao',oll:'',co:'A',cp:'o',eo:'',ep:''}).reload).to eq(nil)
    expect(PosSubsets.new({cop:'random',oll:'',co:'A',cp:'o',eo:'',ep:''}).reload).to eq(true)
  end

  it 'fully_defined' do
    expect(PosSubsets.new({cop:'Ao',oll:'',co:'A',cp:'o',eo:'',ep:''}).fully_defined).to eq(false)
    expect(PosSubsets.new({cop:'Ao',oll:'m99',co:'A',cp:'o',eo:'0',ep:'k'}).fully_defined).to eq(true)
    expect(PosSubsets.new({}).fully_defined).to eq(false)
  end

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

  it '#ep_type_by_cp' do
    expect(PosSubsets.ep_type_by_cp(:o)).to eq(:upper)
    expect(PosSubsets.ep_type_by_cp(:b)).to eq(:upper)
    expect(PosSubsets.ep_type_by_cp(:d)).to eq(:lower)
    expect(PosSubsets.ep_type_by_cp(:f)).to eq(:lower)
    expect(PosSubsets.ep_type_by_cp('invalid')).to eq(:both)
    expect(PosSubsets.ep_type_by_cp(nil)).to eq(:both)
  end

  it '#ep_codes_by_cp' do
    expect(PosSubsets.ep_codes_by_cp(:o)).to eq(Icons::Ep.upper_codes)
    expect(PosSubsets.ep_codes_by_cp(:d)).to eq(Icons::Ep.lower_codes)
    expect(PosSubsets.ep_codes_by_cp(nil)).to eq(Icons::Ep.upper_codes + Icons::Ep.lower_codes)
  end
end