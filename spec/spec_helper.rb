RSpec.configure do |config|
  config.disable_monkey_patching!
  config.warnings = true

  config.include Module.new {
    def be_roughly(expected)
      be_within(1e-10).of(expected)
    end
  }
end
