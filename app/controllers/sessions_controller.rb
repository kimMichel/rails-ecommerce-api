class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            render json: {
               message: "Logged in successfully",
                isAdmin: user.is_admin,
                user: {
                    first_name: user.first_name,
                    last_name: user.last_name
                },
                cart_items: user.cart_items
                }, status: :ok
        else
            render json: { message: "Invalid email or password" }, status: :unauthorized
        end
    end

    def destroy
        session[:user_id] = nil
        render json: { message: "Logged out successfully" }, status: :ok
    end

    def check
        if session[:user_id]
            user = User.find(session[:user_id])
          render json: {
           loggedIn: true,
            user: {
                first_name: user.first_name,
                last_name: user.last_name,
                is_admin: user.is_admin
            },
            cart_items: user.cart_items
           }, status: :ok
        else
          render json: { loggedIn: false }, status: :unauthorized
        end
      end
end
