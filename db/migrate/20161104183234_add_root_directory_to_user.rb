class AddRootDirectoryToUser < ActiveRecord::Migration[5.0]
  def change
    # We don't need to index this. This is the ROOT directory for the user
    add_reference :users, :link_directory, index: false
  end
end
