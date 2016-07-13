require 'rails_helper'

describe AlgSet do
  it 'Handles various id input formats' do
    malg = MirrorAlgs.new(MockRawAlg.new(30, 'H15'), MockRawAlg.new(48, 'H33'))
    allow(MirrorAlgs).to receive(:combined).with('H15.H33') { double(ids: [30,48]) }

    expect(AlgSet.new([]).ids).to eq([1])
    expect(AlgSet.new([5, 7]).ids).to eq([1, 5, 7])
    expect(AlgSet.new([5, 7, 'H15.H33']).ids).to eq([1, 5, 7, 30, 48])
    expect(AlgSet.new([99, 'H15.H33', 5]).ids).to eq([1, 5, 30, 48, 99])

    expect(AlgSet.new([3, malg]).ids).to eq([1, 3, 30, 48])
  end
end
