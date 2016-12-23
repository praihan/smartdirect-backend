require 'rails_helper'

# See helpers/json_helpers.rb for added DSL

RSpec.describe Api::V1::DirectoryResource, type: :request do

  context 'when there is no auth token' do
    it 'fails with 401-Unauthorized' do
      get '/api/v1/directories', headers: default_headers

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
      get '/api/v1/directories', headers: headers

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
    let(:user) {
      create_dummy_user!(
          identifiable_claim: identifiable_claim,
          name: name,
          email: email,
      )
    }

    before(:each) do
      # Force the user to exist before we do anything
      user
    end

    it 'received directory is well-formed' do
      get '/api/v1/directories', headers: headers

      body = JSON.parse response.body

      expect(response.status).to eq(200)

      expect(body['data'].length).to eq(1)

      directory = body['data'][0]
      expect(directory['type']).to eq('directories')
      expect(directory['id'].to_i).to eq(user.directory.id)

      attributes = directory['attributes']
      expect(attributes['name']).to eq('')
      created_at_date = DateTime.parse attributes['created-at'] rescue nil
      expect(created_at_date).to_not eq(nil)
      expect(created_at_date > 30.seconds.ago).to eq(true)

      relationships = directory['relationships']
      expect(relationships['user']).to_not eq(nil)
      expect(relationships['parent']).to_not eq(nil)
      expect(relationships['children']).to_not eq(nil)
    end

    it 'allows getting own directory' do
      get "/api/v1/directories/#{user.directory.id}", headers: headers

      body = JSON.parse response.body

      expect(response.status).to eq(200)

      directory = body['data']
      expect(directory['type']).to eq('directories')
      expect(directory['id'].to_i).to eq(user.directory.id)
    end
  end

  context 'when multiple users' do
    let(:identifiable_claim1) { 'github|1234' }
    let(:name1) { 'User 1' }
    let(:email1) { 'user@user1.com' }
    let(:headers1) {
      default_headers.merge(
          auth_headers_from(
              identifiable_claim: identifiable_claim1,
              name: name1,
              email: email1
          )
      )
    }
    let(:user1) {
      create_dummy_user!(
          identifiable_claim: identifiable_claim1,
          name: name1,
          email: email1,
      )
    }
    let(:identifiable_claim2) { 'google-oauth2|1234' }
    let(:name2) { 'User 2' }
    let(:email2) { 'user@user2.com' }
    let(:headers2) {
      default_headers.merge(
          auth_headers_from(
              identifiable_claim: identifiable_claim2,
              name: name2,
              email: email2
          )
      )
    }
    let(:user2) {
      create_dummy_user!(
          identifiable_claim: identifiable_claim2,
          name: name2,
          email: email2,
      )
    }

    before(:each) do
      # Force the users to exist before we do anything
      user1
      user2
    end

    it 'only shows current user\'s directory' do
      get '/api/v1/directories/', headers: headers1

      body = JSON.parse response.body

      expect(response.status).to eq(200)

      expect(body['data'].length).to eq(1)
      directory = body['data'][0]
      expect(directory['type']).to eq('directories')
      expect(directory['id'].to_i).to eq(user1.directory.id)
    end

    it 'allows getting own directory' do
      get "/api/v1/directories/#{user1.directory.id}", headers: headers1

      body = JSON.parse response.body

      expect(response.status).to eq(200)

      directory = body['data']
      expect(directory['type']).to eq('directories')
      expect(directory['id'].to_i).to eq(user1.directory.id)
    end

    it 'disallows getting other users\' directories' do
      # Note the header-user mismatch
      get "/api/v1/directories/#{user2.directory.id}", headers: headers1

      body = JSON.parse response.body

      expect(response.status).to eq(404)
      # noinspection RubyStringKeysInHashInspection
      expect(body['errors']).to(
          match_array([{
              'title' => 'Record not found',
              'detail' => "The record identified by #{user2.directory.id} could not be found.",
              'code' => 'RECORD_NOT_FOUND',
              'status' => '404',
          }])
      )
    end

    context 'when creating' do
      it 'works on happy path' do
        # if the directory already exists, then this test wouldn't work
        expect(user1.directory.find_by_path(%w(subdirectory))).to eq(nil)

        post '/api/v1/directories', headers: headers1, as: :json, params: {
            'data': {
                'type': 'directories',
                'attributes': {
                    'name': 'subdirectory',
                },
                'relationships': {
                    'parent': {
                        'data': {
                            'type': 'directories',
                            'id': user1.directory.id,
                        }
                    }
                }
            }
        }

        expect(response.status).to eq(201)

        response_data = JSON.parse(response.body)['data']
        created_dir = user1.directory.find_by_path(%w(subdirectory))

        expect(created_dir).to_not eq(nil)
        expect(response_data['type']).to eq('directories')
        expect(response_data['id']).to eq(created_dir.id.to_s)

        response_attributes = response_data['attributes']
        expect(response_attributes['name']).to eq('subdirectory')
      end
    end

  end

end