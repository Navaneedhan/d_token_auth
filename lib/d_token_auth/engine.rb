require 'd_token_auth/rails/routes'
module DTokenAuth
  class Engine < ::Rails::Engine
    isolate_namespace DTokenAuth
  end
  mattr_accessor :otp_verfication_enabled
  self.otp_verfication_enabled = false
  def self.setup(&block)
    yield self
  end
end
