class GroupsController < ApplicationController
  respond_to :json
  before_filter :auth_user, only: [:is_admin, :is_creator, :is_member, :count]


  def create
  	name = params[:name]
    creator_id = params[:creator_id]
     
    if name.nil?
      render_error(404, request.path, 20100, "Group name is null.") and return
    elsif creator_id.nil?
      render_error(404, request.path, 20100, "creator_id is null.") and return
    end

    @creator = User.find(creator_id)

    if @creator && current_user
      if !current_user(@creator)
        render_error(404, request.path, 20100, "Current user is not the creator.")
      else 
        @group = Group.new(name: name, creator_id: creator_id)
        if @group.save
          @membership = Membership.new(user_id: creator_id, group_id: @group.id)
          if @membership.save
            respond_with(@group, only: [:id, :name, :creator_id, :admin_id])
          else
            render_error(404, request.path, 20100, @membership.errors.to_json)
          end
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
      end
    end
  end

  def destroy
    if current_user_is_admin
      @group = Group.find(params[:group_id])
      if @group.destroy
        render json: {request: request.path, message: "Group deleted."}
      else
        render_error(401, request.path, 20100, "Failed to delete the group.")
      end
    end
  end

  def show
    if current_user_is_member
      @group = Group.find(params[:group_id])
      respond_with(@group, only: [:id, :name, :admin_id, :creator_id])
    end
  end

  def update
    if current_user_is_admin
      @group = Group.find(params[:group_id])
      if @group.update_attributes(params[:group])
        respond_with(@group, only: [:id, :name, :creator_id, :admin_id])
      else
        render_error(404, request.path, 20006, "Failed to update the group info.")
      end
    end
  end

  def is_admin
    is_admin?
  end

  def is_creator
    is_creator?
  end

  def is_member
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    if @group && @user
      if is_member?(@group, @user)
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    end
  end

  def count
    @group = Group.find(params[:group_id])
    if @group      
      render json: {count: @group.users.count}
    end
  end

  def transfer_admin
    if current_user_is_admin
      new_admin_id = params[:new_admin_id].to_i
      @new_admin = User.find(new_admin_id)
      @group = Group.find(params[:group_id])
      if @new_admin 
        if is_member?(@group, @new_admin)
          if new_admin_id == @group.admin_id
            render_error(404, request.path, 20100, 
                         "Do not transfer the admin rights to yourself.") and return
          else
            if @group.update_attributes(admin_id: new_admin_id)
              respond_with(@group, only: [:id, :name, :admin_id, :creator_id]) and return
            else
              render_error(404, request.path, 20100, "Failed to update the database.")
            end
          end
        else
          render_error(404, request.path, 20100, "New admin is not a member of the group.")
        end
      end
    end
  end
  

end
