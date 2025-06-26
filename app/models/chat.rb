class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :ai_character
  has_many :messages, dependent: :destroy
end 