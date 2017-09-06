class Linkation < ApplicationRecord
  # Every file has a directory that owns it. Top level files
  # are owned by the ROOT directory of the user
  belongs_to :directory

  # We can't do anything with an orphaned file
  validates_presence_of :directory

  # Validation for name is a little complex...
  validate :_validate_name

  def _validate_name
    # Basic checks:
    #   1. Pass the name regex
    #   2. Name isn't too damn long
    # If either check fails, then we can stop further checking
    max_linkation_name_length = Settings[:app][:max_linkation_name_length]
    if name.length > max_linkation_name_length
      errors.add(:name, 'value exceeds maximum allowed length')
      return
    end
    valid_linkation_name_regex = /#{Settings[:app][:valid_linkation_name_regex]}/
    unless valid_linkation_name_regex =~ name
      # It's okay to be vague
      errors.add(:name, 'value must be a valid linkation name')
      return
    end
    # Make sure my siblings don't have the same name as me (CASE-INSENSITIVE)
    siblings_scope = Linkation.where(directory_id: directory_id)
    duplicate_found = siblings_scope.any? do |s|
      s.id != id and s.name.casecmp(name) == 0
    end
    if duplicate_found
      errors.add(:name, 'already have a sibling with the same value')
    end
  end

  # destination is a url limited by the whitelisted protocols
  validates :destination, url: { schemes: %w(http https ftp ssh) }
end
