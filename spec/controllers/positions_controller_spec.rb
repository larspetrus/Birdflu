require 'rails_helper'

RSpec.describe PositionsController do

  describe "POST find_by_alg" do
    describe 'algs not in DB' do
      it "computes the ll_code by alg" do
        alg = "R2 R F' L F' L D' L' D L' F2 R"
        post_find_by_alg(alg)

        expect(JSON.parse(response.body)).to eq("ll_code" => "a7j7b8j8", "prot" => 0, "packed_alg"=> Algs.pack(alg))
      end

      it "computes the page rotation" do
        alg = "F2 F L' B L' B D' B' D B' L2 F"
        post_find_by_alg(alg)
        expect(JSON.parse(response.body)).to eq("ll_code" => "a7j7b8j8", "prot" => 1, "packed_alg"=> Algs.pack(alg))
      end

      it "removes needless U turns" do
        alg = "B B R2 F R F' R B2 U' L U' L'"
        post_find_by_alg(alg + " U2")
        expect(JSON.parse(response.body)).to eq("ll_code" => "a5c6g8q3", "prot" => 0, "packed_alg"=> Algs.pack(alg))
      end

      it "returns rotation for alg NOT in DB" do
        moves = "B2 B' D U' F U L F' D' B' U' L'"
        post_find_by_alg(moves)
        expect(JSON.parse(response.body)).to eq("ll_code" => "a1i2c3j8", "prot" => 3, "packed_alg"=>Algs.pack(moves))
      end
    end

    it "returns correctly called by alg name" do
      post_find_by_alg("K25")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a1i2c3j8", "prot" => 0, "alg_id"=> RawAlg.by_name("K25").id)
    end

    it "returns rotation for alg in DB" do
      post_find_by_alg("B D U' F U L F' D' B' U' L'")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a1i2c3j8", "prot" => 3, "alg_id"=> RawAlg.by_name("K25").id)
    end

    it "Detects errors" do
      post_find_by_alg("F blah U")
      expect(JSON.parse(response.body)).to eq("error" => 'Invalid move code: "blah"')

      post_find_by_alg("F U R")
      expect(JSON.parse(response.body)).to eq("error" => 'Alg does not solve F2L')

      allow(RawAlg).to receive(:by_name).with("Z99") { nil }

      post_find_by_alg("Z99")
      expect(JSON.parse(response.body)).to eq("error" => "There is no alg named 'Z99'")
    end

    def post_find_by_alg(user_input)
      xhr :post, :find_by_alg, post_alg: user_input, format: :json
      expect(response.code).to eq("200")
    end
  end

  it 'bookmark_url' do
    simple_filter = PosFilters.new({pos: 'Bf__'}, 'all')
    expect(PositionsController.bookmark_url(simple_filter, {})).to eq('?pos=Bf__')

    filter_with_change = PosFilters.new({pos: 'Bf__', poschange: 'eo-2'}, 'all')
    expect(PositionsController.bookmark_url(filter_with_change, {})).to eq('?pos=Bf2_')

    complex_params = ActionController::Parameters.new(pos: 'xyz', poschange: 'xy-z', prot: '1', foo: 'bar')
    expect(PositionsController.bookmark_url(simple_filter, complex_params)).to eq('?pos=Bf__&foo=bar&prot=1')
  end
  
end
