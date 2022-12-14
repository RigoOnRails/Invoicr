# frozen_string_literal: true

class ApplicationSchema < GraphQL::Schema
  mutation(Types::Mutation)
  query(Types::Query)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  # def self.type_error(err, context)
  #   # if err.is_a?(GraphQL::InvalidNullError)
  #   #   # report to your bug tracker here
  #   #   return nil
  #   # end
  #   super
  # end

  # Union and Interface Resolution
  def self.resolve_type(_abstract_type, _obj, _ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, _type_definition, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end

  rescue_from(NotAuthorizedError) do |exception|
    extensions = {
      errorType: :USER_ERROR,
      errorClass: :AUTHORIZATION,
      errorDetails: { message: exception.message }
    }

    raise GraphQL::ExecutionError.new(exception.message, extensions:)
  end
end
