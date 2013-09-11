Gem::Specification.new do |s|
  s.name        = 'typed-class'
  s.version     = '0.5.0'
  s.date        = '2013-08-07'
  s.summary     = "A DSL for defining very simple, strongly typed classes"
  s.description = "Allows you to define very simple classes with immutable variables, type safe constructors, and generated readers"
  s.authors     = ['Michael Bryzek', 'Peter Bakhirev']
  s.email       = 'mbryzek@alum.mit.edu'
  s.files       = ['lib/typed_class.rb',
                   'lib/typed_class/attribute.rb',
                   'lib/typed_class/instance_checks.rb',
                   'lib/typed_class/metadata.rb',
                   'lib/typed_class/option.rb',
                   'lib/typed_class/util.rb',
                   'lib/typed_class/typed_class.rb']
  s.add_development_dependency "rspec"
  s.homepage    = 'http://rubygems.org/gems/typed_class'
  s.license     = 'Apache License, Version 2.0'
end
