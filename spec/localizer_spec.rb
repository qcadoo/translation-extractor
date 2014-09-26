require "spec_helper"

describe "Localizer" do

  example "generating CSV from simple properties file" do
    run "export"
    skip "TODO"
  end

  def run command, *args
    Localizer::CLI.start [command, *args.flatten]
  end

end
