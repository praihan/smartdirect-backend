module Api
  module V1
    class ApplicationResource < JSONAPI::Resource
      abstract

      include JSONAPI::Authorization::PunditScopedResource
    end
  end
end
