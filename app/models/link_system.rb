class LinkSystem < ApplicationRecord

  belongs_to :user

  # This is the ROOT directory that belongs to the owner of this system.
  has_one :directory
  before_create :build_default_root_directory

  private

  def build_default_root_directory
    # Over here, we create the ROOT directory for a user.
    # This directory doesn't really have a name so we choose a default
    build_directory path: Settings[:default_root_directory_name]
    return true
  end
end
