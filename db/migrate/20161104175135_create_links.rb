class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.belongs_to :link_directory, index: true

      t.timestamps
    end
  end
end
