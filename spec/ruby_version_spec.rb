require 'rails_helper'

describe 'Environment' do
  it 'Uses correct Ruby version' do
    project_ruby_version = File.open(".ruby-version", "rb").read
    expect(RUBY_VERSION).to eq(project_ruby_version)
  end
end

