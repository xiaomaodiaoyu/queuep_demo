class MembershipsController < ApplicationController
  respond_to :json
  before_filter :auth_user
  before_filter :group_admin, except: [:destroy]
  before_filter :referred_user_is_group_member, only: [:authorize_member, :unauthorize_member]
  after_filter  :clear_all_data

# params: access_token, group_id, user_id
# admin's right
  def create
    @user = User.find(params[:user_id])
    if @user.is_member?(@group)
      render_error(404, request.path, 20100, "User is already a member.")
    else
      if @user.join!(@group)
        render json: { result:     1,
                       group_id:   @group.id,
                       group_name: @group.name,
                       user_count: @group.users.count }
      else
        render json: {result: 0}
      end
    end
  end

# params: access_token, group_id, user_id
# admin/self's right
  def destroy
    @group = Group.find(params[:group_id])
    @referred_user = User.find(params[:user_id])
    if @referred_user.is_admin?(@group)
      render_error(404, request.path, 20110, "Admin cannot leave group.") and return
    end
    # self or admin
    if current_user?(@referred_user) || @current_user.is_admin?(@group)
      @referred_user.is_member?(@group)
      if @referred_user.leave!(@group)
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    else
      render_error(404, request.path, 20110, "User is not group member.")
    end
  end

# params: access_token, group_id, user_id
# admin's right
  def authorize_member
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    auth_or_unauth_member("auth", @user, @group)
  end

# params: access_token, group_id, user_id
# admin's right
  def unauthorize_member
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    auth_or_unauth_member("unauth", @user, @group)
  end

private
  def auth_or_unauth_member(auth_or_unauth, user, group)
    @membership = user.memberships.find_by_group_id(group.id)
    if (auth_or_unauth == "auth" && !@membership.auth) ||
       (auth_or_unauth == "unauth" && @membership.auth)
      if @membership.toggle!(:auth)
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    else
      render_error(404, request.path, 20110, "Nothing to update.")
    end
  end

end