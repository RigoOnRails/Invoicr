# frozen_string_literal: true

module Types::Base::Interface
  include GraphQL::Schema::Interface
  edge_type_class(Types::Base::Edge)
  connection_type_class(Types::Base::Connection)

  field_class Types::Base::Field
end
