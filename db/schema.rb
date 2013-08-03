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

ActiveRecord::Schema.define(version: 20130729182040) do

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.string   "screen_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "cv_educations", force: true do |t|
    t.string   "school"
    t.string   "from_year"
    t.string   "to_year"
    t.string   "degree"
    t.string   "field_of_study"
    t.string   "grade"
    t.string   "activities"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "cv_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv_experiences", force: true do |t|
    t.date     "from"
    t.date     "to"
    t.string   "company_name"
    t.string   "job_title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "cv_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv_languages", force: true do |t|
    t.string   "language"
    t.string   "proficiency"
    t.integer  "user_id"
    t.integer  "cv_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv_skills", force: true do |t|
    t.string   "name"
    t.string   "sequence"
    t.integer  "user_id"
    t.integer  "cv_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cvs", force: true do |t|
    t.text     "summary"
    t.string   "picture_filename"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.integer  "inviting_user_id"
    t.integer  "invited_user_id"
    t.text     "feedback"
    t.string   "tracking_pixel"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "feedback_date"
    t.boolean  "is_read",          default: false
    t.boolean  "is_original",      default: false
    t.string   "host_name"
  end

  create_table "read_logs", force: true do |t|
    t.integer  "inviting_user_id"
    t.integer  "invited_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_add"
    t.string   "host_name"
  end

  create_table "roles", force: true do |t|
    t.string   "role_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_pages", force: true do |t|
    t.string   "name"
    t.string   "page_route"
    t.text     "content"
    t.boolean  "is_footer",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "state"
    t.string   "city"
    t.text     "address"
    t.string   "zipcode"
    t.string   "contact"
    t.string   "phone"
    t.string   "mobile"
    t.string   "birthdate"
    t.string   "headline"
    t.string   "image"
    t.string   "register_token"
    t.boolean  "is_active",          default: true
    t.boolean  "is_provider",        default: false
    t.integer  "login_count",        default: 0,     null: false
    t.integer  "failed_login_count", default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_inactive_cv",     default: false
  end

end
