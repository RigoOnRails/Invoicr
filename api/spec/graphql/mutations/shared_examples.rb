# frozen_string_literal: true

RSpec.shared_examples('a guest only operation') do
  context 'when authenticated' do
    it 'returns errors' do
      context = {
        viewer: create(:user)
      }

      result = ApplicationSchema.execute(body, context:, variables:)
      expect(result).to(have_graphql_error_class(:AUTHORIZATION))
    end
  end
end
