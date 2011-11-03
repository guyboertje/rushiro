Gem::Specification.new do |s|
  s.name        = 'rushiro'
  s.version     = '1.0.0'
  s.date        = '2011-11-03'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Lee Henson', 'Guy Boertje']
  s.email       = ['lee.m.henson@gmail.com', 'guyboertje@gmail.com']
  s.homepage    = "http://github.com/guyboertje/rushiro"
  s.summary     = %q{Explicit permissions inspired by Apache Shiro}
  s.description = %q{}

  # = MANIFEST =
  s.files = %w[
    Gemfile
    Rakefile
    lib/rushiro.rb
    lib/rushiro/access_control_hash.rb
    lib/rushiro/access_levels.rb
    lib/rushiro/allow_based_control.rb
    lib/rushiro/deny_based_control.rb
    lib/rushiro/permission.rb
    lib/rushiro/permissions.rb
    lib/rushiro/version.rb
    readme.md
    rushiro.gemspec
    spec/access_control_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_development_dependency  'awesome_print',      '~> 0.4.0'
  s.add_development_dependency  'fuubar',             '~> 0.0.0'
  s.add_development_dependency  'rspec',              '~> 2.6.0'
end
