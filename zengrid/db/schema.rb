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

ActiveRecord::Schema.define(:version => 20130315164427) do

  create_table "audit_events", :force => true do |t|
    t.integer  "ticket_id"
    t.datetime "created_at",                  :null => false
    t.text     "channel"
    t.text     "group_name"
    t.text     "agent"
    t.text     "previous_status"
    t.text     "current_status"
    t.text     "subject"
    t.text     "tags"
    t.text     "shift"
    t.text     "team"
    t.boolean  "last"
    t.datetime "updated_at",                  :null => false
    t.integer  "time_since_requester_update"
    t.integer  "time_since_agent_update"
    t.text     "username"
    t.text     "category"
    t.text     "package"
  end

  create_table "health_histories", :force => true do |t|
    t.integer  "daypart"
    t.integer  "health"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "group_backend",                             :default => false
    t.boolean  "group_billing",                             :default => false
    t.boolean  "group_compliance",                          :default => false
    t.boolean  "group_desktop_support",                     :default => false
    t.boolean  "group_dev_relations",                       :default => false
    t.boolean  "group_escalation",                          :default => false
    t.boolean  "group_frontend",                            :default => false
    t.boolean  "group_hp",                                  :default => false
    t.boolean  "group_marketing",                           :default => false
    t.boolean  "group_qa_admins",                           :default => false
    t.boolean  "group_sales",                               :default => false
    t.boolean  "group_support",                             :default => true
    t.boolean  "group_z99_alert",                           :default => false
    t.boolean  "group_z99_everyone",                        :default => false
    t.boolean  "group_z99_reseller",                        :default => false
    t.boolean  "channel_api",                               :default => true
    t.boolean  "channel_email",                             :default => true
    t.boolean  "channel_system",                            :default => true
    t.boolean  "channel_web",                               :default => true
    t.boolean  "tag_live_chat",                             :default => false
    t.boolean  "tag_email",                                 :default => true
    t.boolean  "tag_claimed",                               :default => false
    t.boolean  "tag_keep_open",                             :default => false
    t.boolean  "status_new",                                :default => true
    t.boolean  "status_open",                               :default => true
    t.boolean  "status_pending",                            :default => false
    t.boolean  "status_solved",                             :default => false
    t.boolean  "status_closed",                             :default => false
    t.boolean  "last_event_only",                           :default => false
    t.boolean  "events_with_change_in_status_or_last_only", :default => true
    t.integer  "time_since_requester_update_threshold",     :default => 120
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.boolean  "tag_billing",                               :default => false
    t.boolean  "tag_quiet",                                 :default => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "status_posts", :force => true do |t|
    t.string   "caption"
    t.text     "body"
    t.datetime "timestamp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "outage"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
