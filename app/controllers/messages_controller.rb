class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @message = Message.new
  end

  def create
    begin
      @chat = current_user.chats.find(params[:chat_id])
      @message = @chat.messages.create(message_params.merge(role: "user"))

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
    rescue => e
      respond_to do |format|
        format.html { redirect_to chat_path(@chat), alert: "エラーが発生しました" }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
