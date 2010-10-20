# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-mingle'
  s.version     = 1.0
  s.authors     = ["Vincent Xu"]
  s.description = 'Cucumber Mingle Integration'
  s.summary     = 'cucumber-mingle-1.0'
  s.email       = 'vincent.hao.xu@gmail.com'

  s.platform    = Gem::Platform::RUBY

  s.add_dependency 'cucumber', '~> 0.9.2'
  s.add_dependency 'activeresource', '~> 3.0.1'
  
  s.add_development_dependency 'rake', '~> 0.8.7'
#  s.add_development_dependency 'rcov', '~> 0.9.9'

  s.rubygems_version   = "1.3.7"
  s.files            = `git ls-files`.split("\n")
  # s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # s.extra_rdoc_files = ["LICENSE", "README.rdoc", "History.txt"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
