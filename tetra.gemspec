# encoding: UTF-8
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "tetra/version"

Gem::Specification.new do |s|
  s.name = "tetra"
  s.version = Tetra::VERSION
  s.authors = ["Silvio Moioli"]
  s.email = ["smoioli@suse.de"]
  s.homepage = "https://github.com/SilvioMoioli/tetra"
  s.summary = "Green Java Packager's Tools"
  s.description = "A suite of tools to ease Java packaging in SUSE systems"
  s.license = "MIT"

  s.rubyforge_project = "tetra"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.add_runtime_dependency "clamp"
  s.add_runtime_dependency "rubyzip", ">= 1.0"
  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "text"
  s.add_runtime_dependency "nokogiri"
end