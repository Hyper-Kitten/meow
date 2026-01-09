module HyperKittenMeow
  module Concerns
    module Controllers
      module Admin
        module AdminController
          extend ActiveSupport::Concern
          include Pagy::Method

          included do
            # Prevent CSRF attacks by raising an exception.
            # For APIs, you may want to use :null_session instead.
            protect_from_forgery with: :exception

            before_action :authorize
            helper_method :current_user, :logged_in?
          end

          def authorize
            raise ActionController::RoutingError.new("Not Found") unless logged_in?
          end

          def current_user
            if (user_id = session[:user_id])
              @current_user ||= User.find_by(id: user_id)
            elsif (user_id = cookies.signed[:user_id])
              user = User.find_by(id: user_id)
              if user && user.authenticated?(cookies[:remember_token])
                session[:user_id] = user.id
                @current_user = user
              end
            end
          end

          def logged_in?
            current_user.present?
          end
        end
      end
    end
  end
end
