# module ActionDispatch::Routing
#   class Mapper
#     def mount_devise_token_auth_with_otp_verfication(resource)
#       mapping_name = resource.underscore.gsub('/', '_')
#       devise_scope mapping_name.to_sym do
#         post 'auth/verify_otp', controller: 'd_token_auth/sessions', action: 'verify_otp'
#         post 'auth/resend_otp', controller: 'd_token_auth/sessions', action: 'resend_otp'
#       end
#     end

#   end
# end