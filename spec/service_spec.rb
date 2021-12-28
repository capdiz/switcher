require 'switcher/cli'
require 'switcher/generators/service'
require 'aruba/rspec'
require 'pathname'
RSpec.describe "Creating Switcher Service", type: :aruba do
  include Switcher::Generators::Service
  before(:each) do
    @service_name = "payments"
    @command = run_command("switcher create service #{@service_name}") { 
      |process|
    }
    stop_all_commands
  end

  describe "creating a new service" do
    it "checks motherdir exists" do
      expect(inside_motherdir?).to eq(true)
    end
    it "checks service exists" do 
      expect(service_exists?).to eq(true)
    end 
    context "when service exists" do
      it "replaces existing service"
      it "creates app folder"
      it "creates spec folder"
      it "creates gem file"
    end

    context "when new service" do
      it "creates a gem file"
      it "creates an app folder"
      it "creates a db folder"
      it "creates a spec folder"
    end

    context "inside app folder" do
      it "creates app.rb file"
      it "creates models folder"
      it "creates controllers folder"
    end

    context "inside spec folder" do
      it "creates payments_spec.rb file"
    end
  end
end
