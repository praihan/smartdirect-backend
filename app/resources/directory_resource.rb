class DirectoryResource < ApplicationResource
  # A directory only has one User owner at a time
  # See the model, for how this is retrieved
  has_one :user

  attributes :name
  attributes :depth

  # attributes :parent_id
  has_one :parent, class_name: 'Directory'
  has_many :children, class_name: 'Directory'

  def self.updatable_fields(context)
    return super - [:depth, :children]
  end
  def self.creatable_fields(context)
    return super - [:depth, :children]
  end


  # Before we save, make sure we have our relationships properly set up
  # TODO: create an exception, whitelist it, and use rescue_from
  before_save do
    parent = @model.parent
    # This nil checking is critical in making sure that the user is not allowed to
    # create ROOT directories through the API
    if parent == nil
      raise StandardError.new('cannot have a directory without a parent')
    end
    user_link_system_id = context[:user].link_system.id
    # Although this is checked at the ActiveRecord model level, error messages from there
    # are too descriptive. This is because an ID might exist but the user might not be the
    # owner of that directory. Our model will complain about this...but now the user knows
    # that an ID is taken (gasp). So we don't let them know.
    unless user_link_system_id == parent.link_system_id
      raise StandardError.new("cannot find parent with id '#{parent.link_system_id}'")
    end
    # Make sure that the user that is creating is the owner. But we only need to do this
    # on create - we don't change this anywhere else
    @model.link_system_id = user_link_system_id if @model.new_record?
  end
end
