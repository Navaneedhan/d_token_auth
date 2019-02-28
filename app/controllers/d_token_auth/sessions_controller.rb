module DTokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController
    def create
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
      @resource = nil
      if field
        q_value = get_case_insensitive_field_from_resource_params(field)

        @resource = find_resource(field, q_value)
      end

      if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        valid_password = @resource.valid_password?(resource_params[:password])
        if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
          if @resource.failed_attempts == DTokenAuth.devise_failed_attempts
            @resource.lock_access!
            @resource.update!(failed_attempts: 0)
            return render_create_error_account_locked
          end
          return render_create_error_bad_credentials
        end
        @client_id, @token = @resource.create_token
        @resource.save

        if DTokenAuth.otp_verfication_enabled
          requested_at = Time.current
          @resource.trigger_otp!(requested_at)
          return render_verify_otp_instructions
        else
          sign_in(:user, @resource, store: false, bypass: false)
        end

        yield @resource if block_given?

        render_create_success
      elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        if @resource.respond_to?(:locked_at) && @resource.locked_at
          render_create_error_account_locked
        else
          render_create_error_not_confirmed
        end
      else
        render_create_error_bad_credentials
      end
    end

    def verify_otp
      return render_verify_otp_not_supported unless DTokenAuth.otp_verfication_enabled
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
      @resource = nil
      if field
        q_value = get_case_insensitive_field_from_resource_params(field)
        @resource = find_resource(field, q_value)
      end

      if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        valid_otp = @resource.verify_otp?(resource_params[:otp_value])
        if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_otp }) || !valid_otp
          @resource.increment!(:failed_otp_attempts)
          if @resource.failed_otp_attempts == DTokenAuth.devise_failed_attempts
            @resource.lock_access!
            @resource.update!(failed_otp_attempts: 0)
            return render_create_error_account_locked
          end
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

    def resend_otp
      return render_verify_otp_not_supported unless DTokenAuth.otp_verfication_enabled
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
      @resource = nil
      if field
        q_value = get_case_insensitive_field_from_resource_params(field)
        @resource = find_resource(field, q_value)
      end

      if @resource.present?
        requested_at = Time.current
        @resource.trigger_otp!(requested_at)
      else
        render_invalid_resource
      end
    end

    protected

    def render_verify_otp_bad_credentials
      render(401, 'Invalid OTP.')
    end

    def render_verify_otp_instructions
      render json: {
        data: {
          otp_string: @resource.otp_string
        }
      }
    end

    def render_verify_otp_not_supported
      render(405, 'This action is not supported by the server')
    end

    def render_invalid_resource
      render(401, 'Invalid email')
    end

    private

    def resource_params
      params.permit(*params_for_resource(:sign_in))
    end
  end
end
