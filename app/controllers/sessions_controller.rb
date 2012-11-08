class SessionsController < ApplicationController
  respond_to :json

# params: email, password 
  def create
    email = params[:email]
    password = params[:password]
    @user = User.find_by_email(email.downcase)
    if @user
      if @user.authenticate(password)
        log_in(@user)
      else
        render_error(401, request.path, 20002, "Wrong combination of email and password.")
      end
    else
      render_error(401, request.path, 20002, "User does not exist.")
    end
  end

# params: access_token
  def destroy
    log_out
  end

private
  def generate_token
    access_token = SecureRandom.urlsafe_base64(24)
  end

  def log_in(user)
    @token = Token.find_by_user_id(user.id)
    if !@token.nil?
      @token.destroy
    end
    @new_token = Token.new(user_id: user.id)
    if @new_token.save
      render json: {id: @user.id, access_token: @new_token.access_token}
    else
      render_error(404, request.path, 20002, @new_token.errors.as_json)
    end
  end

  def log_out
    @token = Token.find_by_access_token(params[:access_token])
    if @token
      if @token.destroy
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    else
      render_error(404, request.path, 20003, "Unauthorized")
    end
  end

end
