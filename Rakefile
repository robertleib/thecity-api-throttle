# encoding: utf-8

require 'rubygems'
require 'bundler'
require './lib/thecity/api/throttle/version.rb'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.files = FileList['lib/**/*.rb', '[A-Z]*', 'spec/**/*'].to_a
  gem.version = Thecity::Api::Throttle::VERSION 
  gem.name = "thecity-api-throttle"
  gem.homepage = "http://github.com/robertleib/thecity-api-throttle"
  gem.license = "MIT"
  gem.summary = %Q{Custom Rack::Throttle implementation for TheCity API}
  gem.description = %Q{Custom Rack::Throttle implementation for TheCity API}
  gem.email = "robert.leib@gmail.com"
  gem.authors = ["Robbie Leib"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "thecity-api-throttle #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
