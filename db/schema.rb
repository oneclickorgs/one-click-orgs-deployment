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

ActiveRecord::Schema.define(:version => 20140112175011) do

  create_table "administrators", :force => true do |t|
    t.string   "email",               :limit => 50, :null => false
    t.string   "crypted_password",    :limit => 50
    t.string   "salt",                :limit => 50
    t.string   "password_reset_code"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "agenda_items", :force => true do |t|
    t.integer  "meeting_id"
    t.integer  "position"
    t.string   "title"
    t.text     "minutes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ballots", :force => true do |t|
    t.integer  "election_id"
    t.integer  "member_id"
    t.text     "ranking"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "clauses", :force => true do |t|
    t.string   "name",                                                        :null => false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text     "text_value"
    t.integer  "integer_value"
    t.integer  "boolean_value",   :limit => 1
    t.integer  "organisation_id"
    t.decimal  "decimal_value",                :precision => 10, :scale => 5
  end

  add_index "clauses", ["organisation_id"], :name => "index_clauses_on_organisation_id"

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.integer  "commentable_id"
    t.text     "body"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_commentable_id"

  create_table "decisions", :force => true do |t|
    t.integer "proposal_id"
  end

  add_index "decisions", ["proposal_id"], :name => "index_decisions_on_proposal_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "queue"
  end

  create_table "directorships", :force => true do |t|
    t.integer  "organisation_id"
    t.integer  "director_id"
    t.date     "elected_on"
    t.date     "ended_on"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "elections", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "state"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "meeting_id"
    t.date     "nominations_closing_date"
    t.date     "voting_closing_date"
    t.integer  "seats"
  end

  create_table "meeting_participations", :force => true do |t|
    t.integer  "meeting_id"
    t.integer  "participant_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "meetings", :force => true do |t|
    t.date     "happened_on"
    t.text     "minutes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organisation_id"
    t.integer  "creator_id"
    t.string   "type"
    t.string   "start_time"
    t.text     "venue"
    t.text     "agenda"
  end

  create_table "member_classes", :force => true do |t|
    t.string  "name",            :null => false
    t.string  "description"
    t.integer "organisation_id"
  end

  add_index "member_classes", ["organisation_id"], :name => "index_member_classes_on_organisation_id"

  create_table "member_state_transitions", :force => true do |t|
    t.integer  "member_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "member_state_transitions", ["member_id"], :name => "index_member_state_transitions_on_member_id"

  create_table "members", :force => true do |t|
    t.string   "email",               :limit => 50, :null => false
    t.datetime "created_at"
    t.string   "crypted_password",    :limit => 50
    t.string   "salt",                :limit => 50
    t.integer  "organisation_id"
    t.integer  "member_class_id"
    t.datetime "inducted_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "invitation_code"
    t.string   "password_reset_code"
    t.datetime "last_logged_in_at"
    t.datetime "terms_accepted_at"
    t.string   "state"
    t.date     "elected_on"
    t.string   "role"
    t.date     "stood_down_on"
    t.text     "address"
    t.string   "phone"
  end

  add_index "members", ["organisation_id"], :name => "index_members_on_organisation_id"

  create_table "nominations", :force => true do |t|
    t.integer  "election_id"
    t.integer  "nominee_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "state"
    t.decimal  "votes",       :precision => 15, :scale => 10
  end

  create_table "officerships", :force => true do |t|
    t.integer  "office_id"
    t.integer  "officer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "elected_on"
    t.date     "ended_on"
  end

  create_table "offices", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "title"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "organisations", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
    t.string   "state"
  end

  create_table "paragraphs", :force => true do |t|
    t.text     "body",         :limit => 16777215
    t.integer  "position"
    t.integer  "parent_id"
    t.integer  "document_id"
    t.integer  "heading"
    t.boolean  "continuation"
    t.string   "name"
    t.string   "topic"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "list"
  end

  create_table "proposals", :force => true do |t|
    t.string   "title",                                     :null => false
    t.text     "description"
    t.datetime "creation_date"
    t.datetime "close_date"
    t.string   "parameters",               :limit => 10000
    t.string   "type",                     :limit => 50
    t.integer  "proposer_member_id"
    t.integer  "organisation_id"
    t.string   "state"
    t.integer  "meeting_id"
    t.integer  "additional_votes_for"
    t.integer  "additional_votes_against"
  end

  create_table "resignations", :force => true do |t|
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "seen_notifications", :force => true do |t|
    t.integer  "member_id"
    t.string   "notification"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "seen_notifications", ["member_id", "notification"], :name => "index_seen_notifications_on_member_id_and_notification"
  add_index "seen_notifications", ["member_id"], :name => "index_seen_notifications_on_member_id"

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "share_accounts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "balance"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "share_transaction_state_transitions", :force => true do |t|
    t.integer  "share_transaction_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "share_transaction_state_transitions", ["share_transaction_id"], :name => "share_trans_state_trans_on_share_trans_id"

  create_table "share_transactions", :force => true do |t|
    t.string   "state"
    t.integer  "amount"
    t.integer  "from_account_id"
    t.integer  "to_account_id"
    t.integer  "share_value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "tasks", :force => true do |t|
    t.integer  "member_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "action"
    t.datetime "completed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.date     "starts_on"
    t.datetime "dismissed_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "member_id"
    t.integer  "proposal_id"
    t.integer  "for",         :limit => 1, :null => false
    t.datetime "created_at"
  end

  add_index "votes", ["proposal_id", "member_id"], :name => "index_votes_on_proposal_id_and_member_id"

end
