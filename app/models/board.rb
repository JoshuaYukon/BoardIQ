class Board < ApplicationRecord
  belongs_to :project
  has_many :issues, dependent: :destroy
  has_many :board_states, dependent: :destroy

  after_create :create_default_states

  private

  def create_default_states
    BoardState.create_defaults_for_board(self)
  end
end