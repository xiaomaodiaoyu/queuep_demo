module GroupsHelper
  def is_admin?
    is_admin_or_creator?("admin")
  end

  def is_creator?
    is_admin_or_creator?("creator")
  end

private
  def is_admin_or_creator?(admin_or_creator)
    user_id = params[:user_id].to_i
    @group = Group.find(params[:id])
    if @group
      if admin_or_creator == "admin" && @group.admin_id == user_id
        render json: {result: 1}
      elsif admin_or_creator == "creator" && @group.creator_id == user_id
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    else
      render_error(404, request.path, 20103, "Group does not exist.")
    end    
  end
end
