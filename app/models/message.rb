class Message < ApplicationRecord
  include ActionView::RecordIdentifier
  after_create_commit -> { broadcast_created }
  after_update_commit -> { broadcast_updated }

  enum role: { system: 0, assistant: 10, user: 20 }
  belongs_to :chat
  belongs_to :user, optional: true

  # メッセージをOpenAIのAPI用のフォーマットに変換するメソッド(パフォーマンスを考慮し、プロンプト等のsystemメッセージは先頭に、それ以外は最新の50件を取得)
  def self.for_openai(messages)
    system_prompt = {
      role: "system",
      # contentはenvファイルから取得
      content: ENV["OPENAI_SYSTEM_PROMPT"]
    }
    [system_prompt] + messages.map { |message| { role: message.role, content: message.content } }
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
    broadcast_append_to(
      "#{dom_id(chat)}_messages",
      partial: "messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(chat)}_messages"
    )
  end

end 