class CreateHyperKittenMeowMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :hyper_kitten_meow_menus do |t|
      t.string :key, null: false
      t.timestamps
      t.index :key, unique: true
    end

    create_table :hyper_kitten_meow_menu_items do |t|
      t.references :menu, null: false,
        foreign_key: {to_table: :hyper_kitten_meow_menus, on_delete: :cascade}
      t.references :parent,
        foreign_key: {to_table: :hyper_kitten_meow_menu_items, on_delete: :cascade}
      t.integer :position, null: false
      t.string :label
      t.references :page,
        foreign_key: {to_table: :hyper_kitten_meow_pages, on_delete: :nullify}
      t.string :url
      t.timestamps
      t.index [:menu_id, :parent_id, :position]
    end
  end
end
