require 'rails_helper'

describe AlgMiner do
  it 'as_alg' do
    expect(AlgMiner.as_alg([[:R, 1], [:L, 2], [:U, 3]])).to eq("R L2 U'")
  end

  describe '#next_moves' do
    it 'do not move same side again' do
      expect(AlgMiner.as_alg(AlgMiner.next_moves([:B,1]))).to eq("F F2 F' R R2 R' L L2 L' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves([:L,1]))).to eq("F F2 F' B B2 B' R R2 R' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves([:D,1]))).to eq("F F2 F' B B2 B' R R2 R' L L2 L' U U2 U'")
    end

    it '"slicey moves start with B, L or D, not F, R or U"' do
      expect(AlgMiner.as_alg(AlgMiner.next_moves([:F,1]))).to eq("R R2 R' L L2 L' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves([:R,1]))).to eq("F F2 F' B B2 B' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves([:U,1]))).to eq("F F2 F' B B2 B' R R2 R' L L2 L'")
    end
  end

  describe '#end_states' do
    depth_2 = AlgMiner.find_end_states(2).values

    it 'makes all combinations' do
      ["F R","F2 R","F' R","F R2","F2 R2","F' R2","F R'","F2 R'","F' R'"].each do |moves|
        expect(depth_2).to include([moves])
      end

      expect(depth_2.flatten.count).to eq(198)
      expect(depth_2.count).to eq(198)
    end

    it 'slicey moves are normalized' do
      expect(depth_2).not_to include(["L R"])
      expect(depth_2).to include(["R L"])
    end

    it 'only includes"leafs"' do
      expect(depth_2).not_to include(["L"])
    end

    it 'never ends with U* or U* D*' do
      expect(depth_2).not_to include(["L U"])
      expect(depth_2).not_to include(["U D"])
    end
  end

end
