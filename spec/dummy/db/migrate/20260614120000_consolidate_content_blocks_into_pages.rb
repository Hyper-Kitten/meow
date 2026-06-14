class ConsolidateContentBlocksIntoPages < ActiveRecord::Migration[7.2]
  def up
    add_reference :hyper_kitten_meow_content_blocks, :page,
      foreign_key: {to_table: :hyper_kitten_meow_pages}

    if table_exists?(:hyper_kitten_meow_page_content_blocks)
      execute(<<~SQL)
        UPDATE hyper_kitten_meow_content_blocks AS cb
        SET page_id = pcb.page_id
        FROM hyper_kitten_meow_page_content_blocks AS pcb
        WHERE pcb.content_block_id = cb.id
      SQL

      drop_table :hyper_kitten_meow_page_content_blocks
    end

    add_index :hyper_kitten_meow_content_blocks, [:page_id, :name], unique: true
  end

  def down
    remove_index :hyper_kitten_meow_content_blocks, [:page_id, :name]

    create_table :hyper_kitten_meow_page_content_blocks do |t|
      t.bigint :page_id
      t.bigint :content_block_id
      t.timestamps
    end
    add_index :hyper_kitten_meow_page_content_blocks, :content_block_id,
      name: "index_hyper_kitten_meow_page_content_blocks_on_content_block_id"
    add_index :hyper_kitten_meow_page_content_blocks, [:page_id, :content_block_id],
      unique: true, name: "hyper_kitten_meow_index_page_content_block_ids"
    add_index :hyper_kitten_meow_page_content_blocks, :page_id,
      name: "index_hyper_kitten_meow_page_content_blocks_on_page_id"
    add_foreign_key :hyper_kitten_meow_page_content_blocks,
      :hyper_kitten_meow_content_blocks, column: :content_block_id
    add_foreign_key :hyper_kitten_meow_page_content_blocks,
      :hyper_kitten_meow_pages, column: :page_id

    execute(<<~SQL)
      INSERT INTO hyper_kitten_meow_page_content_blocks (page_id, content_block_id, created_at, updated_at)
      SELECT page_id, id, NOW(), NOW()
      FROM hyper_kitten_meow_content_blocks
      WHERE page_id IS NOT NULL
    SQL

    remove_reference :hyper_kitten_meow_content_blocks, :page,
      foreign_key: {to_table: :hyper_kitten_meow_pages}
  end
end
