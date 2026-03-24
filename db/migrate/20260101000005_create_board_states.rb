class CreateBoardStates < ActiveRecord::Migration[8.0]
  def change
    create_table :board_states do |t|
      t.references :board, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.string :color, default: '#6b7280'

      t.timestamps
    end

    add_index :board_states, [:board_id, :position]
  end
end
