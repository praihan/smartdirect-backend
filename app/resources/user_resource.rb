class UserResource < ApplicationResource
  # A User cannot be changed through our API
  # especially since we use OAuth to get most of the info
  immutable

  # Someone who has access to all users might want to look through
  paginator :offset

  # These are the two parts of @model.identifiable_claim
  # See models/user.rb
  attributes :oauth_provider, :oauth_id

  # The ROOT directory of the user
  has_one :directory
end