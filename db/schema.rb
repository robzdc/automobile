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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130903035531) do

  create_table "adverts", :force => true do |t|
    t.string   "image"
    t.string   "title"
    t.string   "url"
    t.integer  "price"
    t.string   "location"
    t.string   "phone"
    t.text     "comment"
    t.string   "color"
    t.integer  "km"
    t.string   "make"
    t.string   "model"
    t.string   "state"
    t.integer  "year"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "adverts", ["km"], :name => "idx_advert_km"
  add_index "adverts", ["make"], :name => "idx_advert_make"
  add_index "adverts", ["model"], :name => "idx_advert_model"
  add_index "adverts", ["price"], :name => "idx_advert_price"
  add_index "adverts", ["state"], :name => "idx_advert_state"
  add_index "adverts", ["year"], :name => "idx_advert_year"

  create_table "compare_makes", :force => true do |t|
    t.string   "make_id"
    t.string   "website_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "compare_models", :force => true do |t|
    t.integer  "model_id"
    t.integer  "website_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "compare_states", :force => true do |t|
    t.integer  "state_id"
    t.integer  "website_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.integer  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "makes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models", :force => true do |t|
    t.integer  "make_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.integer  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "country_id"
  end

  create_table "websites", :force => true do |t|
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
