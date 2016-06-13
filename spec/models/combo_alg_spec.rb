require 'rails_helper'

describe 'construct' do
  let (:alg1) { RawAlg.make("B' R2 F R F' R B",  7) }
  let (:alg2) { RawAlg.make("B L U L' U' B'",    6) }
  let (:alg3) { RawAlg.make("B U' F' U B' U' F", 7) }

  it 'returns the stored data' do
    ca = ComboAlg.construct(alg1, alg2, 3, alg3, 2, 1)

    expect(ca.alg1_id).to eq(alg1.id)
    expect(ca.alg2_id).to eq(alg2.id)
    expect(ca.combined_alg_id).to eq(alg3.id)
    expect(ca.alg2_shift).to eq(3)
    expect(ca.cancel_count).to eq(2)
    expect(ca.merge_count).to eq(1)
  end
end