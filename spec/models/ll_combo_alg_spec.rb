require 'rails_helper'

describe LlComboAlg do

  it 'should combine the algs' do
    sunes = BigThought.alg_variants('Sune', "F U F' U F U2 F'")
    combo = LlComboAlg.new(sunes[0], sunes[1])

    expect(combo.ll_code_by_moves).to eq("a3a7c3b7")
    expect(combo.name).to eq("Sune-F+SuneM-F'")
    expect(combo.length).to eq(14)
  end
end