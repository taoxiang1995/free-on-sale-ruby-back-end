class Api::V1::ProductController < Api::V1::BaseController
  before_filter :authenticate_request!


  def index
    @products = Product.all
    success_response 200, "All products pulled.", products: @products
  end

  def create
    binding.pry
    @product = Product.new(product_params)
    if @product.save
      current_user.store.products.push(@product)
      current_user.save
      success_response 201, "Product created successfully", product: @product
    else
      error_response 422, "Product could not be created", @product.errors.full_messages
    end
  end

  private

  def product_params
    params.permit(:name, :description, :price)
  end

end

# "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTgxMzI5NTcxYmQyNjcwNjYyMDAwMDAwIn0._lt6fERQdl0k0R9OJrosYZH4GGQdDLjDjmC4g_Yp1P8"