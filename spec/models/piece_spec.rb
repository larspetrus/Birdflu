require 'rails_helper'

RSpec.describe Piece, :type => :model do
  let(:r_shift) { {B: :D, D: :F, F: :U, U: :B, L: :L, R: :R} }

  it 'initializes' do
    piece = Piece.new('URF')
    expect(piece.sticker_on(:U)).to eql(:U)
    expect(piece.sticker_on(:R)).to eql(:R)
    expect(piece.sticker_on(:F)).to eql(:F)
  end

  it 'only accepts the standard (clockwise) names' do
    expect{Piece.new('ABC')}.to raise_error
    expect{Piece.new('UFR')}.to raise_error
    expect{Piece.new('FRU')}.to raise_error
    expect{Piece.new('URF')}.not_to raise_error
  end

  it '#rotate' do
    df = Piece.new('DF')
    expect(df.sticker_on(:D)).to eql(:D)
    df.rotate(1)
    expect(df.sticker_on(:D)).to eql(:F)

    ulb = Piece.new('ULB')
    expect(ulb.sticker_on(:U)).to eql(:U)
    ulb.rotate(1)
    expect(ulb.sticker_on(:U)).to eql(:B)
  end

  it 'u_spin' do
    ulb = Piece.new('ULB')
    uf = Piece.new('UF')

    expect(ulb.u_spin).to eq(0)
    expect(uf.u_spin).to eq(0)

    ulb.rotate(1)
    uf.rotate(1)
    expect(ulb.u_spin).to eq(1)
    expect(uf.u_spin).to eq(1)

    ulb.rotate(1)
    uf.rotate(1)
    expect(ulb.u_spin).to eq(2)
    expect(uf.u_spin).to eq(0)

    ulb.rotate(1)
    expect(ulb.u_spin).to eq(0)

    expect{ Piece.new('DB').u_spin}.to raise_error
  end

  it 'tracks stickers during moves' do
    piece = Piece.new('URF')

    r_shift = {B: :D, D: :F, F: :U, U: :B, L: :L, R: :R}
    piece.shift(r_shift)

    expect(piece.sticker_on(:B)).to eql(:U)
    expect(piece.sticker_on(:R)).to eql(:R)
    expect(piece.sticker_on(:U)).to eql(:F)

    expect(piece.as_tweak).to eq('URF:BRU')

    piece.shift(r_shift, 3)

    expect(piece.sticker_on(:U)).to eql(:U)
    expect(piece.sticker_on(:R)).to eql(:R)
    expect(piece.sticker_on(:F)).to eql(:F)

    expect(piece.as_tweak).to eq('URF:URF')
  end

  it '#is_solved' do
    drb = Piece.new('DRB')
    expect(drb.is_solved).to eq(true)

    drb.shift(r_shift)
    expect(drb.is_solved).to eq(false)
  end

end