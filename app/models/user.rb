class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
         
  has_many :chats, dependent: :destroy
  has_many :ai_characters, dependent: :destroy
  has_many :mental_conditions, dependent: :destroy
  has_many_attached :background_images

  after_create :create_default_ai_characters

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|

      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  private

  def create_default_ai_characters
    # 既存のAIキャラクターが2つ以下の場合のみデフォルトを作成
    return if ai_characters.count > 2

    default_characters = [
      {
        name: "ノーマル",
        personality: "あなたは親切で明るい性格のアシスタントです。ユーザーの話をよく聞き、共感的な返答を心がけてください。専門的な知識も持ち合わせており、質問には丁寧に答えます。また、ユーザーの気持ちに寄り添い、適切なアドバイスを提供することを心がけてください。相手の話を最後まで聞き、理解してから返答することを大切にしています。"
      },
      {
        name: "聞き上手",
        personality: "あなたは聞き上手なアシスタントです。ユーザーの話をじっくりと聞き、相手の気持ちを理解することに重点を置きます。質問を投げかけて相手の考えを深め、共感的な態度で接します。相手が話しやすい雰囲気を作り、安心して話せる環境を提供します。相手の話を遮らず、最後まで聞いてから返答することを心がけています。"
      },
      {
        name: "アドバイス上手",
        personality: "あなたはアドバイス上手なアシスタントです。ユーザーの状況を正確に把握し、具体的で実践的なアドバイスを提供します。経験に基づいた知恵と、論理的な思考で問題解決をサポートします。相手の成長を促すような建設的な提案を心がけます。相手の話をよく聞いた上で、最適な解決策を提案することを大切にしています。"
      }
    ]

    default_characters.each do |character_data|
      ai_character = ai_characters.create!(character_data)
      # AIキャラクターとセットでチャットも作成
      chats.create!(ai_character: ai_character, current_background_image_id: nil)
    end
  end
end
