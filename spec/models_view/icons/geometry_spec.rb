require 'rails_helper'

RSpec.describe Icons::Geometry, :type => :model do

  it '.depth()' do
    marg = Icons::Geometry::MARGIN
    gap = Icons::Geometry::STK_GAP
    cube_size = Icons::Geometry::CUBE_SIZE
    stk_size = Icons::Geometry::STK_SIZE

    d = gap/10
    expect(Icons::Geometry.depth(:F, marg, marg+cube_size, cube_size, marg)).to eq(points: "11.880000000000003,90.0 88.12,90.0 80.12,100.0 19.880000000000003,100.0")

    expect(Icons::Geometry.depth(:B, marg+gap, marg+cube_size, stk_size, 0.6*marg)).to eq(points: "85.85662500000001,10.0 63.461124999999996,10.0 61.766125,4.0 81.341625,4.0")
    expect(Icons::Geometry.depth(:B, marg+gap, marg+cube_size, stk_size, 0.4*marg)).to eq(points: "85.85662500000001,10.0 63.461124999999996,10.0 62.331125,6.0 82.84662499999999,6.0")
  end

  it 'makes the right arrows' do
    expect(Icons::Geometry.arrow_on(:L)).to eq({d: "M49 28H45L50 21L55 28H51V72H55L50 79L45 72H49Z", transform: "translate(-25.875, 0)", class: "c_arrow"})
    expect(Icons::Geometry.arrow_on(:LdR)).to eq({d: "M49 28H45L50 21L55 28H51V72H55L50 79L45 72H49Z", transform: "rotate(90, 50, 50)", class: "e_arrow"})
    expect(Icons::Geometry.arrow_on(:D)).to eq({d: "M49 16H45L50 9L55 16H51V84H55L50 91L45 84H49Z", transform: "rotate(45, 50, 50)", class: "c_arrow"})
    expect(Icons::Geometry.arrow_on(:R2L)).to eq({d: "M49 32H45L50 25L55 32H51V75H49Z", transform: "rotate(270, 50, 50)", class: "e_arrow"})
    expect(Icons::Geometry.arrow_on(:F2L)).to eq({d: "M74 62H78L73 69L68 62H72V31H74Z", transform: "rotate(135, 50, 50)", class: "e_arrow"})
    expect(Icons::Geometry.arrow_on(:R2B)).to eq({d: "M72 38H68L73 31L78 38H74V69H72Z", transform: "rotate(315, 50, 50)", class: "e_arrow"})
    expect {Icons::Geometry.arrow_on(:wrong)}.to raise_error(ArgumentError)
  end
end
