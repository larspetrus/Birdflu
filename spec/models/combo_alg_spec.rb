require 'rails_helper'

def named_alg(alg, name)
  RawAlg.make(alg).tap{|ra| allow(ra).to receive(:name) { name } }
end

RSpec.describe ComboAlg, :type => :model do
  let(:sune) { named_alg("F U F' U F U2 F'", 'Sune') }

  it 'verifies F2L is preserved' do
    expect {ComboAlg.create(name: "Not a LL alg!", moves: "F U D")}.to raise_error( RuntimeError, "Alg does not solve F2L" )
  end

  it 'length' do
    expect(ComboAlg.create(moves: "F U F' U F U2 F'", length: 99).length).to eq(7)
  end

  it 'reconstruct_merge' do
    alg1 = OpenStruct.new(moves: "F R U' B U B' R' F'")
    alg2 = OpenStruct.new(moves: "B L F' L F L2 B'")
    expect(ComboAlg.reconstruct_merge(alg1, alg2, 0, 3, 1)).to eq(["R B U' L U", "L' B' R'", "L2", "R B L'", "B L B2 R'"])

    alg1 = OpenStruct.new(moves: "F U' B' R' U' R U B F'")
    alg2 = OpenStruct.new(moves: "B' F U R U' R' F' U' B")
    expect(ComboAlg.reconstruct_merge(alg1, alg2, 0, 2, 2)).to eq(["B U' F' L' U' L U", "B' F", "B2 F2", "B' F", "U R U' R' F' U' B"])
  end

  describe "#make" do
    it 'combines the algs' do
      sune2 = named_alg("F' U' F U' F' U2 F", 'SuneM')

      combo = ComboAlg.make(sune, sune2, 0)

      expect(combo.position.ll_code).to eq("a3a7c3b7")
      expect(combo.name).to eq("Sune+SuneM")
      expect(combo.length).to eq(13)
      expect(combo.speed).to eq(8.58)
      expect(combo.moves).to eq("R U R' U R U2 R2 U' R U' R' U2 R")
      expect(combo.u_setup).to eq(0)

      expect(combo.base_alg1_id).to eq(sune.id)
      expect(combo.base_alg2_id).to eq(sune2.id)
    end

    it "aligns with the LL_CODE" do
      combo1 = ComboAlg.make(named_alg("L' U' L U L F' L' F", 'Mid'), named_alg("R U' L' U R' U' L", 'Nik'), 2)
      expect(combo1.position.ll_code).to eq("a1b4a3c6")
      expect(combo1.moves).to eq("F' U' F U F R' F' R B U' F' U B' U' F")
      expect(combo1.u_setup).to eq(3)
      expect(combo1.is_aligned_with_ll_code).to eq(true)

      combo2 = ComboAlg.make(named_alg("R B' R' F R B R' F'", 'Evl'), named_alg("R' F' U' F U R", 'Sho'))
      expect(combo2.position.ll_code).to eq("b2f1q4c7")
      expect(combo2.moves).to eq("B L' B' R B L B' R' B' R' U' R U B")
      expect(combo2.u_setup).to eq(1)
      expect(combo2.is_aligned_with_ll_code).to eq(true)
    end

    it "doesn't combine with empty alg" do
      none = RawAlg.make("", 0)
      expect{ComboAlg.make(sune, none, 0)}.to change{ComboAlg.count}.by 0
      expect{ComboAlg.make(none, sune, 0)}.to change{ComboAlg.count}.by 0
      expect{ComboAlg.make(sune, sune, 0)}.to change{ComboAlg.count}.by 1
    end
  end

  it '#merge_moves' do
    expect(ComboAlg.merge_moves("F U2 R'", "B F")).to eq(mv_start: "F U2 R'", mv_cancel1: "", mv_merged: "", mv_cancel2: "", mv_end: "B F", moves: "F U2 R' B F")
    expect(ComboAlg.merge_moves("F U2 R'", "R F")).to eq(mv_start: "F U2", mv_cancel1: "R'", mv_merged: "", mv_cancel2: "R", mv_end: "F", moves: 'F U2 F')
    expect(ComboAlg.merge_moves("F U2 R'", "R2 F")).to eq(mv_start: "F U2", mv_cancel1: "R'", mv_merged: "R", mv_cancel2: "R2", mv_end: "F", moves: "F U2 R F")
    expect(ComboAlg.merge_moves("F U2 R2", "R2 U F")).to eq(mv_start: "F", mv_cancel1: "U2 R2", mv_merged: "U'", mv_cancel2: "R2 U", mv_end: "F", moves: "F U' F")
    expect(ComboAlg.merge_moves("F U2 R2", "R2 U2 F'")).to eq(mv_start: "", mv_cancel1: "F U2 R2", mv_merged: "", mv_cancel2: "R2 U2 F'", mv_end: "", moves: "")

    expect(ComboAlg.merge_moves("L R", "L")).to eq(mv_start: "R", mv_cancel1: "L", mv_merged: "L2", mv_cancel2: "L", mv_end: "", moves: "L2 R")
    expect(ComboAlg.merge_moves("L", "R L")).to eq(mv_start: "", mv_cancel1: "L", mv_merged: "L2", mv_cancel2: "L", mv_end: "R", moves: "L2 R")
    expect(ComboAlg.merge_moves("D L R", "L' R' D")).to eq(mv_start: "", mv_cancel1: "D L R", mv_merged: "D2", mv_cancel2: "L' R' D", mv_end: "", moves: "D2")
    expect(ComboAlg.merge_moves("D L R", "L R F")).to eq(mv_start: "D", mv_cancel1: "L R", mv_merged: "L2 R2", mv_cancel2: "L R", mv_end: "F", moves: "D L2 R2 F")
    expect(ComboAlg.merge_moves("L F B2", "F B2 D")).to eq(mv_start: "L", mv_cancel1: "B2 F", mv_merged: "F2", mv_cancel2: "B2 F", mv_end: "D", moves: "L F2 D")

    expect(ComboAlg.merge_moves("B F' U'", "U B' F")).to eq(mv_start: "", mv_cancel1: "B F' U'", mv_merged: "", mv_cancel2: "U B' F", mv_end: "", moves: "")
  end

  it 'natural_ll_code' do
    unaligned = Cube.new("F' U' L' U L F")
    aligned = Cube.new("R' U' F' U F R")

    expect(aligned.standard_ll_code).to eq(unaligned.standard_ll_code)
    expect(aligned.standard_ll_code).to eq(aligned.natural_ll_code)
  end

end
