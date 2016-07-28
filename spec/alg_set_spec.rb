require 'rails_helper'

describe AlgSet do
  it 'find_raw_alg_ids' do
    malg = MirrorAlgs.new(MockRawAlg.new(30, 'H15'), MockRawAlg.new(48, 'H33'))
    allow(MirrorAlgs).to receive(:combined).with('H15.H33') { double(ids: [30,48]) }

    expect(AlgSet.find_raw_alg_ids([])).to eq([1])
    expect(AlgSet.find_raw_alg_ids([5, 7])).to eq([1, 5, 7])
    expect(AlgSet.find_raw_alg_ids([5, 7, 'H15.H33'])).to eq([1, 5, 7, 30, 48])
    expect(AlgSet.find_raw_alg_ids([99, 'H15.H33', 5])).to eq([1, 5, 30, 48, 99])

    expect(AlgSet.find_raw_alg_ids([3, malg])).to eq([1, 3, 30, 48])
  end
end
