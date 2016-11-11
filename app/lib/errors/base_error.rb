module Errors
  class BaseError < StandardError
    attr_reader :group, :severity, :userdata

    def initialize(group:, message:, severity:, userdata: nil)
      super message
      @group = group
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