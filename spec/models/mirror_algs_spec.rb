require 'rails_helper'

describe MirrorAlgs do
  it 'lower id is always first' do
    alg_a = RawAlg.new
    alg_b = RawAlg.new

    allow(alg_a).to receive(:name) { "A1" }
    allow(alg_a).to receive(:id) { 1 }
    allow(alg_b).to receive(:name) { "B2" }
    allow(alg_b).to receive(:id) { 2 }

    ab = MirrorAlgs.new(alg_a, alg_b)
    ba = MirrorAlgs.new(alg_b, alg_a)
    a_ = MirrorAlgs.new(alg_a, nil)
    
    expect(ab.ids).to eq([alg_a.id, alg_b.id])
    expect(ba.ids).to eq([alg_a.id, alg_b.id])
    expect(a_.ids).to eq([alg_a.id])

    expect(ab.name).to eq('A1·B2')
    expect(ba.name).to eq('A1·B2')
    expect(a_.name).to eq('A1·--')
  end

  it 'set_to_ids' do
    ma1 = double(ids: [12,15])
    ma2 = double(ids: [22,25])
    ma3 = double(ids: [32])

    expect(MirrorAlgs.raw_alg_ids_from([ma1, ma2])).to eq([12, 15, 22, 25])
    expect(MirrorAlgs.raw_alg_ids_from([ma3, ma2, ma2])).to eq([22, 25, 32])
  end
end
