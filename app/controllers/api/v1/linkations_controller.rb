module Api
  module V1
    class LinkationsController < ApplicationResourceController
      before_action :authenticate_user
    end
  end
end