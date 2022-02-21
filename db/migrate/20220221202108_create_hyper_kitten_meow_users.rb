class CreateHyperKittenMeowUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :hyper_kitten_meow_users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_digest

      t.timestamps

      t.index :email, unique: true
    end
  end
end
