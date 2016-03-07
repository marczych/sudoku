require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |task|
   task.test_files = FileList['tests/*.rb']
   task.verbose = true
end
