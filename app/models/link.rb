class Link < ApplicationRecord
  # Every file has a directory that owns it. Top level files
  # are owned by the ROOT directory of the user
  belongs_to :directory

  # We can't do anything with an orphaned file
  validates_presence_of :directory

  # destination is a url limited by the whitelisted protocols
  validates :destination, url: { schemes: %w(http https ftp ssh) }
end
