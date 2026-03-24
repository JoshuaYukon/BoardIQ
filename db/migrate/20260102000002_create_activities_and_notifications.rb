class CreateActivitiesAndNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :action, null: false
      t.string :trackable_type
      t.integer :trackable_id
      t.string :description

      t.timestamps
    end

    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message, null: false
      t.boolean :read, default: false
      t.string :notifiable_type
      t.integer :notifiable_id

      t.timestamps
    end

    add_index :notifications, [:user_id, :read]
  end
end
