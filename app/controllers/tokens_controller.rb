class TokensController < ApplicationController
  respond_to :json

  def new
  end

  def create
  end

  def destroy
  end
=begin

  def create
  	email = params[:email]
    password = params[:password]
    first_name = params[:first_name]
    last_name = params[:last_name]
    @user = User.new(email: email, password: password, 
    	               first_name: first_name, last_name: last_name)
    if @user.save
      respond_with(@user, only: [:id, :email])
    else
      #logger.info("Signup failed")
      render json: {errors: @user.errors.full_messages}
      #render_error(request.path, 20000, @user.errors.as_json)
      #render status: 400, json: {errors: @user.errors.full_messages}
    end
  end

  def destroy
  end
=end

end
