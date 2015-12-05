require 'rails_helper'

RSpec.describe Icons::Base do

  it 'css_classes' do
    icon = Icons::Cop.by_code(:Bf)
    
    expect(icon.css_classes('blah')).to eq('ui-llicon')
    expect(icon.css_classes(icon.name)).to eq('ui-llicon selected')

    none_icon = Icons::Eo.by_code(:'')
    expect(none_icon.css_classes(none_icon.name)).to eq('ui-llicon')
  end
end