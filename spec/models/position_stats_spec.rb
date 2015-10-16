require 'rails_helper'

RSpec.describe PositionStats, :type => :model do

  it 'make' do

    stats = {
        raw_counts: {11 => 2, 12 => 4, 13 => 29, 14 => 134, 15 => 655},
        shortest: 11,
        fastest: 9.2,
        combo_count: 186,
        shortest_combo: 12,
        fastest_combo: 9.3
    }

    pos_stats = PositionStats.make(25, stats)

    expect(pos_stats.raw_counts[13]).to eq(29)
    expect(pos_stats.shortest).to eq(11)
  end
end