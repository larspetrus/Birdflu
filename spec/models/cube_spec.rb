require 'rails_helper'

RSpec.describe Cube, :type => :model do
  let (:cube) { Cube.new }

  it '#sticker_at' do
    expect(cube.sticker_at(:DF, :D)).to eq(:D)
    expect(cube.sticker_at(:DF, :F)).to eq(:F)
    expect(cube.sticker_at(:URF, :U)).to eq(:U)

    expect(cube.sticker_at('URF', :U)).to eq(:U)
    expect(cube.sticker_at('URF', 'U')).to eq(:U)
  end

  it 'moves stickers' do
    cube.move(:R, 1)

    expect(cube.sticker_at(:URF, :U)).to eq(:F)
    expect(cube.sticker_at(:URF, :F)).to eq(:D)
    expect(cube.sticker_at(:URF, :R)).to eq(:R)

    cube.move(:L, 2)
    expect(cube.sticker_at(:UFL, :U)).to eq(:D)
  end

  it 'piece_at' do
    expect(cube.piece_at(:UF).class).to eq(Piece)
    expect(cube.piece_at('UF')).to eq(cube.piece_at(:UF))
  end

  it '#fl_codes' do
    cube.setup_alg("F U F' U F U2 F'")
    expect(cube.fl_codes()).to eq(["a1c3c3c5", "c3c3c5a1", "c3c5a1c3", "c5a1c3c3"])
    expect(cube.standard_fl_code()).to eq("a1c3c3c5")

    cube2 = Cube.new
    cube2.setup_alg("L' B L B' U' B' U B")
    expect(cube2.fl_codes()).to eq(["a8j7o1q6", "b3e5g2i4", "a3c8e2p1", "c8e2p1a3"])
    expect(cube2.standard_fl_code()).to eq("a3c8e2p1")
  end

  it '#apply_position' do
    expect(Cube.new.apply_position('a1c3c3c5').standard_fl_code()).to eq("a1c3c3c5")
    expect(Cube.new.apply_position('a1c3c3c5').corruption).to eq([])

    expect(Cube.new.apply_position('a3c8e2p1').standard_fl_code()).to eq("a3c8e2p1")
    expect(Cube.new.apply_position('a3c8e2p1').corruption).to eq([])
  end

end
