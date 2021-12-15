module Switcher
  module CLI
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

      protected
      def mk_app_dir
        FileUtils.mkdir("app")
      end

      def mk_db_dir
        FileUtils.mkdir("db")
      end

      def gemfile_created?
        File.file?(File.expand_path("Gemfile", destination_root))
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
