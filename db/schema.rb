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

ActiveRecord::Schema.define(:version => 20160204085918) do

  create_table "chronologies", :force => true do |t|
    t.string   "title"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "chronologies", ["event_id"], :name => "index_chronologies_on_event_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "start"
    t.datetime "end"
    t.boolean  "durationEvent"
    t.string   "place"
    t.text     "description"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "validated"
    t.integer  "user_id"
    t.boolean  "approved",          :default => false
    t.integer  "linked_history_id"
  end

  add_index "events", ["user_id", "created_at"], :name => "index_events_on_user_id_and_created_at"

  create_table "gedcoms", :force => true do |t|
    t.string   "name"
    t.string   "content"
    t.boolean  "public",      :default => false
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "approved",    :default => false
    t.string   "description"
  end

  add_index "gedcoms", ["user_id", "created_at"], :name => "index_gedcoms_on_user_id_and_created_at"

  create_table "histories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "owner"
    t.boolean  "status",      :default => false
    t.integer  "user_id"
    t.boolean  "approved",    :default => false
  end

  add_index "histories", ["user_id", "created_at"], :name => "index_histories_on_user_id_and_created_at"

  create_table "joint_histoire_evenements", :force => true do |t|
    t.integer  "event_id"
    t.integer  "history_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "joint_histoire_evenements", ["event_id"], :name => "index_joint_histoire_evenements_on_event_id"
  add_index "joint_histoire_evenements", ["history_id"], :name => "index_joint_histoire_evenements_on_history_id"

  create_table "registres", :force => true do |t|
    t.integer  "history_id"
    t.integer  "event_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "approved",   :default => false
    t.integer  "user_id"
  end

  add_index "registres", ["event_id"], :name => "index_registres_on_event_id"
  add_index "registres", ["history_id"], :name => "index_registres_on_history_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
