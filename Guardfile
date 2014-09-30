kpeg_cmd = "bundle exec kpeg -f"

guard :shell do
  watch(%r{\.kpeg$})                  { |f| `#{kpeg_cmd} #{f[0]} #{f[0]}.rb` }
end

guard :rspec, cmd: 'bundle exec rspec --color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})           { "spec" }
  watch('spec/spec_helper.rb')        { "spec" }
  watch(%r{^spec/support/.+\.rb$})    { "spec" }
  watch(%r{\.gemspec$})               { "spec" }
end
