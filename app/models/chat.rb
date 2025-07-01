class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :ai_character
  has_many :messages, dependent: :destroy

  # チャットごとの背景画像
  has_one_attached :background_image

  # 現在の背景画像ID（ActiveStorage::Blobのidを保存）
  # 例: current_background_image_id:string

  validate :user_chat_limit, on: :create
  validates :ai_character_id, uniqueness: { scope: :user_id, message: "は既にこのユーザーのチャットで使われています" }

  def current_background_image
    return nil if current_background_image_id.blank?
    user.background_images.find_by(blob_id: current_background_image_id)
  end

  private

  def user_chat_limit
    if user && user.chats.count >= 5
      errors.add(:base, "チャット作成は最大5件までです")
    end
  end
end 