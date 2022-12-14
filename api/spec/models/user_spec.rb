# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(User, type: :model) do
  subject(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.not_to(validate_presence_of(:name).on(:create)) }
    it { is_expected.to(validate_presence_of(:name).on(:update)) }
    it { is_expected.to(validate_uniqueness_of(:authentication_token)) }
  end

  describe 'on creation' do
    it 'sets name to email' do
      expect(user.name).to(eq(user.email))
    end

    it 'generates an authentication_token' do
      expect(user.authentication_token).to(be_present)
    end
  end

  describe '#reset_authentication_token' do
    it 'resets authentication_token' do
      expect do
        user.reset_authentication_token
        user.save!
      end.to(change(user, :authentication_token))
    end
  end
end
