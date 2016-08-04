require 'rails_helper'

describe PosFilters do

  def pos_filters_new(params_hash)
    PosFilters.new(params_hash.with_indifferent_access)
  end

  describe ".all" do
    it 'does the basics' do
      parms = {"cop"=>"", "oll"=>"", "co"=>"", "cp"=>"b", "eo"=>"", "ep"=>"", "change"=>"cp-b", "list"=>"algs", "lines"=>"25", "algset_id"=>"2", "sortby"=>"length", "controller"=>"positions", "action"=>"index"}
      expect(pos_filters_new(parms).all).to eq({oll: "", cop: "", co: "", cp: "b", eo: "", ep: ""})

      parms["co"] = "F"
      expect(pos_filters_new(parms).all).to eq({oll: "", cop: "Fb", co: "F", cp: "b", eo: "", ep: ""})

      parms["eo"] = "9"
      expect(pos_filters_new(parms).all).to eq({oll: "m53", cop: "Fb", co: "F", cp: "b", eo: "9", ep: ""})

      parms["ep"] = "G"
      expect(pos_filters_new(parms).all).to eq({oll: "m53", cop: "Fb", co: "F", cp: "b", eo: "9", ep: "G"})
    end

    it 'random' do
      allow(PosFilters).to receive(:random_code) {'f'}

      parms = {"cop"=>"", "oll"=>"", "co"=>"", "cp"=>"random", "eo"=>"", "ep"=>"", "change"=>"cp-random"}
      expect(pos_filters_new(parms).all).to eq({oll: "", cop: "", co: "", cp: "f", eo: "", ep: ""})
    end


    it 'change: #cop or #oll resets everything else' do
      expect(pos_filters_new(change:'cop-Bf', co:'', cp:'', eo:'4',ep:'h').all).to eq(
                                            {cop:'Bf', oll:'',   co:'B',cp:'f',eo:'', ep:''})
      expect(pos_filters_new(change:'oll-m13', co:'', cp:'', eo:'4',ep:'h').all).to eq(
                                            {cop:'',   oll:'m13',co:'B',cp:'', eo:'1',ep:''})
      # except when erased
      expect(pos_filters_new(change:'cop-', co:'B',cp:'f',eo:'4',ep:'h').all).to eq(
                                            {cop:'',oll:'',   co:'', cp:'', eo:'4',ep:'h' })
      expect(pos_filters_new(change:'oll-', co:'B',cp:'b',eo:'4',ep:'h').all).to eq(
                                            {cop:'',  oll:'',co:'',cp:'b',eo:'' ,ep:'h'})
    end

    it 'computes cop and oll' do
      expect(pos_filters_new(change:'cp-o',co:'A',cp:'o',eo:'',ep:'').all).to eq(
                                           {cop:'Ao',oll:'',co:'A',cp:'o',eo:'',ep:''})
      expect(pos_filters_new(change:'eo-4',co:'G',cp:'',eo:'4',ep:'').all).to eq(
                                           {cop:'',oll:'m22',co:'G',cp:'',eo:'4',ep:''})
      expect(pos_filters_new(change:'co-G',co:'G',cp:'o',eo:'8',ep:'').all).to eq(
                                           {cop:'Go',oll:'m47',co:'G',cp:'o',eo:'8',ep:''})

      expect(pos_filters_new(co:'b',cp:'f',eo:'4',ep:'j').all).to eq(
                            {cop:'bf',oll:'m26',co:'b',cp:'f',eo:'4',ep:'j'})
    end

    it 'removes incompatible ep (when needed)' do
      expect(pos_filters_new(change:'cp-r',co:'D',cp:'r',eo:'8',ep:'E').all).to eq(
                                           {cop:'Dr',oll:'m42',co:'D',cp:'r',eo:'8',ep:''})
      expect(pos_filters_new(change:'cp-',co:'B',cp:'',eo:'0',ep:'C').all).to eq(
                                            {cop: '',  oll:'m3',co:'B',cp:'',eo:'0',ep:'C'})
    end

    it "misc" do
      expect(pos_filters_new({}).all).to eq({cop: '', oll: '', co:'' ,cp:'' ,eo:'' ,ep:''})

      no_click_params = {cop: '', oll: 'm3', co: 'B', cp: '', eo: '0', ep: ''}
      expect(pos_filters_new(no_click_params).all).to eq(no_click_params)
    end
  end

  it '.where' do
    expect(pos_filters_new(co:'B', cp:'f', eo:'4', ep:'h').where).to eq({co: 'B', cp: 'f', eo: '4', ep: 'h'})
    expect(pos_filters_new(co:'B', cp: '', eo:'0', ep: '').where).to eq({co: 'B', eo: '0'})
    expect(pos_filters_new(co: '', cp: '', eo: '', ep: '').where).to eq({})
  end

  it '.pos_code' do
    expect(pos_filters_new(co:'B', cp:'f', eo:'4',ep:'h').pos_code).to eq('Bf4h')
    expect(pos_filters_new(co: 'B', cp: '', eo: '0', ep: '').pos_code).to eq('B_0_')
    expect(pos_filters_new(co: '', cp: '', eo: '', ep: '').pos_code).to eq('____')
  end

  it '.url' do
    expect(pos_filters_new(co:'B', cp:'f', eo:'4',ep:'h').url).to eq('co=B&cp=f&eo=4&ep=h')
    expect(pos_filters_new(co: 'B', cp: '', eo: '0', ep: '').url).to eq('co=B&eo=0')
    expect(pos_filters_new(co: '', cp: '', eo: '', ep: '').url).to eq('')
  end

  it 'reload' do
    expect(pos_filters_new(co:'A',cp:'o',eo:'',ep:'').reload).to_not eq(true)
    expect(pos_filters_new(change: 'cop-random', cop:'random',oll:'',co:'A',cp:'o',eo:'',ep:'').reload).to eq(true)
  end

  it 'all_set' do
    expect(pos_filters_new(co:'A',cp:'o',eo:'',ep:'').all_set).to eq(false)
    expect(pos_filters_new(co:'A',cp:'o',eo:'0',ep:'k').all_set).to eq(true)
    expect(pos_filters_new({}).all_set).to eq(false)
  end
  
  it 'unpack_pos' do
    expect(PosFilters.unpack_pos('Fl4I')).to eq({co: 'F', cp: 'l', eo: '4', ep: 'I'}.with_indifferent_access)
    expect(PosFilters.unpack_pos('F_4_')).to eq({co: 'F', cp: '',  eo: '4', ep: ''}.with_indifferent_access)
  end
end