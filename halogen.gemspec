lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'halogen/version'

Gem::Specification.new do |spec|
  spec.name          = 'halogen'
  spec.version       = Halogen::VERSION
  spec.authors       = ['Heather Rivers']
  spec.email         = ['heather@modeanalytics.com']
  spec.summary       = 'HAL+JSON generator'
  spec.description   = 'Provides a framework-agnostic interface for ' \
                       'generating HAL+JSON representations of resources'
  spec.homepage      = 'https://github.com/mode/halogen'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 3.0'

  spec.add_dependency 'json', '~> 2.3.0'

  spec.add_development_dependency 'bundler',   '>= 2.0'
  spec.add_development_dependency 'rake',      '~> 13.0'
  spec.add_development_dependency 'rspec',     '~> 3.2'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'yard',      '~> 0.9.11'
end
