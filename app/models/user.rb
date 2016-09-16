class User < ApplicationRecord
  def self.from_token_payload(payload)
    return self.find_or_create_by identifiable_claim: payload['sub']
  end
end
