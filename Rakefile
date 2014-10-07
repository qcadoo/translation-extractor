require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :test
RSpec::Core::RakeTask.new(:test => :parser)

parser_source = "lib/translations_extractor/parser/ext.kpeg"
parser_target = parser_source + ".rb"

desc "Builds parser from source grammar"
task :parser => parser_target

file parser_target => parser_source do |t|
  system "kpeg -f #{t.prerequisites.join(' ')}"
end
