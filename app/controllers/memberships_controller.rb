class MembershipsController < ApplicationController
  respond_to :json

# params: access_token, group_id, user_id
# admin's right
  def create
    group_id = params[:group_id]
    @group = Group.find(group_id)
    if current_user_is_admin?(@group)
      user_id = params[:user_id]
      @user = User.find(user_id)
      if @user
        if is_member?(@group, @user)
          render_error(404, request.path, 20100, "User is already a member.")
        else
          @membership = Membership.new(user_id: @user.id, group_id: @group.id)
          if @membership.save
            render json: { group_name: @group.name,
                           user_count: @group.users.count }
          else
            render_error(404, request.path, 20109, @membership.errors.as_json)
          end
        end
      end
    end
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


# params: access_token, group_id, user_id
# admin's right
  def authorize_member
    @membership = correct_member
    if @membership
      if !@membership.auth?
        if @membership.toggle!(:auth)
          render json: {result: 1}
        else
          render json: {result: 0}
        end
      else
        render_error(404, request.path, 20112, "Already authorized.")
      end
    end
  end    

# params: access_token, group_id, user_id
# admin's right
  def unauthorize_member
    @membership = correct_member
    if @membership
      if @membership.auth?
        if @membership.toggle!(:auth)
          render json: {result: 1}
        else
          render json: {result: 0}
        end
      else
        render_error(404, request.path, 20112, "Already unauthorized.")
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


end
