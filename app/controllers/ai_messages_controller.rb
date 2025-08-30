class AiMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.create(
      role: "assistant",
      content: params[:message][:content]
    )

    render json: { success: true, message_id: @message.id }
  end
end
