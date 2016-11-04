class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.belongs_to :directory, index: true

      t.timestamps
    end
  end
end
