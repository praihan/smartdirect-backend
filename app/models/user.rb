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

  # This is the ROOT directory that belongs to the user.
  # We use belongs_to because we want the user to store the
  # foreign key to the directory. The directory has no idea
  # if it is owned or not.
  belongs_to :link_directory
  before_create :create_default_link_directory

  private

  def create_default_link_directory
    # Over here, we create the ROOT directory for a user.
    # This directory doesn't really have a name
    create_link_directory(name: '')
    true
  end
end
