class ApplicationController < ActionController::API
  include Knock::Authenticable

  private

  # This method will be called if Knock cannot find
  # a token or otherwise cannot authenticate.
  # It is important to realize that despite the name
  # this only deals with authentication, NOT authorization.
  # This is why we send a 401 instead of 403
  def unauthorized_entity(entity)
    render status: :unauthorized, json: {
        message: 'Invalid token'
    }
  end
end
