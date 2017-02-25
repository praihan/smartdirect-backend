require 'rails_helper'

# See helpers/json_helpers.rb for added DSL

RSpec.describe Api::V1::UserResource, type: :request do
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
  let(:user) {
    create_dummy_user!(
        identifiable_claim: identifiable_claim,
        name: name,
        email: email,
    )
  }

  context 'when there is no auth token' do
    it 'fails with 401-Unauthorized' do
      get '/api/v1/users', headers: default_headers

      body = JSON.parse response.body

      # 401 Unauthorized for no token
      expect(response.status).to eq(401)
      # The message should not contain any extra info
      expect(body).to eq(body_for_invalid_token)
    end
  end

  context 'when first time user' do
    it 'works and returns 200-Success (not 201-Created)' do
      get '/api/v1/users', headers: headers

      body = JSON.parse response.body
      expect(response.status).to eq(200)
    end
  end

  context 'when existing user' do
    before(:each) do
      # Force the user to exist before we do anything
      user
    end

    it 'does not allow duplicate friendly-name\'s' do
      identifiable_claim = 'github|user2'
      user2 = create_dummy_user!(
          identifiable_claim: identifiable_claim,
          name: name,
          email: email,
      )
      user2_headers = default_headers.merge(
          auth_headers_from(
              identifiable_claim: identifiable_claim,
              name: name,
              email: email
          )
      )
      # sanity checks
      expect(user2.valid?).to eq(true)
      expect(user2.friendly_name).not_to eq(user.friendly_name)

      # try to set a duplicate friendly_name
      patch "/api/v1/users/#{user2.id}", headers: user2_headers, as: :json, params: {
          'data': {
              'type': 'users',
              'id': user2.id,
              'attributes': {
                  'friendly-name': user.friendly_name,
              },
              'relationships': {
              }
          }
      }

      body = JSON.parse response.body

      # we should fail to do so
      expect(response.status).to eq(422)
      # noinspection RubyStringKeysInHashInspection
      expect(body['errors']).to(
          match_array([{
              'title' => 'has already been taken',
              'detail' => 'friendly-name - has already been taken',
              'code' => 'VALIDATION_ERROR',
              'source' => {
                  'pointer' => '/data/attributes/friendly-name'
              },
              'status' => '422',
          }])
      )
    end
  end


end