class CreateLinkDirectories < ActiveRecord::Migration[5.0]
  def change
    create_table :link_directories do |t|
      t.ltree :path
      t.timestamps
    end

    add_index :link_directories, :path, using: :btree
  end
end
