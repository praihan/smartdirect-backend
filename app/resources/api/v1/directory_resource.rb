module Api
  module V1
    class DirectoryResource < ApplicationResource
      # A directory only has one User owner at a time
      # See the model, for how this is retrieved
      has_one :user

      # The directory's name (not full path)
      attributes :name

      # Tree relations
      has_one :parent, class_name: 'Directory'
      has_many :children, class_name: 'Directory'

      # Timestamps (readonly)
      attributes :created_at, :updated_at

      def self.updatable_fields(context)
        return super - [:children, :created_at, :updated_at]
      end
      def self.creatable_fields(context)
        return super - [:children, :created_at, :updated_at]
      end

      # Before we save, make sure we have our relationships properly set up
      # TODO: whitelist exception, and use rescue_from
      before_save do
        parent = @model.parent
        action = @model.new_record? ? 'create' : 'update'
        user_id = context[:user].id
        # Although this is checked at the ActiveRecord model level, error messages from there
        # are too descriptive. This is because an ID might exist but the user might not be the
        # owner of that directory. Our model will complain about this...but now the user knows
        # that an ID is taken (gasp). So we don't let them know.
        # This nil checking is critical in making sure that the user is not allowed to
        # create ROOT directories through the API
        if parent == nil || user_id != parent.user_id
          parent_id = @model.parent_id
          raise Errors::ResourceError.new(
              action: "#{action.camelcase} DirectoryResource",
              message: "Cannot find parent directory with #{parent_id == nil ? 'no id' : "id '#{parent_id}'"}",
              severity: Errors::Severity::MINOR,
              code: JSONAPI::RECORD_NOT_FOUND,
              status: :not_found
          )
        end
        # Make sure that the user that is creating is the owner. But we only need to do this
        # on create - we don't change this anywhere else
        @model.user_id = user_id if @model.new_record?
      end
    end
  end
end

