# frozen_string_literal: true

class Types::Base::Field < GraphQL::Schema::Field
  argument_class Types::Base::Argument
end
