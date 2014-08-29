require 'rails_helper'

RSpec.describe Alg, :type => :model do
  it 'makes all variants' do
    stigs = Alg.variants('Stig', "R U' L2")

    expect(stigs.map(&:moves)).to eq(["R U' L2", "F U' B2", "L U' R2", "B U' F2"])
    expect(stigs.map(&:name)).to eq(['Stig-R', 'Stig-F', 'Stig-L', 'Stig-B'])
  end
end
