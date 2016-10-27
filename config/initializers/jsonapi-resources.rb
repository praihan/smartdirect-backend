JSONAPI.configure do |config|
  # Allowed values are :integer(default), :uuid, :string, or a proc
  config.resource_key_type = :uuid

  # Hook up jsonapi-authorization and Pundit
  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]

  # pagination settings
  config.default_page_size = 10
  config.maximum_page_size = 30
end