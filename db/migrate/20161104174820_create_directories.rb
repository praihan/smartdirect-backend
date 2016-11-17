class CreateDirectories < ActiveRecord::Migration[5.0]
  def change
    create_table :directories do |t|
      t.belongs_to :user, index: true
      # We're indexing name because we'll be sorting by it
      t.string :name, index: true

      # This is required for the closure table gem
      t.integer :parent_id

      t.timestamps
    end
  end
end
