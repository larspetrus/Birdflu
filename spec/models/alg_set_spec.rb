require 'rails_helper'

describe AlgSet do

  before(:each) do
    allow(MirrorAlgs).to receive(:_combined_data) do
      {
          'Nothing.--' => double(name: 'Nothing.--', ids: [1]),
          'F1.F3' => double(name: 'F1.F3', ids: [6, 11]),
          'G1.G6' => double(name: 'G1.G6', ids: [30, 48]),
          'J18.--' => double(name: 'J18.--', ids: [215]),
      }
    end
  end

  it 'validation' do
    expect_validation(AlgSet.new(algs: "F1.F3 G1.G6", name: "X", subset: 'eo'))

    expect_validation(AlgSet.new(algs: "F1.F3", name: "", subset: 'eo'), :name, ["can't be blank"])

    expect_validation(AlgSet.new(algs: "F1.F3", name: "X", subset: "xyz"), :subset, ["is not included in the list"])

    expect_validation(AlgSet.new(algs: "K1.K2", name: "X", subset: 'eo'), :algs, ["'K1.K2' is not a valid mirrored alg pair"])
    expect_validation(AlgSet.new(algs: "Nothing.--", name: "X", subset: 'eo'), :algs, ["'Nothing' is not a real alg"])
  end


  it 'algs' do
    expect(AlgSet.make(algs: "F1.F3 G1.G6").algs).to eq("F1.F3 G1.G6")
    expect(AlgSet.make(algs: "G1.G6 F1.F3").algs).to eq("F1.F3 G1.G6")
    expect(AlgSet.make(algs: "F1.F3 F1.F3").algs).to eq("F1.F3")
  end

  it 'alg_set_fact' do
    alg_set = AlgSet.make(algs: "F1.F3 G1.G6")
    expect(alg_set.fact.algs_code).to eq(alg_set.set_code)
  end

  it 'saves .fact automatically on save' do
    alg_set_count = AlgSet.count
    alg_set_fact_count = AlgSetFact.count

    AlgSet.make(algs: "F1.F3 G1.G6").save!

    expect(AlgSet.count).to eq(alg_set_count + 1)
    expect(AlgSetFact.count).to eq(alg_set_fact_count + 1)
  end

  it "alg_set_fact_id is set and updated" do
    as1 = AlgSet.create!(name: "test", algs: "F1.F3", subset: "all")
    as2 = AlgSet.create!(name: "test", algs: "F1.F3 G1.G6", subset: "all")
    as3 = AlgSet.create!(name: "test", algs: "F1.F3", subset: "all")

    expect(as1.alg_set_fact_id).to eq(as1.fact.id)
    expect(as2.reload.alg_set_fact_id).to eq(as2.fact.id)
    expect(as3.alg_set_fact_id).to eq(as1.alg_set_fact_id)

    as3.replace_algs("F1.F3 G1.G6").save!

    expect(as3.alg_set_fact_id).to eq(as2.alg_set_fact_id)
  end

  it 'replace_algs' do
    algset = AlgSet.make(algs: "F1.F3 G1.G6", name: "X")
    asfid1 = algset.fact.id
    expect(algset.fact.algs_code).to eq('F1G1a')

    algset.replace_algs("K1.K2")

    expect(algset.fact.algs_code).to eq('K1a')
    expect(algset.fact.id).not_to eq(asfid1)
    expect(algset.name).to eq("X")
  end

  it 'set_code' do
    expect(AlgSet.make(algs: "F1.F3 G1.G6", subset: 'all').set_code).to eq("F1G1a")
    expect(AlgSet.make(algs: "G1.G6 J18.--", subset: 'eo').set_code).to eq("G1J18e")
    expect(AlgSet.make(algs: "", subset: 'all').set_code).to eq("a")
  end

  it 'ids' do
    expect(AlgSet.make(algs: "F1.F3 G1.G6").ids).to eq([1, 6, 11, 30, 48])
    expect(AlgSet.make(algs: "F1.F3 J18.--").ids).to eq([1, 6, 11, 215])
    expect(AlgSet.make(algs: "F1.F3 F1.F3 ").ids).to eq([1, 6, 11])
    expect(AlgSet.make(algs: "").ids).to eq([1])
    expect(AlgSet.make().ids).to eq([1])
  end

  it 'include?' do
    set = AlgSet.make(algs: 'F1.F3')

    expect(set.include?(double(alg1_id: 6, alg2_id: 6))).to eq(true)
    expect(set.include?(double(alg1_id: 6, alg2_id: 7))).to eq(false)
    expect(set.include?(double(alg1_id: 6, alg2_id: 11))).to eq(true)
  end

  it 'subset_for' do
    all_set = AlgSet.make(subset: "all")
    eo_set = AlgSet.make(subset: "eo")

    eo_pos = Position.find(1)
    non_eo_pos = Position.find(2)

    expect(all_set.applies_to(eo_pos)).to eq(true)
    expect(all_set.applies_to(non_eo_pos)).to eq(true)
    expect(eo_set.applies_to(eo_pos)).to eq(true)
    expect(eo_set.applies_to(non_eo_pos)).to eq(false)
  end

  describe 'data_only' do
    before(:each) do
      allow(algset).to receive(:subset_pos_ids) { [0,1,2]}
      allow(algset.fact).to receive(:lengths) { [12, 14, nil]}
    end

    let (:algset) { AlgSet.create!(name: "test", algs: "F1.F3", subset: "all") }

    it 'computes by default, and returns already cached data when compute is off' do
      expect(algset.fact.coverage).to eq(2)

      algset.data_only

      expect(algset.fact.coverage).to eq(2)
    end

    it 'respects computing_off' do
      algset.data_only
      expect(algset.fact.coverage).to eq(nil)
    end
  end

  it 'menu_options shows only predefined + own set' do
    a1 = AlgSet.create(name: "a1", subset: 'eo', predefined: true)
    a2 = AlgSet.create(name: "a2", subset: 'eo', wca_user_id: 313)
    a3 = AlgSet.create(name: "a3", subset: 'all', wca_user_id: 5000)
    a4 = AlgSet.create(name: "a4", subset: 'all', wca_user_id: 313)
    a5 = AlgSet.create(name: "a5", subset: 'all', predefined: true)

    expect(AlgSet.menu_options(nil)).to eq([["all-a5", a5.id], ["eo-a1", a1.id]])

    expect(AlgSet.menu_options(double(db_id: 313))).to eq([["all-a5", a5.id], ["eo-a1", a1.id], ["all·a4", a4.id], ["eo·a2", a2.id]])
  end

  it 'exports/imports YAML data' do
    as1 = AlgSet.create!(algs: "F1.F3 G1.G6",  name: "Olivia", subset: 'all', description: "I'm normal", predefined: true)
    as2 = AlgSet.create!(algs: "F1.F3 J18.--", name: "Spooon", subset: 'eo',  description: "чат™½➢★閉討", predefined: false)

    yas1 = AlgSet.from_yaml(as1.to_yaml)
    expect(yas1.to_yaml).to eq(as1.to_yaml)

    yas2 = AlgSet.from_yaml(as2.to_yaml)
    expect(yas2.to_yaml).to eq(as2.to_yaml)

    expect(as1.alg_set_fact_id).to eq(yas1.alg_set_fact_id)
    expect(as2.alg_set_fact_id).to eq(yas2.alg_set_fact_id)

    lars_petrus_user_id = 1
    expect([as1, as2, yas1, yas2].map(&:wca_user_id)).to eq([nil, nil, nil, lars_petrus_user_id])
  end
end

def expect_validation(new_algset, field = nil, errors = nil)
  if errors.present?
    expect(new_algset.valid?).to eq(false)
    expect(new_algset.errors[field]).to eq(errors)
  else
    expect(new_algset.valid?).to eq(true)
  end

end