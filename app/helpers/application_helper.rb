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

  def auth_user?(user)
    user == auth_user
  end

  def current_user
    current_user = auth_user
  end

  def current_user?(user)
    if current_user && current_user == user
      return true
    else
      return false
    end
  end

  def current_user_is_admin
    @group = Group.find(params[:group_id])
    if @group
      if current_user 
        if current_user?(User.find(@group.admin_id))
          return true
        else
          render_error(404, request.path, 20006, 
                       "Current user is not the group's admin.")
          return false
        end
      end
    else
      render_error(404, request.path, 20006, "Group does not exist.")
      return false
    end
  end

  def current_user_is_member
    @group = Group.find(params[:group_id])
    if @group
      if current_user 
        if @group.users.include?(current_user)
          return true
        else
          render_error(404, request.path, 20006, 
                       "Current user is not the group's member.")
          return false
        end
      end
    else
      render_error(404, request.path, 20006, "Group does not exist.")
      return false
    end
  end

end
