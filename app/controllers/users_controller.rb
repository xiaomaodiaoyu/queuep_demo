class UsersController < ApplicationController
  respond_to :json
  #before_filter :auth_user,    only: [:show]
  before_filter :correct_user, only: [:show, :update]

  def new
  end

  def show
    @user = User.find(params[:id])
    if @user
      respond_with(@user, only: [:id, :email, :first_name, :last_name])
    else
      render_error(404, request.path, 20000, "Invalid user")
    end
  end

  def create
  	email      = params[:email]
    password   = params[:password]
    first_name = params[:first_name]
    last_name  = params[:last_name]
    
    if email.nil? or password.nil? or first_name.nil? or last_name.nil?
      render_error(401, request.path, 20003, "Incomplete signup information.")
      return
    end
    @user = User.new(email: email, password: password, 
                     first_name: first_name, last_name: last_name)
    if @user.save
      respond_with(@user, only: [:id, :email])
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
  end

  def destroy
    if auth_user.destroy
      render json: {request: request.path, message: "You have successfully logged off."}
    else
      render_error(404, request.path, 20006, "Logoff failed.")
    end
  end

  def update
    @user = User.find(params[:id])
=begin
    # change password
    # needs to be improved
=end
    if !@user.nil?
      if @user.update_attributes(params[:user])
        respond_with(@user, only: [:id, :email])
      elsif @user.errors[:password].include?("is too short (minimum is 6 characters)")
        render_error(404, request.path, 20003, "Password is too short.")
      else
        render_error(404, request.path, 20006, "Failed to update the profile.")
      end
    else
      render_error(404, request.path, 20006, "Invalid user.")
    end
  end

private

    def correct_user
      @user = User.find(params[:id])
      if @user
        if !auth_user?(@user)
          render_error(404, request.path, 20006, "No rights.")
          return
        end
      else
        render_error(404, request.path, 20006, "User does not exist.")
        return
      end  
    end

end
