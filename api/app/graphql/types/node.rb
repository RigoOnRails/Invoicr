# frozen_string_literal: true

module Types::Node
  include Types::Base::Interface
  # Add the `id` field
  include GraphQL::Types::Relay::NodeBehaviors
end
