class CreateLinkDirectories < ActiveRecord::Migration[5.0]
  def change
    create_table :link_directories do |t|

      # These columns are needed for the nested set pattern
      t.string :name
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
