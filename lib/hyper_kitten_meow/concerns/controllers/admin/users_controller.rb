module HyperKittenMeow
  module Concerns
    module Controllers
      module Admin
        module UsersController
          extend ActiveSupport::Concern

          def index
            @pagy, @users = pagy(User.all)
            render Views::Admin::Users::Index.new(users: @users, pagy: @pagy)
          end

          def new
            @user = User.new
            render Views::Admin::Users::New.new(user: @user)
          end

          def create
            @user = User.new(user_params)
            if @user.save
              flash[:success] = "User successfully created."
              redirect_to admin_users_path
            else
              flash[:error] = "There was a problem saving the user."
              render Views::Admin::Users::New.new(user: @user), status: :unprocessable_entity
            end
          end

          def edit
            find_user
            render Views::Admin::Users::Edit.new(user: @user)
          end

          def update
            find_user
            if @user.update(user_params)
              flash[:success] = "User was successfully updated."
              redirect_to admin_users_path
            else
              flash[:error] = "There was a problem saving the user."
              render Views::Admin::Users::Edit.new(user: @user), status: :unprocessable_entity
            end
          end

          def destroy
            find_user
            if @user.destroy
              redirect_to admin_users_path,
                notice: 'User was successfully destroyed.'
            else
              redirect_to admin_users_path
            end
          end

          private

          def find_user
            @user = User.find(params[:id])
          end

          def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
          end
        end
      end
    end
  end
end
