module Errors
  class ApplicationError < RuntimeError
    include ActsAsError
  end
end