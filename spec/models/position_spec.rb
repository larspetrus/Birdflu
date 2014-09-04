require "rails_helper"

RSpec.describe Position, :type => :model do

  it "ll_code uniqueness" do
    expect(Position.create(ll_code: 'a1b1c1a1')).to be_valid
    expect(Position.create(ll_code: 'a1b1c1a1')).not_to be_valid
 end

  it "#tweaks" do
    expect(Position.create(ll_code: 'a1b1c1a1').tweaks()).to eq('ULB:ULB UB:UB RUB:UBR UR:UR RFU:URF UF:UF UFL:UFL UL:UL')
    expect(Position.create(ll_code: 'a1c3c3c5').tweaks()).to eq('ULB:ULB UB:UB BRU:UBR UF:UR RFU:URF UL:UF FLU:UFL UR:UL')
    expect(Position.create(ll_code: 'a3e6f1k4').tweaks()).to eq('ULB:ULB UR:UB URF:UBR LU:UR LUF:URF UF:UF BRU:UFL BU:UL')
  end

end
