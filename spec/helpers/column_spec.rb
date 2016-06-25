require 'rails_helper'

RSpec.describe Column, :type => :model do
  let(:pos1) { Position.find(99) }

  let(:raw1) {RawAlg.new(_moves: Algs.pack("L' B' R B' R' B2 L"), u_setup: 2, length: 7, _speed: 666, position_id: pos1.id)}
  let(:raw2) {RawAlg.new(_moves: Algs.pack("R' U' R B L U L' B'"), u_setup: 2, length: 8, _speed: 555, position_id: pos1.id)}

  let(:combo1) {ComboAlg.new(alg1: raw1, alg2: raw2)}

  let(:context) { {stats: OpenStruct.new(shortest: 7, fastest: 5.55)} }

  it 'MOVES' do
    expect(Column::LENGTH.cell(raw1.presenter(context))).to eq('<td class="optimal">7</td>')
    expect(Column::LENGTH.cell(raw2.presenter(context))).to eq('<td>8</td>')
  end

  it 'SPEED' do
    expect(Column::SPEED.cell(raw1.presenter(context))).to eq('<td>6.66</td>')
    expect(Column::SPEED.cell(raw2.presenter(context))).to eq('<td class="optimal">5.55</td>')
  end

  it 'NAME' do
    allow(raw1).to receive(:name) { "Z99" }
    allow(raw2).to receive(:name) { "B52" }

    expect(Column::NAME.cell(raw1.presenter(context))).to eq('<td class="single">Z99</td>')
    expect(Column::NAME.cell(combo1.presenter(context))).to eq('<td class="combo"><span class="js-goto-post">Z99</span>+<span class="js-goto-post">B52</span></td>')
  end

  it 'POSITION' do
    expect(Column::POSITION.cell(pos1.presenter(context))).to eq("<td><a href=\"/positions/a5a1b3c3\">Co4G</a></td>")
  end

  it 'ALG' do
    expect(Column::ALG.cell(raw1.presenter(context))).to eq('<td class="js-alg">L&#39; B&#39; R B&#39; R&#39; B2 L</td>')

    allow(combo1).to receive(:merge_display_data) {[["L' U' B' U B "], ["L", :merged], ["+"], ["L", :merged], [" U F U' F' L'", :alg2]]}
    expect(Column::ALG.cell(combo1.presenter(context))).to eq('<td class="js-combo"><span>L&#39; U&#39; B&#39; U B </span><span class="merged">L</span><span>+</span><span class="merged">L</span><span class="alg2"> U F U&#39; F&#39; L&#39;</span></td>')
  end

  it 'SHOW' do
    expect(Column::SHOW.cell(raw1.presenter(context))).to eq('<td data-uset="2"><a class="show-pig">show</a></td>')
  end

  it 'NOTES' do
    allow(raw1).to receive(:specialness) { "XYZ" }
    expect(Column::NOTES.cell(raw1.presenter(context))).to eq('<td>XYZ</td>')
  end

  it 'icons' do
    expect(Column::COP.svg_params(raw1.presenter(context))[:icon].name).to eq(pos1.cop)
    expect(Column::EO.svg_params(raw1.presenter(context))[:icon].name).to eq(pos1.eo)
    expect(Column::EP.svg_params(raw1.presenter(context))[:icon].name).to eq(pos1.ep)
  end

end
