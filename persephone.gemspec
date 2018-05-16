# -*- encoding: utf-8 -*-
require File.expand_path('../lib/persephone/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.authors       = ["Dave Sloan"]
  gem.email         = ["daveksloan@gmail.com"]
  gem.description   = %q{Persephone is a gem which implements simple OAuth2 token based API authentication for Rails 4 and Mongoid 5.}
  gem.summary       = %q{This gem implements the OAuth2 client credentials token based authentication for applications. The client requests a token with their ID and secret key and the server responds with a token that can be used on subsequent API requests.}
  gem.homepage      = "https://github.com/davesloan/persephone"

  #gem.files         = `git ls-files`.split($\)
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- spec/*`.split("\n")
  gem.name          = "persephone"
  gem.require_paths = ["lib"]
  gem.version       = Persephone::VERSION

  gem.add_runtime_dependency(%q<rails>, [">= 4.2.5"])
  gem.add_runtime_dependency(%q<uuid>, [">= 2.3.5"])
  gem.add_runtime_dependency(%q<mongoid>, [">= 5.1.0"])
end
