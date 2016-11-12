class ApplicationResourceController < ApplicationController
  include JSONAPI::ActsAsResourceController
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  # This is called by jsonapi-authorization
  def context
    { user: current_user }
  end

  def user_not_authorized
    render status: :forbidden, json: {
        message: 'Forbidden'
    }
  end
end