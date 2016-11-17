# noinspection RubyStringKeysInHashInspection
module RSpecHelpers
  module JsonRequest
    def default_headers
      return {
          'Accept' => 'application/vnd.api+json',
          'Content-Type' => 'application/vnd.api+json',
      }
    end

    def auth_headers_for_user(user, issued_at: Time.now, expires_in: 10.hours)
      return auth_headers_from(
          identifiable_claim: user.identifiable_claim,
          name: user.name,
          email: user.email,
          issued_at: issued_at,
          expires_in: expires_in
      )
    end

    def jwt_payload_from(identifiable_claim:, name:, email:,
                         issued_at: Time.now, expires_in: 10.hours)
      return {
          'sub' => identifiable_claim,
          'email' => email,
          'name' => name,

          'iss' => Settings[:jwt][:issuer],
          'aud' => Settings[:jwt][:client_id],

          'exp' => (Time.now + expires_in).to_i,
          'iat' => issued_at.to_i,
      }
    end

    def auth_headers_from(identifiable_claim:, name:, email:,
                          issued_at: Time.now, expires_in: 10.hours)
      token = Knock::AuthToken.new(
          payload: jwt_payload_from(
              identifiable_claim: identifiable_claim,
              name: name,
              email: email,
              issued_at: issued_at,
              expires_in: expires_in
          )
      ).token
      return auth_headers_for_jwt token
    end

    def auth_headers_for_jwt(jwt)
      return {
          'Authorization' => "Bearer #{jwt}"
      }
    end

    def body_for_invalid_token
      return {
          'message' => 'Invalid token'
      }
    end
  end
end