class CirclingsController < ApplicationController
  respond_to :json
  before_filter :auth_user
  before_filter :circle_group_admin
  after_filter  :clear_all_data  

# params: access_token, circle_id, user_id=1,2,3
# admin's right
  def create
    user_ids = params[:user_id].split(',').map(&:to_i)
    @result = 0   
    user_ids.each do |user_id|
      if @result == 0
      	@user = User.find(user_id)
        add_member_to_circle(@user, @circle, @group)
      end
    end
    render_result_by_case
  end

# params: access_token, circle_id, user_id=1,2,3
# admin's right
  def destroy
    user_ids = params[:user_id].split(',').map(&:to_i)
    @result = 0   
    user_ids.each do |user_id|
      if @result == 0
      	@user = User.find(user_id)
        remove_member_from_circle(@user, @circle, @group)        
      end
    end
    render_result_by_case  
  end

private
  def add_member_to_circle(user, circle, group)
    if user.is_member?(group)
      if !user.is_member?(circle)
        if !user.add_to_circle!(circle)
          @result = 1
        end
      else
      	@result = 3
      end
    else
      @result = 2
    end
  end

  def remove_member_from_circle(user, circle, group)
    if user.is_member?(circle)
      if !user.remove_from_circle!(circle)
        @result = 1
      end
    else
      @result = 4
    end
  end

  def render_result_by_case
    case @result
      when 0 then render json: { circle_id:   @circle.id,
                                 circle_name: @circle.name,
                                 user_count:  @circle.users.count }
      when 1 then render_error(404, request.path, 20401, @circling.errors.as_json)
      when 2 then render_error(404, request.path, 20401, "User(id:#{@user.id}) is not group member")
      when 3 then render_error(404, request.path, 20401, "User(id:#{@user.id}) is already a circle member")
      when 4 then render_error(404, request.path, 20401, "User(id:#{@user.id}) is not a circle member")
    end
  end

end