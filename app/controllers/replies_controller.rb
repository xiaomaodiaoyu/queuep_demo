class RepliesController < ApplicationController
  respond_to :json

  def show
    @reply = Reply.find(params[:id])
    if @reply
      respond_with(@reply, only: [:lat, :lng, :address, :content])
    else
      render_error(404, request.path, 30000, "Invalid reply")
    end
  end

  def destroy
  end


end
