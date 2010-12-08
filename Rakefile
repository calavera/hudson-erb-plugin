require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler::setup

begin
  require 'rspec/core/rake_task'
rescue LoadError
  gem 'rspec'
  require 'rspec/core/rake_task'
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--colour', "--format documentation"]
end

begin
  # Documentation task
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
end

task :default => :spec
