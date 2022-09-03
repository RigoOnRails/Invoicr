# frozen_string_literal: true

module GraphqlHelpers
  # Makes an underscored string look like a fieldname
  # "merge_request" => "mergeRequest"
  def self.fieldnamerize(underscored_field_name)
    graphql_field_name = underscored_field_name.to_s.camelize
    graphql_field_name[0] = graphql_field_name[0].downcase

    graphql_field_name
  end
end
