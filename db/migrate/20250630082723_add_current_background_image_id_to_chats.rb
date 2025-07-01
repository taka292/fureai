class AddCurrentBackgroundImageIdToChats < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :current_background_image_id, :string
  end
end
