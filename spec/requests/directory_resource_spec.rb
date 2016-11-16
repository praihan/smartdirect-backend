require 'rails_helper'

# See helpers/json_helpers.rb for added DSL

RSpec.describe DirectoryResource, type: :request do

  it 'should fail without auth token' do
    get '/directories', headers: default_headers

    body = JSON.parse response.body

    # 401 Unauthorized for no token
    expect(response.status).to eq(401)
    # The message should not contain any extra info
    expect(body).to eq(body_for_invalid_token)
  end

end