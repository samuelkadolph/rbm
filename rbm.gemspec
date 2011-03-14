$:.push(File.expand_path("../lib", __FILE__))
require "rbm/version"

Gem::Specification.new do |s|
  s.name        = "rbm"
  s.version     = RBM::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Samuel Kadolph"]
  s.email       = ["samuel@kadolph.com"]
  s.homepage    = "https://github.com/samuelkadolph/rbm"
  s.summary     = %q{Simple command line tool for quick ruby benchmarks.}
  s.description = %q{Command line tool for doing quick ruby benchmarks. Provide each code fragment to run as a separate code fragment to rbm. } +
                  %q{See rbm --help for more information.}

  s.files         = Dir["bin/*", "lib/**/*", "README.md", "UNLICENSE"]
  s.executables   = ["rbm"]
  s.require_paths = ["lib"]
end
