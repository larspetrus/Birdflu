require 'rails_helper'

describe BigThought do

  describe 'combine' do
    let (:alg1) { RawAlg.make("B' R2 F R F' R B",  'G7', 7) }
    let (:alg2) { RawAlg.make("B L U L' U' B'",    'F1', 6) }
    let (:alg3) { RawAlg.make("B U' F' U B' U' F", 'G4', 7) }

    it "populates incrementally" do
      expect(counts(alg1.id)).to eq(base_alg1: 0, base_alg2: 0, total: 0)

      BigThought.combine(alg1)
      expect(counts(alg1.id)).to eq(base_alg1: 4, base_alg2: 4, total: 4)

      BigThought.combine(alg2)
      expect(counts(alg1.id)).to eq(base_alg1: 8, base_alg2: 8, total: 16)
      expect(counts(alg2.id)).to eq(base_alg1: 8, base_alg2: 8, total: 16)

      BigThought.combine(alg3)
      expect(counts(alg1.id)).to eq(base_alg1: 12, base_alg2: 12, total: 36)
      expect(counts(alg2.id)).to eq(base_alg1: 12, base_alg2: 12, total: 36)
      expect(counts(alg3.id)).to eq(base_alg1: 12, base_alg2: 12, total: 36)
    end

    it 'keeps track of what algs are combined' do
      expect(alg1.combined).to eq(false)
      BigThought.combine(alg1)
      expect(alg1.combined).to eq(true)
    end

    it 'removes cancellations' do
      BigThought.combine(alg1)
      BigThought.combine(alg9 = RawAlg.make("B' R' F R' F' R2 B",  'Reverse G7', 7))
      expect(counts(alg1.id)).to eq(base_alg1: 7, base_alg2: 7, total: 14)
      expect(counts(alg9.id)).to eq(base_alg1: 7, base_alg2: 7, total: 14)
    end

    def counts(base_id)
      counts = {}
      [:base_alg1, :base_alg2].each { |column| counts[column] = ComboAlg.where(column => base_id).count }
      counts[:total] = ComboAlg.count
      counts
    end
  end
end