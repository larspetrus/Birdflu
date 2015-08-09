require 'rails_helper'

RSpec.describe Icons::Svg, :type => :model do
  it 'makes the right arrows' do
    expect(Icons::Svg.arrow_on(:L)).to eq({d: "M49 28H45L50 21L55 28H51V72H55L50 79L45 72H49Z", transform: "translate(-25.875, 0)"})
    expect(Icons::Svg.arrow_on(:LdR)).to eq({d: "M49 28H45L50 21L55 28H51V72H55L50 79L45 72H49Z", transform: "rotate(90, 50, 50)"})
    expect(Icons::Svg.arrow_on(:D)).to eq({d: "M49 16H45L50 9L55 16H51V84H55L50 91L45 84H49Z", transform: "rotate(45, 50, 50)"})
    expect(Icons::Svg.arrow_on(:R2L)).to eq({d: "M49 32H45L50 25L55 32H51V75H49Z", transform: "rotate(270, 50, 50)"})
    expect(Icons::Svg.arrow_on(:F2L)).to eq({d: "M74 62H78L73 69L68 62H72V31H74Z", transform: "rotate(135, 50, 50)"})
    expect(Icons::Svg.arrow_on(:R2B)).to eq({d: "M72 38H68L73 31L78 38H74V69H72Z", transform: "rotate(315, 50, 50)"})
    expect{Icons::Svg.arrow_on(:wrong)}.to raise_error(ArgumentError)
  end
end
