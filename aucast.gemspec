
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aucast/version"

Gem::Specification.new do |spec|
  spec.name          = "aucast"
  spec.version       = Aucast::VERSION
  spec.authors       = ["Bruno Wernimont"]
  spec.email         = ["contact@aucast.io"]

  spec.summary       = %q{Upload audio file and video media URL to Aucast iOS app.}
  spec.description   = %q{The CLI for uploading audio and video URL to Aucast iOS app, that support youtube-dl.}
  spec.homepage      = "https://github.com/brunow/aucast_cli"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables = ["aucast"]
  spec.require_paths = ["lib"]
  
  spec.add_dependency "thor", '~> 0.20'
  spec.add_dependency "rest-client", '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "minitest-reporters", ">= 1.1"
  spec.add_development_dependency "webmock", ">= 3.0"
  spec.add_development_dependency "byebug"
  
end
