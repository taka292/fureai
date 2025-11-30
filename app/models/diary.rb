class Diary < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validate :one_diary_per_day_per_user_japan_time

  private

  def one_diary_per_day_per_user_japan_time
    return unless user && recorded_at
    # 日本時間で日付を判定
    jst_date = recorded_at.in_time_zone("Asia/Tokyo").to_date
    exists = Diary.where(user_id: user_id)
      .where.not(id: id)
      .where("recorded_at >= ? AND recorded_at < ?",
        jst_date.beginning_of_day.in_time_zone("Asia/Tokyo"),
        (jst_date + 1).beginning_of_day.in_time_zone("Asia/Tokyo")
      ).exists?
    if exists
      errors.add(:base, "この日の日記はすでに登録されています")
    end
  end
end
