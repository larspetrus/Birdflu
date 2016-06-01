require "rails_helper"

def named_alg(alg, name)
  RawAlg.make(alg).tap{|ra| allow(ra).to receive(:name) { name } }
end

RSpec.describe Position, :type => :model do
  it "generated everything" do
    expect(Position.count).to eq(4608)
    expect(Position.where('main_position_id = id').count).to eq(3916)
  end

  it "ll_code uniqueness" do
    expect(Position.create(ll_code: Position.find(1).ll_code)).not_to be_valid
 end

  it "pov_variant_in" do
    main_pos = Position.find_by!(ll_code: "a3a6e6o7")
    variants = Position.where(main_position_id: main_pos.id)

    expect(main_pos.pov_variant_in([1, 2, main_pos.id, 8])).to eq(main_pos)
    expect(main_pos.pov_variant_in([1, 2, variants[1].id, 8])).to eq(variants[1])

    # pick main id over others
    expect(main_pos.pov_variant_in([variants[1].id, variants[2].id, main_pos.id])).to eq(main_pos)
  end

  it 'pov_rotations' do
    no_rotation_pos = Position.find_by!(ll_code: 'a7a3b7c3')
    expect(no_rotation_pos.pov_rotations).to eq([])

    main_pov = Position.find_by!(ll_code: 'a7a7e7o7')
    alt_pov  = Position.find_by!(ll_code: 'a1e1e1i1')
    pov_ids = Position.where(main_position_id: main_pov.id).pluck(:id)

    expect(main_pov.pov_rotations).to eq(pov_ids - [main_pov.id])
    expect(alt_pov.pov_rotations).to  eq(pov_ids - [alt_pov.id])
  end

  it "#tweaks" do
    expect(Position.find_by!(ll_code: 'a1c3c3c5').as_roofpig_tweaks()).to eq('ULB:ULB UB:UB BRU:UBR UF:UR RFU:URF UL:UF FLU:UFL UR:UL')
    expect(Position.find_by!(ll_code: 'a3e6f1k4').as_roofpig_tweaks()).to eq('ULB:ULB UR:UB URF:UBR LU:UR LUF:URF UF:UF BRU:UFL BU:UL')
  end

  it "has algs" do
    null_alg = double(algs: '', length: 88, name: 'x', id: 99)
    ComboAlg.make( named_alg("F U F' U F U2 F'", 'a1'), null_alg, 0)
    ComboAlg.make( named_alg("F U2 F' U' F U' F'", 'a2'), null_alg, 0)
    ComboAlg.make( named_alg("B U B' U B U2 B'", 'a3'), null_alg, 0)

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
    expect(pos.attributes).to eq({"id"               => pos.id,
                                 "best_alg_id"       => pos.best_alg_id,
                                 "alg_count"         => pos.alg_count,
                                 "optimal_alg_length"=> pos.optimal_alg_length,
                                 "mirror_id"         => pos.mirror_id,
                                 "main_position_id"  => pos.id,
                                 "ll_code"    => "b7c7f7q7",
                                 "cop"        => "Ff",
                                 "oll"        => "m21",
                                 "eo"         => "4",
                                 "ep"         => "a",
                                 "co"         => "F",
                                 "cp"         => "f",
                                 "inverse_id" => pos.inverse_id,
                                 "weight"     => 1,
                                 "pov_offset" => 0,
                                 })
    expect(pos.is_main).to eq(true)


    pov_pos = Position.find_by!(ll_code: "b5k5p5q5")
    expect(pov_pos.attributes).to eq({"id"           => pov_pos.id,
                                 "best_alg_id"       => pov_pos.best_alg_id,
                                 "alg_count"         => pov_pos.alg_count,
                                 "optimal_alg_length"=> pov_pos.optimal_alg_length,
                                 "mirror_id"         => pov_pos.mirror_id,
                                 "main_position_id"  => pos.id,
                                 "ll_code"    => "b5k5p5q5",
                                 "cop"        => "Fb",
                                 "oll"        => "m21",
                                 "eo"         => "4",
                                 "ep"         => "B",
                                 "co"         => "F",
                                 "cp"         => "b",
                                 "inverse_id" => pov_pos.inverse_id,
                                 "weight"     => nil,
                                 "pov_offset" => 2,
                                })
    expect(pov_pos.is_main).to eq(false)
  end

end
