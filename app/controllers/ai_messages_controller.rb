class AiMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.create(
      role: "assistant",
      content: message_params[:content]
    )

    render json: { success: true, message_id: @message.id }
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
