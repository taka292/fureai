class MentalCondition < ApplicationRecord
  belongs_to :user

  enum mental_state: { very_bad: 0, bad: 1, normal: 2, good: 3, very_good: 4 }, _prefix: :mental
  enum physical_state: { very_bad: 0, bad: 1, normal: 2, good: 3, very_good: 4 }, _prefix: :physical

  validate :one_record_per_day_per_user_japan_time

  private

  def one_record_per_day_per_user_japan_time
    return unless user && recorded_at
    # 日本時間で日付を判定
    jst_date = recorded_at.in_time_zone('Asia/Tokyo').to_date
    exists = MentalCondition.where(user_id: user_id)
      .where.not(id: id)
      .where('recorded_at >= ? AND recorded_at < ?',
        jst_date.beginning_of_day.in_time_zone('Asia/Tokyo'),
        (jst_date + 1).beginning_of_day.in_time_zone('Asia/Tokyo')
      ).exists?
    if exists
      errors.add(:base, '本日分の記録はすでに登録されています')
    end
  end
end
