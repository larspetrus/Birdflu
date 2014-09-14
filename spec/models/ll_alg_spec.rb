require 'rails_helper'

RSpec.describe LlAlg, :type => :model do

  describe 'CRUD' do
    it 'create' do
      al = LlAlg.create(name: 'Bob', moves: "B U B' U B U2 B'", kind: 'solve')

      expect(al.name).to eq('Bob')
      expect(al.moves).to eq("B U B' U B U2 B'")
      expect(al.kind).to eq('solve')
      expect(al.length).to eq(7)
      expect(al.position.ll_code).to eq("a1c3c3c5")
    end
  end

  it 'verifies F2L is preserved' do
    expect{LlAlg.create(name: "Not a LL alg!", moves: "F U D")}.to raise_error
  end

  it 'computes LL code' do
    sune = LlAlg.new(name: "Sune", moves: "F U F' U F U2 F'")
    expect(sune.solves_ll_code).to eq('a1c3c3c5')
  end

  it 'length' do
    expect(LlAlg.create(moves: "F U F' U F U2 F'", length: 99).length).to eq(7)
  end

  it '#combo combines the algs' do
    sunes = BigThought.alg_variants('Sune', "F U F' U F U2 F'")
    combo = LlAlg.create_combo(sunes[0], sunes[1])

    expect(combo.solves_ll_code).to eq("a3a7c3b7")
    expect(combo.position.ll_code).to eq("a3a7c3b7")
    expect(combo.name).to eq("Sune.F+SuneM.F'")
    expect(combo.length).to eq(13)
    expect(combo.moves).to eq("F U F' U F U2 F2 U' F U' F' U2 F")
    expect(combo.kind).to eq('combo')
    
    expect(combo.alg1).to eq(sunes[0])
    expect(combo.alg2).to eq(sunes[1])
  end

  it '#merge_moves' do
    expect(LlAlg.merge_moves("F U2 R'", "B F")).to eq("F U2 R' B F")
    expect(LlAlg.merge_moves("F U2 R'", "R F")).to eq("F U2 F")
    expect(LlAlg.merge_moves("F U2 R'", "R2 F")).to eq("F U2 R F")
    expect(LlAlg.merge_moves("F U2 R2", "R2 U F")).to eq("F U' F")
    # expect(LlAlg.merge_moves("D L R", "L R F")).to eq("D L2 R2 F") # TODO !
    expect(LlAlg.merge_moves("F U2 R2", "R2 U2 F'")).to eq("")
  end

end
