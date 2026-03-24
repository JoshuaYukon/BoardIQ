class Task < ApplicationRecord
  belongs_to :issue

  validates :title, presence: true

  scope :ordered, -> { order(:position) }

  def self.find_max_position(issue_id)
    where(issue_id: issue_id).maximum(:position).to_i
  end
end
