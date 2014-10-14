require "spec_helper"

describe "TranslationsExtractor" do

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
      ["ads.view.project.List.title", "", "Projects"],
      ["ads.view.project.List.clientNameColumn.text", "", "Client"],
      ["ads.view.project.List.editButton.text", "", "Edit"],
      ["ads.view.project.List.tooltippedButton.tooltip", "", "Button tooltip"],
      ["ads.view.project.List.nameColumn.text", "", "Name"],
      ["ads.view.project.List.newButton.text", "", "New"],
      ["ads.view.project.List.removeErrorTitle", "", "Remove error!"],
      ["ads.view.project.List.hasStagesErrorMsg", "", "Can't remove project with any stage."],
      ["ads.view.project.List.dateFormat", "", "d-m-Y"],
      ["ads.view.project.List.daysText", "", " days"],
      ["ads.view.project.List.hasQuote", "", "Intentionally contains \" character"],
      ["ads.store.StageTypes.guideline", "", "Guideline"],
      ["ads.store.StageTypes.project", "", "Project"],
      ["Main.errorTitle", "", "Error"],
    ].sort
  end

  def run command, *args
    TranslationsExtractor::CLI.start [command, *args.flatten]
  end

end
