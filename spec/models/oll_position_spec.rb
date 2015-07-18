require 'rails_helper'

RSpec.describe OllPosition, :type => :model do

  describe 'OP' do
    it 'color' do
      o25 = OllPosition.new(:o25, 'OLL 25', %w(U U B U U L U U))

      expect(o25.name).to eq('OLL 25')
      expect(o25.code).to eq(:o25)
      expect(o25.color(:ULB_U)).to eq('oll-color')
      expect(o25.color(:ULB_L)).to eq(nil)
    end
  end

end
