class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found_errors
  rescue_from ActiveModel::MassAssignmentSecurity::Error, with: :mass_assignment_errors
  
  protected
    def record_not_found_errors
      render_error(404, request.path, 404, "Record not found") 
    end

    def mass_assignment_errors
      render_error(404, request.path, 404, "Do not hack!") 
    end
end
