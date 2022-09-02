# frozen_string_literal: true

class Types::Base::Union < GraphQL::Schema::Union
  edge_type_class(Types::Base::Edge)
  connection_type_class(Types::Base::Connection)
end
