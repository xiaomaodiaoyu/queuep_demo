module ApplicationHelper
  
  def render_error(status, request, error_code, error)
    render status: status,
           json: {request: request,
                  error_code: error_code,
                  error: error}
    return
  end

  def auth_user
    @token = Token.find_by_access_token(params[:access_token])
    if !@token.nil?
      @user = @token.user
    end
  end

  def auth_user?(user)
    user == auth_user
  end
end
