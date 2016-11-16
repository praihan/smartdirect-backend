# noinspection RubyStringKeysInHashInspection
module RSpecHelpers
  module JsonRequest
    def default_headers
      return {
          'Accept' => 'application/vnd.api+json',
          'Content-Type' => 'application/vnd.api+json',
      }
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