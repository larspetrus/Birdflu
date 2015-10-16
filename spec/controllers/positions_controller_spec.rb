require 'rails_helper'

RSpec.describe PositionsController do
  describe "POST find_by_alg" do
    it "finds the ll_code by alg" do
      xhr :post, :find_by_alg, alg: "R' F' L F' L D' L' D L' F2 R", format: :json
      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq({"ll_code" => "a7j7b8j8"})
    end

    it "finds the ll_code by alg name" do
      RawAlg.create(b_alg: "B D U' F U L F' D' B' U' L'", alg_id: 'H25', length: 8)

      xhr :post, :find_by_alg, alg: "H25", format: :json
      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq({"ll_code" => "a1i2c3j8"})
    end

    it "is case independent" do
      xhr :post, :find_by_alg, alg: "B2 r2 f r f' r b2 u' L U' L'", format: :json
      expect(JSON.parse(response.body)).to eq({"ll_code" => "a5c6g8q3"})
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
