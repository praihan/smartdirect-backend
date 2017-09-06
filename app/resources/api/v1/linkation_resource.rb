module Api
  module V1
    class LinkationResource < ApplicationResource
      # Parent
      has_one :directory

      # Timestamps (readonly)
      attributes :created_at, :updated_at

      # The links's name (not full path)
      attributes :name

      # The destination link
      attributes :destination

      def self.updatable_fields(context)
        return super - [:created_at, :updated_at]
      end
      def self.creatable_fields(context)
        return super - [:created_at, :updated_at]
      end
    end
  end
end
