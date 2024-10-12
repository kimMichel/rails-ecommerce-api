class CartsController < ApplicationController
    before_action :require_login

    def show
        @cart_items = current_user.cart_items.includes(:book)
        render json: @cart_items.to_json(include: :book)
    end

    def add_to_cart
        if book = Book.find_by(id: params[:book_id], is_active: true)
            cart_item = current_user.cart_items.find_or_initialize_by(book: book)

            if cart_item.new_record?
                cart_item.quantity = params[:quantity] || 1
            else
                cart_item.quantity += params[:quantity] || 1
            end

            if cart_item.save
                render json: { message: "Book added to cart successfully" }, status: :ok
            else
                render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { error: "Book not found." }, status: :not_found
        end
    end

    def remove_from_cart
        cart_item = current_user.cart_items.find_by(book_id: params[:book_id])

        if cart_item&.destroy
            render json: { message: "Book removed from cart successfully" }, status: :ok
        else
            render json: { error: "Book not found in cart" }, status: :not_found
        end
    end
end
