class GroupsController < ApplicationController
  respond_to :json

  def new
  end

  def create
  	name = params[:name]
    parent = params[:parent]
    creator_id = params[:creator_id]

    if request.format != :json
      render status: 406, json: {message: "The request must be json."}
      return
    end
    
    if !parent.nil?
      @parent = Group.find_by_name(parent)
      # Only admins could create subgroups
      if @parent.admins.include?(User.find(creator_id)) 
        @group = Group.new(name: name, creator_id: creator_id)
        if @group.save
          @administration = Administration.new(admin_id: creator_id, managinggroup_id: @group.id)
          @group.move_to_child_of(@parent)
          respond_with(@group)
        else
          logger.info("Failed to create the group.")
          render status: 400, json: {errors: @group.errors.full_messages}
        end
      else
        logger.info("Failed to create the group.")
        render status: 400, json: {messages: "Only admins could create subgroups."}
      end
    else
      @group = Group.new(name: name, creator_id: creator_id)
      if @group.save
        @administration = Administration.new(admin_id: creator_id, managinggroup_id: @group.id)
        @membership = Membership.new(user_id: creator_id, group_id: @group.id)
        if @administration.save && @membership.save
          respond_with(@group)
        end
      else
        logger.info("Failed to create the group.")
        render status: 400, json: {errors: @group.errors.full_messages}
      end
    end
  end 
end
