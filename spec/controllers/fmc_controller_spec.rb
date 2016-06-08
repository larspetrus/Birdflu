require 'rails_helper'

RSpec.describe FmcController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  describe 'NISS' do

    it 'decode' do
      cc = "L2 D' L2 (R2 F2) R B R' (R2 F R) R L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' R"
      expect(FmcController.niss_decode(cc)).to eq(["L2 D' L2","nR2 F2","R B R'","nR2 F R","R L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' R"])
    end

    it 'to_alg' do
      cc = "L2 D' L2 (R2 F2) R B R' (R2 F R) R L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' R"
      solution = "L2 D' L2 R B L F' L' F R' U2 F' U F U2 F U F' U' R' F' L F L' F' R2 F2 R2"

      expect(FmcController.niss_to_alg(cc)).to eq(solution)
    end
  end


end
