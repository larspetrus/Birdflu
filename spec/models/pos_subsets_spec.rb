require 'rails_helper'

describe PosSubsets do

  describe ".as_params" do
    it 'change: #cop or #oll resets everything else' do
      expect(PosSubsets.new({change:'cop-Bf', co:'', cp:'', eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'Bf', oll:'',   co:'B',cp:'f',eo:'', ep:''})
      expect(PosSubsets.new({change:'oll-m13', co:'', cp:'', eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'',   oll:'m13',co:'B',cp:'', eo:'1',ep:''})
      # except when erased
      expect(PosSubsets.new({change:'cop-', co:'B',cp:'f',eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'',oll:'',   co:'', cp:'', eo:'4',ep:'h' })
      expect(PosSubsets.new({change:'oll-', co:'B',cp:'b',eo:'4',ep:'h'}).as_params).to eq(
                                            {cop:'',  oll:'',co:'',cp:'b',eo:'' ,ep:'h'})
    end

    it 'computes cop and oll' do
      expect(PosSubsets.new({change:'cp-o', cop:''  ,oll:'',co:'A',cp:'o',eo:'',ep:''}).as_params).to eq(
                                           {cop:'Ao',oll:'',co:'A',cp:'o',eo:'',ep:''})
      expect(PosSubsets.new({change:'eo-4', cop:'',oll:''   ,co:'G',cp:'',eo:'4',ep:''}).as_params).to eq(
                                           {cop:'',oll:'m22',co:'G',cp:'',eo:'4',ep:''})
      expect(PosSubsets.new({change:'co-G', cop:''  ,oll:''   ,co:'G',cp:'o',eo:'8',ep:''}).as_params).to eq(
                                           {cop:'Go',oll:'m47',co:'G',cp:'o',eo:'8',ep:''})

      expect(PosSubsets.new({cop:''  ,oll:''   ,co:'b',cp:'f',eo:'4',ep:'j'}).as_params).to eq(
                            {cop:'bf',oll:'m26',co:'b',cp:'f',eo:'4',ep:'j'})
    end

    it 'removes incompatible ep (when needed)' do
      expect(PosSubsets.new({change:'cp-r', cop:'Dr',oll:'m42',co:'D',cp:'r',eo:'8',ep:'E'}).as_params).to eq(
                                           {cop:'Dr',oll:'m42',co:'D',cp:'r',eo:'8',ep:''})
      expect(PosSubsets.new({change:'cp-', cop: 'Bb',oll:'m3',co:'B',cp:'',eo:'0',ep:'C'}).as_params).to eq(
                                            {cop: '',  oll:'m3',co:'B',cp:'',eo:'0',ep:'C'})
    end

    it "misc" do
      expect(PosSubsets.new({}).as_params).to eq({cop: '', oll: ''})

      no_click_params = {cop: '', oll: 'm3', co: 'B', cp: '', eo: '0', ep: ''}
      expect(PosSubsets.new(no_click_params).as_params).to eq(no_click_params)
    end
  end

  it '.where' do
    expect(PosSubsets.new({cop:'Bf', oll:'m13',co:'B', cp:'f', eo:'4',ep:'h'}).where).to eq({co: 'B', cp: 'f', eo: '4', ep: 'h'})
    expect(PosSubsets.new({cop: '', oll: 'm3', co: 'B', cp: '', eo: '0', ep: ''}).where).to eq({co: 'B', eo: '0'})
    expect(PosSubsets.new({cop: '', oll: '', co: '', cp: '', eo: '', ep: ''}).where).to eq({})
  end

  it 'reload' do
    expect(PosSubsets.new({cop:'Ao',oll:'',co:'A',cp:'o',eo:'',ep:''}).reload).to_not eq(true)
    expect(PosSubsets.new({change: 'cop-random', cop:'random',oll:'',co:'A',cp:'o',eo:'',ep:''}).reload).to eq(true)
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

  it 'valid_xx_codes' do
    expect(PosSubsets.valid_codes(:co)).to eq(%w(A B C D E F G b))
    expect(PosSubsets.valid_codes(:cp)).to eq(%w(b d f l o r))
    expect(PosSubsets.valid_codes(:eo)).to eq(%w(0 1 2 4 6 7 8 9))
    expect(PosSubsets.valid_codes(:ep)).to eq(%w(A B C D E F G H I J K L a b c d e f g h i j k l))

  end
  
  it 'unpack_pos' do
    expect(PosSubsets.unpack_pos('Fl4I')).to eq({co: 'F', cp: 'l', eo: '4', ep: 'I'})
    expect(PosSubsets.unpack_pos('F_4_')).to eq({co: 'F', cp: '',  eo: '4', ep: ''})
  end
end