class GroupsController < ApplicationController
  respond_to :json
  before_filter :auth_user
  before_filter :group_member, only: [:show]
  before_filter :group_admin,  only: [:update, :destroy, :transfer_admin]
  before_filter :referred_user_is_group_member, only: [:transfer_admin]
  after_filter  :clear_all_data

# params: access_token, name
# auth user's right 
  def create
    name = params[:name]
    @group = Group.new(name: name)
    @group.creator_id = @current_user.id
    if @group.save
      @current_user.creator_join!(@group)
      respond_with(@group, only: [:id, :name, :creator_id, :admin_id])
    else
      render_error(404, request.path, 20101, @group.errors.as_json)
    end
  end

# params: access_token, group_id
# member's right
  def show
    respond_with(@group, only: [:id, :name, :admin_id, :creator_id])
  end

# params: access_token, group_id, group[variable]
# admin's right
  def update
    if @group.update_attributes(params[:group])
      respond_with(@group, only: [:id, :name, :creator_id, :admin_id])
    else
      render_error(404, request.path, 20103, "Failed to update group info")
    end
  end

# params: access_token, group_id
# admin's right
  def destroy
    if @group.destroy
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

# params: access_token, group_id, user_id
# auth user's right
  def is_admin
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    if @user.is_admin?(@group)
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

# params: access_token, group_id, user_id
# auth user's right
  def is_creator
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    if @user.is_creator?(@group)
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

# params: access_token, group_id, user_id
# auth user's right
  def is_member
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    if @user.is_member?(@group)
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

# params: access_token, group_id
# auth user's right
  def count
    @group = Group.find(params[:group_id])   
    render json: {group_id: @group.id,
                  user_count: @group.users.count}
  end

# params: access_token, group_id, user_id
# admin's right
  def transfer_admin
    if current_user?(@referred_user)
      render_error(404, request.path, 20111, "Cannot transfer admin to yourself.")
    else
      change_admin(@current_user, @referred_user, @group)
      respond_with(@group, only: [:id, :name, :admin_id, :creator_id])
    end
  end

private
  def change_admin(old_admin, new_admin, group)
    group.admin_id = new_admin.id
    @old_membership = Membership.find_by_user_id_and_group_id(old_admin.id, group.id)
    @old_membership.toggle!(:admin)
    @new_membership = Membership.find_by_user_id_and_group_id(new_admin.id, group.id)
    @new_membership.toggle!(:admin)
    @new_membership.toggle!(:auth) unless @new_membership.auth
  end

end
