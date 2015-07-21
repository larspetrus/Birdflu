require 'rails_helper'

describe BigThought do

  it 'makes all alg variants' do
    niks = BigThought.create_alg_bases('Nik', "L U' R' U L' U' R", true)

    expect(niks.map(&:moves_u0)).to eq(["L U' R' U L' U' R", "R' U L U' R U L'"])
    expect(niks.map(&:name)).to eq(["Nik", "NikM"])

    stigs = BigThought.create_alg_bases('Stig', "L U' R' U L' U' R", false)
    expect(stigs.map(&:name)).to eq(["Stig"])
  end

  it 'alg_label' do
    expect(BigThought.alg_label("F U F'")).to eq("F")
    expect(BigThought.alg_label("F2 U F'")).to eq("F2U")
    expect(BigThought.alg_label("F2 U2 F'")).to eq("F2U2F'")
  end

  it 'mirror' do
    expect(BigThought.mirror("F U' B2 D")).to eq("F' U B2 D'")
    expect(BigThought.mirror("R L' R2")).to eq("L' R L2")
    expect(BigThought.mirror("B L' B R2 B' L B R2 B2")).to eq("B' R B' L2 B R' B' L2 B2")
  end

  it 'reverse' do
    expect(BigThought.reverse("F U' B2 D")).to eq("D' B2 U F'")
    expect(BigThought.reverse("R L' R2")).to eq("R2 L R'")
    expect(BigThought.reverse("B L' B R2 B' L B R2 B2")).to eq("B2 R2 B' L' B R2 B' L B'")
  end

  describe 'root_algs' do
    #TODO Find dupes

    it "#reversibility is correct" do
      BigThought.all_root_algs.each do |alg|

        ll_code   = Cube.new(alg.moves).standard_ll_code
        ll_code_M = Cube.new(BigThought.mirror(alg.moves)).standard_ll_code

        revalg = BigThought.reverse(alg.moves)
        rev_ll_code   = Cube.new(revalg).standard_ll_code
        rev_ll_code_M = Cube.new(BigThought.mirror(revalg)).standard_ll_code

        if ll_code == ll_code_M
          expect(alg.type).to eq(:singleton), alg.name
        elsif ll_code_M == rev_ll_code
          expect(alg.type).to eq(:mirror_only), alg.name
        else
          expect(alg.type).to eq(:reverse), alg.name
        end

      end
    end
  end

  describe 'combine' do
    let (:root1) { BigThought.root_alg("H435",  "F R U R' U' F'") }
    let (:root2) { BigThought.root_alg("Arne",  "R2 F2 B2 L2 D L2 B2 F2 R2", :singleton) }
    let (:root3) { BigThought.root_alg("Niklas","L U' R' U L' U' R", :mirror_only) }

    it "populates incrementally" do
      BigThought.combine(alg1 = BaseAlg.make(root1.name, root1.moves))
      expect(counts(alg1.id)).to eq(base_alg1: 5, base_alg2: 4, total: 5)

      BigThought.combine(alg2 = BaseAlg.make(root2.name, root2.moves))
      expect(counts(alg1.id)).to eq(base_alg1: 9, base_alg2: 8, total: 18)
      expect(counts(alg2.id)).to eq(base_alg1: 9, base_alg2: 8, total: 18)

      BigThought.combine(alg3 = BaseAlg.make(root3.name, root3.moves))
      expect(counts(alg1.id)).to eq(base_alg1: 13, base_alg2: 12, total: 39)
      expect(counts(alg2.id)).to eq(base_alg1: 13, base_alg2: 12, total: 39)
      expect(counts(alg3.id)).to eq(base_alg1: 13, base_alg2: 12, total: 39)
    end

    it 'removes cancellations' do
      BigThought.combine(alg1 = BaseAlg.make(root1.name, root1.moves))
      BigThought.combine(alg2 = BaseAlg.make("AntiH435",  "F U R U' R' F'"))
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