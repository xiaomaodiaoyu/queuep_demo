class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  include SessionsHelper
  include GroupsHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found_errors

  protected
    def record_not_found_errors
      render_error(404, request.path, 404, "Record not found") 
    end
end
