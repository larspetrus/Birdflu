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
    alg1 = double(moves: "F R U' B U B' R' F'")
    alg2 = double(moves: "B L F' L F L2 B'")
    expect(ComboAlg._merge_display_data(alg1, alg2, 0, 3, 1)).to eq([["R B U' L U "], ["L' ", :merged], ["B' R'", :cancel1], [" + "], ["R B", :cancel2], [" L'", :merged], [" B L B2 R'", :alg2]])

    alg1 = double(moves: "L' B L B' U' B' U B")
    alg2 = double(moves: "B L' B' L U L U' L'")
    expect(ComboAlg._merge_display_data(alg1, alg2, 2, 0, 0)).to eq([["R' F R F' U' F' U F "], ["+"], [" L F' L' F U F U' F'", :alg2]])

    alg1 = double(moves: "L U F U' F' L'")
    alg2 = double(moves: "R' F2 L F L' F R")
    expect(ComboAlg._merge_display_data(alg1, alg2, 1, 0, 0)).to eq([["B U L U' L' B' "], ["+"], [" R' F2 L F L' F R", :alg2]])

    alg1 = double(moves: "B U2 L F U' F' U' L' U' B'")
    alg2 = double(moves: "L2 R' U L2 U' R U L2 U' L2")
    expect(ComboAlg._merge_display_data(alg1, alg2, 3, 0, 0)).to eq([["R U2 B L U' L' U' B' U' R' "], ["+"], [" B2 F' U B2 U' F U B2 U' B2", :alg2]])

    alg1 = double(moves: "L' U R U' L U R'")
    alg2 = double(moves: "L' R U R' U' L U2 R U2 R'")
    expect(ComboAlg._merge_display_data(alg1, alg2, 0, 1, 0)).to eq([["L' U R U' L U "], ["R'", :cancel1],[" + "], ["R", :cancel2], [" L' U R' U' L U2 R U2 R'", :alg2]])
  end
end
