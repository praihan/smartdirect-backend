class CreateDirectories < ActiveRecord::Migration[5.0]
  def change
    create_table :directories do |t|
      t.belongs_to :link_system, index: true
      t.ltree :path
      t.timestamps
    end

    # Of course, we gotta index on path. We're going to be searching with it
    # all the time! Since we will only really search in conjunction with a user's
    # LinkSystem, it's nice to index that too.
    add_index :directories, [:link_system_id, :path], using: :btree
  end
end
