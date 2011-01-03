# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "transliteration/version"

Gem::Specification.new do |s|
  s.name        = "ru_translit"
  s.version     = RuTranslit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johannes Stein"]
  s.email       = ["johannes@unsyn.com"]
  s.homepage    = "http://rubygems.org/gems/ru_translit"
  s.summary     = %q{Get a list of latin transliterations from a cyrillic word and vice versa.}
  s.description = %q{Transliterations and detransliterations, using English, German and scientific transliteration variants.}

  s.rubyforge_project = "ru_translit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
