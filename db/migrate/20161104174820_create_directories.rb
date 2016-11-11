class CreateDirectories < ActiveRecord::Migration[5.0]
  def change
    create_table :directories do |t|
      t.belongs_to :link_system
      t.string :name

      # This is required for the closure table gem
      t.integer :parent_id

      t.timestamps
    end

    # We are going to index on LinkSystem + name because we will need to
    # look for specific paths under a specific user when they modify it or
    # we have to look up the link to direct to
    add_index :directories, [:link_system_id, :name], using: :btree

    # We also need to index on name since we sort on this column.
    # Also it's unique!
    add_index :directories, :name, :unique => true
  end
end
