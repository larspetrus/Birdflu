require 'rails_helper'

RSpec.describe PositionsController do

  it 'read_user_prefs' do
    allow(AlgSet).to receive(:menu_options) {[101, 102].map{|id| ["Algset ##{id}", id]}} # TODO Ugh... Since there is no way to reset class method stubs, let's stub them all the same for now

    missing_cookie = {}
    expect(ApplicationController.read_list_format(missing_cookie).to_h).to eq(Fields::ALL_DEFAULTS)

    invalid_cookie = {field_values: ''}
    expect(ApplicationController.read_list_format(invalid_cookie).to_h).to eq(Fields::ALL_DEFAULTS)

    fully_defined = {field_values: JSON.generate(list: "algs", lines: "100", sortby: "length", algset: "101")}
    expect(ApplicationController.read_list_format(fully_defined).to_h).to eq(:list=>"algs", :lines=>"100", :sortby=>"length", :algset=>"101")

    partially_defined = {field_values: JSON.generate(algset: "101")}
    expect(ApplicationController.read_list_format(partially_defined).to_h).to eq(:list=>"positions", :lines=>"25", :sortby=>"_speed", :algset=>"101")

    obsolete_property = {field_values: JSON.generate(algset: "102", extra_key: 'Sparta!')}
    expect(ApplicationController.read_list_format(obsolete_property).to_h).to eq(:list=>"positions", :lines=>"25", :sortby=>"_speed", :algset=>"102")

    invalid_value = {field_values: JSON.generate(lines: "37")}
    expect(ApplicationController.read_list_format(invalid_value).to_h).to eq(:list=>"positions", :lines=>"25", :sortby=>"_speed", :algset=>"0")
  end

  def mockies
    def (mock_cookies = {}).permanent; self end
    mock_cookies
  end
  it 'store_user_prefs' do
    allow(AlgSet).to receive(:menu_options) {[101, 102].map{|id| ["Algset ##{id}", id]}} # TODO Ugh... Since there is no way to reset class method stubs, let's stub them all the same for now

    PositionsController.store_list_format(cookies = mockies, {lines: '50', algset: '101'}.with_indifferent_access)
    expect(cookies[:field_values]).to eq(JSON.generate(lines: '50', algset: '101'))

    PositionsController.store_list_format(cookies = mockies, {'lines' => '50', 'algset' => '101'}.with_indifferent_access)
    expect(cookies[:field_values]).to eq(JSON.generate(lines: '50', algset: '101'))

    PositionsController.store_list_format(cookies = mockies, {lines: '25', algset: '102', extra_key: 'Mango'}.with_indifferent_access)
    expect(cookies[:field_values]).to eq(JSON.generate(lines: '25', algset: '102'))
  end

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
      allow(RawAlg).to receive(:by_name).with("K25") { db_alg }

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

    it "handles 2'" do
      post_find_by_alg("B2 R2' F R F' R B2 U' L U' L'")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a5c6g8q3", "prot" => 0, "found_by"=>"B2 R2 F R F' R B2 U' L U' L'")
    end

    it "ignores ()+ responsibly" do
      post_find_by_alg("B2 R2 F+R F' R B2 (U' L) U' L'")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a5c6g8q3", "prot" => 0, "found_by"=>"B2 R2 F R F' R B2 U' L U' L'")
    end

    it "removes needless U turns" do
      post_find_by_alg("B2 R2 F R F' R B2 U' L U' L' U2")
      expect(JSON.parse(response.body)).to eq("ll_code" => "a5c6g8q3", "prot" => 0, "found_by"=>"B2 R2 F R F' R B2 U' L U' L'")
    end


    it "Detects errors" do
      post_find_by_alg("F blah U")
      expect(JSON.parse(response.body)).to eq("error" => 'Invalid move code: "BLAH"')

      post_find_by_alg("F U R")
      expect(JSON.parse(response.body)).to eq("error" => 'Alg does not solve F2L')

      allow(RawAlg).to receive(:by_name).with("Z99") { nil }

      post_find_by_alg("Z99")
      expect(JSON.parse(response.body)).to eq("error" => "There is no alg named 'Z99'")
    end

    def post_find_by_alg(user_input)
      xhr :post, :find_by_alg, alg: user_input, format: :json
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
