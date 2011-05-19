$:.unshift 'lib'

begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts "Please install rspec (bundle install)"
  exit
end

begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.rcov[:rcov_opts] << "-Ispec"
  end
rescue LoadError
  puts "Can't find metric_fu"
end

RSpec::Core::RakeTask.new :spec

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/fanny_pack.rb -I ./lib"
end

desc "Push a new version to RubyGems"
task :publish do
  require 'fanny_pack/version'

  ver = FannyPack::Version

  sh "gem build fanny_pack.gemspec"
  sh "gem push fanny_pack-#{ver}.gem"
  sh "git tag -a -m 'FannyPack v#{ver}' v#{ver}"
  sh "git push origin v#{ver}"
  sh "git push origin master"
end

desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
end

task :default => :spec
