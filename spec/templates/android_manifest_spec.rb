require 'spec_helper'

describe Confetti::Template::AndroidManifest do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::AndroidManifest
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"android.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/android_manifest.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :package_name }
    it { should respond_to :class_name }
  end

  describe "default values" do
    it "should define output filename as \"AndroidManifest.xml\"" do
      @template_class.new.output_filename.should == "AndroidManifest.xml"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
    end

    it "should accept the config object" do
      lambda {
        @template_class.new(@config)
      }.should_not raise_error
    end

    describe "templated attributes" do
      before do
        @template = @template_class.new(@config)
      end

      it "should set package_name correctly" do
        @template.package_name.should == "com.whoever.awesome.app"
      end

      it "should set class_name correctly" do
        @template.class_name.should == "AwesomeApp"
      end

      it "should use the default version" do
        @template.version.should == "0.0.1"
      end

      it "should render the correct AndroidManifest" do
        @template.render.should == File.read("#{ fixture_dir }/android_manifest_spec.xml")
      end
    end
  end
end