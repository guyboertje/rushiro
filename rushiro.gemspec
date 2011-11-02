Gem::Specification.new do |s|
  s.name        = 'rushiro'
  s.version     = '1.0.0'
  s.date        = '2011-11-02'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Lee Henson', 'Guy Boertje']
  s.email       = ['lee.m.henson@gmail.com', 'guyboertje@gmail.com']
  s.homepage    = "http://github.com/guyboertje/rushiro"
  s.summary     = %q{Explicit permissions inspired by Apache Shiro}
  s.description = %q{}

  # = MANIFEST =

  # = MANIFEST =

  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_development_dependency  'awesome_print',      '~> 0.4.0'
  s.add_development_dependency  'cranky',             '~> 0.2.0'
  s.add_development_dependency  'fuubar',             '~> 0.0.0'
  s.add_development_dependency  'rspec',              '~> 2.6.0'
end
