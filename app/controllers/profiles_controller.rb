class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    current_password = params[:user][:current_password]

    # パスワード変更時のみcurrent_passwordのバリデーション
    if user_params[:password].present?
      if @user.valid_password?(current_password)
        if @user.update(user_params)
          redirect_to edit_profile_path, notice: 'プロフィールを更新しました'
        else
          render :edit, status: :unprocessable_entity
        end
      else
        @user.assign_attributes(user_params) # 入力値をフォームに反映
        @user.errors.add(:current_password, "が正しくありません")
        render :edit, status: :unprocessable_entity
      end
    else
      # パスワード以外の更新はcurrent_password不要
      if @user.update(user_params.except(:password, :password_confirmation))
        redirect_to edit_profile_path, notice: 'プロフィールを更新しました'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end 