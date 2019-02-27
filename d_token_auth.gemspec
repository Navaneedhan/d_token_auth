$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "d_token_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "d_token_auth"
  spec.version     = DTokenAuth::VERSION
  spec.authors     = ["navaneedhanr"]
  spec.email       = ["navaneedhan.ravichandran@weinvest.net"]
  # spec.homepage    = "TODO: Set to 'http://mygemserver.com'"
  spec.summary     = "Summary of DTokenAuth."
  spec.description = "Description of DTokenAuth."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2"

  spec.add_dependency "devise_token_auth"
end
