# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Auth::SignUp do
  let(:body) do
    <<-GRAPHQL
      mutation SignUp($input: AuthSignUpInput!) {
        authSignUp(input: $input) {
          user {
            name
            email
          }

          authenticationToken
        }
      }
    GRAPHQL
  end

  let(:variables) do
    {
      input: {
        email: 'john@example.com',
        password: 'password'
      }
    }
  end

  let(:remote_ip) { '54.200.249.197' }

  let(:execute) do
    request = ActionDispatch::Request.new({})
    request.remote_ip = remote_ip

    ApplicationSchema.execute(body, variables:, context: { request: })
  end

  let(:data) { execute['data']['authSignUp'] }

  it_behaves_like 'a guest only operation'

  it 'returns expected data' do
    expect(data['user']['name']).to eq('john@example.com')
    expect(data['user']['email']).to eq('john@example.com')
    expect(data['authenticationToken']).to eq(User.find_by(email: 'john@example.com').authentication_token)
  end
end
