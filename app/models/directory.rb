class Directory < ApplicationRecord

  # A directory can contains other directories as well as files
  # Deleting is recursive
  has_many :links, dependent: :destroy
  belongs_to :link_system

  # Get the current user through the owning LinkSystem
  delegate :user, to: :link_system

  # Validation for name is a little complex...
  validate :_validate_name
  # We can't do anything with an orphaned directory
  validates_presence_of :link_system

  # A directory is modeled in the db using a closure table
  has_closure_tree(
      name_column: 'name', order: 'name',
      dependent: :destroy,
      parent_column_name: 'parent_id',
      with_advisory_lock: true
  )

  private

  def _validate_name
    if root?
      # Root nodes get a pass as long as name is empty string.
      # A root node is owned by a LinkSystem directory and has
      # no actual meaning to the user.
      if name != ''
        errors.add(:name, 'must be nil for root directory')
      end
      return
    end
    # Non-root nodes have to pass the name regex
    valid_directory_name_regex = /#{Settings[:app][:valid_directory_name_regex]}/
    unless valid_directory_name_regex =~ name
      # It's okay to be vague
      errors.add(:name, 'must be a valid directory name')
    end
  end
end
