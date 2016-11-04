class CreateLinkDirectories < ActiveRecord::Migration[5.0]
  def change
    create_table :link_directories do |t|
      t.ltree :path
      t.timestamps
    end

    # Of course, we gotta index on path. We're going to be searching with it
    # all the time!
    add_index :link_directories, :path, using: :btree
  end
end
