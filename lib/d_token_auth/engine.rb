require 'd_token_auth/rails/routes'
module DTokenAuth
  class Engine < ::Rails::Engine
    isolate_namespace DTokenAuth
  end
  self.otp_verfication_enabled = false
end
