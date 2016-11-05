class DirectoryResource < ApplicationResource
  attributes :hello

  # A directory only has one User owner at a time
  # See the model, for how this is retrieved
  has_one :user

  def hello
    'World'
  end
end
