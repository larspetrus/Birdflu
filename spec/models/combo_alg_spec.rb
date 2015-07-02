require 'rails_helper'

RSpec.describe ComboAlg, :type => :model do

  it 'verifies F2L is preserved' do
      expect{ComboAlg.create(name: "Not a LL alg!", moves: "F U D")}.to raise_error( RuntimeError, "Can't make LL code with F2L unsolved" )
  end

  it 'computes LL code' do
    sune = ComboAlg.new(name: "Sune", moves: "F U F' U F U2 F'")
    expect(sune.solves_ll_code).to eq('a1c3c3c5')
  end

  it 'length' do
    expect(ComboAlg.create(moves: "F U F' U F U2 F'", length: 99).length).to eq(7)
  end

  describe "#create-ish" do
    it 'combines the algs' do
      sune1 = BaseAlg.make('Sune',  "F U F' U F U2 F'")
      sune2 = BaseAlg.make('SuneM', "F' U' F U' F' U2 F")

      combo = ComboAlg.create_combo(sune1, sune2, 0)

      expect(combo.solves_ll_code).to eq("a3a7c3b7")
      expect(combo.position.ll_code).to eq("a3a7c3b7")
      expect(combo.name).to eq("Sune+SuneM")
      expect(combo.length).to eq(13)
      expect(combo.moves).to eq("R U R' U R U2 R2 U' R U' R' U2 R")
      expect(combo.u_setup).to eq(0)

      expect(combo.base_alg1).to eq(sune1)
      expect(combo.base_alg2).to eq(sune2)
    end

    it "aligns with the LL_CODE" do
      combo1 = ComboAlg.create_combo(BaseAlg.make('Mid', "L' U' L U L F' L' F"), BaseAlg.make('Nik', "R U' L' U R' U' L"), 0)
      expect(combo1.solves_ll_code).to eq("a1b4a3c6")
      expect(combo1.moves).to eq("F' U' F U F R' F' R B U' F' U B' U' F")
      expect(combo1.u_setup).to eq(3)

      combo2 = ComboAlg.create_combo(BaseAlg.make('Evl', "R B' R' F R B R' F'"), BaseAlg.make('Sho', "R' F' U' F U R"), 0)
      expect(combo2.solves_ll_code).to eq("b2f1q4c7")
      expect(combo2.moves).to eq("B L' B' R B L B' R' B' R' U' R U B")
      expect(combo2.u_setup).to eq(1)
    end
  end

  it '#merge_moves' do
    expect(ComboAlg.merge_moves("F U2 R'", "B F")).to eq(mv_start: "F U2 R'", mv_cancel1: "", mv_merged: "", mv_cancel2: "", mv_end: "B F", moves: "F U2 R' B F")
    expect(ComboAlg.merge_moves("F U2 R'", "R F")).to eq(mv_start: "F U2", mv_cancel1: "R'", mv_merged: "", mv_cancel2: "R", mv_end: "F", :moves=> 'F U2 F')
    expect(ComboAlg.merge_moves("F U2 R'", "R2 F")).to eq(mv_start: "F U2", mv_cancel1: "R'", mv_merged: "R", mv_cancel2: "R2", mv_end: "F", moves: "F U2 R F")
    expect(ComboAlg.merge_moves("F U2 R2", "R2 U F")).to eq(mv_start: "F", mv_cancel1: "U2 R2", mv_merged: "U'", mv_cancel2: "R2 U", mv_end: "F", moves: "F U' F")
    # expect(ComboAlg.merge_moves("D L R", "L R F")).to eq(mv_start: "D", mv_cancel1: "L R", mv_merged: "L2 R2", mv_cancel2: "L R", mv_end: "F", :moves=>"D L2 R2 F") # TODO !
    expect(ComboAlg.merge_moves("F U2 R2", "R2 U2 F'")).to eq(:mv_start=>"", :mv_cancel1=>"F U2 R2", :mv_merged=>"", :mv_cancel2=>"R2 U2 F'", :mv_end=>"", :moves=>"")
  end

  it '#rotate_by_U' do
    expect(ComboAlg.rotate_by_U("F U2 R' D B2 L'")).to eq("L U2 F' D R2 B'")
  end

end