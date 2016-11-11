class DirectoryResource < ApplicationResource
  # A directory only has one User owner at a time
  # See the model, for how this is retrieved
  has_one :user

  attributes :name
  attributes :depth

  # TODO: will this work?
  # has_one :parent

  def self.updatable_fields(context)
    return super - [:depth]
  end
  def self.creatable_fields(context)
    return super - [:depth]
  end


  # Before we save, make sure we have our relationships properly set up
  before_save do
    @model.link_system_id = context[:user].link_system.id if @model.new_record?
  end
end
