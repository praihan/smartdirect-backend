JSONAPI.configure do |config|
  # Allowed values are :integer(default), :uuid, :string, or a proc
  config.resource_key_type = :uuid

  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]
end