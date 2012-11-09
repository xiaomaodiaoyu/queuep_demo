class SessionsController < ApplicationController
  respond_to :json
  before_filter :signed_up_user, only: [:create]
  before_filter :auth_user, only: [:destroy]

# params: email, password 
  def create
    password = params[:password]
    if @user.authenticate(password)
      log_in(@user)
    else
      render_error(401, request.path, 20002, "Wrong combination of email and password.")
    end
  end

# params: access_token
  def destroy
    if @current_user.token.destroy
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

private
  def log_in(user)
    @token = Token.find_by_user_id(user.id)
    if !@token.nil?
      @token.destroy
    end
    @new_token = Token.new
    @new_token.user_id = user.id
    if @new_token.save
      render json: {id: @user.id, access_token: @new_token.access_token}
    else
      render_error(404, request.path, 20002, @new_token.errors.as_json)
    end
  end

  def signed_up_user
    email = params[:email]
    user = User.find_by_email(email.downcase)
    if user
      @user = user
    else
      render_error(401, request.path, 20002, "Email does not exist.")
      return false
    end
  end

end
