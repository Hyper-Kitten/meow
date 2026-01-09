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
            redirect_to admin_login_path and return if User.any?

            @user = User.new
            render Views::Admin::FirstUsers::New.new(user: @user)
          end

          def create
            redirect_to admin_login_path and return if User.any?

            @user = User.new(user_params)
            if @user.save
              flash[:success] = "User successfully created. Please log in."
              redirect_to admin_login_path
            else
              flash[:error] = "There was a problem saving the user."
              render Views::Admin::FirstUsers::New.new(user: @user), status: :unprocessable_entity
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
