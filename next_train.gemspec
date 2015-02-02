# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "next_train"
  spec.version       = "0.0.2"
  spec.authors       = ["Sandro Padin"]
  spec.email         = ["sandropadin@gmail.com"]
  spec.summary       = %q{Find out when the next CTA train arrives.}
  spec.description   = %q{Find out when the next CTA train arrives.}
  spec.homepage      = "https://github.com/spadin/next_train"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cta-api"
  spec.add_dependency "time_diff"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "webmock"
end
