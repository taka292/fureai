class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  enum role: { system: 0, assistant: 10, user: 20 }
  belongs_to :chat
  belongs_to :user, optional: true

  # バリデーション
  validates :content,
            presence: true,
            length: {
              minimum: 1,
              maximum: 10000,
              too_short: "メッセージを入力してください",
              too_long: "メッセージは10,000文字以内で入力してください"
            }
  validates :role, presence: true
  validates :chat_id, presence: true

  # メッセージをOpenAIのAPI用のフォーマットに変換するメソッド(パフォーマンスを考慮し、プロンプト等のsystemメッセージは先頭に、それ以外は最新の50件を取得)
  def self.for_openai(messages)
    # 最初のメッセージからチャットとAIキャラクターを取得
    chat = messages.first.chat
    ai_character = chat.ai_character

    # ベースプロンプト（環境変数 or デフォルト）
    base_prompt = ENV["OPENAI_SYSTEM_PROMPT"] || "あなたは親切で丁寧なアシスタントです。"
    # キャラクターごとのpersonalityを追記
    personality_prompt = ai_character.personality.present? ? "\n\n#{ai_character.personality}" : ""

    system_prompt = {
      role: "system",
      content: base_prompt + personality_prompt
    }

    [ system_prompt ] + messages.map { |message| { role: message.role, content: message.content } }
  end

  # メッセージを作成したら、チャットのmessagesに追加するメソッド
  def broadcast_created
    # 指定したターゲット（DOM ID）に、新しいメッセージ（パーシャル）を後で追加（append）するという命令
    broadcast_append_later_to(
      "#{dom_id(chat)}_messages", # チャットのmessagesのDOM ID
      partial: "messages/message", # パーシャルのパス
      locals: { message: self, scroll_to: true }, # パーシャルに渡すローカル変数(メッセージとスクロールの設定)
      target: "#{dom_id(chat)}_messages" # パーシャルのターゲット(チャットのmessagesのDOM ID)
    )
  end

  def broadcast_updated
    broadcast_replace_later_to(
      "#{dom_id(chat)}_messages",
      partial: "messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(self)}_messages"
    )
  end
end
