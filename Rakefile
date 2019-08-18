require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

RDoc::Task.new :docs do |t|
  t.main = "lib/luigi-template.rb"
  t.rdoc_files.include('lib/*.rb')
  t.rdoc_dir = 'docs'
  # t.options << "--all"
end

desc "Run tests"
task :default => :test
