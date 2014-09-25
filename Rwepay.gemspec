# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Rwepay/version'

Gem::Specification.new do |spec|
  spec.name          = "Rwepay"
  spec.version       = Rwepay::VERSION
  spec.authors       = ["RaymondChou"]
  spec.email         = ["freezestart@gmail.com"]
  spec.summary       = "WeChat Pay gem"
  spec.description   = "WeChat Pay gem"
  spec.homepage      = "https://github.com/RaymondChou/Rwepay"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "nokogiri"
end
