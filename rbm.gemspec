require File.expand_path("../.gemspec", __FILE__)
require File.expand_path("../lib/rbm/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "rbm"
  gem.authors     = ["Samuel Kadolph"]
  gem.email       = ["samuel@kadolph.com"]
  gem.description = readme.description
  gem.summary     = readme.summary
  gem.homepage    = "http://samuelkadolph.github.com/rbm/"
  gem.version     = RBM::VERSION

  gem.files       = Dir["bin/*", "lib/**/*"]
  gem.executables = Dir["bin/*"].map(&File.method(:basename))
  gem.test_files  = Dir["test/**/*_test.rb"]
end
