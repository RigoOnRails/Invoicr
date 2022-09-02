# frozen_string_literal: true

class Types::Query < Types::Base::Object
  # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
  include GraphQL::Types::Relay::HasNodeField
  include GraphQL::Types::Relay::HasNodesField

  # Add root-level fields here.
  # They will be entry points for queries on your schema.
end
