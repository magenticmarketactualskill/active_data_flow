# frozen_string_literal: true

module Submoduler
  # Represents the result of a validation check
  class ValidationResult
    attr_reader :submodule_name, :check_type, :status, :message

    def initialize(submodule_name:, check_type:, status:, message: nil)
      @submodule_name = submodule_name
      @check_type = check_type
      @status = status # :pass or :fail
      @message = message
    end

    def passed?
      @status == :pass
    end

    def failed?
      @status == :fail
    end
  end
end
