require 'rails_helper'

RSpec.describe Cube, :type => :model do
  let (:new_cube) { Cube.new }

  it 'can be created from moves and ll_codes' do
    expect(Cube.by_alg("F U F' U F U2 F'").standard_ll_code).to eq("a1c3c3c5")
    expect(Cube.by_code("c3c5a1c3").standard_ll_code).to eq("a1c3c3c5")
    expect(Cube.new().standard_ll_code).to eq("a1a1a1a1")
  end

  it '#sticker_at' do
    expect(new_cube.sticker_at(:DF, :D)).to eq(:D)
    expect(new_cube.sticker_at(:DF, :F)).to eq(:F)
    expect(new_cube.sticker_at(:URF, :U)).to eq(:U)

    expect(new_cube.sticker_at('URF', :U)).to eq(:U)
    expect(new_cube.sticker_at('URF', 'U')).to eq(:U)
  end

  it 'moves stickers' do
    new_cube.do(Move::R)

    expect(new_cube.sticker_at(:URF, :U)).to eq(:F)
    expect(new_cube.sticker_at(:URF, :F)).to eq(:D)
    expect(new_cube.sticker_at(:URF, :R)).to eq(:R)

    new_cube.do(Move::L2)
    expect(new_cube.sticker_at(:UFL, :U)).to eq(:D)
  end

  it 'piece_at' do
    expect(new_cube.piece_at(:UF).class).to eq(Piece)
    expect(new_cube.piece_at('UF')).to eq(new_cube.piece_at(:UF))
  end

  it '#ll_codes' do
    cube1 = Cube.by_alg("F U F' U F U2 F'")
    expect(cube1.ll_codes()).to eq(["a1c3c3c5", "c3c3c5a1", "c3c5a1c3", "c5a1c3c3"])
    expect(cube1.standard_ll_code()).to eq("a1c3c3c5")
    expect(cube1.standard_ll_code_offset()).to eq(0)

    cube2 = Cube.by_alg("L' B L B' U' B' U B")
    expect(cube2.ll_codes()).to eq(["a8j7o1q6", "b3e5g2i4", "a3c8e2p1", "c8e2p1a3"])
    expect(cube2.standard_ll_code()).to eq("a8j7o1q6")
    expect(cube2.standard_ll_code_offset()).to eq(0)

    expect { Cube.by_alg("F").ll_codes()}.to raise_error(RuntimeError, "Alg does not solve F2L")
  end

  it '#standard_ll_code()' do
    expect(Cube.by_code('a1g4q7c2').standard_ll_code).to eq('a1g4q7c2')
    expect(Cube.by_code('a2b3f8p1').standard_ll_code).to eq('a2b3f8p1')
    expect(Cube.by_code('b1g2g2j1').standard_ll_code).to eq('b5j5q6q6')
    expect(Cube.by_code('a1a1a1a1').standard_ll_code).to eq('a1a1a1a1')
    expect(Cube.by_code('a2i3c8j1').standard_ll_code).to eq('a2i3c8j1')
  end

  it '#standard_ll_code(:mirror)' do
    expect(Cube.by_code('a1g4q7c2').standard_ll_code(:mirror)).to eq('a2b3f8p1')
    expect(Cube.by_code('a2b3f8p1').standard_ll_code(:mirror)).to eq('a1g4q7c2')
    expect(Cube.by_code('b1g2g2j1').standard_ll_code(:mirror)).to eq('b4b3g3q4')
    expect(Cube.by_code('a1a1a1a1').standard_ll_code(:mirror)).to eq('a1a1a1a1')
    expect(Cube.by_code('a2i3c8j1').standard_ll_code(:mirror)).to eq('a6i5c8j3')
  end

  it '#apply_position' do
    cube = Cube.by_code('a1c3c3c5')
    expect(cube.standard_ll_code()).to eq("a1c3c3c5")
    expect(cube.corruption).to eq([])

    cube2 = Cube.by_code('a3c8e2p1')
    expect(cube2.standard_ll_code()).to eq("a8j7o1q6")
    expect(cube2.corruption).to eq([])

    cube3 = Cube.by_code('a7i7a7i7')
    expect(cube3.standard_ll_code()).to eq("a3i3a3i3")
  end

  it 'f2l_solved' do
    cube = Cube.new
    expect(cube.f2l_solved).to eq(true)
    cube.do(Move::Fp)
    cube.do(Move::Up)
    cube.do(Move::Lp)
    cube.do(Move::U)
    cube.do(Move::L)
    expect(cube.f2l_solved).to eq(false)
    cube.do(Move::F)
    expect(cube.f2l_solved).to eq(true)
  end

  it 'state_string' do
    cube = Cube.new
    expect(cube.state_string).to eq('aceADgGJikmoqMPsSVux')
    cube.do(Move::F)
    expect(cube.state_string).to eq('aceADpLXikhtqMPnHUux')
  end

  it 'f2l_state_string' do
    cube = Cube.new
    expect(cube.f2l_state_string).to eq('aceADgGJikmo--------')
    cube.do(Move::F)
    expect(cube.f2l_state_string).to eq('aceADpL-ikh----nH---')
  end

  it 'color_css' do
    cube = Cube.new
    cube.do(Move::F)

    expect(cube.color_css('U', nil)).to eq('u-color')
    expect(cube.color_css('F', nil)).to eq('f-color')
    expect(cube.color_css('ULB','U')).to eq('u-color')
    expect(cube.color_css('UF', 'U')).to eq('l-color')
  end
end
