class CreateHyperKittenMeowPages < ActiveRecord::Migration[7.0]
  def change
    create_table :hyper_kitten_meow_pages do |t|
      t.string :title
      t.boolean :published, null: false, default: false
      t.datetime :published_at
      t.text :body
      t.string :slug
      t.string :template

      t.timestamps

      t.index :slug, unique: true
    end
  end
end
