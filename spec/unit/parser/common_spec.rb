require "spec_helper"

describe "Localizer::Parser::Common" do

  subject{ Object.new.extend Localizer::Parser::Common }

  describe "matches_type?" do
    example "setSomeValue matches setter type" do
      subject.matches_type?("setSomeValue", "setter").should be true
    end
    example "define matches scope type" do
      subject.matches_type?("define", "scope").should be true
    end
    example "nearlyAnything matches attribute type" do
      subject.matches_type?("nearlyAnything", "attribute").should be true
    end
    example "override does not match attribute type" do
      subject.matches_type?("override", "attribute").should be false
    end
  end

  describe "translate_setter_to_key" do
    example "setSomeValue" do
      subject.translate_setter_to_key("setSomeValue").should == "someValue"
    end
    example "notASetterName" do
      subject.translate_setter_to_key("notASetterName").should be nil
    end
  end

end
