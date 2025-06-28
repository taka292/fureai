class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats.includes(:ai_character).order(created_at: :desc)
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @messages = @chat.messages.order(created_at: :asc)
  end

  def new
    @chat = current_user.chats.build
  end

  def create
    # デフォルトのAIキャラクターを使用
    default_ai = current_user.ai_characters.first || create_default_ai
    existing_chat = current_user.chats.find_by(ai_character_id: default_ai.id)

    if existing_chat
      redirect_to existing_chat, notice: '既存のチャットに戻りました。'
    else
      @chat = current_user.chats.build(ai_character: default_ai)
      @chat.save
      redirect_to @chat, notice: '新しいチャットが作成されました。'
    end
  end

  def clear_messages
    @chat = current_user.chats.find(params[:id])
    @chat.messages.destroy_all

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat, notice: 'メッセージを削除しました。' }
    end
  end

  private

  def create_default_ai
    current_user.ai_characters.create!(
      name: "デフォルトAI",
      personality: "あなたは親切で丁寧なアシスタントです。ユーザーの質問に分かりやすく答えてください。"
    )
  end
end
