require 'rails_helper'

RSpec.describe FmcController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  it 'Segment.from_code' do
    cc = "L2 D' L2 (R2 F2) R B R' (R2 F R) R L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' R"
    cc_segments = FmcController::Segment.from_code(cc)
    expect(cc_segments.map(&:moves)).to eq(["L2 D' L2","R2 F2","R B R'","R2 F R","R L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' R"])
    expect(cc_segments.map(&:reversed)).to eq([false, true, false, true, false])

    segments = FmcController::Segment.from_code("(F R) (U L) U2")
    expect(segments.map(&:moves)).to eq(["F R", "U L", "U2"])
    expect(segments.map(&:reversed)).to eq([true, true, false])
  end

  it 'to_alg' do
    cc = "L2 D' L2 (R2 F2) R B R' (R2 F R) R L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' R"
    solution = "L2 D' L2 R B L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' F' R2 F2 R2"

    expect(FmcController.niss_to_alg(cc)).to eq(solution)
  end

  it 'unpack' do
    niss = "L2 D' L2 (R2 F2) R B R' (R2 F R) R L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' R"
    packed_niss = "lpl(rf)RBP(rFR)RLE1FPuEUFuFUEnPELF1R"
    expect(FmcController.unpack(packed_niss)).to eq(niss)
  end
end
