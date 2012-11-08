module ApplicationHelper
  
  def render_error(status, request, error_code, error)
    render status: status,
           json: {request: request,
                  error_code: error_code,
                  error: error}
  end

  def auth_user
    @token = Token.find_by_access_token(params[:access_token])
    if @token.nil?
      render_error(404, request.path, 20006, "Auth failed.") 
      @user = nil
    else
      @user = @token.user
    end
  end

  def current_user_is_admin?(group)
    if group
      @current_user = auth_user
      if @current_user
        if is_admin?(group, @current_user.id)
          return true
        else
          render_error(401, request.path, 20100, 
                       "Current user is not admin.")
          return false
        end
      end
    end  
  end


end
