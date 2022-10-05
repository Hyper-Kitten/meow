class CreateHyperKittenMeowMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :hyper_kitten_meow_menu_items do |t|
      t.references :page, null: false, foreign_key: { to_table: :hyper_kitten_meow_pages }
      t.references :menu, null: false, foreign_key: { to_table: :hyper_kitten_meow_menus }
      t.string :title
      t.string :url
      t.integer :position

      t.timestamps
    end
  end
end
