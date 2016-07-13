require 'rails_helper'

describe MirrorAlgs do
  it 'lower id is always first' do
    alg_a = MockRawAlg.new(1, 'A1')
    alg_b = MockRawAlg.new(2, 'B2')

    ab = MirrorAlgs.new(alg_a, alg_b)
    ba = MirrorAlgs.new(alg_b, alg_a)
    a_ = MirrorAlgs.new(alg_a, nil)
    
    expect(ab.ids).to eq([alg_a.id, alg_b.id])
    expect(ba.ids).to eq([alg_a.id, alg_b.id])
    expect(a_.ids).to eq([alg_a.id])

    expect(ab.name).to eq('A1.B2')
    expect(ba.name).to eq('A1.B2')
    expect(a_.name).to eq('A1.--')
  end

  it 'dedupes' do
    alg_a = MockRawAlg.new(1, 'A1')
    alg_b = MockRawAlg.new(1, 'A2')

    ab = MirrorAlgs.new(alg_a, alg_b)
    expect(ab.ids).to eq([alg_a.id])
    expect(ab.name).to eq('A1.--')
  end

  it 'set_to_ids' do
    ma1 = double(ids: [12,15])
    ma2 = double(ids: [22,25])
    ma3 = double(ids: [32])

    expect(MirrorAlgs.raw_alg_ids_from([ma1, ma2])).to eq([12, 15, 22, 25])
    expect(MirrorAlgs.raw_alg_ids_from([ma3, ma2, ma2])).to eq([22, 25, 32])
  end

  it 'all_combined' do
    h33 = MockRawAlg.new(48, 'H33')
    h15 = MockRawAlg.new(30, 'H15', h33)

    allow(RawAlg).to receive(:where) { [h15, h33] }

    expect(MirrorAlgs.all_combined.map(&:to_s)).to eq([MirrorAlgs.new(h15, h33).to_s])
    
    expect(MirrorAlgs.combined('H15.H33').to_s).to eq("H15.H33 [30, 48]")
  end
end

