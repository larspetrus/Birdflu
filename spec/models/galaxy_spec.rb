require 'rails_helper'

describe Galaxy do
    let(:g1) { Galaxy.create(wca_user_id: 909, style: 9) }

  before(:each) do
    g1.stars.create(raw_alg_id: 5)
    g1.stars.create(raw_alg_id: 25)
    g1.stars.create(raw_alg_id: 625)
  end

  describe 'construction' do
    it 'create' do
      expect(g1.wca_user_id).to eq(909)
      expect(g1.style).to eq(9)
      expect(g1.alg_ids).to eq([5, 25, 625])

      g2 = Galaxy.create(wca_user_id: 909, style: 9)
      expect(g2.alg_ids).to eq([])
    end

    it 'make' do
      g2 = Galaxy.make(909, 9, [5, 25, 625])

      expect(g2.wca_user_id).to eq(909)
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

end
