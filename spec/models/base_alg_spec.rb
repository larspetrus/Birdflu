require 'rails_helper'

RSpec.describe BaseAlg, :type => :model do

  describe 'CRUD' do
    it 'create / make' do
      al = BaseAlg.make('Bob', "B U B' U B U2 B'")

      expect(al.name).to eq('Bob')
      expect(al.moves(0)).to eq("B U B' U B U2 B'")
      expect(al.moves(1)).to eq("R U R' U R U2 R'")
      expect(al.moves(2)).to eq("F U F' U F U2 F'")
      expect(al.moves(3)).to eq("L U L' U L U2 L'")
    end
  end

  it 'verifies F2L is preserved' do
      expect{BaseAlg.make("Not a LL alg!", "F U D")}.to raise_error( RuntimeError, "Can't make LL code with F2L unsolved" )
  end

  it '#rotate_by_U' do
    expect(BaseAlg.rotate_by_U("F U2 R' D B2 L'")).to eq("L U2 F' D R2 B'")
  end

end
