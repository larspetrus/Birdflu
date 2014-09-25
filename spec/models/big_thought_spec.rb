require 'rails_helper'

describe BigThought do

  it 'makes all alg variants' do
    niks = BigThought.alg_variants('Nik', "L U' R' U L' U' R", true)

    expect(niks.map(&:moves)).to eq(["L U' R' U L' U' R", "R' U L U' R U L'", "B U' F' U B' U' F", "F' U B U' F U B'", "R U' L' U R' U' L", "L' U R U' L U R'", "F U' B' U F' U' B", "B' U F U' B U F'"])
    expect(niks.map(&:name)).to eq(["Nik", "NikM", "Nik", "NikM", "Nik", "NikM", "Nik", "NikM"])
    expect(niks.map(&:kind)).to eq(['solve', 'solve', 'generator', 'generator', 'generator', 'generator', 'generator', 'generator'])

    stigs = BigThought.alg_variants('Stig', "L U' R' U L' U' R", false)
    expect(stigs.map(&:name)).to eq(["Stig", "Stig", "Stig", "Stig"])
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
        ll_code   = Cube.new.setup_alg(alg[1]).standard_ll_code
        ll_code_M = Cube.new.setup_alg(BigThought.mirror(alg[1])).standard_ll_code

        revalg = BigThought.reverse(alg[1])
        rev_ll_code   = Cube.new.setup_alg(revalg).standard_ll_code
        rev_ll_code_M = Cube.new.setup_alg(BigThought.mirror(revalg)).standard_ll_code

        if ll_code == ll_code_M
          expect(alg[2]).to eq(:singleton), alg[0]
        elsif ll_code_M == rev_ll_code
          expect(alg[2]).to eq(:mirror_only), alg[0]
        else
          expect(alg[2]).to eq(:reverse), alg[0]
        end

      end
    end
  end
end