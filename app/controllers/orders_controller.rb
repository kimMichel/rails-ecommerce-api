class OrdersController < ApplicationController
    before_action :require_login

    def create
        selected_cart_item_ids = params[:cart_item_ids] || []

        cart_items = if selected_cart_item_ids.empty?
            current_user.cart_items
        else
            current_user.cart_items.where(id: selected_cart_item_ids)
        end

        if cart_items.empty?
            render json: { error: "No items selected for the order" }, status: :unprocessable_entity
            return
        end

        total = cart_items.sum { |item| item.book.price * item.quantity }
        order = current_user.orders.new(status: "pending", total: total)

        cart_items.each do |cart_item|
            order.order_items.build(book: cart_item.book, quantity: cart_item.quantity)
        end

        if order.save
            cart_items.destroy_all
            render json: { message: "Order created successfully", order: order }, status: :ok
        else
            render json: { error: order.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        order = current_user.orders.find(params[:id])

        render json: order.to_json(include: { order_items: { include: :book } })
    end

    def destroy
        order = current_user.orders.find(params[:id])

        if order.status === "cancelled"
            render json: { message: "This order is already cancelled" }, status: :ok
            return
        end

        if order.update(status: "cancelled")
            render json: { message: "Order cancelled successfully" }, status: :ok
        else
            render json: { error: "Failed to cancelled the order" }, status: :unprocessable_entity
        end
    end
end
