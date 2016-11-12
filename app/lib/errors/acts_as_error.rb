module Errors
  module ActsAsError
    attr_reader :action, :severity, :userdata

    def initialize(action:, message:, severity:, userdata: nil)
      super message
      @action = action
      @severity = severity
      @userdata = userdata
    end
  end
end