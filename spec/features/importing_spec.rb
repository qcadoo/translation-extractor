require "spec_helper"

describe "Localizer" do

  example "fails when header is invalid" do
    Dir.mktmpdir do |dir|
      input = fixture_path("invalid_translations.csv")
      pl_properties = File.join dir, "locale_pl.properties"
      en_properties = File.join dir, "locale_en.properties"

      FileUtils.touch pl_properties
      FileUtils.touch en_properties

      proc {
        run "import", "-i", input, pl_properties, en_properties
      }.should raise_exception

      JavaProperties.load(pl_properties).should be_empty
      JavaProperties.load(en_properties).should be_empty
    end
  end

  example "generating properties files from CSV" do
    Dir.mktmpdir do |dir|
      input = fixture_path("translations.csv")
      pl_properties = File.join dir, "locale_pl.properties"
      en_properties = File.join dir, "locale_en.properties"

      FileUtils.touch pl_properties
      FileUtils.touch en_properties

      run "import", "-i", input, pl_properties, en_properties
      JavaProperties.load(pl_properties).should == {
        :"some.very.important.color" => "niebieski",
        :"less.important.color" => "karmazyn",
      }
      JavaProperties.load(en_properties).should == {
        :"some.very.important.color" => "blue",
        :"less.important.color" => "crimson",
      }
    end
  end

  def run command, *args
    Localizer::CLI.start [command, *args.flatten]
  end

end
