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
  end

  it "There can only be 18 moves" do
    expect { Move.new(:M, 2) }.to raise_error
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

end