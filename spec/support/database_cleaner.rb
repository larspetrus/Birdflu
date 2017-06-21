RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: [WcaUser, Position, RawAlg, ComboAlg].map(&:table_name))
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Reset class level @-caches
  config.after(:each) do
    MirrorAlgs.instance_variable_set(:@combined_data, nil)
  end

end