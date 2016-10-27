require 'rails_helper'

RSpec.describe Icons::Base do

  it 'css_classes' do
    icon = Icons::Cop.by_code(:Bf)
    
    expect(icon.css_classes('blah', false)).to eq('pick-icon')
    expect(icon.css_classes(icon.name, false)).to eq('pick-icon selected')
    expect(icon.css_classes(icon.name, true)).to eq('locked-pick-icon')

    none_icon = Icons::Eo.by_code(:'')
    expect(none_icon.css_classes(none_icon.name)).to eq('pick-icon')
  end
end