kpeg_cmd = "bundle exec kpeg -f"

guard :shell, all_on_start: true do
  watch(%r{\.kpeg$})                  { |f| `#{kpeg_cmd} #{f[0]} #{f[0]}.rb` }
end

guard :rspec, cmd: 'bundle exec rspec --color', all_on_start: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})           { "spec" }
  watch('spec/spec_helper.rb')        { "spec" }
  watch(%r{^spec/support/.+\.rb$})    { "spec" }
  watch(%r{^spec/fixtures/.*$})       { "spec" }
  watch(%r{\.gemspec$})               { "spec" }
end
