class Api::V1::ProductController < Api::V1::BaseController
  before_filter :authenticate_request!, :except => [:index]


  def index
    @products = Product.all
    success_response 200, "All products pulled.", products: @products
  end

  def create
    base_64_image = params[:image]
    blob = Base64.decode64(base_64_image)
    decoded_image = MiniMagick::Image.read(blob)
    image_file = File.open(decoded_image.path)
    @product = Product.new(product_params.merge(:image=> image_file))
    if @product.save
      @product.image_url = @product.image.url
      @product.save
      current_user.store.products.push(@product)
      current_user.save
      success_response 201, "Product created successfully", product: @product
    else
      error_response 422, "Product could not be created", @product.errors.full_messages
    end
  end

  private

  def product_params
    params.permit(:name, :description, :price, :image)
  end

end

# "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTgxMzI5NTcxYmQyNjcwNjYyMDAwMDAwIn0._lt6fERQdl0k0R9OJrosYZH4GGQdDLjDjmC4g_Yp1P8"