class UsersController < ApplicationResourceController
  before_action :authenticate_user
end
