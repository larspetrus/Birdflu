require 'rails_helper'

describe RawAlg do
  describe '#make()' do
    it 'all fields' do
      alg = RawAlg.make("R' F2 L F L' F R", 'G7', 7)

      expect(alg.alg_id).to eq('G7')
      expect(alg.length).to eq(7)
      expect(alg.variant(:B)).to eq("B' R2 F R F' R B")
      expect(alg.variant(:R)).to eq("R' F2 L F L' F R")
      expect(alg.variant(:F)).to eq("F' L2 B L B' L F")
      expect(alg.variant(:L)).to eq("L' B2 R B R' B L")
      expect(alg.position.ll_code).to eq('a5c8c8c1')
      expect(alg.u_setup).to eq(2)
      expect(alg.moves).to eq("R' F2 L F L' F R")
      expect(alg.specialness).to eq("LFR")
      expect(alg.speed).to eq(6.3)

      expect(alg.mirror_id).to eq(nil) # must run RawAlg.populate_mirror_id after loading algs
    end

    it 'all fields ' do
      alg = RawAlg.make("B F' U B D L2 D' B' U' B' U2 F", 'L1172', 12)

      expect(alg.alg_id).to eq('L1172')
      expect(alg.length).to eq(12)
      expect(alg.variant(:B)).to eq("B F' U B D L2 D' B' U' B' U2 F")
      expect(alg.variant(:R)).to eq("L' R U R D B2 D' R' U' R' U2 L")
      expect(alg.variant(:F)).to eq("B' F U F D R2 D' F' U' F' U2 B")
      expect(alg.variant(:L)).to eq("L R' U L D F2 D' L' U' L' U2 R")
      expect(alg.position.ll_code).to eq('a1a5a7a7')
      expect(alg.u_setup).to eq(0)
      expect(alg.moves).to eq("B F' U B D L2 D' B' U' B' U2 F")
      expect(alg.specialness).to eq(nil)
      expect(alg.speed).to eq(10.74)
    end

    it 'picks right variant for moves' do
      expect(RawAlg.make("B L U L' U' B'", 'x', 6).moves).to eq("R B U B' U' R'")
      expect(RawAlg.make("R B U B' U' R'", 'x', 6).moves).to eq("R B U B' U' R'")
      expect(RawAlg.make("F R U R' U' F'", 'x', 6).moves).to eq("R B U B' U' R'")
      expect(RawAlg.make("L F U F' U' L'", 'x', 6).moves).to eq("R B U B' U' R'")

      expect(RawAlg.make("B U B' U B U2 B'", 'x', 6).moves).to eq("F U F' U F U2 F'")
      expect(RawAlg.make("R U R' U R U2 R'", 'x', 6).moves).to eq("F U F' U F U2 F'")

      expect(RawAlg.make("F' U2 F U F' U F", 'x', 6).moves).to eq("L' U2 L U L' U L")
    end

    it 'setup_moves' do
      u_setup_3 = RawAlg.make("B L U L' U' B'", 'x', 6)
      expect(u_setup_3.u_setup).to eq(3)
      expect(u_setup_3.setup_moves).to eq("| setupmoves=U'")
      expect(u_setup_3.setup_moves(1)).to eq("")
      expect(u_setup_3.setup_moves(2)).to eq("| setupmoves=U")
    end
  end

  it 'find_from_moves' do
    db_alg = RawAlg.make("F2 U L R' F2 L' R U F2", 'I143', 9)

    expect(RawAlg.find_from_moves(db_alg.moves, db_alg.position).alg_id).to eq('I143')
    expect(RawAlg.find_from_moves(Algs.anti_normalize(db_alg.moves), db_alg.position).alg_id).to eq('I143')
    expect(RawAlg.find_from_moves("B D U' F U L F' D' B' U' L'", db_alg.position)).to eq(nil)
  end
end
