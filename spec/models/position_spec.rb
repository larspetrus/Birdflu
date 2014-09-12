require "rails_helper"

RSpec.describe Position, :type => :model do

  it "ll_code uniqueness" do
    expect(Position.create(ll_code: 'a1b1c1a1')).to be_valid
    expect(Position.create(ll_code: 'a1b1c1a1')).not_to be_valid
 end

  it "#tweaks" do
    expect(Position.create(ll_code: 'a1b1c1a1').tweaks()).to eq('ULB:ULB UB:UB RUB:UBR UR:UR RFU:URF UF:UF UFL:UFL UL:UL')
    expect(Position.create(ll_code: 'a1c3c3c5').tweaks()).to eq('ULB:ULB UB:UB BRU:UBR UF:UR RFU:URF UL:UF FLU:UFL UR:UL')
    expect(Position.create(ll_code: 'a3e6f1k4').tweaks()).to eq('ULB:ULB UR:UB URF:UBR LU:UR LUF:URF UF:UF BRU:UFL BU:UL')
  end

  it "has algs" do
    a1 = LlAlg.create(name: 'a1', moves: "F U F' U F U2 F'")
    a2 = LlAlg.create(name: 'a2', moves: "F U2 F' U' F U' F'")
    a3 = LlAlg.create(name: 'a3', moves: "B U B' U B U2 B'")

    expect(Position.find_by!(ll_code: "a1c3c3c5").ll_algs.to_ary).to eq([a1, a3])
    expect(Position.find_by!(ll_code: "a1b5b7b7").ll_algs).to eq([a2])
  end

  it 'sets orientations' do
    solved = Position.create(ll_code: 'a1a1a1a1')
    expect(solved.oriented_edges).to eq(4)
    expect(solved.oriented_corners).to eq(4)

    messy = Position.create(ll_code: 'a4c5c1c4')
    expect(messy.oriented_edges).to eq(2)
    expect(messy.oriented_corners).to eq(1)
  end
end
