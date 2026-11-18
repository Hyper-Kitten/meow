module HyperKittenMeow
  module Admin
    class SessionsController < AdminController
      skip_before_action :authorize, only: [:new, :create]

      def new
        redirect_to admin_root_path and return if logged_in?
        redirect_to new_admin_first_user_path and return unless User.any?
        render Views::Admin::Sessions::New.new
      end

      def create
        permitted = params.require(:session).permit([:email, :password])
        user = User.find_by(email: permitted[:email].downcase)
        if user && user.authenticate(permitted[:password])
          # Log the user in and redirect to the user's show page.

          user.set_encrypted_remember_token!
          session[:user_id] = user.id
          cookies.permanent.signed[:user_id] = user.id
          cookies.permanent[:remember_token] = user.remember_token
          redirect_to return_to_path || admin_root_path
        else
          flash.now[:error] = t("sessions.failed_login")
          render Views::Admin::Sessions::New.new, status: :unprocessable_entity
        end
      end

      def destroy
        session.delete(:user_id)
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
        redirect_to admin_login_path
      end

      private

      # Only paths on this site, so the login form can't be used to send people elsewhere.
      def return_to_path
        path = session.delete(:return_to).to_s
        path if path.start_with?("/") && !path.start_with?("//")
      end
    end
  end
end
