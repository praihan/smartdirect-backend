class ApplicationResource < JSONAPI::Resource
  abstract

  include JSONAPI::Authorization::PunditScopedResource
end