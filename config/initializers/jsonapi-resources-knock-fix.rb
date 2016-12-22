# https://github.com/nsarno/knock/issues/5
# https://github.com/cerebris/jsonapi-resources/issues/450
# Note a fix has been merged but not released yet
module JSONAPI
  class LinkBuilder
    private

    def build_engine_name
      scopes = module_scopes_from_class(primary_resource_klass)

      unless scopes.empty?
        begin
          "#{ scopes.first.to_s.camelize }::Engine".safe_constantize
        rescue LoadError => e
        end
      end
    end
  end
end