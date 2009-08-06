# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{isis}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Sanheim"]
  s.date = %q{2009-08-05}
  s.default_executable = %q{isis}
  s.email = %q{rsanheim@gmail.com}
  s.executables = ["isis"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".treasure_map.rb",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "bin/isis",
     "examples/example_helper.rb",
     "examples/isis/array_extensions_example.rb",
     "examples/isis/config_example.rb",
     "examples/isis/runner_example.rb",
     "examples/isis_example.rb",
     "features/isis.feature",
     "features/step_definitions/isis_steps.rb",
     "features/support/env.rb",
     "features/support/ruby_forker.rb",
     "features/support/smart_match.rb",
     "fixtures/config_01",
     "isis.gemspec",
     "lib/isis.rb",
     "lib/isis/array_extensions.rb",
     "lib/isis/command.rb",
     "lib/isis/config.rb",
     "lib/isis/hash_extensions.rb",
     "lib/isis/runner.rb",
     "version.yml"
  ]
  s.homepage = %q{http://github.com/rsanheim/isis}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Meta git}
  s.test_files = [
    "examples/example_helper.rb",
     "examples/isis/array_extensions_example.rb",
     "examples/isis/config_example.rb",
     "examples/isis/runner_example.rb",
     "examples/isis_example.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
