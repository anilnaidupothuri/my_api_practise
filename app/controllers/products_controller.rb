class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    before_action :check_login, only: [:create, :update, :destroy]
	def show 
		options = {include: [:user]}
		render json: ProductSerializer.new(@product , options).serializable_hash
	end 

	def index 
		@products = Product.page(params[:page].per(params[:per_page].search(params)
		render json: ProductSerializer.new(@products).serializable_hash
	end 

	def create 
		product= current_user.products.create(product_params)
		if product.save
		   render json:product, status: :created 
		else
		   render json: product.errors 
		end

    end  

    def update 
    	if @product.update(product_params)
            render json:@product 
        else 
        	render json:@product.errors 
        end 
    end 

    def destroy 
    	@product.destroy 
    	head :no_content
    end


	private 

	def set_product 
		@product = Product.find(params[:id])
	end

	def product_params 
		params.require(:product).permit(:title, :published, :price)
	end
end
