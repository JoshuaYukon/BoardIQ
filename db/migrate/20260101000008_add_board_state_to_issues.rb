class AddBoardStateToIssues < ActiveRecord::Migration[8.0]
  def change
    add_reference :issues, :board_state, foreign_key: true, null: true
  end
end
