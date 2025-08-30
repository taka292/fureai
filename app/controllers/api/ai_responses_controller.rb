class Api::AiResponsesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = Chat.find(params[:chat_id])

    begin
      # OpenAI APIを通常モードで呼び出し
      client = OpenAI::Client.new

      messages = Message.for_openai(@chat.messages.order(created_at: :asc))

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: messages,
          temperature: 0.8
        }
      )

      content = response.dig("choices", 0, "message", "content")

      render json: { content: content }
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
