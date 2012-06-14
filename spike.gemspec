# -*- encoding: utf-8 -*-
require File.expand_path('../lib/spike/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Harrison"]
  gem.email         = ["james@talkunafraid.co.uk"]
  gem.description   = %q{A tool for recursively optimising directories of images}
  gem.summary       = %q{This tool uses optipng, jpegoptim and gifsicle to optimise image file sizes for a directory tree.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "spike"
  gem.require_paths = ["lib"]
  gem.version       = Spike::VERSION
  gem.add_dependency("sqlite3", ">= 1.3.6")
  gem.add_dependency("sequel", ">= 3.36.0")
  gem.add_dependency("trollop", ">= 1.16.2")
end
