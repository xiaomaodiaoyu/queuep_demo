module SessionsHelper

  def log_in(user)
  # cookies[:remember_token] = { value:   user.remember_token,
      #                              expires: 20.years.from_now.utc }
  	#cookies.permanent[:remember_token] = user.remember_token
   	
    @token = Token.find_by_user_id(user.id)
    if !@token.nil?
      @token.destroy
    end
    @new_token = Token.new(user_id: user.id)
    if @new_token.save
      render json: {id: @user.id, access_token: @new_token.access_token}
    else
      render_error(404, request.path, 20006, @new_token.errors.as_json)
    end
  end

  def log_out
    @user = User.find(params[:user_id])
    @token = Token.find_by_access_token(params[:access_token])
    if !@user.nil? && !@token.nil? && (@user == @token.user)
      @token.destroy
      self.current_user = nil
      render json: {request: request.path, message: "You have successfully logged out."}
    else
      render_error(404, request.path, 20006, "Unauthorized")
    end
  end


  def authenticate(user, password)
    user.authenticate(password)
  end

  
end
