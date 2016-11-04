class LinkDirectory < ApplicationRecord
  # Only a ROOT directory will have a user attached to it
  belongs_to :user, optional: true

  # A directory can contains other directories as well as files
  # Deleting is recursive
  has_many :links, dependent: :destroy

  acts_as_nested_set dependent: :destroy
end
