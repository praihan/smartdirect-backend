class User < ApplicationRecord
  def self.from_token_payload(payload)
    # Sanity checks:
    # We require scopes: openid email name
    return nil unless %w(iss sub aud email name).all? { |field| payload[field].is_a? String }
    return nil unless %w(exp iat).all? { |field| payload[field].is_a? Integer }

    # This is expected to be in the format
    # "#{provider}|#{user_id}"
    sub_claim = payload['sub']

    # Only accept recognized providers, e.g. 'github|', 'google-oauth2|'
    # Take note of the pipe (|) that separates the provider from their ID
    known_providers = Settings[:auth0][:known_oauth_providers]
    return nil if known_providers.none? { |provider| sub_claim.start_with? "#{provider}|" }

    # Since we provide no sign up mechanism ourselves, users are created on the fly
    user = self.find_or_create_by identifiable_claim: sub_claim do |user|
      # NOTE: This is only called when creating a new user
      # The code works without this but then we have an extra query
      # and created_at no longer matches updated_at
      user.name = payload['name']
      user.email = payload['email']
    end

    # If these fields have changed, then update them in the database as well
    # If we've just created a new user right, that's okay. This will be a no-op
    user.name = payload['name']
    user.email = payload['email']
    user.save if user.changed?

    # And finally, return the user back
    return user
  end

  # This is the LinkSystem attached to the user. Directories and files
  # are linked to the LinkSystem instead of the User directory for ease
  # of moving data around later.
  has_one :link_system
  # When a new user is created, we need to also create a build system for them
  before_create :build_link_system

  # The user (after one step of redirection) ultimately owns its LinkSystem's
  # ROOT directory.
  has_one :directory, through: :link_system

  # If the user doesn't have a LinkSystem, they can't do anything
  validates_associated  :link_system

  # This is the first part of the claim. (e.g. 'github', 'google-oauth2')
  def oauth_provider
    return identifiable_claim_parts[0] || '<unknown>'
  end

  # This is the second part of the claim. It is the unique ID for the user that
  # comes from the oauth_provider
  def oauth_id
    return identifiable_claim_parts[1] || '<unknown>'
  end

  private

  def identifiable_claim_parts
    parts = identifiable_claim.split('|')
    # We expect it in the format specified in models/user.rb
    # Otherwise don't provide any information
    return parts if parts.length == 2
    return []
  end
end
