module Api
  module V1
    class CurrentUserController < ApplicationController
      before_action :authenticate_user

      def index
        redirect_to "/api/v1/users/#{current_user.id}/"
      end
    end
  end
end

