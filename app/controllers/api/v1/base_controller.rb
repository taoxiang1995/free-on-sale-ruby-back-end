class Api::V1::BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :add_allow_credentials_headers
  protect_from_forgery with: :null_session
  attr_reader :current_user

  def add_allow_credentials_headers
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'                                                                                                                                                                                                     
    response.headers['Access-Control-Allow-Credentials'] = 'true'                                                                                                                                                                                                                          
  end 

  def options                                                                                                                                                                                                                                                                              
    head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'                                                                                                                                                                                                         
  end

  protected
  def authenticate_request!
    binding.pry
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  private
  def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  # jwt token encryption
  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email}
    }
  end

  # error and success response
  def success_response code, meta, data
    render  status: code,
            json: {
              meta: meta,
              data: data
            }
  end

  def error_response code, meta, errors
    render  status: code,
            json: {
              meta: meta,
              errors: errors
            }
  end

end
