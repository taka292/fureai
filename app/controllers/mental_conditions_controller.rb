class MentalConditionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mental_condition, only: [ :show, :edit, :update, :destroy ]

  def index
    @mental_conditions = current_user.mental_conditions.order(recorded_at: :desc)
    @diaries = current_user.diaries.order(recorded_at: :desc)
    @already_recorded_today = already_recorded_today?
    end_date = Time.current.in_time_zone("Asia/Tokyo").to_date
    start_date = end_date - 6.days

    # group_by_dayのformatオプションを使用して日付フォーマットを指定（日本時間）
    # enumの値（0-4）を+1して1-5の範囲に変換（グラフの縦軸を0-5にするため）
    @mental_chart = current_user.mental_conditions
      .where(recorded_at: start_date.beginning_of_day..end_date.end_of_day)
      .group_by_day(:recorded_at, range: start_date..end_date, format: "%m/%d", time_zone: "Asia/Tokyo")
      .average(:mental_state)
      .transform_values { |v| v.nil? ? nil : v + 1 }

    @physical_chart = current_user.mental_conditions
      .where(recorded_at: start_date.beginning_of_day..end_date.end_of_day)
      .group_by_day(:recorded_at, range: start_date..end_date, format: "%m/%d", time_zone: "Asia/Tokyo")
      .average(:physical_state)
      .transform_values { |v| v.nil? ? nil : v + 1 }

    # 日付ごとにコンディションと日記をグループ化
    @records_by_date = {}
    @mental_conditions.each do |condition|
      next unless condition.recorded_at
      date_key = condition.recorded_at.in_time_zone("Asia/Tokyo").to_date
      @records_by_date[date_key] ||= { condition: nil, diary: nil }
      @records_by_date[date_key][:condition] = condition
    end
    @diaries.each do |diary|
      next unless diary.recorded_at
      date_key = diary.recorded_at.in_time_zone("Asia/Tokyo").to_date
      @records_by_date[date_key] ||= { condition: nil, diary: nil }
      @records_by_date[date_key][:diary] = diary
    end
    @records_by_date = @records_by_date.sort_by { |date, _| date }.reverse.to_h
  end

  def show
  end

  def new
    if already_recorded_today?
      redirect_to mental_conditions_path, alert: "本日分の記録はすでに登録されています" and return
    end
    @mental_condition = current_user.mental_conditions.new
  end

  def create
    if already_recorded_today?
      redirect_to mental_conditions_path, alert: "本日分の記録はすでに登録されています" and return
    end
    @mental_condition = current_user.mental_conditions.new(mental_condition_params)
    @mental_condition.recorded_at = Time.current.in_time_zone("Asia/Tokyo")
    if @mental_condition.save
      redirect_to mental_conditions_path, notice: "記録を保存しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @mental_condition.assign_attributes(mental_condition_params)
    @mental_condition.recorded_at = Time.current.in_time_zone("Asia/Tokyo")
    if @mental_condition.save
      redirect_to mental_conditions_path, notice: "記録を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @mental_condition.destroy
    redirect_to mental_conditions_path, notice: "記録を削除しました"
  end

  private

  def set_mental_condition
    @mental_condition = current_user.mental_conditions.find(params[:id])
  end

  def mental_condition_params
    params.require(:mental_condition).permit(:mental_state, :physical_state)
  end

  def already_recorded_today?
    today = Time.current.in_time_zone("Asia/Tokyo").to_date
    current_user.mental_conditions.where(
      recorded_at: today.beginning_of_day..today.end_of_day
    ).exists?
  end
end
