class CurrentUserController < ApplicationController
  before_action :authenticate_user

  def index
    redirect_to "/users/#{current_user.id}/"
  end

end
