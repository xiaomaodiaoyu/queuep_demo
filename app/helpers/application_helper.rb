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

  def is_admin_creator?(admin_creator, user_id, group)
    if admin_creator == "admin" && group.admin_id == user_id
      return true
    elsif admin_creator == "creator" && group.creator_id == user_id
      return true
    end
    return false
  end

  def is_admin?(user_id, group)
    is_admin_creator?("admin", user_id, group)
  end

  def is_creator?(user_id, group)
    is_admin_creator?("creator", user_id, group)
  end  

  def is_member?(user, group)
    group.users.include?(user)
  end

# do not path auth_user as param, will raise double render erro
  def user_and_group_exist?(user, group)
    if user
      if group
        return true
      end
    end
  end

  def current_user_is_member?(group)
    current_user = auth_user
    if user_and_group_exist?(current_user, group)
      if is_member?(current_user, group)
        return true
      else
        render_error(401, request.path, 20100, 
                     "Current user is not member.")
        return false
      end
    end
  end

  def current_user_is_admin?(group)
    current_user = auth_user
    if user_and_group_exist?(current_user, group)
      if is_admin?(current_user.id, group)
          return true
      else
        render_error(401, request.path, 20100, 
                     "Current user is not admin.")
        return false
      end
    end
  end

end
