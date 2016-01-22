# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160122072003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "blocked_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "blocked_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "blocked_users", ["user_id"], name: "index_blocked_users_on_user_id", using: :btree

  create_table "chats", force: :cascade do |t|
    t.text     "message"
    t.integer  "conversation_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "status",          default: 0,     null: false
    t.integer  "from_user_id",    default: 0,     null: false
    t.boolean  "is_read",         default: false
  end

  add_index "chats", ["conversation_id"], name: "index_chats_on_conversation_id", using: :btree

  create_table "conversation_participants", force: :cascade do |t|
    t.integer  "conversation_id", null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "conversation_participants", ["conversation_id"], name: "index_conversation_participants_on_conversation_id", using: :btree
  add_index "conversation_participants", ["user_id"], name: "index_conversation_participants_on_user_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "from_user_id",                  null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "last_message"
    t.integer  "last_user_id"
    t.integer  "conversation_type", default: 0, null: false
    t.string   "topic"
  end

  add_index "conversations", ["conversation_type"], name: "index_conversations_on_conversation_type", using: :btree
  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

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
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "privacies", force: :cascade do |t|
    t.text     "privacy_text"
    t.boolean  "is_latest",    default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.decimal  "rating"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "rated_on_id",             null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "status",      default: 0, null: false
  end

  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "reported_chats", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "reported_by_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "reported_chats", ["chat_id"], name: "index_reported_chats_on_chat_id", using: :btree

  create_table "reported_ratings", force: :cascade do |t|
    t.integer  "rating_id"
    t.integer  "reported_by_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "reported_ratings", ["rating_id"], name: "index_reported_ratings_on_rating_id", using: :btree

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree
  add_index "rpush_notifications", ["is_admin_notification"], name: "index_rpush_notifications_on_is_admin_notification", using: :btree
  add_index "rpush_notifications", ["sent_by_id"], name: "index_rpush_notifications_on_sent_by_id", using: :btree
  add_index "rpush_notifications", ["user_id"], name: "index_rpush_notifications_on_user_id", using: :btree

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
    t.decimal  "rating",                 default: 0.0
    t.integer  "status",                 default: 0,       null: false
    t.integer  "user_type",              default: 0,       null: false
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.json     "tokens"
    t.integer  "number_of_ratings",      default: 0
    t.string   "profile_picture"
    t.string   "device_token"
    t.string   "username",                                 null: false
    t.string   "device_type"
    t.string   "uuid_iphone"
    t.integer  "privacy_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.json     "object_changes"
    t.string   "comment"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "blocked_users", "users"
  add_foreign_key "chats", "conversations"
  add_foreign_key "conversations", "users"
  add_foreign_key "jobs", "users"
  add_foreign_key "ratings", "users"
  add_foreign_key "reported_chats", "chats"
  add_foreign_key "reported_ratings", "ratings"
end
