require 'rails_helper'

RSpec.describe PositionStats, :type => :model do

  it 'make' do
    stats = {
        raw_counts: {11 => 2, 12 => 4, 13 => 29, 14 => 134, 15 => 655},
        shortest: 11,
        fastest: 9.2,
    }

    pos_stats = PositionStats.make(25, stats)

    expect(pos_stats.raw_counts[13]).to eq(29)
    expect(pos_stats.shortest).to eq(11)
  end

  it 'aggregate' do
    data1 = {
        raw_counts: {12 => 4, 13 => 29, 14 => 134, 15 => 655},
        shortest: 12,
        fastest: 10.2,
    }
    data2 = {
        raw_counts: {14 => 7, 15 => 62},
        shortest: 14,
        fastest: 9.88,
    }
    aggregate = PositionStats.aggregate([PositionStats.make(1, data1), PositionStats.make(2, data2)])
    expect(aggregate.position_count).to eq(2)
    expect(aggregate.shortest).to eq(12)
    expect(aggregate.fastest).to eq(9.88)
    expect(aggregate.raw_counts).to eq({12 => 4, 13 => 29, 14 => 141, 15 => 717})

    empty_agg = PositionStats.aggregate([])
    expect(empty_agg.position_count).to eq(0)
    expect(empty_agg.shortest).to eq(99)
    expect(empty_agg.fastest).to eq(99)
    expect(empty_agg.raw_counts).to eq({})

  end
end