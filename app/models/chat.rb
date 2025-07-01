class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :ai_character
  has_many :messages, dependent: :destroy

  # チャットごとの背景画像
  has_one_attached :background_image

  # 現在の背景画像ID（ActiveStorage::Blobのidを保存）
  # 例: current_background_image_id:string

  def current_background_image
    return nil if current_background_image_id.blank?
    user.background_images.find_by(blob_id: current_background_image_id)
  end
end 