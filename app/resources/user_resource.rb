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
  has_one :link_directory

  def oauth_provider
    return identifiable_claim_parts[0] || '<unknown>'
  end

  def oauth_id
    return identifiable_claim_parts[1] || '<unknown>'
  end

  private

  def identifiable_claim_parts
    parts = @model.identifiable_claim.split('|')
    # We expect it in the format specified in models/user.rb
    # Otherwise don't provide any information
    return parts if parts.length == 2
    return []
  end
end