require 'rake'

begin
  require 'rspec/core/rake_task'
rescue LoadError
  gem 'rspec'
  require 'rspec/core/rake_task'
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--colour', "--format documentation"]
end

task :default => :spec
