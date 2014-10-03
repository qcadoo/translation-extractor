# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'localizer/version'

Gem::Specification.new do |spec|
  spec.name          = "localizer"
  spec.version       = Localizer::VERSION
  spec.authors       = ["Sebastian Skałacki"]
  spec.email         = ["skalee@gmail.com"]
  spec.summary       = %q{Localizes Ext JS and Java properties}
  spec.description   = nil
  spec.homepage      = ""
  spec.license       = "ISC"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "java-properties"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-shell"
  spec.add_development_dependency "kpeg"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1"
end
