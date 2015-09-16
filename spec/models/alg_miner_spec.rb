require 'rails_helper'

describe AlgMiner do

  AlgMiner::LOGGING = false

  it 'as_alg' do
    expect(AlgMiner.as_alg([Move::R, Move::L2, Move::Up])).to eq("R L2 U'")
  end

  describe '#next_moves' do
    it 'do not move same side again' do
      expect(AlgMiner.as_alg(AlgMiner.next_moves(Move::B))).to eq("F F2 F' R R2 R' L L2 L' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves(Move::L))).to eq("F F2 F' B B2 B' R R2 R' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves(Move::D))).to eq("F F2 F' B B2 B' R R2 R' L L2 L' U U2 U'")
    end

    it '"slicey moves start with B, L or D, not F, R or U"' do
      expect(AlgMiner.as_alg(AlgMiner.next_moves(Move::F))).to eq("R R2 R' L L2 L' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves(Move::R))).to eq("F F2 F' B B2 B' U U2 U' D D2 D'")
      expect(AlgMiner.as_alg(AlgMiner.next_moves(Move::U))).to eq("F F2 F' B B2 B' R R2 R' L L2 L'")
    end
  end

  it 'solvedish' do
    digger = AlgDigger.new(2, nil)
    expect(digger.solvedish("U")).to be_truthy
    expect(digger.solvedish("F")).to be_falsey
    expect(digger.solvedish("R2 R2 U2")).to be_truthy
  end

  describe '#end_states' do
    let(:depth_2) { GoalFinder.new(2).run.finishes }

    it 'makes all combinations' do
      ["F R","F2 R","F' R","F R2","F2 R2","F' R2","F R'","F2 R'","F' R'"].each do |moves|
        expect(depth_2).to include(moves)
      end

      expect(depth_2.flatten.count).to eq(198)
      expect(depth_2.count).to eq(198)
    end

    it 'slicey moves are normalized' do
      expect(depth_2).not_to include("L R")
      expect(depth_2).to include("R L")
    end

    it 'only includes"leafs"' do
      expect(depth_2).not_to include("L")
    end

    it 'never ends with U* or U* D*' do
      expect(depth_2).not_to include("L U")
      expect(depth_2).not_to include("U D")
    end
  end

  it 'compress_alg' do
    expect(AlgMiner.compress_alg([Move::F, Move::R2, Move::Up])).to eq('Frn')
  end

  it 'decompress_alg' do
    expect(AlgMiner.decompress_alg('Frn')).to eq("F R2 U'")
  end

end