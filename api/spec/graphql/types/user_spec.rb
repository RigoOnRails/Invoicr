# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::User do
  subject(:user_type) { described_class }

  let(:user) { create(:user) }

  def execute_query(body, variables: {})
    ApplicationSchema.execute(body, context: { viewer: user }, variables:)
  end

  it { is_expected.to have_graphql_name('User') }

  it 'does not expose sensitive data' do
    expect(user_type).not_to have_graphql_fields(:authentication_token, :encrypted_password)
  end
end
