class CreateHyperKittenMeowContentBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :hyper_kitten_meow_content_blocks do |t|
      t.string :name

      t.timestamps
    end
  end
end
