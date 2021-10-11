
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "longjump/version"

Gem::Specification.new do |spec|
  spec.name          = "longjump"
  spec.version       = Longjump::VERSION
  spec.authors       = ["Alex Watt"]
  spec.email         = ["alex@alexcwatt.com"]

  spec.summary       = "Jump to URI's deep inside applications."
  spec.homepage      = "https://github.com/alexcwatt/longjump"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = ["longjump"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.13"
end
