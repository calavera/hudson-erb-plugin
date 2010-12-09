require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler::setup

task :default => :spec

begin
  require 'rspec/core/rake_task'
rescue LoadError
  gem 'rspec'
  require 'rspec/core/rake_task'
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--colour', "--format documentation"]
end


namespace :doc do
  begin
    # Documentation task
    require 'yard'
    YARD::Rake::YardocTask.new
  rescue LoadError
  end

  desc 'upload documentation to github pages'
  task :upload => :yard do
    `git co gh-pages`
    `mv doc/* .`
    `rm -rf doc`
    `git ci -am 'release documentation'`
    `git push origin gh-pages`
  end
end

namespace :maven do
  desc 'upload a development snapshot'
  task :snapshot do
    `mvn deploy`
  end

  desc 'relase a maven artifact to the central repository'
  task :release do
    `mvn release:prepare release:perform`
  end

  desc 'release an artifact and take default version numbers'
  task :release_b do
    `mvn release:prepare release:perform -B`
  end
end
