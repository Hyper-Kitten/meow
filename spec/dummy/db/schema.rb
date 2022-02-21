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

ActiveRecord::Schema.define(version: 2022_02_21_205003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categorical_taggings", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.bigint "tag_id_id"
    t.index ["tag_id_id"], name: "index_categorical_taggings_on_tag_id_id"
    t.index ["taggable_type", "taggable_id"], name: "index_categorical_taggings_on_taggable"
  end

  create_table "categorical_tags", force: :cascade do |t|
    t.string "label"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["label"], name: "index_categorical_tags_on_label", unique: true
    t.index ["slug"], name: "index_categorical_tags_on_slug", unique: true
  end

  create_table "hyper_kitten_meow_posts", force: :cascade do |t|
    t.string "title"
    t.boolean "published", default: false, null: false
    t.datetime "published_at", precision: 6
    t.text "summary"
    t.string "slug"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_hyper_kitten_meow_posts_on_slug", unique: true
    t.index ["user_id"], name: "index_hyper_kitten_meow_posts_on_user_id"
  end

  create_table "hyper_kitten_meow_users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_hyper_kitten_meow_users_on_email", unique: true
  end

  add_foreign_key "categorical_taggings", "categorical_tags", column: "tag_id_id"
  add_foreign_key "hyper_kitten_meow_posts", "hyper_kitten_meow_users", column: "user_id"
end
