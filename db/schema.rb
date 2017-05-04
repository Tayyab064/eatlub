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

ActiveRecord::Schema.define(version: 20170504090352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "address"
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "categories_food_items", force: :cascade do |t|
    t.integer "category_id"
    t.integer "food_item_id"
    t.index ["category_id"], name: "index_categories_food_items_on_category_id", using: :btree
    t.index ["food_item_id"], name: "index_categories_food_items_on_food_item_id", using: :btree
  end

  create_table "components", force: :cascade do |t|
    t.string   "title",      default: ""
    t.float    "price",      default: 0.0
    t.integer  "option_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["option_id"], name: "index_components_on_option_id", using: :btree
  end

  create_table "deals", force: :cascade do |t|
    t.datetime "avaliable"
    t.integer  "total_order",   default: 1
    t.integer  "order",         default: 0
    t.float    "discount",      default: 1.0
    t.integer  "restaurant_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["restaurant_id"], name: "index_deals_on_restaurant_id", using: :btree
  end

  create_table "deliver_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "image"
    t.string   "description", default: ""
  end

  create_table "deliverables", force: :cascade do |t|
    t.string   "name"
    t.datetime "opening_time"
    t.datetime "closing_time"
    t.string   "location"
    t.integer  "owner_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "status",              default: 0
    t.string   "image",               default: ""
    t.boolean  "popular",             default: false
    t.string   "about_us",            default: ""
    t.string   "post_code"
    t.integer  "weekly_order",        default: 0
    t.string   "no_of_location"
    t.boolean  "delivery",            default: false
    t.float    "delivery_fee",        default: 0.0
    t.float    "commission",          default: 0.0
    t.string   "cover"
    t.string   "phone_number"
    t.string   "close_day",           default: [],                 array: true
    t.integer  "order_status",        default: 0
    t.integer  "deliver_category_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["deliver_category_id"], name: "index_deliverables_on_deliver_category_id", using: :btree
  end

  create_table "details", force: :cascade do |t|
    t.boolean  "online",     default: true
    t.integer  "status",     default: 0
    t.string   "city"
    t.integer  "vehicle"
    t.integer  "rider_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string   "token"
    t.string   "device",     default: "Android"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["user_id"], name: "index_devices_on_user_id", using: :btree
  end

  create_table "food_items", force: :cascade do |t|
    t.string   "name"
    t.float    "price"
    t.integer  "section_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "image",       default: ""
    t.boolean  "publish",     default: true
    t.string   "description"
    t.index ["section_id"], name: "index_food_items_on_section_id", using: :btree
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "title"
    t.float    "price",        default: 0.0
    t.integer  "food_item_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["food_item_id"], name: "index_ingredients_on_food_item_id", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "orderable_type"
    t.integer  "orderable_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "quantity",       default: 0
    t.integer  "ingredients",    default: [],              array: true
    t.integer  "option",         default: [],              array: true
    t.index ["order_id"], name: "index_items_on_order_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address",    default: ""
    t.integer  "rider_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string   "title",         default: "Menu"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "menuable_id"
    t.string   "menuable_type"
  end

  create_table "options", force: :cascade do |t|
    t.string   "title"
    t.float    "price",        default: 0.0
    t.integer  "food_item_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["food_item_id"], name: "index_options_on_food_item_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "address",     default: ""
    t.string   "notes",       default: ""
    t.integer  "status",      default: 0
    t.integer  "user_id"
    t.integer  "rider_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "assigned"
    t.float    "tip",         default: 0.0
    t.integer  "ordera_id"
    t.string   "ordera_type"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "promocodes", force: :cascade do |t|
    t.string   "promocode"
    t.float    "amount",     default: 1.0
    t.boolean  "used",       default: false
    t.integer  "usedby"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.datetime "opening_time"
    t.datetime "closing_time"
    t.string   "location"
    t.string   "cuisine"
    t.string   "typee"
    t.integer  "owner_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "status",         default: 0
    t.string   "image",          default: ""
    t.boolean  "popular",        default: false
    t.string   "about_us",       default: ""
    t.string   "post_code"
    t.integer  "weekly_order",   default: 0
    t.string   "no_of_location"
    t.boolean  "delivery",       default: false
    t.float    "delivery_fee",   default: 0.0
    t.float    "commission",     default: 0.0
    t.string   "cover"
    t.string   "phone_number"
    t.string   "close_day",      default: [],                 array: true
    t.integer  "order_status",   default: 0
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "summary",         default: ""
    t.integer  "rating",          default: 1
    t.integer  "quality",         default: 1
    t.integer  "price",           default: 1
    t.integer  "punctuality",     default: 1
    t.integer  "courtesy",        default: 1
    t.integer  "reviewer_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "title",       default: ""
    t.integer  "menu_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "description"
    t.index ["menu_id"], name: "index_sections_on_menu_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                 default: ""
    t.string   "username",             default: ""
    t.string   "email"
    t.integer  "gender"
    t.integer  "role",                 default: 0
    t.boolean  "verified",             default: false
    t.boolean  "block",                default: false
    t.string   "password_digest"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "inpas"
    t.string   "token"
    t.string   "mobile_number"
    t.string   "password_reset_token"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["role"], name: "index_users_on_role", using: :btree
  end

  create_table "wallets", force: :cascade do |t|
    t.float    "amount",     default: 0.0
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_wallets_on_user_id", using: :btree
  end

end
