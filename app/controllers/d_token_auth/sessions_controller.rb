module DTokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController
    def create
      super do
        puts "i am in sessions controller of new gem"
      end
    end

    # private
    #   def resource_params
    #     params.permit(*params_for_resource(:sign_in))
    #   end
  end
end
  

# def verify_otp
#   # Check
#   field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

#   @resource = nil
#   if field
#     q_value = get_case_insensitive_field_from_resource_params(field)

#     @resource = find_resource(field, q_value)
#   end

#   if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
#     valid_otp = @resource.valid_otp?(resource_params[:otp_value])
#     if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_otp }) || !valid_otp
#       return render_create_error_bad_credentials
#     end
#     @client_id, @token = @resource.create_token
#     @resource.save

#     sign_in(:user, @resource, store: false, bypass: false)

#     yield @resource if block_given?

#     render_create_success
#   elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
#     if @resource.respond_to?(:locked_at) && @resource.locked_at
#       render_create_error_account_locked
#     else
#       render_create_error_not_confirmed
#     end
#   else
#     render_create_error_bad_credentials
#   end
# end