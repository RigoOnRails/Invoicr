# frozen_string_literal: true

class Types::User < Types::Base::Object
  field :id, ID, null: false
  field :email, String, null: false
  field :name, String, null: false
end
