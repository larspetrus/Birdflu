require 'rails_helper'

describe AlgSetsHelper do
  let(:uncalculated_as) {AlgSet.make(algs: '', name: 'no').data_only}

  it 'fmt_coverage_percent' do
    expect(helper.fmt_coverage_percent(uncalculated_as)).to eq('--')
    expect(helper.fmt_coverage_percent(double(coverage: 22, subset_pos_ids: 1..50.to_i))).to eq('44%')
  end

  it 'fmt_coverage_fraction' do
    expect(helper.fmt_coverage_fraction(uncalculated_as, false)).to eq('')
    expect(helper.fmt_coverage_fraction(uncalculated_as, true)).to eq('')

    half_covered = double(full_coverage?: false, coverage: 22, subset_pos_ids: 1..50.to_i)
    expect(helper.fmt_coverage_fraction(half_covered, false)).to eq('22/50')
    expect(helper.fmt_coverage_fraction(half_covered, true)).to eq('(22/50)')
  end
end