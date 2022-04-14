class RemoveActiveStorage < ActiveRecord::Migration[7.0]
  def change
    drop_table "action_text_rich_texts"
    drop_table "active_storage_attachments"
  end
end
