require 'rails_helper'

RSpec.describe PositionsController do
  describe "POST find_by_alg" do
    it "computes the ll_code by alg" do
      post_find_by_alg("R' F' L F' L D' L' D L' F2 R")

      expect(JSON.parse(response.body)).to eq("ll_code" => "a7j7b8j8", "prot" => 0, "found_by"=>"R' F' L F' L D' L' D L' F2 R")
    end

    it "computes the page rotation" do
      post_find_by_alg("F' L' B L' B D' B' D B' L2 F")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a7j7b8j8", "prot" => 1, "found_by"=>"F' L' B L' B D' B' D B' L2 F")
    end

    it "finds the ll_code and position id by alg name" do
      db_alg = RawAlg.make("R D U' L U B L' D' R' U' B'", 11)
      allow(RawAlg).to receive(:find_with_name).with("K25") { db_alg }

      post_find_by_alg("K25")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a1i2c3j8", "prot" => 0, "alg_id"=>db_alg.id)
    end

    it "finds the ll_code and position id by moves, if the alg is in the DB" do
      db_alg = RawAlg.make("R D U' L U B L' D' R' U' B'", 11)

      post_find_by_alg("B D U' F U L F' D' B' U' L'")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a1i2c3j8", "prot" => 3, "alg_id"=>db_alg.id)
    end

    it "is case independent" do
      post_find_by_alg("B2 r2 f r f' r b2 u' L U' L'")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a5c6g8q3", "prot" => 0, "found_by"=>"B2 R2 F R F' R B2 U' L U' L'")
    end


    it "Detects errors" do
      post_find_by_alg("F blah U")
      expect(JSON.parse(response.body)).to eq("error" => 'Invalid move code: "BLAH"')

      post_find_by_alg("F U R")
      expect(JSON.parse(response.body)).to eq("error" => 'Alg does not solve F2L')

      allow(RawAlg).to receive(:find_with_name).with("Z99") { nil }

      post_find_by_alg("Z99")
      expect(JSON.parse(response.body)).to eq("error" => "There is no alg named 'Z99'")
    end

    def post_find_by_alg(user_input)
      xhr :post, :find_by_alg, alg: user_input, format: :json
      expect(response.code).to eq("200")
    end
  end
end
