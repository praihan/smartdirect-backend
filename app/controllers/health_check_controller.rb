class HealthCheckController < ApplicationController
  before_action :authenticate_user

  def show
    render json: {
      status: 'OK'
    }
  end

end
