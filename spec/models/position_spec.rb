require "rails_helper"

RSpec.describe Position, :type => :model do
  it "generated everything" do
    expect(Position.count).to eq(3916)
  end

  it "ll_code uniqueness" do
    expect(Position.create(ll_code: 'a1b1c1a1')).to be_valid
    expect(Position.create(ll_code: 'a1b1c1a1')).not_to be_valid
 end

  it "#tweaks" do
    expect(Position.create(ll_code: 'a1b1c1a1').as_roofpig_tweaks()).to eq('ULB:ULB UB:UB RUB:UBR UR:UR RFU:URF UF:UF UFL:UFL UL:UL')
    expect(Position.create(ll_code: 'a1c3c3c5').as_roofpig_tweaks()).to eq('ULB:ULB UB:UB BRU:UBR UF:UR RFU:URF UL:UF FLU:UFL UR:UL')
    expect(Position.create(ll_code: 'a3e6f1k4').as_roofpig_tweaks()).to eq('ULB:ULB UR:UB URF:UBR LU:UR LUF:URF UF:UF BRU:UFL BU:UL')
  end

  it "has algs" do
    null_alg = RawAlg.create(b_alg: '', alg_id: 'x')
    ComboAlg.make( RawAlg.create(b_alg: "F U F' U F U2 F'", alg_id: 'a1'), null_alg, 0)
    ComboAlg.make( RawAlg.create(b_alg: "F U2 F' U' F U' F'", alg_id: 'a2'), null_alg, 0)
    ComboAlg.make( RawAlg.create(b_alg: "B U B' U B U2 B'", alg_id: 'a3'), null_alg, 0)

    expect(Position.find_by!(ll_code: "a1c3c3c5").combo_algs.map(&:name)).to contain_exactly("a1+x", "a3+x")
    expect(Position.find_by!(ll_code: "a1b5b7b7").combo_algs.map(&:name)).to contain_exactly("a2+x")
  end

  it '#corner_swap_for' do
    expect(Position.corner_swap_for('a1a1a1a1')).to eq(:no)
    expect(Position.corner_swap_for('a1a1o1a1')).to eq(nil)
    expect(Position.corner_swap_for('a4e6o5a7')).to eq(:right)
    expect(Position.corner_swap_for('a6k5p5o6')).to eq(:back)
    expect(Position.corner_swap_for('a4i8c1j1')).to eq(:diagonal)
    expect(Position.corner_swap_for('b4k8p3q7')).to eq(:back)
    expect(Position.corner_swap_for('b2c2b2c2')).to eq(:no)
    expect(Position.corner_swap_for('b3f6g1k4')).to eq(:left)
    expect(Position.corner_swap_for('b5f1q5c1')).to eq(:right)
  end

  it '#set_cop_name' do
    messy = Position.create(ll_code: 'a4c5c1c4', cop: 'none')
    messy.set_cop_name
    expect(messy.cop).to eq('Bo')
  end

end
