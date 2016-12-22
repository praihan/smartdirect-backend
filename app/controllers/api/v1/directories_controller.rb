module Api
  module V1
    class DirectoriesController < ApplicationResourceController
      before_action :authenticate_user
    end
  end
end
