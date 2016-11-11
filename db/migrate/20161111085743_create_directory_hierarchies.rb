class CreateDirectoryHierarchies < ActiveRecord::Migration
  def change
    create_table :directory_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :directory_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "directory_anc_desc_idx"

    add_index :directory_hierarchies, [:descendant_id],
      name: "directory_desc_idx"
  end
end
