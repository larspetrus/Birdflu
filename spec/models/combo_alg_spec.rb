require 'rails_helper'

describe ComboAlg do
  describe 'construct' do
    let (:alg1) { RawAlg.make("B' R2 F R F' R B",  7) }
    let (:alg2) { RawAlg.make("B L U L' U' B'",    6) }
    let (:alg3) { RawAlg.make("B U' F' U B' U' F", 7) }

    it 'returns the stored data' do
      ca = ComboAlg.construct(alg1, alg2, 3, alg3, 2, 1)

      expect(ca.alg1_id).to eq(alg1.id)
      expect(ca.alg2_id).to eq(alg2.id)
      expect(ca.combined_alg_id).to eq(alg3.id)
      expect(ca.position_id).to eq(alg3.position_id)
      expect(ca.alg2_shift).to eq(3)
      expect(ca.cancel_count).to eq(2)
      expect(ca.merge_count).to eq(1)
    end
  end

  it '_merge_display_data' do
    alg1 = OpenStruct.new(moves: "F R U' B U B' R' F'")
    alg2 = OpenStruct.new(moves: "B L F' L F L2 B'")
    expect(ComboAlg._merge_display_data(alg1, alg2, 0, 3, 1)).to eq([["R B U' L U "], ["L' ", :merged], ["B' R'", :cancel1], [" + "], ["R B", :cancel2], [" L'", :merged], [" B L B2 R'", :alg2]])

    alg1 = OpenStruct.new(moves: "L' B L B' U' B' U B")
    alg2 = OpenStruct.new(moves: "B L' B' L U L U' L'")
    expect(ComboAlg._merge_display_data(alg1, alg2, 2, 0, 0)).to eq([["R' F R F' U' F' U F "], ["+"], [" L F' L' F U F U' F'", :alg2]])

    alg1 = OpenStruct.new(moves: "L U F U' F' L'")
    alg2 = OpenStruct.new(moves: "R' F2 L F L' F R")
    expect(ComboAlg._merge_display_data(alg1, alg2, 1, 0, 0)).to eq([["B U L U' L' B' "], ["+"], [" R' F2 L F L' F R", :alg2]])
  end
end
