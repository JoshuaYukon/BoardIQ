# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_24_061824) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_on_record_name_blob"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "project_id", null: false
    t.integer "trackable_id"
    t.string "trackable_type"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["project_id"], name: "index_activities_on_project_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "board_states", force: :cascade do |t|
    t.integer "board_id", null: false
    t.string "color", default: "#6b7280"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["board_id", "position"], name: "index_board_states_on_board_id_and_position"
    t.index ["board_id"], name: "index_board_states_on_board_id"
  end

  create_table "boards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_boards_on_project_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "issue_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["issue_id", "created_at"], name: "index_comments_on_issue_id_and_created_at"
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "board_state_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "project_id", null: false
    t.integer "sprint_id"
    t.integer "status", default: 0
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["board_id"], name: "index_issues_on_board_id"
    t.index ["board_state_id"], name: "index_issues_on_board_state_id"
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["sprint_id"], name: "index_issues_on_sprint_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "message", null: false
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.boolean "read", default: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "project_invitations", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.integer "invited_by_id", null: false
    t.integer "project_id", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["invited_by_id"], name: "index_project_invitations_on_invited_by_id"
    t.index ["project_id", "email"], name: "index_project_invitations_on_project_id_and_email", unique: true
    t.index ["project_id"], name: "index_project_invitations_on_project_id"
    t.index ["token"], name: "index_project_invitations_on_token", unique: true
  end

  create_table "project_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "project_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_project_memberships_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_project_memberships_on_project_id"
    t.index ["user_id"], name: "index_project_memberships_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sprints", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.text "goal"
    t.string "name", null: false
    t.integer "project_id", null: false
    t.date "start_date"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_sprints_on_project_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.integer "issue_id", null: false
    t.integer "position", default: 0
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "position"], name: "index_tasks_on_issue_id_and_position"
    t.index ["issue_id"], name: "index_tasks_on_issue_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "projects"
  add_foreign_key "activities", "users"
  add_foreign_key "board_states", "boards"
  add_foreign_key "boards", "projects"
  add_foreign_key "comments", "issues"
  add_foreign_key "comments", "users"
  add_foreign_key "issues", "board_states"
  add_foreign_key "issues", "boards"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "sprints"
  add_foreign_key "issues", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "project_invitations", "projects"
  add_foreign_key "project_invitations", "users", column: "invited_by_id"
  add_foreign_key "project_memberships", "projects"
  add_foreign_key "project_memberships", "users"
  add_foreign_key "sprints", "projects"
  add_foreign_key "tasks", "issues"
end
