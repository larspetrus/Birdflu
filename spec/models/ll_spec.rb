require "rails_helper"

RSpec.describe LL, :type => :model do
  it "#corner_data" do
    expect(LL.corner_data(:g).distance).to eq(1)
    expect(LL.corner_data(:g).spin).to eq(2)

    expect(LL.corner_data('g')).to eq(LL.corner_data(:g))
  end

  it "#edge_data" do
    expect(LL.edge_data('3').distance).to eq(1)
    expect(LL.edge_data('3').spin).to eq(0)
    expect(LL.edge_data('6').distance).to eq(2)
    expect(LL.edge_data('6').spin).to eq(1)

    expect(LL.edge_data(1)).to eq(LL.edge_data('1'))
  end

  it '#corner_code' do
    expect(LL.corner_code(0, 0)).to eq('a')
    expect(LL.corner_code(0, 1)).to eq('b')
    expect(LL.corner_code(1, 2)).to eq('g')
    expect(LL.corner_code(3, 0)).to eq('o')
  end

  it '#edge_code' do
    expect(LL.edge_code(0, 0)).to eq('1')
    expect(LL.edge_code(0, 1)).to eq('2')
    expect(LL.edge_code(2, 0)).to eq('5')
    expect(LL.edge_code(3, 1)).to eq('8')
  end

end
