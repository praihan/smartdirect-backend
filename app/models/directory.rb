class Directory < ApplicationRecord

  # A directory can contains other directories as well as files
  # Deleting is recursive
  has_many :links, dependent: :destroy
  belongs_to :user

  # We can't have a directory that belongs to user A
  # but with a parent directory that belongs to user B
  validate :_validate_same_user_as_parent
  # Validation for name is a little complex...
  validate :_validate_name

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
      # The name has no actual meaning to the user.
      if name != ''
        errors.add(:name, 'value must be empty for root directory')
      end
      return
    end
    # Non-root nodes have to pass the name regex
    valid_directory_name_regex = /#{Settings[:app][:valid_directory_name_regex]}/
    unless valid_directory_name_regex =~ name
      # It's okay to be vague
      errors.add(:name, 'value must be a valid directory name')
    end
    # Make sure my siblings don't have the same name as me (CASE-INSENSITIVE)
    # Also, if we have a parent related error, we risk letting out info about another
    # user if we check a sibling name
    if errors.messages[:parent].blank?
      sibling_names = siblings.pluck(:name)
      if sibling_names.any?{ |s| s.casecmp(name) == 0 }
        errors.add(:name, 'already have a sibling with the same value')
      end
    end
  end

  def _validate_same_user_as_parent
    if parent != nil && parent.user_id != user_id
      errors.add(:parent, 'directory must have a parent that is part of the same user\'s tree')
    end
  end
end
