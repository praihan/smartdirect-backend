class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      # identifiable_claim refers to the 'sub' claim in a jwt
      # it will be used to identify a user via a jwt
      # however, the primary key is still :id
      t.string :identifiable_claim

      t.belongs_to :directory

      # these are two columns that should *never* be used to identify a user.
      # They are simply additional information
      t.string :email
      t.string :name

      # this should also never be used to identify the user. This is the "user name"
      # that should be in the URL instead of the user's id when looking it up publicly.
      t.string :friendly_name

      t.timestamps
    end

    add_index :users, :identifiable_claim, :unique => true
    add_index :users, :friendly_name, :unique => true
  end
end
