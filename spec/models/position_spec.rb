require "rails_helper"

RSpec.describe Position, :type => :model do
  it "generated everything" do
    expect(Position.count).to eq(4608)
    expect(Position.where('pov_position_id IS NULL').count).to eq(3916)
  end

  it "ll_code uniqueness" do
    expect(Position.create(ll_code: Position.find(1).ll_code)).not_to be_valid
 end

  it 'set_mirror_id' do
    does_not_work_for_POVs
  end

  it 'the inverse id thing' do
    does_not_work_for_POVs
  end

  it "#tweaks" do
    expect(Position.find_by!(ll_code: 'a1c3c3c5').as_roofpig_tweaks()).to eq('ULB:ULB UB:UB BRU:UBR UF:UR RFU:URF UL:UF FLU:UFL UR:UL')
    expect(Position.find_by!(ll_code: 'a3e6f1k4').as_roofpig_tweaks()).to eq('ULB:ULB UR:UB URF:UBR LU:UR LUF:URF UF:UF BRU:UFL BU:UL')
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

  it "has generated correct attributes" do
    pos = Position.find_by!(ll_code: "b7c7f7q7")
    expect(pos.attributes).to eq({"id"=>pos.id,
                                 "best_alg_id"       => pos.best_alg_id,
                                 "alg_count"         => pos.alg_count,
                                 "optimal_alg_length"=> pos.optimal_alg_length,
                                 "best_combo_alg_id" => pos.best_combo_alg_id,
                                 "mirror_id"         => pos.mirror_id,
                                 "pov_position_id"   => nil,
                                 "ll_code"    => "b7c7f7q7",
                                 "cop"        => "Ff",
                                 "oll"        => "m21",
                                 "eo"         => "4",
                                 "ep"         => "a",
                                 "co"         => "F",
                                 "cp"         => "f",
                                 "inverse_id" => nil,
                                 "weight"     => 1,
                                 "pov_offset" => 0,
                                 })


    pov_pos = Position.find_by!(ll_code: "b5k5p5q5")
    expect(pov_pos.attributes).to eq({"id"           => pov_pos.id,
                                 "best_alg_id"       => pov_pos.best_alg_id,
                                 "alg_count"         => pov_pos.alg_count,
                                 "optimal_alg_length"=> pov_pos.optimal_alg_length,
                                 "best_combo_alg_id" => pov_pos.best_combo_alg_id,
                                 "mirror_id"         => pov_pos.mirror_id,
                                 "pov_position_id"   => pos.id,
                                 "ll_code"    => "b5k5p5q5",
                                 "cop"        => "Fb",
                                 "oll"        => "m21",
                                 "eo"         => "4",
                                 "ep"         => "B",
                                 "co"         => "F",
                                 "cp"         => "b",
                                 "inverse_id" => nil,
                                 "weight"     => nil,
                                 "pov_offset" => 2,
                                })
  end

end
