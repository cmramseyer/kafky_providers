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

ActiveRecord::Schema[8.1].define(version: 2026_08_06_170000) do
  create_table "outbox_events", force: :cascade do |t|
    t.bigint "aggregate_id", null: false
    t.string "aggregate_type", null: false
    t.datetime "created_at", null: false
    t.string "event_id", null: false
    t.string "event_type", null: false
    t.json "payload", null: false
    t.datetime "published_at"
    t.datetime "updated_at", null: false
    t.index ["aggregate_type", "aggregate_id"], name: "index_outbox_events_on_aggregate_type_and_aggregate_id"
    t.index ["event_id"], name: "index_outbox_events_on_event_id", unique: true
    t.index ["published_at"], name: "index_outbox_events_on_published_at"
  end

  create_table "provider_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "delivered", default: false, null: false
    t.text "product_desc", null: false
    t.string "product_sku", null: false
    t.integer "provider_id", null: false
    t.integer "purchase_quantity", null: false
    t.string "source_event_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_provider_orders_on_provider_id"
    t.index ["source_event_id"], name: "index_provider_orders_on_source_event_id", unique: true
  end

  create_table "providers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_providers_on_email", unique: true
  end

  add_foreign_key "provider_orders", "providers"
end
