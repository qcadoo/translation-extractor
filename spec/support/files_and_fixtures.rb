module FilesAndFixtures

  def fixture_path file
    fixtures_root = File.expand_path("../../fixtures", __FILE__)
    File.join(fixtures_root, file)
  end

  def tmp_dir
    path = File.expand_path "../../../tmp", __FILE__
    FileUtils.mkdir_p path
    path
  end

end

RSpec.configure do |c|

  c.include FilesAndFixtures

end
