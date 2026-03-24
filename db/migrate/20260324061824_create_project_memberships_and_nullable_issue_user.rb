class CreateProjectMembershipsAndNullableIssueUser < ActiveRecord::Migration[8.1]
  def change
    create_table :project_memberships do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, default: 'member', null: false
      t.timestamps
    end

    add_index :project_memberships, [:project_id, :user_id], unique: true

    # Make issue assignee optional (was null: false)
    change_column_null :issues, :user_id, true
  end
end
