# frozen_string_literal: true

class Mutations::Auth::SignUp < Mutations::Base::Mutation
  graphql_name 'AuthSignUp'
  description 'Creates an account with the provided credentials.'

  null true

  argument :email, String, "The user's email address.", required: true
  argument :password, String, "The user's password.", required: true

  field :authentication_token, String, "The user's authentication token.", null: true
  field :user, Types::User, 'The newly registered user.', null: true

  def ready?(*)
    raise(NotAuthorizedError, I18n.t('errors.auth.already_registered')) if context[:viewer].present?

    true
  end

  def resolve(email:, password:)
    # Build user, but don't save yet
    user = User.new(email:, password:)

    # Set trackable attributes
    user.update_tracked_fields(context[:request])

    # Finally, save user
    user.save!

    { authentication_token: user.authentication_token, user: }
  end
end
