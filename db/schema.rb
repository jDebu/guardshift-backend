# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_04_110803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "service_id", null: false
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_availabilities_on_employee_id"
    t.index ["service_id"], name: "index_availabilities_on_service_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.time "week_start_time"
    t.time "week_end_time"
    t.time "weekend_start_time"
    t.time "weekend_end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.index ["employee_id"], name: "index_shifts_on_employee_id"
    t.index ["service_id"], name: "index_shifts_on_service_id"
  end

  create_table "time_blocks", force: :cascade do |t|
    t.string "blockable_type"
    t.bigint "blockable_id"
    t.date "date", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "availability_time_block_id"
    t.index ["availability_time_block_id"], name: "index_time_blocks_on_availability_time_block_id"
    t.index ["blockable_type", "blockable_id"], name: "index_time_blocks_on_blockable"
  end

  add_foreign_key "availabilities", "employees"
  add_foreign_key "availabilities", "services"
  add_foreign_key "shifts", "employees"
  add_foreign_key "shifts", "services"
  add_foreign_key "time_blocks", "time_blocks", column: "availability_time_block_id"
end
