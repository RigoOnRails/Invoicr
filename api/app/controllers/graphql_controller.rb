# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      viewer: current_user_from_token,
      request:
    }
    result = ApplicationSchema.execute(query, variables:, context:, operation_name:)
    render(json: result)
  rescue StandardError => e
    raise(e) unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

    def bearer_token
      pattern = /^Bearer /
      header = request.headers['Authorization']
      result = Base64.strict_decode64(header.gsub(pattern, '')) if header&.match(pattern)

      if result
        result.force_encoding('UTF-8').ascii_only? ? result : nil
      end
    rescue ArgumentError
      nil
    end

    def current_user_from_token
      return unless bearer_token

      email = bearer_token.split(':')&.first
      authentication_token = bearer_token.split(':')&.last

      # If user was not found, return nothing
      return unless (user = User.find_by(email:))

      # Return user if authentication_tokens match
      user if Devise.secure_compare(user.authentication_token, authentication_token)
    end

    # Handle variables in form data, JSON body, or a blank value
    def prepare_variables(variables_param)
      case variables_param
      when String
        if variables_param.present?
          JSON.parse(variables_param) || {}
        else
          {}
        end
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
      when nil
        {}
      else
        raise(ArgumentError, "Unexpected parameter: #{variables_param}")
      end
    end

    def handle_error_in_development(error)
      logger.error(error.message)
      logger.error(error.backtrace.join("\n"))

      render({
        json: { errors: [{ message: error.message, backtrace: error.backtrace }], data: {} },
        status: :internal_server_error
      })
    end
end
