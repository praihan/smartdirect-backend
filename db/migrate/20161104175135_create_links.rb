class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.belongs_to :directory, index: true

      t.string :name, index: true

      # the destination URL
      t.string :destination
      # The desired TTL in a cache
      t.integer :ttl, default: 0

      t.timestamps
    end
  end
end
