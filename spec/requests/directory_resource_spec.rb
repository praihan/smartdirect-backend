require 'rails_helper'

# See helpers/json_helpers.rb for added DSL

RSpec.describe DirectoryResource, type: :request do

  context 'when there is no auth token' do
    it 'fails with 401-Unauthorized' do
      get '/directories', headers: default_headers

      body = JSON.parse response.body

      # 401 Unauthorized for no token
      expect(response.status).to eq(401)
      # The message should not contain any extra info
      expect(body).to eq(body_for_invalid_token)
    end
  end

  context 'when first time user' do
    it 'works and returns 200-Success (not 201-Created)' do
      headers = default_headers.merge(
          auth_headers_from(
              identifiable_claim: 'github|1234',
              name: 'Donald Duck',
              email: 'Donald@Duck.com'
          )
      )
      get '/directories', headers: headers

      body = JSON.parse response.body

      expect(response.status).to eq(200)
    end
  end

  context 'when existing user' do
    let(:identifiable_claim) { 'github|1234' }
    let(:name) { 'Scott Sterling' }
    let(:email) { 'Scott@Sterling.co.uk' }
    let(:headers) {
      default_headers.merge(
          auth_headers_from(
              identifiable_claim: identifiable_claim,
              name: name,
              email: email
          )
      )
    }

    before(:each) do
      # Force the user to exist before we do anything
      @user = create_dummy_user!(
          identifiable_claim: identifiable_claim,
          name: name,
          email: email,
      )
    end

    it 'received directory is well-formed' do
      get '/directories', headers: headers

      body = JSON.parse response.body

      expect(response.status).to eq(200)

      expect(body['data'].length).to eq(1)

      directory = body['data'][0]
      expect(directory['id'].to_i).to eq(@user.directory.id)
      expect(directory['type']).to eq('directories')

      attributes = directory['attributes']
      expect(attributes['name']).to eq('')
      created_at_date = DateTime.parse attributes['created-at'] rescue nil
      expect(created_at_date).to_not eq(nil)
      expect(created_at_date > 30.seconds.ago).to eq(true)
      expect(attributes['created-at']).to eq(attributes['updated-at'])

      relationships = directory['relationships']
      expect(relationships['user']).to_not eq(nil)
      expect(relationships['parent']).to_not eq(nil)
      expect(relationships['children']).to_not eq(nil)
    end

  end

end