class GetAiResponse
  include Sidekiq::Worker
  RESPONSES_PER_MESSAGE = 1
  MODEL_NAME = "gpt-4o-mini"
  TEMPERATURE = 0.8

  # ジョブを実行するメソッド
  def perform(chat_id)
    chat = Chat.find(chat_id)
    call_openai(chat)
  end

  private

  # チャットの応答を取得するメソッド
  def call_openai(chat)
    OpenAI::Client.new.chat(
      parameters: {
        model: MODEL_NAME,
        messages: Message.for_openai(chat.messages.order(created_at: :asc)), # フォーマットをAPI用のフォーマットに変換する
        temperature: TEMPERATURE,
        stream: stream_proc(chat), # stream_procメソッドでストリーミングデータを処理
        n: RESPONSES_PER_MESSAGE
      }
    )
  end

  # メッセージを作成するメソッド
  def create_messages(chat)
    Array.new(RESPONSES_PER_MESSAGE) do |i|
      message = chat.messages.create(role: "assistant", content: "", response_number: i) # Messageに保存する
      message.broadcast_created # 新しいメッセージが作成された後に、そのメッセージに対して broadcast_created メソッドが呼び出される
      message
    end
  end

  # ストリーミングデータを処理し、都度dbにupdateしていくメソッド
  def stream_proc(chat)
    messages = create_messages(chat)
    proc do |chunk, _bytesize|
      new_content = chunk.dig("choices", 0, "delta", "content")
      message = messages.find { |m| m.response_number == chunk.dig("choices", 0, "index") }
      message.update(content: message.content + new_content) if new_content
    end
  end
end
