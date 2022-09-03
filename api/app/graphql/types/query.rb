# frozen_string_literal: true

class Types::Query < Types::Base::Object
  # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
  include GraphQL::Types::Relay::HasNodeField
  include GraphQL::Types::Relay::HasNodesField

  field :viewer, Types::User, 'The currently authenticated user.', null: true

  def viewer
    context[:viewer]
  end
end
