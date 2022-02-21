class CreateHyperKittenMeowPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :hyper_kitten_meow_posts do |t|
      t.string :title
      t.boolean :published, null: false, default: false
      t.datetime :published_at
      t.text :summary
      t.string :slug
      t.references :user, foreign_key: { to_table: :hyper_kitten_meow_users }

      t.timestamps

      t.index :slug, unique: true
    end
  end
end
