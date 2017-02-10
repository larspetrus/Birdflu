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
    expect_validation(AlgSet.make(algs: "F1.F3 G1.G6", name: "X"))

    expect_validation(AlgSet.make(algs: "F1.F3", name: ""), :name, ["can't be blank"])

    expect_validation(AlgSet.make(algs: "F1.F3", name: "X", subset: "xyz"), :subset, ["is not included in the list"])

    expect_validation(AlgSet.make(algs: "K1.K2", name: "X"), :algs, ["'K1.K2' is not a valid mirrored alg pair"])
    expect_validation(AlgSet.make(algs: "Nothing.--", name: "X"), :algs, ["'Nothing' is not a real alg"])
  end


  it 'algs' do
    expect(AlgSet.make(algs: "F1.F3 G1.G6", name: "X").algs).to eq("F1.F3 G1.G6")
    expect(AlgSet.make(algs: "G1.G6 F1.F3", name: "X").algs).to eq("F1.F3 G1.G6")
    expect(AlgSet.make(algs: "F1.F3 F1.F3", name: "X").algs).to eq("F1.F3")
  end

  it 'alg_set_fact' do
    alg_set = AlgSet.make(algs: "F1.F3 G1.G6", name: "X")
    expect(alg_set.fact.algs_code).to eq(alg_set.set_code)
  end

  it 'saves .fact automatically on save' do
    alg_set_count = AlgSet.count
    alg_set_fact_count = AlgSetFact.count

    AlgSet.make(algs: "F1.F3 G1.G6", name: "X").save!

    expect(AlgSet.count).to eq(alg_set_count + 1)
    expect(AlgSetFact.count).to eq(alg_set_fact_count + 1)
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
    expect(AlgSet.make(algs: "F1.F3 G1.G6 K1.K2", name: "X", subset: 'all').set_code).to eq("F1G1K1a")
    expect(AlgSet.make(algs: "J18.-- K1.K2", name: "X", subset: 'eo').set_code).to eq("J18K1e")

  end

  it 'ids' do
    expect(AlgSet.make(algs: "F1.F3 G1.G6", name: "X").ids).to eq([1, 6, 11, 30, 48])
    expect(AlgSet.make(algs: "F1.F3 J18.--", name: "X").ids).to eq([1, 6, 11, 215])
    expect(AlgSet.make(algs: "F1.F3 F1.F3 ", name: "X").ids).to eq([1, 6, 11])
  end

  it 'include?' do
    set = AlgSet.make(algs: 'F1.F3', name: "X")

    expect(set.include?(double(alg1_id: 6, alg2_id: 6))).to eq(true)
    expect(set.include?(double(alg1_id: 6, alg2_id: 7))).to eq(false)
    expect(set.include?(double(alg1_id: 6, alg2_id: 11))).to eq(true)
  end

  it 'subset_for' do
    all_set = AlgSet.make(algs: 'F1', name: "all", subset: "all")
    eo_set = AlgSet.make(algs: 'F1', name: "eo", subset: "eo")

    eo_pos = Position.find 1
    non_eo_pos = Position.find 2

    expect(all_set.applies_to(eo_pos)).to eq(true)
    expect(all_set.applies_to(non_eo_pos)).to eq(true)
    expect(eo_set.applies_to(eo_pos)).to eq(true)
    expect(eo_set.applies_to(non_eo_pos)).to eq(false)
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