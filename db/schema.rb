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

ActiveRecord::Schema.define(version: 20160905193650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "daycares", force: :cascade do |t|
    t.string    "source"
    t.string    "daycare_type"
    t.string    "center_name"
    t.string    "permalink"
    t.string    "address"
    t.string    "borough"
    t.string    "zipcode"
    t.string    "phone"
    t.string    "permit_status"
    t.string    "permit_number"
    t.string    "permit_expiration_date"
    t.string    "age_range"
    t.integer   "maximum_capacity"
    t.string    "site_type"
    t.boolean   "certified_to_administer_medication"
    t.integer   "years_operating"
    t.boolean   "has_inspections"
    t.string    "grade"
    t.datetime  "created_at",                                                                                  null: false
    t.datetime  "updated_at",                                                                                  null: false
    t.geography "lonlat",                             limit: {:srid=>4326, :type=>"point", :geographic=>true}
  end

  add_index "daycares", ["lonlat"], name: "index_daycares_on_lonlat", using: :gist

  create_table "infractions", force: :cascade do |t|
    t.integer  "inspection_id"
    t.string   "violation_summary"
    t.string   "category"
    t.string   "oneword_category"
    t.string   "code_subsection"
    t.string   "status"
    t.string   "short_description"
    t.integer  "multiplier"
    t.string   "extra_notes"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "infractions", ["inspection_id"], name: "index_infractions_on_inspection_id", using: :btree

  create_table "inspections", force: :cascade do |t|
    t.integer "daycare_id"
    t.string  "result"
    t.date    "date"
  end

  add_index "inspections", ["daycare_id"], name: "index_inspections_on_daycare_id", using: :btree

end
