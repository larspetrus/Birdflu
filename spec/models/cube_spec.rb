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

  it '#ll_codes' do
    cube.setup_alg("F U F' U F U2 F'")
    expect(cube.ll_codes()).to eq(["a1c3c3c5", "c3c3c5a1", "c3c5a1c3", "c5a1c3c3"])
    expect(cube.standard_ll_code()).to eq("a1c3c3c5")
    expect(cube.standard_ll_code_offset()).to eq(0)

    cube2 = Cube.new.setup_alg("L' B L B' U' B' U B")
    expect(cube2.ll_codes()).to eq(["a8j7o1q6", "b3e5g2i4", "a3c8e2p1", "c8e2p1a3"])
    expect(cube2.standard_ll_code()).to eq("a3c8e2p1")
    expect(cube2.standard_ll_code_offset()).to eq(2)

    expect{ Cube.new.setup_alg("F").ll_codes()}.to raise_error(RuntimeError, "Can't make LL code with F2L unsolved")
  end

  it '#standard_ll_code(:mirror)' do
    cube = Cube.new.apply_position('a1g4q7c2')
    expect(cube.standard_ll_code(:mirror)).to eq('a2b3f8p1')

    cube = Cube.new.apply_position('a2b3f8p1')
    expect(cube.standard_ll_code(:mirror)).to eq('a1g4q7c2')

    cube = Cube.new.apply_position('b1g2g2j1')
    expect(cube.standard_ll_code(:mirror)).to eq('b3g3q4b4')

    cube = Cube.new.apply_position('a1a1a1a1')
    expect(cube.standard_ll_code(:mirror)).to eq('a1a1a1a1')

    cube = Cube.new.apply_position('a2i3c8j1')
    expect(cube.standard_ll_code(:mirror)).to eq('a1k4b7i2')
  end

  it '#apply_position' do
    expect(cube.apply_position('a1c3c3c5').standard_ll_code()).to eq("a1c3c3c5")
    expect(cube.corruption).to eq([])

    cube2 = Cube.new.apply_position('a3c8e2p1')
    expect(cube2.standard_ll_code()).to eq("a3c8e2p1")
    expect(cube2.corruption).to eq([])

    cube3 = Cube.new.apply_position('a7i7a7i7')
    expect(cube3.standard_ll_code()).to eq("a3i3a3i3")
  end

end
