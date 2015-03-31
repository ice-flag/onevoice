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

ActiveRecord::Schema.define(:version => 20150331131425) do

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "license_plate"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "email"
    t.string   "lp_make"
    t.string   "lp_model"
    t.string   "lp_year"
    t.string   "lp_cylinder"
    t.string   "lp_car_category"
    t.string   "lp_model_type"
    t.string   "lp_seats"
    t.string   "lp_fuel"
    t.string   "lp_apk"
    t.text     "description"
    t.integer  "supplier_parts"
  end

end
