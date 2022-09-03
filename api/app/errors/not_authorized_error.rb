# frozen_string_literal: true

class NotAuthorizedError < StandardError
  def initialize(message = nil)
    super(message || t('errors.not_authorized'))
  end
end
