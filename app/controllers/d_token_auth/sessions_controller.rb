module DTokenAuth
  class SessionsController < DeviseTokenAuth::ApplicationController
    def create
      puts "i am in sessions controller of new gem"
    end
  end
end
  