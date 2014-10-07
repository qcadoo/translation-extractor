require "spec_helper"

describe "TranslationsExtractor" do

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

  example "modifying JS according to CSV translation" do
    expected_js = File.read fixture_path("locale-en.js")
    expected_js.sub! "this.setTitle('Projects');", "this.setTitle('Change');"
    expected_js.sub! "this.lookupReference('newButton').setText('New');",
      "this.lookupReference('newButton').setText('Newer');"
    expected_js.sub! '{ "name": "Guideline", "value": "guideline" },',
      '{ "name": "Principles", "value": "guideline" },'
    expected_js.sub! "ads.app.getController('Main').errorTitle = 'Error';",
      "ads.app.getController('Main').errorTitle = 'Fatal';"

    Dir.mktmpdir do |dir|
      js_path = File.join(dir, "locale-en.js")
      FileUtils.cp fixture_path("locale-en.js"), js_path
      translations_file_path = fixture_path("js_translations.csv")

      run "import", "-i", translations_file_path, js_path

      File.read(js_path).should == expected_js
    end
  end

  def run command, *args
    TranslationsExtractor::CLI.start [command, *args.flatten]
  end

end
