# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlController, type: :request do
  let(:user) { create(:user) }

  describe 'POST /graphql' do
    let(:query) { '{ viewer { email } }' }

    context 'when authenticated' do
      before do
        auth_token = Base64.strict_encode64("#{user.email}:#{user.authentication_token}")
        headers = {
          Authorization: "Bearer #{auth_token}"
        }

        post(graphql_path, headers:, params: { query: })
      end

      it 'gives access to viewer' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['viewer']['email']).to eq(user.email)
      end
    end

    context 'when not authenticated' do
      before do
        post(graphql_path, params: { query: })
      end

      it 'does not give access to viewer' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['viewer']).to be_nil
      end
    end
  end
end
