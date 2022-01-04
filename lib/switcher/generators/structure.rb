module Switcher
  module Generators
    module Structure
      def init_gemfile
        run('bundle init')
        if gemfile_created?
          insert_into_file "Gemfile", default_gems
          insert_into_file "Gemfile", test_block_gems
          insert_into_file "Gemfile", development_block_gems
          install_gems
        end
      end
      
      def install_gems
        run('git init')
        run('bundle install')
        init_rspec
        init_capistrano
      end

      def init_rspec
        run('rspec --init')
      end

      def init_capistrano
        run('bundle exec cap install')
      end

      def define_app_dir_structure
        mk_app_dir
        if app_dir_exists?
          inside("app") do
            mk_app_rb_file
            mk_models_dir
            mk_controllers_dir
          end
        end
      end

      def define_db_dir_structure
        mk_db_dir
      end

      def add_config_files
        if config_dir_exists?
          inside("config") do
            mk_router_rb_file
            mk_db_file
          end
        end
      end
    
      def mk_service_spec(service_name)
        if spec_dir_exists?
          inside("spec") do
            FileUtils.touch("#{service_name}_spec.rb")        
          end
        end
      end

      protected
      def mk_app_dir
        FileUtils.mkdir("app")
      end

      def mk_app_rb_file
        FileUtils.touch("app.rb")
      end

      def mk_models_dir
        FileUtils.mkdir("models")
      end

      def mk_controllers_dir
        FileUtils.mkdir("controllers")
      end

      def mk_db_dir
        FileUtils.mkdir("db")
      end

      def mk_router_rb_file
        FileUtils.touch("router.rb")        
      end

      def mk_db_file
        FileUtils.touch("db.yml")
      end

      def gemfile_created?
        File.file?(File.expand_path("Gemfile", destination_root))
      end

      def app_dir_exists?
        File.exists?(File.expand_path("app", destination_root))
      end

      def db_dir_exists?
        File.exists?(File.expand_path("db", destination_root))
      end

      def config_dir_exists?
        File.exists?(File.expand_path("config", destination_root)) 
      end

      def spec_dir_exists?
        File.exists?(File.expand_path("spec", destination_root))
      end

      def default_gems
        "gem \'switcher\'\n" "gem \'pg\'" ", " "\'>= 0.18\'" ", " "\'< 2.0\'\n" "gem \'puma\'" ", " "\'~> 4.1\'\n\n"
      end

      def test_block_gems
        "group :test do\n" "  gem \'rspec\'\n" "  gem \'rack-test\'\n" "  gem \'rouge\'\n" "end"
      end

      def development_block_gems
        "\n\n" "group :development do\n" "  gem \'capistrano\'" ", " "\'~> 3.16\'" ", " "require: false\n" "  gem \'capistrano-bundler\'" ", " "require: false\n" "  gem \'capistrano3-puma\'" ", " "require: false\n" "  gem \'capistrano-rbenv\'" ", " "github: \'capistrano/rbenv\'" ", " "require: false\n" "end" 
      end
    end
  end
end
