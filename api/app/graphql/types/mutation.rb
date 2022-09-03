# frozen_string_literal: true

class Types::Mutation < Types::Base::Object
  field :auth_sign_up, mutation: Mutations::Auth::SignUp
end
