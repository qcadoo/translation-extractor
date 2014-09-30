require "spec_helper"

describe "Localizer" do

  example "generating CSV from single properties file" do
    properties_path = fixture_path("locale_pl.properties")
    output_file = Tempfile.new(%w[translations .csv], tmp_dir)

    run "export", "-o", output_file.path, properties_path
    out = CSV.read output_file

    out.should_not be_empty
    out.should == [
      ["Klucz", "Translacja polska", "Translacja angielska"],
      ["project.name.copy.postfix", "(kopiuj)", ""],
      ["project.name.copy.prefix", "Eksport", ""],
    ]
  end

  example "generating CSV from multiple properties files" do
    pl_properties_path = fixture_path("locale_pl.properties")
    en_properties_path = fixture_path("locale_en.properties")
    output_file = Tempfile.new(%w[translations .csv], tmp_dir)

    run "export", "-o", output_file.path, pl_properties_path, en_properties_path
    out = CSV.read output_file

    out.should_not be_empty
    out.should == [
      ["Klucz", "Translacja polska", "Translacja angielska"],
      ["project.name.copy.postfix", "(kopiuj)", "(copy)"],
      ["project.name.copy.prefix", "Eksport", "Export"],
    ]
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
        :"less.important.color" => "czerwony",
      }
      JavaProperties.load(en_properties).should == {
        :"some.very.important.color" => "blue",
        :"less.important.color" => "red",
      }
    end
  end

  example "generating CSV from single JS source" do
    js_path = fixture_path("locale-en.js")
    output_file = Tempfile.new(%w[translations .csv], tmp_dir)

    run "export", "-o", output_file.path, js_path
    out = CSV.read output_file

    out.should_not be_empty

    out.should == [
      ["Klucz", "Translacja polska", "Translacja angielska"],
      ["ads.locale.en.view.project.List.title", "", "Projects"],
    ]
  end

  def run command, *args
    Localizer::CLI.start [command, *args.flatten]
  end

end
