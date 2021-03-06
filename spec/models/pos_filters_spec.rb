require 'rails_helper'

describe PosFilters do

  def pos_filters_new(params_hash, position_subset = 'all')
    PosFilters.new(params_hash.with_indifferent_access, position_subset)
  end

  describe ".all" do
    it 'does the basics' do
      parms = {"pos"=>"_b__", "poschange"=>"cp-b", "list"=>"algs", "lines"=>"25", "algset_id"=>"2", "sortby"=>"length", "controller"=>"positions", "action"=>"index"}
      expect(pos_filters_new(parms).all).to eq({oll: "", cop: "", co: "", cp: "b", eo: "", ep: ""})

      parms["pos"] ="Fb__"
      expect(pos_filters_new(parms).all).to eq({oll: "", cop: "Fb", co: "F", cp: "b", eo: "", ep: ""})

      parms["pos"] = "Fb9_"
      expect(pos_filters_new(parms).all).to eq({oll: "m53", cop: "Fb", co: "F", cp: "b", eo: "9", ep: ""})

      parms["pos"] = "Fb9G"
      expect(pos_filters_new(parms).all).to eq({oll: "m53", cop: "Fb", co: "F", cp: "b", eo: "9", ep: "G"})
    end

    it 'random' do
      allow(PosFilters).to receive(:random_code) {'f'}

      parms = {"pos"=>"", "poschange"=>"cp-random"}
      expect(pos_filters_new(parms).all).to eq({oll: "", cop: "", co: "", cp: "f", eo: "", ep: ""})
    end


    it 'poschange: #cop or #oll resets everything else' do
      expect(pos_filters_new(poschange:'cop-Bf', pos:'  4h').all).to eq(
                                            {cop:'Bf', oll:'',   co:'B',cp:'f',eo:'', ep:''})
      expect(pos_filters_new(poschange:'oll-m13', pos:'  4h').all).to eq(
                                            {cop:'', oll:'m13',co:'B',cp:'', eo:'1',ep:''})
      # except when erased
      expect(pos_filters_new(poschange:'cop-', pos:'Bf4h').all).to eq(
                                            {cop:'',oll:'',   co:'', cp:'', eo:'4',ep:'h' })
      expect(pos_filters_new(poschange:'oll-', pos:'Bb4h').all).to eq(
                                            {cop:'',  oll:'',co:'',cp:'b',eo:'' ,ep:'h'})
    end

    it 'computes cop and oll' do
      expect(pos_filters_new(poschange:'cp-o',pos:'Ao  ').all).to eq(
                                           {cop:'Ao',oll:'',co:'A',cp:'o',eo:'',ep:''})
      expect(pos_filters_new(poschange:'eo-4',pos:'G 4').all).to eq(
                                           {cop:'',oll:'m22',co:'G',cp:'',eo:'4',ep:''})
      expect(pos_filters_new(poschange:'co-G',pos:'Go8').all).to eq(
                                           {cop:'Go',oll:'m47',co:'G',cp:'o',eo:'8',ep:''})

      expect(pos_filters_new(pos:'bf4j').all).to eq(
                            {cop:'bf',oll:'m26',co:'b',cp:'f',eo:'4',ep:'j'})
    end
    
    it 'wtf' do
      expect(pos_filters_new("pos"=>"Ab__", "poschange"=>"eo-6").all).to eq(co: "A", cp: "b", cop: "Ab", oll: "m28", eo: "6", ep: "")
    end

    it 'removes incompatible ep (when needed)' do
      expect(pos_filters_new(poschange:'cp-r',pos:'Dr8E').all).to eq(
                                           {cop:'Dr',oll:'m42',co:'D',cp:'r',eo:'8',ep:''})
      expect(pos_filters_new(poschange:'cp-',pos:'B 0C').all).to eq(
                                            {cop: '',oll:'m3', co:'B',cp:'',eo:'0',ep:'C'})

      expect(pos_filters_new(pos:'Ao9l').all).to eq({cop: 'Ao', oll: 'm28', co: 'A', cp: 'o', eo: '9', ep:''})
    end

    it "misc" do
      expect(pos_filters_new({}).all).to eq({cop: '', oll: '', co:'' ,cp:'' ,eo:'' ,ep:''})

      no_click_params = {cop: '', oll: 'm3', co: 'B', cp: '', eo: '0', ep: ''}
      expect(pos_filters_new({pos: 'B 0 '}).all).to eq({cop: '', oll: 'm3', co: 'B', cp: '', eo: '0', ep: ''})
    end

    it 'restricts to EO' do
      expect(pos_filters_new({pos:'____'}, 'eo').all).to eq({eo: "4", cop: "", cp: "", co: "", ep: "", oll: ""})
      expect(pos_filters_new({poschange:'cop-bo',pos:'____'}, 'eo').all).to eq({eo: "4", cop: "bo", cp: "o", co: "b", ep: "", oll: "m26"})
    end
  end

  it '.where' do
    expect(pos_filters_new(pos:'Bf4h').where).to eq({co: 'B', cp: 'f', eo: '4', ep: 'h'})
    expect(pos_filters_new(pos:'B 0 ').where).to eq({co: 'B', eo: '0'})
    expect(pos_filters_new(pos:'    ').where).to eq({})
  end

  it '.pos_code' do
    expect(pos_filters_new(pos:'Bf4h').pos_code).to eq('Bf4h')
    expect(pos_filters_new(pos:'B 0 ').pos_code).to eq('B_0_')
    expect(pos_filters_new(pos:'    ').pos_code).to eq('____')
  end

  it 'two_set' do
    expect(pos_filters_new(pos:'Ao  ').count).to eq(2)
    expect(pos_filters_new(pos:'Ao0K').count).to eq(4)
    expect(pos_filters_new(pos:'__0_').count).to eq(1)
    expect(pos_filters_new({}).count).to eq(0)
  end

  it 'unpack_pos' do
    expect(PosFilters.unpack_pos('Fl4I')).to eq({co: 'F', cp: 'l', eo: '4', ep: 'I'})
    expect(PosFilters.unpack_pos('F_4_')).to eq({co: 'F', eo: '4'})
  end

  it 'unpack_pos tries to be nice' do
    expect(PosFilters.unpack_pos('a')).to eq({co: 'A'})
    expect(PosFilters.unpack_pos('b')).to eq({co: 'b'})

    expect(PosFilters.unpack_pos('_O')).to eq({cp: 'o'})
  end
end