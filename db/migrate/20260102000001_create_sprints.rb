class CreateSprints < ActiveRecord::Migration[8.0]
  def change
    create_table :sprints do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.text :goal
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0

      t.timestamps
    end

    add_reference :issues, :sprint, foreign_key: true, null: true
  end
end
