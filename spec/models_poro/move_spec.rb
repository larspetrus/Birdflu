require 'rails_helper'

describe Move do

  it "#[]" do
    expect(Move["L'"]).to eq(Move::Lp)
    expect(Move["U2"]).to eq(Move::U2)
    expect(Move["B"]).to eq(Move::B)

    r2 = Move['R2']
    expect(r2.side).to eq(:R)
    expect(r2.turns).to eq(2)
    expect(r2.name).to eq('R2')

    expect {Move['M']}.to raise_error(RuntimeError, 'Invalid move code: "M"')
  end

  it "There can only be 18 moves" do
    expect { Move.new(:M, 2) }.to raise_error(RuntimeError, "Attempt to create 19th move: Move.new(M, 2)")
  end

  it '#name_from' do
    expect(Move.name_from("F", 1)).to eq("F")
    expect(Move.name_from("L", 2)).to eq("L2")
    expect(Move.name_from("B", 3)).to eq("B'")
  end

  it '#same_side' do
    expect(Move.same_side("F'", "F2")).to eq(true)
    expect(Move.same_side("F2", "R2")).to eq(false)
    expect(Move.same_side("F", nil)).to eq(false)
    expect(Move.same_side(nil, "L")).to eq(false)
  end

  it '#opposite_sides' do
    expect(Move.opposite_sides("F'", "B")).to eq(true)
    expect(Move.opposite_sides("F", "R2")).to eq(false)
    expect(Move.opposite_sides("F", nil)).to eq(false)
    expect(Move.opposite_sides(nil, "L")).to eq(false)
  end

  it '#merge' do
    expect(Move.merge("F", "F2")).to eq("F'")
    expect(Move.merge("F2", "F'")).to eq("F")
    expect(Move.merge("F2", "F2")).to eq(nil)
    expect(Move.merge("F'", "F'")).to eq("F2")
  end

  it '#turns' do
    expect(Move.turns("F")).to eq(1)
    expect(Move.turns("B2")).to eq(2)
    expect(Move.turns("U'")).to eq(3)
  end

  it ".inverse" do
    expect(Move::F.inverse ).to eq(Move::Fp)
    expect(Move::L2.inverse).to eq(Move::L2)
    expect(Move::Dp.inverse).to eq(Move::D)
  end

end


describe SideTracker do
  it "knows_sides" do
    tracker = SideTracker.new

    expect(tracker.side_at('R')).to eq('R')
    expect(tracker.side_at('D')).to eq('D')
    expect(tracker.side_at('J')).to be_nil
  end

  it "tracks_sides" do
    tracker = SideTracker.new
    tracker.track('R')
    expect(tracker.side_at('R')).to eq('R')
    expect(tracker.side_at('D')).to eq('D')
    expect(tracker.side_at('J')).to be_nil

    tracker = SideTracker.new
    tracker.track('x')
    expect(tracker.side_at('R')).to eq('R')
    expect(tracker.side_at('D')).to eq('F')
    expect(tracker.side_at('F')).to eq('U')

    tracker = SideTracker.new
    tracker.track('x2')
    expect(tracker.side_at('R')).to eq('R')
    expect(tracker.side_at('D')).to eq('U')
    expect(tracker.side_at('F')).to eq('B')
  end

  it 'can track an alg' do
    expect(SideTracker.new.to_classic("R U R' x U R U' x'")).to eq("R U R' F R F'")
  end

  it ".normalize" do
    expect(SideTracker.normalize("L R L2")).to eq("L' R")
    expect(SideTracker.normalize("L L L' R")).to eq("L R")
    expect(SideTracker.normalize("R L L L R")).to eq("L' R2")

    expect(SideTracker.normalize("L R L2 U D U F2 B' F2")).to eq("L' R D U2 B'")

    expect(SideTracker.normalize("R L L L D D' L R")).to eq("R2")
  end
end


describe NotationDoctor do
  it "converts correctly" do
    # Classic format algs are unchanged
    expect(NotationDoctor.to_classic_notation("F U F' U F U2 F'")).to eq("F U F' U F U2 F'")
    expect(NotationDoctor.to_classic_notation(%w(F U F' U F U2 F'))).to eq("F U F' U F U2 F'")


    # Handles "advanced" moves:
    expect(NotationDoctor.to_classic_notation(DuAlg.new("f R U R' U' f'"))).to eq("B U L U' L' B'")
    expect(NotationDoctor.to_classic_notation("f R U R' U' f'")).to eq("B U L U' L' B'")  # OLL 45 setup
    expect(NotationDoctor.to_classic_notation("M' R' U' R U' R' U2 R U' M")).to eq("L R2 F' R F' R' F2 R F' L' R")

    expect(NotationDoctor.to_classic_notation(%w(f R U R' U' f'))).to eq("B U L U' L' B'")  # A list argument also works

    expect(NotationDoctor.to_classic_notation("B z R U R' U' B' z'")).to eq("B U L U' L' B'")
    expect(NotationDoctor.to_classic_notation("f R U R' U' f'")).to eq("B U L U' L' B'")

    expect(NotationDoctor.to_classic_notation("L F2 R' F' R F' L'")).to eq("L F2 R' F' R F' L'")
    expect(NotationDoctor.to_classic_notation("r U2 R' U' R U' r'")).to eq("L F2 R' F' R F' L'")

    expect(NotationDoctor.to_classic_notation("M U M'")).to eq("L' R B L R'")
    expect(NotationDoctor.to_classic_notation("R U R' x U R U' x'")).to eq("R U R' F R F'")
    expect(NotationDoctor.to_classic_notation("E' R E x U R U' x'")).to eq("D U' B D' U F R F'")
  end

  it "handles move interactions/cancellations" do
    expect(NotationDoctor.to_classic_notation("R L")).to eq("L R")
    expect(NotationDoctor.to_classic_notation("L y B")).to eq("L2")
    expect(NotationDoctor.to_classic_notation("L R L")).to eq("L2 R")
  end

  it "_to_classic_plus_xyz" do
    expect(NotationDoctor._to_classic_plus_xyz(DuAlg.new("f R U R' U' f'"))).to eq("B z R U R' U' B' z'")
    expect(NotationDoctor._to_classic_plus_xyz("M' R' U' R U' R' U2 R U' M")).to eq("L R' x R' U' R U' R' U2 R U' L' R x'")
  end
end