# frozen_string_literal: true

require 'graphql/helpers'

RSpec::Matchers.define(:have_graphql_name) do |name|
  match do |klass|
    klass.graphql_name == name
  end
end

RSpec::Matchers.define(:have_graphql_type) do |expected|
  match do |field|
    field.type == expected
  end
end

RSpec::Matchers.define(:have_graphql_fields) do |*expected|
  def expected_field_names
    expected.map { |name| GraphqlHelpers.fieldnamerize(name) }
  end

  match do |klass|
    klass.fields.keys.to_set == expected_field_names.to_set
  end

  failure_message do |klass|
    missing = expected_field_names - klass.fields.keys
    extra = klass.fields.keys - expected_field_names

    message = []

    message << "is missing fields: <#{missing.inspect}>" if missing.any?
    message << "contained unexpected fields: <#{extra.inspect}>" if extra.any?

    message.join("\n")
  end

  match_when_negated do |klass|
    return expected_field_names.none? { |name| klass.fields.key?(name) } if expected.any?

    klass.fields.keys.empty?
  end

  failure_message_when_negated do |klass|
    unexpected = klass.fields.keys & expected_field_names

    message = []
    message << "contained unexpected fields: <#{extra.inspect}>" if unexpected.any?
    message.join("\n")
  end
end

RSpec::Matchers.define(:have_graphql_field) do |field_name|
  match do |klass|
    klass.fields.key?(GraphqlHelpers.fieldnamerize(field_name))
  end
end

RSpec::Matchers.define(:have_graphql_arguments) do |*expected|
  def expected_argument_names
    expected.map { |name| GraphqlHelpers.fieldnamerize(name) }
  end

  match do |field|
    field.arguments.keys.to_set == expected_argument_names.to_set
  end

  failure_message do |field|
    missing = expected_argument_names - field.arguments.keys
    extra = field.arguments.keys - expected_argument_names

    message = []

    message << "is missing arguments: <#{missing.inspect}>" if missing.any?
    message << "contained unexpected arguments: <#{extra.inspect}>" if extra.any?

    message.join("\n")
  end

  match_when_negated do |field|
    return expected_argument_names.none? { |name| field.arguments.key?(name) } if expected.any?

    field.arguments.keys.empty?
  end

  failure_message_when_negated do |field|
    unexpected = field.arguments.keys & expected_argument_names

    message = []
    message << "contained unexpected arguments: <#{extra.inspect}>" if unexpected.any?
    message.join("\n")
  end
end

RSpec::Matchers.define(:have_graphql_argument) do |argument_name|
  match do |klass|
    klass.arguments.key?(GraphqlHelpers.fieldnamerize(argument_name))
  end
end
