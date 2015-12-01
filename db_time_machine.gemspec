# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'db_time_machine/version'

Gem::Specification.new do |spec|
  spec.name          = "db_time_machine"
  spec.version       = DbTimeMachine::VERSION
  spec.authors       = ["SURAT PYARI"]
  spec.email         = ["suratpyari.db21@gmail.com"]

  spec.summary       = %q{Dump data and upload to fog directory.}
  spec.description   = %q{This gem takes the dump of database for a rails application and upload it to fog directory.}
  spec.homepage      = "https://github.com/suratpyari/db_time_machine"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "rails", [">= 4.0"]
  spec.add_runtime_dependency "fog", [">= 1.32"]

end
