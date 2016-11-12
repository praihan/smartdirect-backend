module Errors
  class ApplicationError < RuntimeError
    include Errors::ActsAsError
  end
end