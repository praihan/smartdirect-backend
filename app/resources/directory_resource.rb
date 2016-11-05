class DirectoryResource < ApplicationResource
  # A directory only has one User owner at a time
  # See the model, for how this is retrieved
  has_one :user

  attributes :full_path

  before_create :sanitize_create_and_update_params

  def sanitize_create_and_update_params
    return
  end
end
