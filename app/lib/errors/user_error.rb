module Errors
  class UserError < StandardError
    def initialize(msg)
      super msg
    end
  end
end