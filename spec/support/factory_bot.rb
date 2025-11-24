RSpec.configure do |config|
  config.before(:suite) do
    next unless ENV['LINT_FACTORIES'] == 'true'

    begin
      DatabaseCleaner.start
      FactoryBot.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
