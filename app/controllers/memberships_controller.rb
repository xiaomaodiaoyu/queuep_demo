class MembershipsController < ApplicationController
  respond_to :json

  def create
    if current_user_is_admin
      user_id = params[:user_id]
      group_id = params[:group_id]
      @user = User.find(user_id)
      @group = Group.find(group_id)
      if @user
        if is_member?(@group, @user)
          render_error(404, request.path, 20100, 
                      "User is already a member.") and return
        else
          @membership = Membership.new(user_id: user_id, 
                                       group_id: group_id)
          if @membership.save
            render json: { group_name: @group.name,
                           user_count: @group.users.count }
          else
            render_error(404, request.path, 20100, 
                         @membership.errors.full_messages) and return
          end
        end
      end
    end
  end
  
  def destroy
    if current_user_is_member
      user_id = params[:user_id].to_i
      group_id = params[:group_id]
      @user = User.find(user_id)
      @group = Group.find(group_id)
      if @user && @group
        if is_member?(@group, @user)
          if user_id == @group.admin_id
            render_error(404, request.path, 20006, "Admin could not leave the group.") and return
          elsif delete_by_admin_or_self(@group, user_id)      
            @membership = Membership.find_by_user_id_and_group_id(user_id, group_id)
            if @membership.destroy
              render json: {result: 1} and return
            else
              render json: {result: 0} and return
            end
          else
            render_error(404, request.path, 20006, "Failed to leave the group.")
          end
        else
          render_error(404, request.path, 20006, "User is not group member.")
        end
      end
    end
  end

private
  def delete_by_admin_or_self(group, user_id)
    @token = Token.find_by_access_token(params[:access_token])
    current_user_id = @token.user_id
    if @token && current_user_id == user_id
      return true
    elsif current_user_id == group.admin_id
      return true
    else
      return false
    end
  end

end
