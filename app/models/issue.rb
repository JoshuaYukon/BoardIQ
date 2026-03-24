class Issue < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :board
  belongs_to :board_state, optional: true
  belongs_to :sprint, optional: true
  has_many :comments, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_rich_text :description
  has_many_attached :attachments

  # legacy constant - kept for backwards compatibility
  STATUSES = { todo: 0, in_progress: 1, done: 2 }

  def status_name
    board_state&.name || STATUSES.key(self.status) || 'New'
  end
end
