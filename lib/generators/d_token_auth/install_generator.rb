module DTokenAuth
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :user_class, type: :string, default: 'User'
    argument :mount_path, type: :string, default: 'auth'

    def run_other_generators
      generate "devise:install"
      generate "devise_token_auth:install '#{user_class}' '#{mount_path}'" # initializers for the devise_token_auth

      readme 'DEVISE_README'
    end

    def create_initializer_file
      copy_file('d_token_auth.rb', 'config/initializers/d_token_auth.rb')
    end

    def create_mailers
      copy_file('unlock_instructions.html.erb', 'app/views/devise/mailer/unlock_instructions.html.erb')
    end

    def add_route_mount
      f    = 'config/routes.rb'
      str  = "mount_devise_token_auth_with_otp_verfication '#{user_class}'"
      if File.exist?(File.join(destination_root, f))
        line = parse_file_for_line(f, 'mount_devise_token_auth_with_otp_verfication')

        if line
          existing_user_class = true
        else
          line = 'Rails.application.routes.draw do'
          existing_user_class = false
        end

        if parse_file_for_line(f, str)
          say_status('skipped', "Routes already exist for #{user_class}")
        else
          insert_after_line(f, line, str)

          if existing_user_class
            scoped_routes = ''\
              "as :#{user_class.underscore} do\n"\
              "    # Define routes for #{user_class} within this block.\n"\
              "  end\n"
            insert_after_line(f, str, scoped_routes)
          end
        end
      else
        say_status('skipped', "config/routes.rb not found. Add \"mount_devise_token_auth_with_otp_verfication '#{user_class}'\" to your routes file.")
      end
    end

    private

    def parse_file_for_line(filename, str)
      match = false

      File.open(File.join(destination_root, filename)) do |f|
        f.each_line do |line|
          match = line if line =~ /(#{Regexp.escape(str)})/mi
        end
      end
      match
    end

    def insert_after_line(filename, line, str)
      gsub_file filename, /(#{Regexp.escape(line)})/mi do |match|
        "#{match}\n  #{str}"
      end
    end
  end
end