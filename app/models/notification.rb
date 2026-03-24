class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(20) }

  def self.notify(user:, message:, notifiable: nil)
    create(
      user: user,
      message: message,
      notifiable_type: notifiable&.class&.name,
      notifiable_id: notifiable&.id
    )
  end
end
