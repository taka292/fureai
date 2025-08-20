class AiCharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ai_character, only: [ :edit, :update ]

  def edit
  end

  def update
    if @ai_character.update(ai_character_params)
      redirect_to chat_path(@ai_character.chats.first), notice: "AIキャラクター設定を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_ai_character
    @ai_character = current_user.ai_characters.find(params[:id])
  end

  def ai_character_params
    params.require(:ai_character).permit(:name, :personality, :avatar)
  end
end
