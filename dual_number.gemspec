lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dual_number/version'

Gem::Specification.new do |spec|
  spec.name          = 'dual_number'
  spec.version       = DualNumber::VERSION
  spec.author        = 'Tom Stuart'
  spec.email         = 'tom@codon.com'

  spec.summary       = 'A Ruby implementation of dual numbers.'
  spec.homepage      = 'https://github.com/tomstuart/dual_number'
  spec.license       = 'CC0-1.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.4'
end
