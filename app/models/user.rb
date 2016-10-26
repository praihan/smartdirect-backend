class User < ApplicationRecord
  def self.from_token_payload(payload)
    # This is expected to be in the format
    # "#{provider}|#{user_id}"
    sub_claim = payload['sub']

    # Just to be safe...
    unless sub_claim.is_a? String
      return nil
    end

    # Only accept recognized providers, e.g. 'github|', 'google-oauth2|'
    # Take note of the pipe (|) that separates the provider from their ID
    known_providers = Settings[:auth0][:known_oauth_providers]
    if known_providers.none? { |provider| sub_claim.start_with? "#{provider}|" }
      return nil
    end

    # Since we provide no sign up mechanism, users are created on the fly
    return self.find_or_create_by identifiable_claim: sub_claim
  end
end
