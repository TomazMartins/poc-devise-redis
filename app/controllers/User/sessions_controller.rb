# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token

  before_action :configure_sign_in_params, only: [:create]


  # POST /resource/sign_in
  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in(:user, resource)

      key = SecureRandom.uuid
      session[key] = resource.as_json

      render json: {
        auth_token: key,
        email: resource.email,
        success: true,
      }

      return
    end

    invalid_login_attempt
  end


  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end

  def invalid_login_attempt
    render status: :unauthorized, json: {
      success: false,
      message: "Error with your login or password"
    }
  end
end
