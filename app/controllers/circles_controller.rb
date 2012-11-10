class CirclesController < ApplicationController
  respond_to :json
  before_filter :auth_user
  before_filter :group_admin, only: [:create]
  before_filter :circle_group_admin, only: [:destroy, :update]
  after_filter  :clear_all_data

# params: access_token, group_id, name
# admin's right
  def create
    @circle = @group.circles.new(name: params[:name])
    @circle.creator_id = @current_user.id
    @circle.last_update_admin_id = @current_user.id
    if @circle.save
      respond_with(@circle, only: [:id, :name, :group_id])
    else
      render_error(404, request.path, 20401, @circle.errors.as_json)
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
        render_error(401, request.path, 20402, "Failed to edit circle.")
      end
    else
      render_error(401, request.path, 20402, "Nothing to update.")
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

end