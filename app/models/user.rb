class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
         
  has_many :chats, dependent: :destroy
  has_many :ai_characters, dependent: :destroy
  has_many_attached :background_images

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|

      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
end
