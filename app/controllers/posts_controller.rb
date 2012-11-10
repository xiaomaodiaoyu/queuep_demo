class PostsController < ApplicationController
  respond_to :json
  before_filter :auth_user
  before_filter :group_member,                  only: [:create, :user_posts_in_one_group, :group_posts]
  before_filter :referred_user_is_group_member, only: [:user_posts_in_one_group]
  before_filter :authorized_member,             only: [:create]
  before_filter :post_author,                   only: [:destroy, :update]

# params: access_token, group_id, content
# authorized user's right 
  def create
    @post = @current_user.posts.build(content:  params[:content])
    @post.group_id = @group.id
    if @post.save
      respond_with(@post, only: [:content, :user_id, :group_id, :created_at])
    else
      render_error(404, request.path, 20201, @post.errors.full_messages)
    end
  end

# params: access_token, post_id, post[variable]
# author's right 
  def update
    if @post.update_attributes(params[:post])
      respond_with @post
    else
      render_error(401, request.path, 20203, "Failed to edit post.")
    end
  end

# params: access_token, post_id
# author's right 
  def destroy
  	if @post.destroy
    	render json: {result: 1}
    else
     	render json: {result: 0}
    end
  end

# params: access_token, post_id, user_id
# member's right 
  def is_author
    @post = Post.find(params[:post_id])
    @group = Group.find(@post.group_id)
    if @current_user.is_member?(@group)
      @user = User.find(params[:user_id])
      if @user.is_author?(@post)
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    else
      render_error(401, request.path, 20203, "Current user is not in the post's group.")
    end 
  end

# params: access_token, user_id, group_id
# member's right
  def user_posts_in_one_group
    @posts = @referred_user.find_posts(@group)
    render_results(@posts)
  end

# params: access_token, group_id
# member's right
  def group_posts
    @posts = @group.posts
    render_results(@posts)
  end

# params: access_token, group_id
# self's right
  def all_my_posts
    @posts = @current_user.posts
    render_results(@posts)
  end
  
private
  def post_author
    post = Post.find(params[:post_id])
    if post.user_id == @current_user.id
      @post = post
    else
      render_error(401, request.path, 20100, "Not the author.")
      return false
    end
  end



end