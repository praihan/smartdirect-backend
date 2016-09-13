class ApplicationController < ActionController::API
  include Knock::Authenticable

  private

  # This method will be called if Knock cannot find
  # a token or otherwise cannot authenticate
  def unauthorized_entity(entity)
    render status: 401, json: {
      message: 'Invalid token'
    }
  end
end
