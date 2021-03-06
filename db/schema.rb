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

ActiveRecord::Schema.define(:version => 20120914033725) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "title",                       :null => false
    t.string   "slug",                        :null => false
    t.text     "body",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body_html",                   :null => false
    t.string   "description", :default => "", :null => false
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true
  add_index "pages", ["title"], :name => "index_pages_on_title", :unique => true

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "posts", :force => true do |t|
    t.string       "title",                                 :null => false
    t.string       "category",                              :null => false
    t.string       "description",                           :null => false
    t.text         "body",                                  :null => false
    t.boolean      "published",      :default => false,     :null => false
    t.boolean      "announced",      :default => false,     :null => false
    t.string_array "slugs"
    t.string_array "terms"
    t.string_array "tags"
    t.string_array "images"
    t.datetime     "published_on",                          :null => false
    t.datetime     "created_at"
    t.datetime     "updated_at"
    t.string       "renderer",       :default => "textile", :null => false
    t.text         "body_html",                             :null => false
    t.text         "body_truncated",                        :null => false
  end

  add_index "posts", ["category", "published_on"], :name => "category", :order => {"published_on"=>:desc}
  add_index "posts", ["published_on"], :name => "basic_search", :order => {"published_on"=>:desc}
  add_index "posts", ["slugs"], :name => "slugs"
  add_index "posts", ["tags"], :name => "tags"
  add_index "posts", ["terms"], :name => "terms"

end
