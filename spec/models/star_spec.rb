require 'rails_helper'

describe Star do
  it '::select_from_class' do
    expect(Star.select_from_class('star4')).to eq(['raw_alg', 4])
    expect(Star.select_from_class('cstar81')).to eq(['combo_alg', 81])
    expect{Star.select_from_class('blah4')}.to raise_error(RuntimeError)
    expect{Star.select_from_class('star4b')}.to raise_error(ArgumentError)
  end
end
