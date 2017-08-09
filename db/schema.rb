# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170809112123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "blocked_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "blocked_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id"], name: "index_blocked_users_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "tags"
    t.string   "class_name"
    t.string   "family"
    t.string   "location"
    t.string   "url"
    t.integer  "site_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["site_id"], name: "index_categories_on_site_id", using: :btree
  end

  create_table "chats", force: :cascade do |t|
    t.text     "message"
    t.integer  "conversation_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "status",          default: 0,     null: false
    t.integer  "from_user_id",    default: 0,     null: false
    t.boolean  "is_read",         default: false
    t.index ["conversation_id"], name: "index_chats_on_conversation_id", using: :btree
  end

  create_table "conversation_participants", force: :cascade do |t|
    t.integer  "conversation_id", null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_conversation_participants_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_conversation_participants_on_user_id", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "from_user_id",                      null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "last_message"
    t.integer  "last_user_id"
    t.integer  "conversation_type", default: 0,     null: false
    t.boolean  "is_abandoned",      default: false
    t.index ["conversation_type"], name: "index_conversations_on_conversation_type", using: :btree
    t.index ["is_abandoned"], name: "index_conversations_on_is_abandoned", using: :btree
    t.index ["user_id"], name: "index_conversations_on_user_id", using: :btree
  end

  create_table "deleted_conversations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_deleted_conversations_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_deleted_conversations_on_user_id", using: :btree
  end

  create_table "eulas", force: :cascade do |t|
    t.text     "eula_text"
    t.boolean  "is_latest",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "offered_by_id",             null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "status",        default: 0
    t.string   "detail"
    t.string   "comment"
    t.index ["user_id"], name: "index_jobs_on_user_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "file"
    t.string   "url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_photos_on_category_id", using: :btree
  end

  create_table "privacies", force: :cascade do |t|
    t.text     "privacy_text"
    t.boolean  "is_latest",    default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "tags"
    t.string   "client_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.decimal  "rating"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "rated_on_id",             null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "status",      default: 0, null: false
    t.integer  "job_id"
    t.index ["job_id"], name: "index_ratings_on_job_id", using: :btree
    t.index ["user_id"], name: "index_ratings_on_user_id", using: :btree
  end

  create_table "reported_chats", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "reported_by_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["chat_id"], name: "index_reported_chats_on_chat_id", using: :btree
  end

  create_table "reported_ratings", force: :cascade do |t|
    t.integer  "rating_id"
    t.integer  "reported_by_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["rating_id"], name: "index_reported_ratings_on_rating_id", using: :btree
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge"
    t.string   "device_token",          limit: 64
    t.string   "sound",                            default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                           default: 86400
    t.boolean  "delivered",                        default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                           default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "alert_is_json",                    default: false
    t.string   "type",                                                 null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                 default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                               null: false
    t.integer  "retries",                          default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                       default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
    t.integer  "user_id"
    t.integer  "sent_by_id"
    t.boolean  "is_admin_notification",            default: false
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree
    t.index ["is_admin_notification"], name: "index_rpush_notifications_on_is_admin_notification", using: :btree
    t.index ["sent_by_id"], name: "index_rpush_notifications_on_sent_by_id", using: :btree
    t.index ["user_id"], name: "index_rpush_notifications_on_user_id", using: :btree
  end

  create_table "sites", force: :cascade do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "tags"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_sites_on_project_id", using: :btree
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "survey_number"
    t.integer  "submitted_by"
    t.boolean  "lat"
    t.boolean  "long"
    t.integer  "sub_category_id"
    t.string   "rainfall"
    t.string   "humidity"
    t.string   "temperature"
    t.float    "health_score"
    t.string   "live_leaf_cover"
    t.string   "live_branch_stem"
    t.float    "stem_diameter"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["sub_category_id"], name: "index_submissions_on_sub_category_id", using: :btree
    t.index ["submitted_by"], name: "index_submissions_on_submitted_by", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "eula_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.decimal  "rating",                 default: "0.0"
    t.integer  "status",                 default: 0,       null: false
    t.integer  "user_type",              default: 0,       null: false
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.json     "tokens"
    t.integer  "number_of_ratings",      default: 0
    t.string   "profile_picture"
    t.string   "username",               default: "",      null: false
    t.string   "device_token"
    t.string   "device_type"
    t.string   "uuid_iphone"
    t.integer  "privacy_id"
    t.string   "mobile_number"
    t.boolean  "approved",               default: false
    t.integer  "project_id"
    t.integer  "managed_project_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["managed_project_id"], name: "index_users_on_managed_project_id", using: :btree
    t.index ["project_id"], name: "index_users_on_project_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.json     "object_changes"
    t.string   "comment"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "blocked_users", "users"
  add_foreign_key "chats", "conversations"
  add_foreign_key "conversations", "users"
  add_foreign_key "deleted_conversations", "conversations"
  add_foreign_key "deleted_conversations", "users"
  add_foreign_key "jobs", "users"
  add_foreign_key "ratings", "users"
  add_foreign_key "reported_chats", "chats"
  add_foreign_key "reported_ratings", "ratings"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "submissions", "sub_categories"
end
