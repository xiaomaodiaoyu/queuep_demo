class RepliesController < ApplicationController
  respond_to :json
  before_filter :auth_user, except: [:show]
  before_filter :post_group_member, only: [:create, :post_replies]
  before_filter :correct_receiver,  only: [:create]
  before_filter :correct_viewer,    only: [:post_replies]
  before_filter :reply_author, only: [:destroy, :update]
  after_filter  :clear_all_data

# params: access_token, post_id, content, location, lat, lng
# correct_receiver's right
  def create
    content = params[:content]
    location = params[:location]
    lat = params[:lat]
    lng = params[:lng]
    @reply = @current_user.replies.new(content: content,
                                       location: location,
                                       lat: lat, lng: lng)
    @reply.post_id = @post.id
    if @reply.save
      respond_with(@reply, only: [:id, :content, :location, :lat, :lng, :created_at])
    else
      render_error(404, request.path, 20301, @reply.errors.as_json)
    end
  end

# params: access_token, reply_id, reply[variable]
# author's right
  def update
    if @reply.update_attributes(params[:reply])
      respond_with @reply
    else
      render_error(401, request.path, 20302, "Failed to edit reply.")
    end
  end

# params: access_token, reply_id
# author's right
  def destroy
    if @reply.destroy
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

# params: access_token, post_id
# authorized member's right
  def post_replies
    @replies = @post.replies
    render_results(@replies)
  end
  
# testing
  def show
    @reply = Reply.find(params[:id])
    if @reply
      respond_with(@reply, only: [:lat, :lng, :address, :content])
    else
      render_error(404, request.path, 30000, "Invalid reply")
    end
  end

private
  def correct_receiver
    @receivers = @group.users
    if @receivers.include?(@current_user)
      return true
    else
      render_error(404, request.path, 20300, "Invalid receiver")
      return false
    end
  end

  def post_group_member
    @post = Post.find(params[:post_id])
    @group = @post.group
    if @current_user.is_member?(@group)
      return true
    else
      render_error(404, request.path, 20300, "Current user is not in the post's group.")
      return false
    end
  end

  def reply_author
    @reply = Reply.find(params[:reply_id])
    if @current_user.is_author?(@reply)
      return true
    else
      render_error(404, request.path, 20300, "Not the reply's author.")
      return false
    end
  end

  def correct_viewer
    @viewers = @group.authorized_users
    if @viewers.include?(@current_user)
      return true
    else
      render_error(404, request.path, 20300, "Invalid viewer")
      return false
    end
  end
end
