require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sg-ruby"
    gem.summary = %Q{A SimpleGeo Ruby Client}
    # gem.description = %Q{}
    gem.email = "dan@dofter.com"
    gem.homepage = "http://github.com/archfear/sg-ruby"
    gem.authors = ["Dan Dofter"]
    
    gem.add_dependency("oauth", ">= 0.4.0")
    gem.add_dependency("json_pure", "~> 1.2.4")

    gem.add_development_dependency("shoulda", "~> 2.10.0")
    gem.add_development_dependency("jnunemaker-matchy", "~> 0.4.0")
    gem.add_development_dependency("mocha", "~> 0.9.0")
    gem.add_development_dependency("fakeweb", "~> 1.2.0")
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sg-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
