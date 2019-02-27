require 'devise_token_auth'
require 'd_token_auth/rails/routes'
module DTokenAuth
  class Engine < ::Rails::Engine
    isolate_namespace DTokenAuth
  end
end
