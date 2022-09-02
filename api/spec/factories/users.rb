# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Company.name }
    email { Faker::Internet.unique.email }
    password { 'secret12345' }
    confirmed_at { DateTime.now.utc }
  end
end
