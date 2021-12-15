module Switcher
  module CLI
    class Prompts
      COLOURS = %w(red yellow blue green)
      OPTIONS = %w(y n).freeze
      OUTPUT_MSGS = { load_script_msg: "Creating load script...", deploy_script_msg: "Creating deploy script...", run_test_script_msg: "Creating run_test script..." }
      QUERIES = { create_service: "Would you like to setup an API now? Note: you can do this later with the \'switcher create service\' command", replace_motherdir: "Would you like to replace it?", delete_services: " }
    end
  end
end
