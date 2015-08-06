require 'rails_helper'

RSpec.describe BaseAlg, :type => :model do

  describe 'CRUD' do
    it 'create / make' do
      al = BaseAlg.make('Bob', "B U B' U B U2 B'")

      expect(al.name).to eq('Bob')
      expect(al.id).to eq(al.root_base_id)
      expect(al.moves(0)).to eq("B U B' U B U2 B'")
      expect(al.moves(1)).to eq("R U R' U R U2 R'")
      expect(al.moves(2)).to eq("F U F' U F U2 F'")
      expect(al.moves(3)).to eq("L U L' U L U2 L'")
    end
  end

  describe 'create_family' do
    it 'of 1' do
      stigs= BaseAlg.create_group('Stig', "F U R U' R' F'", [:a])

      expect(stigs.map(&:name)).to eq(["Stig"])
      expect(stigs.map(&:moves_u0)).to eq(["F U R U' R' F'"])
      expect(stigs[0].id).to eq(stigs[0].root_base_id)
    end

    it 'of 2' do
      niks = BaseAlg.create_group('Nik', "L U' R' U L' U' R", [:a, :Ma])

      expect(niks.map(&:name)).to eq(["Nik", "M.Nik"])
      expect(niks.map(&:moves_u0)).to eq(["L U' R' U L' U' R", "R' U L U' R U L'"])
      expect(niks[0].id).to eq(niks[0].root_base_id)
      expect(niks.map(&:root_base_id)).to eq([niks[0].id, niks[0].id])
    end

    it 'of 4' do
      sagas = BaseAlg.create_group('Saga', "R' U' R U' R' U2 R", [:a, :Ma, :Aa, :AMa])

      expect(sagas.map(&:name)).to eq(["Saga", "M.Saga", "A.Saga", "AM.Saga"])
      expect(sagas.map(&:moves_u0)).to eq(["R' U' R U' R' U2 R", "L U L' U L U2 L'", "R' U2 R U R' U R", "L U2 L' U' L U' L'"])
      expect(sagas[0].id).to eq(sagas[0].root_base_id)
      expect(sagas.map(&:root_base_id)).to eq([sagas[0].id, sagas[0].id, sagas[0].id, sagas[0].id])
    end
  end

  it 'mirror' do
    expect(BaseAlg.mirror("F U' B2 D")).to eq("F' U B2 D'")
    expect(BaseAlg.mirror("R L' R2")).to eq("L' R L2")
    expect(BaseAlg.mirror("B L' B R2 B' L B R2 B2")).to eq("B' R B' L2 B R' B' L2 B2")
  end

  it 'reverse' do
    expect(BaseAlg.reverse("F U' B2 D")).to eq("D' B2 U F'")
    expect(BaseAlg.reverse("R L' R2")).to eq("R2 L R'")
    expect(BaseAlg.reverse("B L' B R2 B' L B R2 B2")).to eq("B2 R2 B' L' B R2 B' L B'")
  end

  it 'verifies F2L is preserved' do
      expect{BaseAlg.make("Not a LL alg!", "F U D")}.to raise_error( RuntimeError, "Can't make LL code with F2L unsolved" )
  end

  it '#rotate_by_U' do
    expect(BaseAlg.rotate_by_U("F U2 R' D B2 L'")).to eq("L U2 F' D R2 B'")
  end

end
