class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [ :create ]

  def new
    @message = Message.new
  end

  def create
    @message = @chat.messages.build(message_params.merge(role: "user"))

    if @message.save
      respond_to do |format|
        format.html do
          redirect_to chat_path(@chat)
        end
        format.json do
          render json: {
            success: true,
            html: render_to_string(partial: "messages/message",
                                  locals: { message: @message, scroll_to: true },
                                  formats: [ :html ])
          }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to chat_path(@chat), alert: @message.errors.full_messages.join(", ") }
        format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to chats_path, alert: "チャットが見つかりません" }
      format.json { render json: { error: "チャットが見つかりません" }, status: :not_found }
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
