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

  it 'ids' do
    expect(AlgSet.make(algs: "F1.F3 G1.G6", name: "X").ids).to eq([1, 6, 11, 30, 48])
    expect(AlgSet.make(algs: "F1.F3 J18.--", name: "X").ids).to eq([1, 6, 11, 215])
    expect(AlgSet.make(algs: "F1.F3 F1.F3 ", name: "X").ids).to eq([1, 6, 11])
  end

  it 'include?' do
    set = AlgSet.new(algs: 'F1.F3')

    expect(set.include?(double(alg1_id: 6, alg2_id: 6))).to eq(true)
    expect(set.include?(double(alg1_id: 6, alg2_id: 7))).to eq(false)
    expect(set.include?(double(alg1_id: 6, alg2_id: 11))).to eq(true)
  end
  
  it 'coverage methods' do
    as = AlgSet.make(algs: "fake", name: "fake")

    allow(as).to receive(:subset_pos_ids) { [1,2,3,4] }
    allow(as).to receive(:lengths) { ['-', 9,12,nil,9] }
    allow(as).to receive(:speeds) { ['-', 7.77,11.11,nil,9.99] }

    expect(as.coverage).to eq(3)
    expect(as.uncovered_ids).to eq([3])
    expect(as.full_coverage?).to eq(false)
    expect(as.covered_weight).to eq(6)
    expect(as.average_length).to eq(11.0)
    expect(as.average_speed).to be_within(0.01).of(10.37)
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