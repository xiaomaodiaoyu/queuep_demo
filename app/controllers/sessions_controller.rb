class SessionsController < ApplicationController
  respond_to :json

  def create
    email = params[:email]
    password = params[:password]
    
    if request.format != :json
      render_error(406, request.path, 20000, "The request must be json.")
      return
    end

    if email.nil? or password.nil?
      render_error(400, request.path, 20004, "Both email and password required.")
      return
    end

    @user = User.find_by_email(email.downcase)
    if @user
      if @user.authenticate(password)
        log_in(@user)
      else
        render_error(401, request.path, 20004, "Wrong combination of email and password.")
      end
    else
      render_error(401, request.path, 20006, "User does not exist.")
    end
  end

  def destroy
    log_out
  end

  private

    def generate_token
      access_token = SecureRandom.urlsafe_base64(24)
    end

end
