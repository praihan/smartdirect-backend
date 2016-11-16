# noinspection RubyStringKeysInHashInspection
module RSpecHelpers
  module JsonRequest
    def default_headers
      return {
          'Accept' => 'application/vnd.api+json',
          'Content-Type' => 'application/vnd.api+json',
      }
    end

    def auth_headers_for(user)
      token = Knock::AuthToken.new(payload: {
          'sub' => user.identifiable_claim,
          'email' => user.email,
          'name' => user.name,

          # 'iss' => '',
          # 'aud' => '',
          # 'exp' => 1234,
          # 'iat' => 1234,
      }).token
      return jwt_auth_headers token
    end

    def jwt_auth_headers(jwt)
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