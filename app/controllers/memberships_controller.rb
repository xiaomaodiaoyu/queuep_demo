class MembershipsController < ApplicationController
  respond_to :json

# params: access_token, group_id, user_id
# admin's right
  def create
    @group = Group.find(params[:group_id])
    if current_user_is_admin?(@group)
      @user = User.find(params[:user_id])
      if !is_member?(@user, @group)
        @user.join!(@group)
        render json: { group_name: @group.name,
                       user_count: @group.users.count }
      else
        render_error(404, request.path, 20100, "User is already a member.")
      end
    end
  end

# params: access_token, group_id, user_id
# admin's right
  def authorize_member
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    auth_or_unauth_member("auth", @group, @user)
  end

# params: access_token, group_id, user_id
# admin's right
  def unauthorize_member
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    auth_or_unauth_member("unauth", @group, @user)
  end 


# params: access_token, group_id, user_id
# admin/self's right

  def destroy
    @current_user = auth_user
    if @current_user
      group_id = params[:group_id].to_i
      @group = Group.find(group_id)      
      if @group
        user_id = params[:user_id].to_i
        @user = User.find(user_id)
        if @user
          if is_member?(@group, @user)
            admin_id = @group.admin_id
            if admin_id == user_id
              render_error(404, request.path, 20110, "Admin cannot leave group.")
            else
              current_user_id = @current_user.id
              # self || admin
              if current_user_id == user_id || current_user_id == admin_id 
                @membership = Membership.find_by_user_id_and_group_id(user_id, group_id)
                if @membership.destroy
                  render json: {result: 1}
                else
                  render json: {result: 0}
                end
              else
                render_error(401, request.path, 20110, "User is not self/admin.")
              end
            end
          else
            render_error(401, request.path, 20110, "User is not group member.")
          end
        end
      end
    end
  end









private
  def correct_member
    @group = Group.find(params[:group_id])
    if current_user_is_admin?(@group)
      @user = User.find(params[:user_id])
      if @user
        if is_member?(@group, @user)
          @membership = Membership.find_by_user_id_and_group_id(params[:user_id], params[:group_id])
        else
          render_error(404, request.path, 20112, "User is not group member.")
          return false
        end
      end
    end
  end

  def auth_or_unauth_member(auth_or_unauth, group, user)
    if current_user_is_admin?(group)
      if user_and_group_exist?(user, group)
        if is_member?(user, group)
          @membership = Membership.find_by_user_id_and_group_id(user.id, group.id)
          if (auth_or_unauth == "auth" && !@membership.auth?) ||
             (auth_or_unauth == "unauth" && @membership.auth?)  
            @membership.toggle!(:auth)
            render json: {result: 1}
          else
            render_error(404, request.path, 20112, "Nothing needs to update.")
          end
        else
          render_error(404, request.path, 20112, "User is not group member.")
        end
      end
    end
  end


end
