require 'rails_helper'

RSpec.describe PositionsController do
  describe "POST find_by_alg" do
    it "finds the ll_code by alg" do
      xhr :post, :find_by_alg, alg: "R' F' L F' L D' L' D L' F2 R", format: :json
      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq({"ll_code" => "a7j7b8j8", "urot" => 0, "found_by"=>"R' F' L F' L D' L' D L' F2 R"})
    end

    it "computes the U rotation" do
      xhr :post, :find_by_alg, alg: "F' L' B L' B D' B' D B' L2 F", format: :json
      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq({"ll_code" => "a7j7b8j8", "urot" => 1, "found_by"=>"F' L' B L' B D' B' D B' L2 F"})
    end

    it "finds the ll_code by alg name" do
      RawAlg.make("B D U' F U L F' D' B' U' L'", 'H25', 8)

      xhr :post, :find_by_alg, alg: "H25", format: :json
      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq({"ll_code" => "a1i2c3j8", "urot" => 0, "found_by"=>"H25"})
    end

    it "is case independent" do
      xhr :post, :find_by_alg, alg: "B2 r2 f r f' r b2 u' L U' L'", format: :json
      expect(JSON.parse(response.body)).to eq({"ll_code" => "a5c6g8q3", "urot" => 0, "found_by"=>"B2 R2 F R F' R B2 U' L U' L'"})
    end

    it "Errors invalid moves" do
      xhr :post, :find_by_alg, alg: "F blah U", format: :json
      expect(JSON.parse(response.body)).to eq({"error" => 'Invalid move code: "BLAH"'})
    end

    it "Errors non LL algs" do
      xhr :post, :find_by_alg, alg: "F U R", format: :json
      expect(JSON.parse(response.body)).to eq({"error" => 'Alg does not solve F2L'})
    end

    it "Errors non existent alg names" do
      xhr :post, :find_by_alg, alg: "Z99", format: :json
      expect(JSON.parse(response.body)).to eq({"error" => "There is no alg named 'Z99'"})
    end
  end

  #TODO handle nil?
end
