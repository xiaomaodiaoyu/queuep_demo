class AdministrationsController < ApplicationController
  respond_to :json

  def create
  	admin_id = params[:user_id]
    managinggroup_id = params[:group_id]
    @administration = Administration.new(admin_id: admin_id, managinggroup_id: managinggroup_id)
    if @administration.save
      respond_with(@administration)
    else
      logger.info("Administration failed")
      render status: 400, json: {errors: @administration.errors.full_messages}
    end
  end
end
