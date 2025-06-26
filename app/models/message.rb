class Message < ApplicationRecord
  enum role: { user: 0, ai: 1 }
  belongs_to :chat
  belongs_to :user, optional: true
end 