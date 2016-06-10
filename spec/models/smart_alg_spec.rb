require 'rails_helper'

describe SmartAlg do

  it 'Accepts standard and compressed notation' do
    expect(SmartAlg.new("F U2 R'").standard).to eq("F U2 R'")
    expect(SmartAlg.new("F U2 R'").compressed).to eq("FuP")

    expect(SmartAlg.new("BE").standard).to eq("B F'")
    expect(SmartAlg.new("U'").standard).to eq("U'")

    expect(SmartAlg.new("").standard).to eq("")
    expect(SmartAlg.new(nil).standard).to eq("")
  end
end