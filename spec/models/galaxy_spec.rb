require 'rails_helper'

describe Galaxy do
  let(:g1) { Galaxy.create!(wca_user_id: 1, style: 9, starred_type: 'raw_alg') }

  before(:each) do
    g1.stars.create!(starred_id: 5)
    g1.stars.create!(starred_id: 25)
    g1.stars.create!(starred_id: 625)
  end

  describe 'construction' do
    it 'create' do
      expect(g1.wca_user_id).to eq(1)
      expect(g1.style).to eq(9)
      expect(g1.alg_ids).to eq([5, 25, 625])

      g2 = Galaxy.create!(wca_user_id: 2, style: 4, starred_type: 'combo_alg')
      expect(g2.alg_ids).to eq([])
    end

    it 'make' do
      g2 = Galaxy.make(3, 9, [5, 25, 625])

      expect(g2.wca_user_id).to eq(3)
      expect(g2.style).to eq(9)
      expect(g2.alg_ids).to eq([5, 25, 625])
    end
  end

  it 'add and remove ids' do
    g1.add(175)

    expect(g1.alg_ids).to eq([5, 25, 625, 175])

    g1b = Galaxy.find(g1.id)
    expect(g1b.alg_ids).to eq([5, 25, 625, 175])

    g1b.remove(25)
    expect(g1b.alg_ids).to eq([5, 625, 175])

    g1c = Galaxy.find(g1.id)
    expect(g1c.alg_ids).to eq([5, 625, 175])
  end

  it 'include?' do
    expect(g1.include?(47)).to eq(false)
    expect(g1.include?(25)).to eq(true)
    expect(g1.include?('25')).to eq(true)
  end

  it 'alg_names' do
    allow(RawAlg).to receive(:find).with(5)   { double(name: 'X5') }
    allow(RawAlg).to receive(:find).with(25)  { double(name: 'X25') }
    allow(RawAlg).to receive(:find).with(625) { double(name: 'X625') }

    expect(g1.alg_names).to eq(['X25', 'X5', 'X625'])
  end

end
