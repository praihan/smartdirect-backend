module Errors
  class ResourceError < JSONAPI::Exceptions::Error
    include Errors::ActsAsError
    attr_reader :code, :status

    def initialize(action:, message:, severity: Errors::Severity::MINOR, userdata: nil, code:, status: :bad_request)
      super action: action, message: message, severity: severity, userdata: userdata
      @code = code
      @status = status
    end

    def errors
      return [
          JSONAPI::Error.new(
              code: code,
              status: status,
              title: "#{action} failed",
              detail: message
          )
      ]
    end
  end
end