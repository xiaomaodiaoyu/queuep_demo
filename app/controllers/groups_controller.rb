class GroupsController < ApplicationController
  respond_to :json
  before_filter :auth_user, only: [:is_admin, :is_creator, :is_member, :count]

# params: access_token, name
# auth user's right 
  def create
    name = params[:name]
    current_user = auth_user
    if current_user
      @group = Group.new(name: name, creator_id: current_user.id)
      if @group.save
        current_user.creator_join!(@group)
        respond_with(@group, only: [:id, :name, :creator_id, :admin_id])
      end
    else
      render_error(404, request.path, 20101, @group.errors.as_json)
    end
  end

=begin
        elsif @group.errors[:name].any?
          if @group.errors[:name].include?("is too long (maximum is 50 characters)")
            render_error(404, request.path, 20100, "Group name is too long. (max: 50)")
          elsif @group.errors[:name].include?("has already been taken")
            render_error(404, request.path, 20100, "Group name is in use.")
          else
            render_error(404, request.path, 20100, "Invalid group name.")
          end
        else
          render_error(404, request.path, 20100, "Failed to create the new group.")
        end
=end


# params: access_token, group_id, user_id
# auth user's right
  def is_admin
    group_id = params[:group_id]
    user_id  = params[:user_id].to_i
    @group = Group.find(group_id)
    if @group
      if is_admin?(user_id, @group)
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    end
  end

# params: access_token, group_id, user_id
# auth user's right
  def is_creator
    group_id = params[:group_id]
    user_id  = params[:user_id].to_i
    @group = Group.find(group_id)
    if @group
      if is_creator?(user_id, @group)
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    end
  end

# params: access_token, group_id, user_id
# auth user's right
  def is_member
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    if user_and_group_exist?(@user, @group)
      if is_member?(@user, @group)
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    end
  end

# params: access_token, group_id
# auth user's right
  def count
    @group = Group.find(params[:group_id])
    if @group      
      render json: {count: @group.users.count}
    end
  end

# params: access_token, group_id
# member's right
  def show
    @group = Group.find(params[:group_id])
    if current_user_is_member?(@group)
      respond_with(@group, only: [:id, :name, :admin_id, :creator_id])
    end
  end

# params: access_token, group_id
# admin's right
  def update
    @group = Group.find(params[:group_id])
    if current_user_is_admin?(@group)
      if @group.update_attributes(params[:group])
        respond_with(@group, only: [:id, :name, :creator_id, :admin_id])
      else
        render_error(404, request.path, 20108, "Failed to update group info")
      end
    end
  end

# params: access_token, group_id
# admin's right
  def destroy
    @group = Group.find(params[:group_id])
    if current_user_is_admin?(@group)
      if @group.destroy
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    end
  end


# params: access_token, group_id, new_admin_id
# admin's right 
  def transfer_admin
    @group = Group.find(params[:group_id])
    if current_user_is_admin?(@group)
      new_admin_id = params[:new_admin_id].to_i
      @new_admin = User.find(new_admin_id)
      if @new_admin
        if is_member?(@group, @new_admin)
          if new_admin_id == @group.admin_id
            render_error(404, request.path, 20111, "Cannot transfer rights to yourself.")
          else
            if @group.update_attributes(admin_id: new_admin_id)
              respond_with(@group, only: [:id, :name, :admin_id, :creator_id])
            else
              render_error(404, request.path, 10002, "Failed to update database")
            end
          end
        else
          render_error(401, request.path, 20100, "New admin is not group member.")
        end
      end
    end
  end

=begin
  def tranfer_admin
    @group = Group.find(params[:group_id])
    if current_user_is_admin?(@group)
      if 
    end
  end
=end

end
