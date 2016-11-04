class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      # identifiable_claim refers to the 'sub' claim in a jwt
      # it will be used to identify a user via a jwt
      # however, the primary key is still :id
      t.string :identifiable_claim

      t.belongs_to :directory, index: false

      t.timestamps
    end

    add_index :users, :identifiable_claim, :unique => true
  end
end
