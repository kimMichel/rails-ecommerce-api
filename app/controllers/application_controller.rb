class ApplicationController < ActionController::API
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
        !!current_user
    end

    def admin?
        current_user && current_user.is_admin
    end

    def require_login
        unless logged_in?
            render json: { error: "You must be logged in to access this section" }, status: :unauthorized
        end
    end

    def require_admin
        unless admin?
            render json: { error: "You must be an admin to access this section" }, status: :forbidden
        end
    end
end
