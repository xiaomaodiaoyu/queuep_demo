class SessionsController < ApplicationController
  respond_to :json

  def create
    email = params[:email]
    password = params[:password]
    
    if request.format != :json
      render status: 406, json: {errors: "The request must be json."}
      return
    end

    if email.nil? or password.nil?
      render status: 400, json: {errors: "Both email and password required."}
      return
    end

    @user = User.find_by_email(email.downcase)
    if @user && @user.authenticate(password)
      respond_with(@user)
    else
      logger.info("User #{email} failed signin, user cannot be found.")
      render status: 401, json: {errors: "Incorrect email/password"}
    end
  end

  def destroy
    @user = User.find_by_remember_token(params[:remember_token])
    if @user.nil?
      logger.info("Token not found.")
      render status: 404, json: {message: "Token not found."}
    else
      #@user.reset_authentication_token!
      render status: 200, json: {token: params[:id]}
    end
  end
end
