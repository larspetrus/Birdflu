require 'rails_helper'

RSpec.describe PositionShowHelper do

  it 'length_value' do
    expect(length_value("length7", {})).to eq('<td>7</td>')
    expect(length_value("length7", {copy: true})).to eq('<td class="copy">7</td>')
    expect(length_value("length7", {shortest: true})).to eq('<td class="optimal">7</td>')
    expect(length_value("length7", {copy: true, shortest: true})).to eq('<td class="optimalcopy">7</td>')
  end
end
