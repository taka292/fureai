class DiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_diary, only: [ :show, :edit, :update, :destroy ]

  def index
    @diaries = current_user.diaries.order(recorded_at: :desc)
  end

  def show
  end

  def new
    @diary = current_user.diaries.new
    if params[:date]
      @diary.recorded_at = Date.parse(params[:date]).in_time_zone("Asia/Tokyo").beginning_of_day
    else
      @diary.recorded_at = Time.current.in_time_zone("Asia/Tokyo")
    end
  end

  def create
    @diary = current_user.diaries.new(diary_params)
    if params[:diary][:recorded_at].present?
      date = Date.parse(params[:diary][:recorded_at])
      @diary.recorded_at = date.in_time_zone("Asia/Tokyo").beginning_of_day
    else
      @diary.recorded_at = Time.current.in_time_zone("Asia/Tokyo")
    end
    if @diary.save
      redirect_to mental_conditions_path, notice: "日記を保存しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @diary.assign_attributes(diary_params)
    if params[:diary][:recorded_at].present?
      date = Date.parse(params[:diary][:recorded_at])
      @diary.recorded_at = date.in_time_zone("Asia/Tokyo").beginning_of_day
    end
    if @diary.save
      redirect_to mental_conditions_path, notice: "日記を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @diary.destroy
    redirect_to mental_conditions_path, notice: "日記を削除しました"
  end

  private

  def set_diary
    @diary = current_user.diaries.find(params[:id])
  end

  def diary_params
    params.require(:diary).permit(:content, :recorded_at)
  end
end
