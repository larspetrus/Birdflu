require 'rails_helper'

describe 'Environment' do
  it 'Uses correct Ruby version' do
    project_ruby_version = File.open(".ruby-version", "rb").read
    expect(RUBY_VERSION).to eq(project_ruby_version)
  end

  it 'has the expected seed data' do
    expect(Position.maximum(:id)).to eq(5992)
    expect(RawAlg.maximum(:id)).to eq(46743068)
    expect(ComboAlg.maximum(:id)).to eq(164444)
    expect(RawAlg.id_ranges).to eq([2, 6, 16, 54, 198, 904, 3502, 15340, 71660, 347930, 1666938, 8569752])
  end
end

