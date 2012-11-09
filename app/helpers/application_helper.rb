module ApplicationHelper
  def render_error(status, request, error_code, error)
    render status: status,
           json: {request: request,
                  error_code: error_code,
                  error: error}
  end  

  def auth_user
    @token = Token.find_by_access_token(params[:access_token])
    if !@token.nil?
      @current_user = @token.user
    else
      render_error(404, request.path, 20006, "Auth failed.")
      return false
    end
  end

  def current_user?(user)
    @current_user == user
  end

  def clear_all_data
    @current_user = nil
    @group = nil
    @referred_user = nil
  end

  def group_admin
    group = Group.find(params[:group_id])
    if @current_user.is_admin?(group)
      @group = group
    else
      render_error(404, request.path, 20006, "Not group admin.")
      return false
    end
  end  

  def group_member
    group = Group.find(params[:group_id])
    if @current_user.is_member?(group)
      @group = group
    else
      render_error(404, request.path, 20006, "Not group member.")
      return false
    end
  end

  def referred_user_is_group_member
    referred_user = User.find(params[:user_id])
    if referred_user.is_member?(@group)
      @referred_user = referred_user
      return true
    else
      render_error(404, request.path, 20006, "Referred user is not group member.")
      return false
    end
  end

  def authorized_member
    @membership = @current_user.memberships.find_by_group_id(@group.id)
    if @membership.auth?
      return true
    else
      render_error(404, request.path, 20006, "Not authorized.")
      return false
    end  
  end

end
