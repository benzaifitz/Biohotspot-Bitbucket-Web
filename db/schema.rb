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

ActiveRecord::Schema.define(version: 20190125130222) do

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
    t.string   "family_common"
    t.string   "location"
    t.string   "url"
    t.integer  "site_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "deleted_at"
    t.string   "family_scientific"
    t.string   "species_scientific"
    t.string   "species_common"
    t.string   "status"
    t.string   "growth"
    t.string   "habit"
    t.string   "impact"
    t.string   "distribution"
    t.integer  "specie_type_id"
    t.string   "photographer"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at", using: :btree
    t.index ["site_id"], name: "index_categories_on_site_id", using: :btree
    t.index ["specie_type_id"], name: "index_categories_on_specie_type_id", using: :btree
  end

  create_table "category_documents", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_sub_categories", force: :cascade do |t|
    t.integer  "sub_category_id"
    t.integer  "category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
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

  create_table "document_projects", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "document_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "document"
    t.string   "name"
    t.integer  "project_id"
    t.integer  "category_document_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["category_document_id"], name: "index_documents_on_category_document_id", using: :btree
    t.index ["project_id"], name: "index_documents_on_project_id", using: :btree
  end

  create_table "eulas", force: :cascade do |t|
    t.text     "eula_text"
    t.boolean  "is_latest",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text     "comment"
    t.integer  "land_manager_id"
    t.integer  "project_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
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

  create_table "land_manager_sub_categories", force: :cascade do |t|
    t.integer  "land_manager_id"
    t.integer  "sub_category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "location_users", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  create_table "photos", force: :cascade do |t|
    t.string   "file"
    t.string   "url"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.boolean  "approved",           default: true
    t.string   "reject_comment"
    t.string   "file_secure_token"
    t.string   "imageable_sub_type"
    t.index ["imageable_id", "imageable_type"], name: "index_photos_on_imageable_id_and_imageable_type", using: :btree
  end

  create_table "privacies", force: :cascade do |t|
    t.text     "privacy_text"
    t.boolean  "is_latest",    default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "project_categories", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "project_manager_projects", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "project_manager_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "is_admin",           default: false
    t.string   "token"
    t.integer  "status",             default: 0,     null: false
  end

  create_table "project_requests", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "status",     default: 2, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "reason"
    t.index ["project_id"], name: "index_project_requests_on_project_id", using: :btree
    t.index ["status"], name: "index_project_requests_on_status", using: :btree
    t.index ["user_id"], name: "index_project_requests_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "tags"
    t.string   "organization"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "project_manager_id"
    t.integer  "status",             default: 0, null: false
    t.string   "image"
    t.string   "ecosystem"
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
    t.text     "alert"
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
    t.boolean  "deleted",                          default: false
    t.boolean  "content_available",                default: false
    t.text     "notification"
    t.boolean  "mutable_content",                  default: false
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree
    t.index ["is_admin_notification"], name: "index_rpush_notifications_on_is_admin_notification", using: :btree
    t.index ["sent_by_id"], name: "index_rpush_notifications_on_sent_by_id", using: :btree
    t.index ["user_id"], name: "index_rpush_notifications_on_user_id", using: :btree
  end

  create_table "site_categories", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sites", force: :cascade do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "tags"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "location_id"
  end

  create_table "specie_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "phylum"
    t.string   "klass"
    t.string   "order"
    t.string   "superfamily"
    t.string   "family"
    t.string   "genus"
    t.string   "species"
    t.string   "sub_species"
    t.index ["name"], name: "index_specie_types_on_name", unique: true, using: :btree
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.integer  "site_id"
    t.string   "treatment"
    t.index ["category_id"], name: "index_sub_categories_on_category_id", using: :btree
    t.index ["user_id"], name: "index_sub_categories_on_user_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "survey_number"
    t.integer  "submitted_by"
    t.integer  "sub_category_id"
    t.string   "rainfall"
    t.string   "humidity"
    t.string   "temperature"
    t.string   "health_score"
    t.string   "live_leaf_cover"
    t.string   "live_branch_stem"
    t.string   "stem_diameter"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "sample_photo"
    t.string   "monitoring_photo"
    t.string   "dieback"
    t.boolean  "leaf_tie_month",                default: false
    t.boolean  "seed_borer",                    default: false
    t.boolean  "loopers",                       default: false
    t.boolean  "grazing",                       default: false
    t.text     "field_notes"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "monitoring_photo_secure_token"
    t.string   "sample_photo_secure_token"
    t.string   "sample_photo_full_url"
    t.string   "monitoring_photo_full_url"
    t.integer  "status",                        default: 0
    t.boolean  "approved",                      default: true
    t.string   "reject_comment"
    t.integer  "project_id"
    t.integer  "location_id"
    t.integer  "site_id"
    t.integer  "category_id"
    t.index ["sub_category_id"], name: "index_submissions_on_sub_category_id", using: :btree
    t.index ["submitted_by"], name: "index_submissions_on_submitted_by", using: :btree
  end

  create_table "tutorials", force: :cascade do |t|
    t.string   "avatar"
    t.text     "avatar_text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
    t.string   "username",               default: ""
    t.string   "device_token"
    t.string   "device_type"
    t.string   "uuid_iphone"
    t.integer  "privacy_id"
    t.string   "mobile_number"
    t.boolean  "approved",               default: false
    t.integer  "project_id"
    t.integer  "managed_project_id"
    t.integer  "site_id"
    t.integer  "location_id"
    t.boolean  "pm_invited",             default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["managed_project_id"], name: "index_users_on_managed_project_id", using: :btree
    t.index ["project_id"], name: "index_users_on_project_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
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
  add_foreign_key "categories", "specie_types"
  add_foreign_key "chats", "conversations"
  add_foreign_key "conversations", "users"
  add_foreign_key "deleted_conversations", "conversations"
  add_foreign_key "deleted_conversations", "users"
  add_foreign_key "jobs", "users"
  add_foreign_key "ratings", "users"
  add_foreign_key "reported_chats", "chats"
  add_foreign_key "reported_ratings", "ratings"
  add_foreign_key "sub_categories", "categories"
end
