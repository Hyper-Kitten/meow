class CreateHyperKittenMeowPageContentBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :hyper_kitten_meow_page_content_blocks do |t|
      t.references :page, foreign_key: { to_table: :hyper_kitten_meow_pages }
      t.references :content_block, foreign_key: { to_table: :hyper_kitten_meow_content_blocks }

      t.timestamps
    end

    add_index :hyper_kitten_meow_page_content_blocks, [:page_id, :content_block_id], unique: true, name: "hyper_kitten_meow_index_page_content_block_ids" 
  end
end
