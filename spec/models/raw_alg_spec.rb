require 'rails_helper'

describe RawAlg do
  describe '#make()' do
    it 'all fields' do
      alg = RawAlg.make("R' F2 L F L' F R", 7)

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

      expect(alg.non_db?).to eq(false)
    end

    it 'all fields 2' do
      alg = RawAlg.make("B F' U B D L2 D' B' U' B' U2 F", 12)

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

    it 'all fields about Nothing' do
      alg = RawAlg.make("", 0)

      expect(alg.length).to eq(0)
      expect(alg.variant(:B)).to eq("")
      expect(alg.variant(:R)).to eq("")
      expect(alg.variant(:F)).to eq("")
      expect(alg.variant(:L)).to eq("")
      expect(alg.position.ll_code).to eq('a1a1a1a1')
      expect(alg.u_setup).to eq(0)
      expect(alg.moves).to eq("")
      expect(alg.specialness).to eq(nil)
      expect(alg.speed).to eq(0.0)
    end

    it 'picks right variant for moves' do
      expect(RawAlg.make("B L U L' U' B'", 6).moves).to eq("R B U B' U' R'")
      expect(RawAlg.make("R B U B' U' R'", 6).moves).to eq("R B U B' U' R'")
      expect(RawAlg.make("F R U R' U' F'", 6).moves).to eq("R B U B' U' R'")
      expect(RawAlg.make("L F U F' U' L'", 6).moves).to eq("R B U B' U' R'")

      expect(RawAlg.make("B U B' U B U2 B'", 6).moves).to eq("F U F' U F U2 F'")
      expect(RawAlg.make("R U R' U R U2 R'", 6).moves).to eq("F U F' U F U2 F'")

      expect(RawAlg.make("F' U2 F U F' U F", 6).moves).to eq("L' U2 L U L' U L")
    end

    it 'setup_moves' do
      u_setup_3 = RawAlg.make("B L U L' U' B'", 6)
      expect(u_setup_3.u_setup).to eq(3)
      expect(u_setup_3.setup_moves).to eq("| setupmoves=U'")
      expect(u_setup_3.setup_moves(1)).to eq("")
      expect(u_setup_3.setup_moves(2)).to eq("| setupmoves=U")
    end
  end

  describe 'find_x' do
    alg = "L' B' R' U2 R2 B L B' R' B F U2 F'"
    alg_m = Algs.mirror(alg)
    algs = [alg, alg_m, Algs.reverse(alg), Algs.reverse(alg_m)].map{|a| Algs.official_variant(a)}

    it 'mirror' do
      a1, a2, a3, a4 = algs.map{ |alg| RawAlg.make(alg, 13) }

      expect(a1.find_mirror).to eq(a2)
      expect(a2.find_mirror).to eq(a1)
      expect(a3.find_mirror).to eq(a4)
      expect(a4.find_mirror).to eq(a3)
    end

    it 'reverse' do
      a1, a2, a3, a4 = algs.map{ |alg| RawAlg.make(alg, 13) }

      expect(a1.find_reverse).to eq(a3)
      expect(a3.find_reverse).to eq(a1)
      expect(a2.find_reverse).to eq(a4)
      expect(a4.find_reverse).to eq(a2)
    end
  end


  it 'find_from_moves' do
    db_alg = RawAlg.make("F2 U L R' F2 L' R U F2", 9)

    expect(RawAlg.find_from_moves(db_alg.moves, db_alg.position).id).to eq(db_alg.id)
    expect(RawAlg.find_from_moves(Algs.shift(db_alg.moves, 2), db_alg.position).id).to eq(db_alg.id)
    expect(RawAlg.find_from_moves(Algs.anti_normalize(db_alg.moves), db_alg.position).id).to eq(db_alg.id)
    expect(RawAlg.find_from_moves("B D U' F U L F' D' B' U' L'", db_alg.position)).to eq(nil)
  end

  it 'computes name from id' do
    id_mins = [2, 5, 12]

    expect(RawAlg.name_for(2, id_mins)).to eq('F1')
    expect(RawAlg.name_for(6, id_mins)).to eq('G2')
    expect(RawAlg.name_for(25,id_mins)).to eq('H14')
    expect(RawAlg.name_for(1, id_mins)).to eq('Nothing')
    
    expect(RawAlg.id('F1',  id_mins)).to eq(2)
    expect(RawAlg.id('G2',  id_mins)).to eq(6)
    expect(RawAlg.id('H14', id_mins)).to eq(25)
    expect(RawAlg.id('h14', id_mins)).to eq(25)
    expect(RawAlg.id('Nothing', id_mins)).to eq(1)

    expect(RawAlg.id('G200', id_mins)).to eq(nil) # G7 is the highest G name
    expect(RawAlg.id('NotAnID', id_mins)).to eq(nil)
    # known problem: There is no check for non existent ID with max length, like H9999999 in this test case

    expect(RawAlg.instance_variable_get('@id_ranges')).to eq(nil) # Avoid test contamination. May be overkill
  end

  it 'as alg objects' do
    raw_alg = RawAlg.make("F2 U L R' F2 L' R U F2", 9)

    expect(raw_alg.ui_alg.to_s).to eq(raw_alg.moves)
    expect(raw_alg.db_alg.to_s).to eq(raw_alg._moves)
  end

  it 'non_bd' do
    alg = RawAlg.make_non_db("F U F' U F U2 F'")

    expect(alg.moves).to eq("F U F' U F U2 F'")
    expect(alg.length).to eq(7)
    expect(alg.speed).to eq(4.8)
    expect(alg.u_setup).to eq(2)
    expect(alg.name).to eq('-')
    expect(alg.specialness).to eq('FU Not in DB')

    expect(alg.id).to eq(nil)
    expect(alg.non_db?).to eq(true)
    expect(alg.matches(:anything)).to eq(true)

    expect(alg.valid?).to eq(false) # Make sure it can't end up in DB!

    not_special_alg = RawAlg.make_non_db("F' R U' B' U' B U' F U F' U R' U' B' U2 B F")
    expect(not_special_alg.specialness).to eq('Not in DB')
  end
  
  it 'nick_name' do
    expect(RawAlg.nick_names(8)).to eq("Sune")
    expect(RawAlg.nick_names(14)).to eq("Sune")

    expect(RawAlg.nick_names(1605)).to eq("Sune²")
    expect(RawAlg.nick_names(2636)).to eq("Sune²")

    expect(RawAlg.nick_names(123456)).to eq(nil)
  end
end
