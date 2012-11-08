class PostsController < ApplicationController
  respond_to :json
  before_filter :auth_user, only: [:is_author, :user_posts, :group_posts]

# params: access_token, group_id, content
# authorized user's right 
  def create
    @current_user = auth_user
    if @current_user
      group_id = params[:group_id]
      @group = Group.find(group_id)
      if is_authorized?(@group, @current_user)
        @post = @current_user.posts.build(group_id: @group.id,
      	                                  content:  params[:content])
        if @post.save
      	  respond_with(@post, only: [:content, :user_id, :group_id, :created_at])
        else
          render_error(404, request.path, 20101, @post.errors.full_messages)
        end
      end
    end
  end

# params: access_token, post_id
# author's right 
  def destroy
  	@post = Post.find(params[:post_id])
    @current_user = auth_user
    if is_author?(@post, @current_user)
      if @post.destroy
      	render json: {result: 1}
      else
       	render json: {result: 0}
      end
    end
  end

# params: access_token, post_id, post[variable]
# author's right 
  def update
    @post = Post.find(params[:post_id])
    @current_user = auth_user
    if is_author?(@post, @current_user)
      if @post.update_attributes(params[:post])
      	respond_with @post
      else
       	render_error(401, request.path, 20203, "Failed to edit post.")
      end
    end
  end

# params: access_token, post_id, user_id
# auth_user's right 
  def is_author
    @post = Post.find(params[:post_id])
    @user = User.find(params[:user_id])
    if is_author?(@post, @user)
      render json: {result: 1}
    end 
  end

# params: access_token, user_id, group_id
# auth_user's right
  def user_posts
    @user = User.find(params[:user_id])
    if @user
      @posts = @user.posts
      if !@posts.empty?
        group_id = params[:group_id]
        @posts_in_group = @posts.where(group_id: group_id)
        if !@posts_in_group.empty?
          render json: {result: 1,
                        count:  @posts_in_group.count,
                        posts:  @posts_in_group} and return
        end
      end
      render json: {result: 0}
    end
  end

# params: access_token, group_id
# member's right
  def group_posts
    @current_user = auth_user
    if @current_user
      @group = Group.find(params[:group_id])
      if @group
        if is_member?(@group, @current_user)
          @posts = @group.posts
          if !@posts.empty?
            render json: {result: 1,
                          count:  @posts.count,
                          posts:  @posts} and return
          end
          render json: {result: 0}
        else
          render_error(401, request.path, 20100, 
                       "Current user is not group member.")
        end
      end
    end
  end



private
  def is_authorized?(group, user)
    if user
      if group
        if is_member?(@group, @current_user)
          @membership = Membership.find_by_user_id_and_group_id(@current_user.id, @group.id)
          if @membership.auth?
          	return true
          else
            render_error(404, request.path, 20006, "User unauthorized.")
            return false
          end
        end
      end
    end
  end

  def is_author?(post, user)
    if user
      if post
        if post.user_id == user.id
          return true
        else
          render_error(404, request.path, 20006, "User is not the author.")
          return false
        end
      end
    end
  end

end