class Api::V1::AuthenticationController < Api::V1::BaseController
  
  def authenticate_user
    user = User.find_for_database_authentication(email: params[:email])
    if user and user.valid_password?(params[:password])
      success_response 200, "Login Success", json: payload(user)
    else
      error_response 401, "Login Failed", 'Invalid Username/Password'
    end
  end

  def register_user
    user = User.new(registration_params)
    if user.save
      binding.pry
      user.store = Store.create
      success_response 201, "User registered successfully", json: payload(user)
    else
      error_response 422, "Registration failed.", user.errors.full_messages
    end
  end

  private

  def registration_params
    params.permit(:email, :password)
  end

end