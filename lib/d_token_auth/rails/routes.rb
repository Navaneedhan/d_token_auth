module ActionDispatch::Routing
  class Mapper (resource)
    def mount_devise_token_auth_with_otp_verfication
      @scope = ActionDispatch::Routing::Mapper::Scope.new(
            path:         '',
            shallow_path: '',
            constraints:  {},
            defaults:     {},
            options:      {},
            parent:       nil
          )
      mapping_name = resource.underscore.gsub('/', '_')
      devise_scope mapping_name.to_sym do
        post 'auth/verify_otp', controller: 'd_token_auth/sessions', action: 'verify_otp'
      end
    end

  end
end