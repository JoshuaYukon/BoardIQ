class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :issue, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :completed, default: false
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :tasks, [:issue_id, :position]
  end
end
