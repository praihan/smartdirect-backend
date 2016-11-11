class LinkSystem < ApplicationRecord

  belongs_to :user

  # This is the ROOT directory that belongs to the owner of this system.
  has_one :directory
  before_create :build_root_directory

  private

  def build_root_directory
    # Over here, we create the ROOT directory for a user.
    # This directory doesn't really have a name so we choose empty string
    build_directory name: ''
    return true
  end

  # If the LinkSystem doesn't have a Directory, it's useless
  validates_associated :directory
end
