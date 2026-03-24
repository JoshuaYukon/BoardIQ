class BoardState < ApplicationRecord
  belongs_to :board
  has_many :issues, dependent: :nullify

  validates :name, presence: true
  validates :board_id, presence: true
  validates :position, presence: true

  scope :ordered, -> { order(:position) }

  # Default states for new boards
  def self.create_defaults_for_board(board)
    ['New', 'In Progress', 'Done'].each_with_index do |name, index|
      create!(board: board, name: name, position: index)
    end
  end
end
