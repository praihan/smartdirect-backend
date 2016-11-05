class User < ApplicationRecord
  def self.from_token_payload(payload)
    # This is expected to be in the format
    # "#{provider}|#{user_id}"
    sub_claim = payload['sub']

    # Just to be safe...
    return nil unless sub_claim.is_a? String

    # Only accept recognized providers, e.g. 'github|', 'google-oauth2|'
    # Take note of the pipe (|) that separates the provider from their ID
    known_providers = Settings[:auth0][:known_oauth_providers]
    return nil if known_providers.none? { |provider| sub_claim.start_with? "#{provider}|" }

    # Since we provide no sign up mechanism, users are created on the fly
    return self.find_or_create_by identifiable_claim: sub_claim
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
end
