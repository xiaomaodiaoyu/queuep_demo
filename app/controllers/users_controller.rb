class UsersController < ApplicationController
  respond_to :json
  before_filter :auth_user,                     except: [:create]
  before_filter :current_user_is_referred_user, except: [:create]
  after_filter  :clear_all_data

# params: email, password, first_name, last_name
  def create
    email      = params[:email]
    password   = params[:password]
    first_name = params[:first_name]
    last_name  = params[:last_name]
    @user = User.new(email: email, password: password, 
                     first_name: first_name, last_name: last_name)
    if @user.save
      respond_with(@user, only: [:id, :email])
    else
      render_error(404, request.path, 20001, @user.errors.as_json)
    end
  end

# params: access_token, user_id
# self's right
  def show
    respond_with(@user, only: [:id, :email, :first_name, :last_name])
  end 

# params: access_token, user_id, user[variable]
# self's right
  def update
    # only change password
    # needs to be improved
    if @user.update_attributes(params[:user])
      respond_with(@user, only: [:id, :email, :first_name, :last_name])
    else
      render_error(404, request.path, 20005, "Failed to update profile")
    end
  end  

# params: access_token, user_id
# self's right
  def destroy
    if @user.destroy
      render json: {result: 1}
    else
      render json: {result: 0}
    end
  end

private
  def current_user_is_referred_user
    user = User.find(params[:user_id])
    if current_user?(user)
      @user = user
    else
      render_error(404, request.path, 20000, "Self's right.")
      return false
    end
  end


end