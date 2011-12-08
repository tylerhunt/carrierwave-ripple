require './lib/carrierwave/ripple/version'

Gem::Specification.new do |s|
  s.name        = 'carrierwave-ripple'
  s.version     = Carrierwave::Ripple::VERSION
  s.authors     = ['Tyler Hunt']
  s.email       = ['tyler@tylerhunt.com']
  s.homepage    = 'https://github.com/tylerhunt/carrierwave-ripple'
  s.summary     = %q{Ripple support for CarrierWave}
  s.description = %q{Ripple support for CarrierWave}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'carrierwave'
end
