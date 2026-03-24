class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.references :project, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end