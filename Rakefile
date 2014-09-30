require "bundler/gem_tasks"

parser_source = "lib/localizer/ext_parser.kpeg"
parser_target = parser_source + ".rb"

desc "Builds parser from source grammar"
task :parser => parser_target

file parser_target => parser_source do |t|
  system "kpeg -f #{t.prerequisites.join(' ')}"
end
