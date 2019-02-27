require 'devise_token_auth'
module DTokenAuth
  class Engine < ::Rails::Engine
    isolate_namespace DTokenAuth
  end
end
