class Comment < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  has_rich_text :content
  has_many_attached :images

  validates :content, presence: true

  scope :ordered, -> { order(created_at: :asc) }
end
