require 'rails_helper'

describe RawAlg do
  it '#create' do
    alg1 = RawAlg.create(b_alg: "B' R2 F R F' R B", alg_id: 'G7', length: 7)

    expect(alg1.alg_id).to eq('G7')
    expect(alg1.length).to eq(7)
    expect(alg1.b_alg).to eq("B' R2 F R F' R B")
    expect(alg1.r_alg).to eq("R' F2 L F L' F R")
    expect(alg1.l_alg).to eq("L' B2 R B R' B L")
    expect(alg1.f_alg).to eq("F' L2 B L B' L F")
    expect(alg1.position.ll_code).to eq('a5c8c8c1')
    expect(alg1.u_setup).to eq(2)
    expect(alg1.moves).to eq(alg1.r_alg)

    expect(alg1.mirror_id).to eq(nil) # must run RawAlg.populate_mirror_id after loading algs
  end
end
