# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable

  validates :name, presence: true, on: :update
  validates :authentication_token, uniqueness: true

  before_save :ensure_authentication_token
  before_create :set_default_name

  def reset_authentication_token
    self.authentication_token = generate_authentication_token
  end

  private

    def set_default_name
      self.name = email
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

    def ensure_authentication_token
      self.authentication_token = generate_authentication_token if authentication_token.blank?
    end
end
