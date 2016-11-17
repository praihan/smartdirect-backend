module RSpecHelpers
  module UserModel

    # noinspection RubyStringKeysInHashInspection
    def create_dummy_jwt_payload(name: nil, email: nil, sub: nil)
      return {
          'iss' => Settings[:jwt][:issuer],
          'aud' => Settings[:jwt][:client_id],
          'exp' => (Time.now + 10.hours).to_i,
          'iat' => Time.now.to_i,
          'email' => email || 'JohnSmith@example.com',
          'name' => name || 'John Smith',
          'sub' => sub || 'github|1234',
      }
    end

    def create_dummy_user(identifiable_claim: nil, name: nil, email: nil)
      default_payload = create_dummy_jwt_payload
      return User.create(
          identifiable_claim: identifiable_claim || default_payload['sub'],
          name: name || default_payload['name'],
          email: email || default_payload['email'],
      )
    end

  end
end