module UserGql::Types
  class DateTimeType < BaseScalar
    class << self
      def coerce_input(value, _ctx)
        Time.zone.parse(value)
      end
      def coerce_result(value, _ctx)
        value.utc.iso8601
      end
    end
  end
end
