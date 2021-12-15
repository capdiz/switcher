require 'switcher/cli'
require 'aruba/rspec'
require 'pathname'
require 'switcher/scripts/load'

RSpec.describe 'Switcher Cli', type: :aruba do
  before(:each) do 
    @single_motherdir_name = "chozishop"
    @command = run_command("switcher motherdir #{@single_motherdir_name}") { |process| 
      type("y")
      type("merchants")
    }
    stop_all_commands    
  end

  describe "#creating_switcher_application" do
    context "when application exists" do
      it "overwrites load script" do
        load_script = all_files.select do |file|
          path = Pathname.new("#{file}")
          path.basename.to_s == "load"
        end
        expect(load_script.size).to eq(1)
      end
      it "overwrites deploy script" do
        deploy_script = all_files.select do |file|
          path = Pathname.new(file)
          path.basename.to_s == "deploy"
        end
        expect(deploy_script.size).to eq(1)
      end
      it "overwrites run_test script" do
        run_test_script = all_files.select do |file|
          path = Pathname.new(file)
          path.basename.to_s == "run_test"
        end
        expect(run_test_script.size).to eq(1)
      end
    end

    context "when application doesn't exist" do
      it "creates single mother directory" do 
        singlemother_dir = all_directories.select do |dir|
          path = Pathname.new(dir)
          path.basename.to_s == "chozishop"
        end
        expect(singlemother_dir.size).to eq(1)
      end
    end

    context "inside single-mother directory" do
      it "creates load script" do
        load_script = all_files.select do |file|
          path = Pathname.new(file)
          path.basename.to_s == "load"
        end
        expect(load_script.size).to eq(1)
      end
      it "creates deploy script" do
        deploy_script = all_files.select do |file|
          path = Pathname.new(file)
          path.basename.to_s == "deploy"
        end
        expect(deploy_script.size).to eq(1)
      end
      it "creates run_test script" do
        run_test_script = all_files.select do |file|
          path = Pathname.new(file)
          path.basename.to_s == "run_test"
        end
        expect(run_test_script.size).to eq(1)
      end
      it "creates a services directory" do 
        services_dir = all_directories.select do |dir|
          path = Pathname.new(dir)
          path.basename.to_s == "services"
        end
        expect(services_dir.size).to eq(1)
      end
    end

    context "inside services directory" do
      it "creates a merchants application" do
        merchants_dir = all_directories.select do |dir|
          path = Pathname.new(dir)
          path.basename.to_s == "merchants"
        end
        expect(merchants_dir.size).to eq(1)
      end      
    end

    context "inside merchants directory" do
      it "creates a gem file" do
        gem_file = all_files.select do |file|
          path = Pathname.new(file)
          path.basename.to_s == "Gemfile"
        end
        expect(gem_file.size).to eq(1)
      end
      it "creates a cap file" do
        cap_file = all_files.select do |file|
          path = Pathname.new(file)
          path.basename.to_s == "Capfile"
        end
        expect(cap_file.size).to eq(1)
      end
      it "creates an app directory" do
        app_dir = all_directories.select do |dir|
          path = Pathname.new(dir)
          path.basename.to_s == "app"
        end
        expect(app_dir.size).to eq(1)
      end
      it "creates a config directory" do
        config_dir = all_directories.select do |dir|
          path = Pathname.new(dir)
          path.basename.to_s == "config"
        end
        expect(config_dir.size).to eq(1)
      end
      it "creates a db directory" do
        db_dir = all_directories.select do |dir|
          path = Pathname.new(dir)
          path.basename.to_s == "db"
        end
        expect(db_dir.size).to eq(1)
      end
      it "creates a spec directory" do
        spec_dir = all_directories.select do |dir|
          path = Pathname.new(dir)
          path.basename.to_s == "spec"
        end
        expect(spec_dir.size).to eq(1)
      end
    end
  end
end 

