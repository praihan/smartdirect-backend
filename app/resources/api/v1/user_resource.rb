module Api
  module V1
    class UserResource < ApplicationResource
      # A User cannot be changed through our API
      # especially since we use OAuth to get most of the info
      immutable

      # These are the two parts of @model.identifiable_claim
      # See models/user.rb
      attributes :oauth_provider, :oauth_id

      # These are just general info about the user
      attributes :name, :email

      # This is also an identifiable (unique) attribute of the user
      attributes :friendly_name

      # The ROOT directory of the user
      has_one :directory
    end
  end
end
