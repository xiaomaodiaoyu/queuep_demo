class GroupsController < ApplicationController
  respond_to :json
  before_filter :correct_creator, only: [:create]

  def is_group_admin
    is_group_admin?
  end

  def is_group_creator
    is_group_creator?
  end

  def new
  end

  def create
  	name = params[:name]
    creator_id = params[:creator_id]

    if request.format != :json
      render status: 406, json: {message: "The request must be json."}
      return
    end
    
    if name.nil?
      render_error(404, request.path, 20100, "Group name is null.")
    elsif creator_id.nil?
      render_error(404, request.path, 20100, "creator_id is null.")      
    elsif !auth_user?(@creator)
      render_error(404, request.path, 20100, "Current user is not the creator.")
    else
      @group = Group.new(name: name, creator_id: creator_id)
      if @group.save
        respond_with(@group, only: [:id, :name, :creator_id, :admin_id])
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

private
  def correct_creator
    @creator = User.find(params[:creator_id])
    if @creator
      if !auth_user?(@creator)
        render_error(404, request.path, 20100, "Current user is not the creator.")
        return
      end
    else
      render_error(404, request.path, 20100, "creator_id does not exist.")
      return
    end     
  end  

end
