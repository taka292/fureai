class AiCharacter < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  
  # ActiveStorageで画像を添付
  has_one_attached :avatar
  
  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { scope: :user_id, message: "は既に登録されています" }
  validates :personality, presence: true, length: { maximum: 1000 }
  
  # ActiveStorageのバリデーション
  validate :acceptable_avatar
  
  private
  
  def acceptable_avatar
    return unless avatar.attached?
    
    unless avatar.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:avatar, 'はPNG、JPG、JPEG形式のみアップロード可能です')
    end
    
    unless avatar.byte_size <= 5.megabytes
      errors.add(:avatar, 'は5MB以下にしてください')
    end
  end
end 