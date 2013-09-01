$:.unshift 'lib'

require 'fanny_pack/version'

Gem::Specification.new do |s|
  s.name      = 'fanny_pack'
  s.version   = FannyPack::Version
  s.platform  = Gem::Platform::RUBY
  s.date      = Time.now.strftime('%Y-%m-%d')
  s.summary   = 'Ruby bindings for the Fantastico API'
  s.homepage  = 'https://github.com/site5/fanny_pack'
  s.authors   = ['Joshua Priddle']
  s.email     = 'jpriddle@site5.com'
  s.license   = 'MIT'

  s.files     = %w[ Rakefile README.markdown ]
  s.files    += Dir['lib/**/*']
  s.files    += Dir['spec/**/*']

  s.add_runtime_dependency 'builder', '>= 3.0.0'
  s.add_runtime_dependency 'faraday', '~> 0.8.1'
  s.add_runtime_dependency 'malcolm', '~> 0.0.2'
  s.add_runtime_dependency 'nori', '~> 1.1.0'
  s.add_runtime_dependency 'xml-simple', '~> 1.1.1'
  s.add_runtime_dependency('jruby-openssl', '~> 0.7.4') if RUBY_PLATFORM == 'java'

  s.add_development_dependency 'rake', '~> 0.9.2.2'
  s.add_development_dependency 'rspec', '~> 2.10.0'
  s.add_development_dependency 'fakeweb', '~> 1.3.0'
  s.add_development_dependency 'awesome_print', '~> 1.0.2'
  s.add_development_dependency 'vcr', '~> 2.2.0'

  s.extra_rdoc_files = ['README.markdown']
  s.rdoc_options     = ["--charset=UTF-8"]

  s.description = <<-DESC
    Ruby bindings for the Fantastico API
  DESC
end
