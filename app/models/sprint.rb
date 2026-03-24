class Sprint < ApplicationRecord
  belongs_to :project
  has_many :issues, dependent: :nullify

  enum :status, { planning: 0, active: 1, completed: 2 }

  validates :name, presence: true
  validates :project_id, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  def issue_count
    issues.count
  end

  def completed_count
    issues.joins(:board_state).where(board_states: { position: BoardState.maximum(:position) }).count
  end
end
