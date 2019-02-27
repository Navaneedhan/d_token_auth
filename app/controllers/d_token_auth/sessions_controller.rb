module DTokenAuth
  class SessionsController < DeviseTokenAuth::ApplicationController
    def create
      puts "i am in sessions controller of new gem"
      render_create_error_bad_credentials
    end
  end
end
  