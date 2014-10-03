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

  example "generating CSV from single JS source" do
    js_path = fixture_path("locale-en.js")
    output_file = Tempfile.new(%w[translations .csv], tmp_dir)

    run "export", "-o", output_file.path, js_path
    out = CSV.read output_file

    out.should_not be_empty

    out.sort.should == [
      ["Klucz", "Translacja polska", "Translacja angielska"],
      ["ads.locale.en.view.project.List.title", "", "Projects"],
      ["ads.locale.en.view.project.List.clientNameColumn", "", "Client"],
      ["ads.locale.en.view.project.List.editButton", "", "Edit"],
      ["ads.locale.en.view.project.List.nameColumn", "", "Name"],
      ["ads.locale.en.view.project.List.newButton", "", "New"],
      ["ads.locale.en.view.project.List.removeErrorTitle", "", "Remove error!"],
      ["ads.locale.en.view.project.List.hasStagesErrorMsg", "", "Can't remove project with any stage."],
      ["ads.locale.en.view.project.List.dateFormat", "", "d-m-Y"],
      ["ads.locale.en.view.project.List.daysText", "", " days"],
    ].sort
  end

  def run command, *args
    Localizer::CLI.start [command, *args.flatten]
  end

end
