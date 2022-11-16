module HyperKittenMeow
  module Concerns
    module Controllers
      module Admin
        module FirstUsersController
          extend ActiveSupport::Concern
          included do
            skip_before_action :authorize
          end

          def new
            redirect_to admin_login_path if User.any?

            @user = User.new
          end

          def create
            redirect_to admin_login_path if User.any?

            @user = User.new(user_params)
            if @user.save
              flash[:success] = "User successfully created. Please log in."
              redirect_to admin_login_path
            else
              flash[:error] = "There was a problem saving the user."
              render :new
            end
          end
          private

          def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
          end
        end
      end
    end
  end
end
