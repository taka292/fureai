class MentalConditionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mental_condition, only: [:show, :edit, :update, :destroy]

  def index
    @mental_conditions = current_user.mental_conditions.order(recorded_at: :desc)
    end_date = Time.current.in_time_zone('Asia/Tokyo').to_date
    start_date = end_date - 6.days
    @mental_chart = current_user.mental_conditions.where(recorded_at: start_date.beginning_of_day..end_date.end_of_day).group_by_day(:recorded_at, range: start_date..end_date).average(:mental_state)
    @physical_chart = current_user.mental_conditions.where(recorded_at: start_date.beginning_of_day..end_date.end_of_day).group_by_day(:recorded_at, range: start_date..end_date).average(:physical_state)
  end

  def show
  end

  def new
    if already_recorded_today?
      redirect_to mental_conditions_path, alert: '本日分の記録はすでに登録されています' and return
    end
    @mental_condition = current_user.mental_conditions.new
  end

  def create
    if already_recorded_today?
      redirect_to mental_conditions_path, alert: '本日分の記録はすでに登録されています' and return
    end
    @mental_condition = current_user.mental_conditions.new(mental_condition_params)
    @mental_condition.recorded_at = Time.current.in_time_zone('Asia/Tokyo').beginning_of_day
    if @mental_condition.save
      redirect_to mental_conditions_path, notice: '記録を保存しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @mental_condition.update(mental_condition_params)
      redirect_to mental_conditions_path, notice: '記録を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @mental_condition.destroy
    redirect_to mental_conditions_path, notice: '記録を削除しました'
  end

  private

  def set_mental_condition
    @mental_condition = current_user.mental_conditions.find(params[:id])
  end

  def mental_condition_params
    params.require(:mental_condition).permit(:mental_state, :physical_state)
  end

  def already_recorded_today?
    today = Time.current.in_time_zone('Asia/Tokyo').to_date
    current_user.mental_conditions.where(
      recorded_at: today.beginning_of_day..today.end_of_day
    ).exists?
  end
end