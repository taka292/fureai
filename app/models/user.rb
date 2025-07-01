class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :chats, dependent: :destroy
  has_many :ai_characters, dependent: :destroy
  has_many_attached :background_images
end
