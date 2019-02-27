module DTokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController
    def create
      puts "i am in sessions controller of new gem"
      p resource_params
      p resource_class
      p resource_params.authentication_keys
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
      puts field
    end

    # private
    #   def resource_params
    #     params.permit(*params_for_resource(:sign_in))
    #   end
  end
end
  