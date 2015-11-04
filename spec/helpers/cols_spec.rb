require 'rails_helper'

RSpec.describe Cols, :type => :model do

  it 'MOVES' do
    alg = OpenStruct.new(length: 7)
    expect(Cols::MOVES.td(alg, {})).to eq('<td>7</td>')
    expect(Cols::MOVES.td(alg, {copy: true})).to eq('<td class="copy">7</td>')
    expect(Cols::MOVES.td(alg, {shortest: true})).to eq('<td class="optimal">7</td>')
    expect(Cols::MOVES.td(alg, {copy: true, shortest: true})).to eq('<td class="optimalcopy">7</td>')
  end

  it 'NAME' do
    expect(Cols::NAME.td(OpenStruct.new(name: "Z99", single?: true), nil)).to eq('<td>Z99</td>')
    expect(Cols::NAME.td(OpenStruct.new(name: "X1+Y2"), nil)).to eq('<td><span class="goto-pos">X1</span>+<span class="goto-pos">Y2</span></td>')
  end
end
