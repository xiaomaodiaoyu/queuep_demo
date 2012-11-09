class CirclesController < ApplicationController
  respond_to :json
  before_filter :auth_user
  before_filter :group_admin, only: [:create]
  before_filter :circle_group_admin, only: [:destroy, :update]

# params: access_token, group_id, name
# admin's right
  def create
    @circle = @group.circles.new(name: params[:name])
    @circle.creator_id = @current_user.id
    @circle.last_update_admin_id = @current_user.id
    if @circle.save
      respond_with(@circle, only: [:id, :name, :group_id])
    else
      render_error(404, request.path, 20201, @circle.errors.as_json)
    end
  end

# params: access_token, circle_id
# admin's right
  def destroy
    if @circle.destroy
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

# params: access_token, circle_id, name
# admin's right
  def update
  	new_name = params[:name]
  	if new_name && @circle.name != new_name
  	  @circle.name = new_name
   	  @circle.last_update_admin_id = @current_user.id
      if @circle.save
        respond_with @circle
      else
        render_error(401, request.path, 20203, "Failed to edit circle.")
      end
    else
      render_error(401, request.path, 20203, "Nothing to update.")
    end
  end

private
  def circle_group_admin
    @circle = Circle.find(params[:circle_id])
    @group = @circle.group
    if @current_user.is_admin?(@group)
      return true
    else
      render_error(404, request.path, 30000, "Current user is not admin of the circle's group")
      return false
    end
  end


end