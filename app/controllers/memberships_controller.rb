class MembershipsController < ApplicationController
  respond_to :json

  def create
  	user_id = params[:user_id]
    group_id = params[:group_id]
    @membership = Membership.new(user_id: user_id, group_id: group_id)
    if @membership.save
      respond_with(@membership)
    else
      logger.info("Joining group failed")
      render status: 400, json: {errors: @user.errors.full_messages}
    end
  end
end
