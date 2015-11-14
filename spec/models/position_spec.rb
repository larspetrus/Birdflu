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
    null_alg = double(algs: '', length: 88, alg_id: 'x', id: 99)
    ComboAlg.make( RawAlg.make("F U F' U F U2 F'", 'a1'), null_alg, 0)
    ComboAlg.make( RawAlg.make("F U2 F' U' F U' F'", 'a2'), null_alg, 0)
    ComboAlg.make( RawAlg.make("B U B' U B U2 B'", 'a3'), null_alg, 0)

    expect(Position.find_by!(ll_code: "a1c3c3c5").combo_algs.map(&:name)).to contain_exactly("a1+x", "a3+x")
    expect(Position.find_by!(ll_code: "a1b5b7b7").combo_algs.map(&:name)).to contain_exactly("a2+x")
  end

  it '#set_x_name' do
    messy = Position.create(ll_code: 'a4c5c1c4', cop: 'none')

    messy.set_cop_name
    expect(messy.cop).to eq('Bo')

    messy.set_eo_name
    expect(messy.eo).to eq('7')

    messy.set_ep_name
    expect(messy.ep).to eq('I')
  end

end
