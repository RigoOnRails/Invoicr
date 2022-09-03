# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Types::Query) do
  subject { described_class }

  it { is_expected.to(have_graphql_name('Query')) }
  it { is_expected.to(have_graphql_field('viewer')) }

  describe 'viewer field' do
    subject { described_class.fields['viewer'] }

    let(:body) { 'query { viewer { email } }' }

    it { is_expected.not_to(have_graphql_arguments) }
    it { is_expected.to(have_graphql_type(Types::User)) }

    context 'when authenticated' do
      let(:user) { build_stubbed(:user) }
      let(:result) { ApplicationSchema.execute(body, context: { viewer: user }) }

      it 'resolves to current user' do
        expect(result['data']['viewer']['email']).to(eq(user.email))
      end
    end

    context 'when not authenticated' do
      let(:result) { ApplicationSchema.execute(body, context: { viewer: nil }) }

      it 'resolves to nil' do
        expect(result['data']['viewer']).to(be_nil)
      end
    end
  end
end
