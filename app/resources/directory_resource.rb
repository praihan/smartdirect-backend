class DirectoryResource < ApplicationResource
  # A directory only has one User owner at a time
  # See the model, for how this is retrieved
  has_one :user

  attributes :full_path

  # Before we save, make sure we have our relationships properly set up
  before_save do
    @model.link_system_id = context[:user].link_system.id if @model.new_record?
  end
end
