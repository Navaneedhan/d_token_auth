module DTokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController
    def create
      p "i am in the begin"
      super do |resource|
        if DTokenAuth.otp_verfication_enabled
          resource.decrement!(:sign_in_count)
          sign_out :user
          requested_at = Time.now
          resource.trigger_otp!(requested_at)
          return render_verify_otp_instructions
        end
      end
      p "current user"
      p current_user
      p "resource"
      p resource
      if resource == current_user # the resource is logged in
        p "decrementing"
        resource.decrement!(:sign_in_count)
        sign_out :user
      else
        # do the lock strategy
      end
      p "i am in the end"
    end

    def verify_otp
      return unless DTokenAuth.otp_verfication_enabled

      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
      @resource = nil
      if field
        q_value = get_case_insensitive_field_from_resource_params(field)
        @resource = find_resource(field, q_value)
      end

      if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_otp }) || !valid_otp
          return render_verify_otp_bad_credentials
        end
        sign_in(:user, @resource, store: false, bypass: false)

        yield @resource if block_given?

        render render_create_success
      elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        if @resource.respond_to?(:locked_at) && @resource.locked_at
          render_create_error_account_locked
        else
          render_create_error_not_confirmed
        end
      else
        render_verify_otp_bad_credentials
      end
    end

    private

    def resource_params
      params.permit(*params_for_resource(:sign_in))
    end

    def render_verify_otp_bad_credentials

    end

    def render_verify_otp_instructions

    end
  end
end
