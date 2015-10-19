require 'rake'
require 'rake/testtask'
require 'rake/clean'

CLEAN.include('*.gem', '*.rbc')

namespace :gem do
  desc 'Build the each-with-flag gem'
  task :create => [:clean] do
    spec = eval(IO.read('each-with-flag.gemspec'))
    if Gem::VERSION < '2.0'
      Gem::Builder.new(spec).build
    else
      require 'rubygems/package'
      Gem::Package.build(spec)
    end
  end

  desc 'Install the each_with_flag library as a gem'
  task :install => [:create] do
    file = Dir['*.gem'].first
    sh "gem install -l #{file}"
  end
end

Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = true
end

task :default => :test