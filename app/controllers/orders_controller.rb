class OrdersController < ApplicationController
  before_action :check_login, only: [:index, :show, :create]
	def index 
		@orders = current_user.orders 
		render json: OrderSerializer.new(@orders).serializable_hash
	end 

	def show 
		order = current_user.orders.find(params[:id])
		if order
		    options = { include: [:products]} 
	     	render json: OrderSerializer.new(@order).serializable_hash
	    else 
	    	head 404
	    end
         
	end 

	def create
	  order = current_user.orders.create(order_prams) 
	  if order.save 
	  	render json: order 
	  else 
	  	render json: order.errors
	  end 
	end 

	private 
	def order_prams 
		params.require(:order).permit(:total, product_ids: [])
	end
end
