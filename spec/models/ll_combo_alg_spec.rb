require 'rails_helper'

describe LlComboAlg do

  it 'should combine the algs' do
    sunes = BigThought.alg_variants('Sune', "F U F' U F U2 F'")
    combo = LlComboAlg.new(sunes[0], sunes[1])

    expect(combo.ll_code_by_moves).to eq("a3a7c3b7")
    expect(combo.name).to eq("Sune-F+SuneM-F'")
    expect(combo.length).to eq(13)
    expect(combo.moves).to eq("F U F' U F U2 F2 U' F U' F' U2 F")
  end

  it '#merge_moves' do
    expect(LlComboAlg.merge_moves("F U2 R'", "B F")).to eq("F U2 R' B F")
    expect(LlComboAlg.merge_moves("F U2 R'", "R F")).to eq("F U2 F")
    expect(LlComboAlg.merge_moves("F U2 R'", "R2 F")).to eq("F U2 R F")
    expect(LlComboAlg.merge_moves("F U2 R2", "R2 U F")).to eq("F U' F")
    # expect(LlComboAlg.merge_moves("D L R", "L R F")).to eq("D L2 R2 F") # TODO !
  end
end