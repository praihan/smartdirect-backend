module Errors
  class BaseError < StandardError
    attr_reader :action, :severity, :userdata

    def initialize(action:, message:, severity:, userdata: nil)
      super message
      @action = action
      @severity = severity
      @userdata = userdata
    end
  end

  module Severity
    CRITICAL = 'critical'
    MAJOR = 'major'
    MINOR = 'minor'
  end

  # Make the severities under Errors:: as well
  include Severity
end