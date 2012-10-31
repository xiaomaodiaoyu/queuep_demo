class UsersController < ApplicationController
  respond_to :json
  #before_filter :signed_in_user, only: [:index]

  def new
  end

  def index
    @users = User.all
    respond_with({users: @users}.as_json)
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

  def create
  	email = params[:email]
    password = params[:password]
    first_name = params[:first_name]
    last_name = params[:last_name]
    @user = User.new(email: email, password: password, 
    	             first_name: first_name, last_name: last_name)
    if @user.save
      respond_with(@user)
    else
      logger.info("Signup failed")
      render status: 400, json: {errors: @user.errors.full_messages}
    end
  end 
end
