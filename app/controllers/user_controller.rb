class UserController < ApplicationResourceController
  before_action :authenticate_user
end
