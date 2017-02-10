require 'rails_helper'

describe AlgSetFact do

  it 'computes the stats' do
    as = AlgSet.make(algs: "fake", name: "fake")

    allow(as).to receive(:subset_pos_ids) { [1,2,3,4] }
    allow(as.fact).to receive(:lengths) { ['-', 9,12,nil,9] }
    allow(as.fact).to receive(:speeds) { ['-', 7.77,11.11,nil,9.99] }

    expect(as.coverage).to eq(3)
    expect(as.uncovered_ids).to eq('3')
    expect(as.uncovered_ids_arr).to eq(['3'])
    expect(as.full_coverage?).to eq(false)
    expect(as.fact.covered_weight).to eq(6)
    expect(as.average_length).to eq(11.0)
    expect(as.average_speed).to be_within(0.01).of(10.37)
  end

  it 'find_or_create_empty is shared' do
    as1 = AlgSet.make(algs: "F1.F3 F2.F4 G1.G6 G2.G7", name: "simple")

    foc1 = AlgSetFact.find_or_create_empty(as1)
    expect(foc1.algs_code).to eq(as1.set_code)
    expect(foc1._avg_length).to eq(nil)

    as2 = AlgSet.make(algs: "F1.F3 F2.F4 G1.G6 G2.G7", name: "similar")

    foc2 = AlgSetFact.find_or_create_empty(as2)
    expect(foc2.algs_code).to eq(as2.set_code)
    expect(foc2._avg_length).to eq(nil)

    expect(foc1.id).to eq(foc2.id)
  end
end
