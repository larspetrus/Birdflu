require "rails_helper"

RSpec.describe Position, :type => :model do
  it "generated everything" do
    expect(Position.count).to eq(3916)
  end

  it "ll_code uniqueness" do
    expect(Position.create(ll_code: Position.find(1).ll_code)).not_to be_valid
 end

  it "#tweaks" do
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

    messy.set_filter_names
    expect(messy.cop).to eq('Bo')
    expect(messy.eo).to eq('7')
    expect(messy.ep).to eq('I')
  end

end
