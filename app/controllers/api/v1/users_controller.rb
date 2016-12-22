module Api
  module V1
    class UsersController < ApplicationResourceController
      before_action :authenticate_user
    end
  end
end
