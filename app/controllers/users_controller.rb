class UsersController < ApplicationController
  respond_to :json

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

=begin
    elsif @user.errors[:first_name].any?
      if @user.errors[:first_name].include?("is too long (maximum is 50 characters)")
        render_error(404, request.path, 20003, "first_name is too long. (max: 50)")
      end
    elsif @user.errors[:last_name].any?
      if @user.errors[:last_name].include?("is too long (maximum is 50 characters)")
        render_error(404, request.path, 20003, "last_name is too long. (max: 50)")
      end
    elsif @user.errors[:password].any?
      if @user.errors[:password].include?("is too short (minimum is 6 characters)")
        render_error(404, request.path, 20003, "Password is too short.")
      end
    elsif @user.errors[:email].any? 
      if @user.errors[:email].include?("is invalid")
        render_error(404, request.path, 20003, "Invalid email.")    
      elsif @user.errors[:email].include?("has already been taken")
        render_error(404, request.path, 20002, "Email is in use.")
      end
    else
      render_error(404, request.path, 20006, "Signup failed.")
    end
=end

# params: access_token, group_id, user_id
# self's right
  def show
    @user = User.find(params[:user_id])
    if current_user_is_referred_user?(@user)
      respond_with(@user, only: [:id, :email, :first_name, :last_name])
    end
  end 

# params: access_token, user_id, user[variable]
# self's right
  def update
    # only change password
    # needs to be improved
    @user = User.find(params[:user_id])
    if current_user_is_referred_user?(@user)
      if @user.update_attributes(params[:user])
        respond_with(@user, only: [:id, :email])
      else
        render_error(404, request.path, 20004, "Failed to update profile")
      end
    end
  end  

# params: access_token, user_id
# self's right
  def destroy
    if current_user.destroy
      render json: {request: request.path, message: "You have successfully logged off."}
    else
      render_error(404, request.path, 20006, "Logoff failed.")
    end
    @user = User.find(params[:user_id])
    if current_user_is_referred_user?(@user)
      if @user.destroy
        render json: {result: 1}
      else
        render json: {result: 0}
      end
    end
  end


private
  def current_user_is_referred_user?(user)
    @current_user = auth_user
    if @current_user
      if user
        if user.id == @current_user.id
          return true
        else
          render_error(401, request.path, 20100, 
                       "Current user is not the referred user.")
          return false
        end
      end
    end
  end

end
