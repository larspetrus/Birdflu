require 'rails_helper'

describe BigThought do

  it 'alg_label' do
    expect(BigThought.alg_label("F U F'")).to eq("F")
    expect(BigThought.alg_label("F2 U F'")).to eq("F2U")
    expect(BigThought.alg_label("F2 U2 F'")).to eq("F2U2F'")
  end

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
      [moves, BaseAlg.mirror(moves), BaseAlg.reverse(moves), BaseAlg.mirror(BaseAlg.reverse(moves))].each do |base_variant|
        all << base_variant
        3.times { all << BaseAlg.rotate_by_U(all.last) }
      end
      all.uniq
    end

  end

  describe 'combine' do
    let (:root1) { RootAlg.new("H435",  "F R U R' U' F'") }
    let (:root2) { RootAlg.new("Arne",  "R2 F2 B2 L2 D L2 B2 F2 R2")} # :singleton
    let (:root3) { RootAlg.new("Niklas","L U' R' U L' U' R") } # :mirror_only

    it "populates incrementally" do
      alg1 = BaseAlg.make(root1.moves, name: root1.name)
      expect(counts(alg1.id)).to eq(base_alg1: 1, base_alg2: 0, total: 1)
      BigThought.combine(alg1)
      expect(counts(alg1.id)).to eq(base_alg1: 5, base_alg2: 4, total: 5)

      BigThought.combine(alg2 = BaseAlg.make(root2.moves, name: root2.name))
      expect(counts(alg1.id)).to eq(base_alg1: 9, base_alg2: 8, total: 18)
      expect(counts(alg2.id)).to eq(base_alg1: 9, base_alg2: 8, total: 18)

      BigThought.combine(alg3 = BaseAlg.make(root3.moves, name: root3.name))
      expect(counts(alg1.id)).to eq(base_alg1: 13, base_alg2: 12, total: 39)
      expect(counts(alg2.id)).to eq(base_alg1: 13, base_alg2: 12, total: 39)
      expect(counts(alg3.id)).to eq(base_alg1: 13, base_alg2: 12, total: 39)
    end

    it 'keeps track of what algs are combined' do
      alg = BaseAlg.make(root1.moves, name: root1.name)
      expect(alg.combined).to eq(false)
      BigThought.combine(alg)
      expect(alg.combined).to eq(true)
    end

    it 'removes cancellations' do
      BigThought.combine(alg1 = BaseAlg.make(root1.moves, name: root1.name))
      BigThought.combine(alg2 = BaseAlg.make("F U R U' R' F'", name: "AntiH435"))
      expect(counts(alg1.id)).to eq(base_alg1: 8, base_alg2: 7, total: 16)
      expect(counts(alg2.id)).to eq(base_alg1: 8, base_alg2: 7, total: 16)
    end

    def counts(base_id)
      counts = {}
      [:base_alg1, :base_alg2].each { |column| counts[column] = ComboAlg.where(column => base_id).count }
      counts[:total] = ComboAlg.count
      counts
    end
  end
end