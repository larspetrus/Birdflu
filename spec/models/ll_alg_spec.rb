require 'rails_helper'

RSpec.describe LlAlg, :type => :model do

  describe 'CRUD' do
    it 'create' do
      al = LlAlg.create(name: 'Bob', moves: "B U B' U B U2 B'", kind: 'solve')

      expect(al.name).to eq('Bob')
      expect(al.moves).to eq("B U B' U B U2 B'")
      expect(al.kind).to eq('solve')
      expect(al.length).to eq(7)
      expect(al.position).to eq(nil)
    end
  end

  it 'verifies F2L is preserved' do
      expect{LlAlg.create(name: "Not a LL alg!", moves: "F U D")}.to raise_error( RuntimeError, "Can't make LL code with F2L unsolved" )
  end

  it 'computes LL code' do
    sune = LlAlg.new(name: "Sune", moves: "F U F' U F U2 F'")
    expect(sune.solves_ll_code).to eq('a1c3c3c5')
  end

  it 'length' do
    expect(LlAlg.create(moves: "F U F' U F U2 F'", length: 99).length).to eq(7)
  end

  describe "#combo" do
    it 'combines the algs' do
      sune1 = LlAlg.create(name: 'Sune',  moves: "F U F' U F U2 F'")
      sune2 = LlAlg.create(name: 'SuneM', moves: "F' U' F U' F' U2 F")

      combo = LlAlg.create_combo(sune1, sune2)

      expect(combo.solves_ll_code).to eq("a3a7c3b7")
      expect(combo.position.ll_code).to eq("a3a7c3b7")
      expect(combo.name).to eq("Sune+SuneM")
      expect(combo.length).to eq(13)
      expect(combo.moves).to eq("R U R' U R U2 R2 U' R U' R' U2 R")
      expect(combo.u_setup).to eq(0)
      expect(combo.kind).to eq('combo')

      expect(combo.alg1).to eq(sune1)
      expect(combo.alg2).to eq(sune2)
    end

    it "aligns with the LL_CODE" do
      combo1 = LlAlg.create_combo(LlAlg.create(name: 'Mid', moves: "L' U' L U L F' L' F"), LlAlg.create(name: 'Nik', moves: "R U' L' U R' U' L"))
      expect(combo1.solves_ll_code).to eq("a1b4a3c6")
      expect(combo1.moves).to eq("F' U' F U F R' F' R B U' F' U B' U' F")
      expect(combo1.u_setup).to eq(3)

      combo2 = LlAlg.create_combo(LlAlg.create(name: 'Evl', moves: "R B' R' F R B R' F'"), LlAlg.create(name: 'Sho', moves: "R' F' U' F U R"))
      expect(combo2.solves_ll_code).to eq("b2f1q4c7")
      expect(combo2.moves).to eq("B L' B' R B L B' R' B' R' U' R U B")
      expect(combo2.u_setup).to eq(1)
    end
  end

  it '#merge_moves' do
    expect(LlAlg.merge_moves("F U2 R'", "B F")).to eq("F U2 R' B F")
    expect(LlAlg.merge_moves("F U2 R'", "R F")).to eq("F U2 F")
    expect(LlAlg.merge_moves("F U2 R'", "R2 F")).to eq("F U2 R F")
    expect(LlAlg.merge_moves("F U2 R2", "R2 U F")).to eq("F U' F")
    # expect(LlAlg.merge_moves("D L R", "L R F")).to eq("D L2 R2 F") # TODO !
    expect(LlAlg.merge_moves("F U2 R2", "R2 U2 F'")).to eq("")
  end

  it '#rotate_by_U' do
    expect(LlAlg.rotate_by_U("F U2 R' D B2 L'")).to eq("L U2 F' D R2 B'")
  end

end
