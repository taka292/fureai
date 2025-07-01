class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [
    :show, :clear_messages, :edit_background, :update_background,
    :delete_background_images, :destroy_selected_background_images
  ]

  def index
    @chats = current_user.chats.includes(:ai_character).order(created_at: :desc)
  end

  def show
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
    @chat.messages.destroy_all

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat, notice: 'メッセージを削除しました。' }
    end
  end

  def edit_background
    @background_images = current_user.background_images
  end

  def update_background
    # 1. 新しい画像のアップロードがあれば最優先
    if params[:user] && params[:user][:background_image]
      attachment = current_user.background_images.attach(params[:user][:background_image])
      if attachment.present?
        blob_id = attachment.last.blob_id
        @chat.update(current_background_image_id: blob_id)
      end

    # 2. 既存画像もしくは黒背景の選択
    elsif params[:background_image_blob_id].present?
      if params[:background_image_blob_id] == 'black'
        @chat.update(current_background_image_id: 'black')
      else
        @chat.update(current_background_image_id: params[:background_image_blob_id])
      end

    # 3. 白背景の選択
    elsif params[:background_image_blob_id] == ""
      @chat.update(current_background_image_id: nil)
    end

    redirect_to @chat, notice: '背景設定を更新しました'
  end

  # 削除するための背景画像一覧の表示
  def delete_background_images
    @background_images = current_user.background_images
  end

  # 選択した背景画像を削除
  def destroy_selected_background_images
    if params[:blob_ids].present?
      params[:blob_ids].each do |blob_id|
        image = current_user.background_images.find_by(blob_id: blob_id)
        image&.purge
        # もし削除した画像が現在の背景なら白背景に戻す
        current_user.chats.where(current_background_image_id: blob_id).update_all(current_background_image_id: nil)
      end
      redirect_to edit_background_chat_path(@chat), notice: '選択した画像を削除しました'
    else
      redirect_to delete_background_images_chat_path(@chat), alert: '削除する画像を選択してください'
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end

  def create_default_ai
    current_user.ai_characters.create!(
      name: "デフォルトAI",
      personality: "あなたは親切で丁寧なアシスタントです。ユーザーの質問に分かりやすく答えてください。"
    )
  end
end
