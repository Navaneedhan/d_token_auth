module DTokenAuth
  class AccountsController < Devise::UnlocksController
    def show
      super do |resource|
        if resource.errors.empty?
          return render_unlocked
        else
          return render_errors(resource.errors)
        end
      end
    end

    protected

    def render_unlocked
      render(200, 'Unlocked')
    end

    def render_errors(errors)
      render json: {
        errors: errors
      }, status: :unprocessable_entity
    end
  end
end
  