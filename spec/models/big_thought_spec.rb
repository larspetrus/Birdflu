require 'rails_helper'

describe BigThought do

  describe 'root_algs' do

    xit "algs are unique" do
      pending(%Q(This takes 5 seconds AND fails on "L R'" vs "R' L" diffs))
      dupes = []
      seen_moves = {}
      RootAlg.all.each do |alg|
        if seen_moves[alg.moves]
          dupes << "#{alg.name} has the same moves as #{seen_moves[alg.moves]}"
        end
        all_variations(alg.moves).each do |variation|
          seen_moves[variation] = alg.name
        end

      end
      expect(dupes).to eq([])
    end

    def all_variations(moves)
      all = []
      [moves, Algs.mirror(moves), Algs.reverse(moves), Algs.mirror(Algs.reverse(moves))].each do |base_variant|
        all << base_variant
        3.times { all << Algs.rotate_by_U(all.last) }
      end
      all.uniq
    end

  end

  describe 'combine' do
    let (:root1) { {b_alg: "B' R2 F R F' R B",  alg_id: 'G7', length: 7} }
    let (:root2) { {b_alg: "B L U L' U' B'",    alg_id: 'F1', length: 6} }
    let (:root3) { {b_alg: "B U' F' U B' U' F", alg_id: 'G4', length: 7} }

    it "populates incrementally" do
      alg1 = RawAlg.create(root1)
      alg2 = RawAlg.create(root2)
      alg3 = RawAlg.create(root3)

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
      alg = RawAlg.create(root1)
      expect(alg.combined).to eq(false)
      BigThought.combine(alg)
      expect(alg.combined).to eq(true)
    end

    it 'removes cancellations' do
      BigThought.combine(alg1 = RawAlg.create(root1))
      BigThought.combine(alg2 = RawAlg.create({b_alg: "B' R' F R' F' R2 B",  alg_id: 'Reverse G7', length: 7}))
      expect(counts(alg1.id)).to eq(base_alg1: 7, base_alg2: 7, total: 14)
      expect(counts(alg2.id)).to eq(base_alg1: 7, base_alg2: 7, total: 14)
    end

    def counts(base_id)
      counts = {}
      [:base_alg1, :base_alg2].each { |column| counts[column] = ComboAlg.where(column => base_id).count }
      counts[:total] = ComboAlg.count
      counts
    end
  end
end