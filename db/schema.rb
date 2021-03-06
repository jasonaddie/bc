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

ActiveRecord::Schema.define(version: 2019_06_04_105303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_uid", null: false
    t.string "data_name", null: false
    t.string "data_mime_type"
    t.integer "data_size"
    t.string "type", limit: 30
    t.integer "data_width"
    t.integer "data_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.string "locale"
    t.index ["locale"], name: "index_friendly_id_slugs_on_locale"
    t.index ["slug", "sluggable_type", "locale"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_locale"
    t.index ["slug", "sluggable_type", "scope", "locale"], name: "index_friendly_id_slugs_uniqueness", unique: true
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "highlight_translations", force: :cascade do |t|
    t.integer "highlight_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "summary"
    t.string "link"
    t.boolean "is_public", default: false
    t.date "date_publish_old"
    t.datetime "published_at"
    t.index "to_tsvector('simple'::regconfig, (((title)::text || ' '::text) || summary))", name: "idx_highlight_search", using: :gin
    t.index ["highlight_id"], name: "index_highlight_translations_on_highlight_id"
    t.index ["is_public"], name: "index_highlight_translations_on_is_public"
    t.index ["locale"], name: "index_highlight_translations_on_locale"
    t.index ["title"], name: "index_highlight_translations_on_title"
  end

  create_table "highlights", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover_image_uid"
    t.string "crop_alignment", default: "c"
  end

  create_table "illustration_annotation_translations", force: :cascade do |t|
    t.integer "illustration_annotation_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "annotation", limit: 1000
    t.index ["illustration_annotation_id"], name: "index_7938b22a3d4e6cbb84b7378dac6a6f60586b231b"
    t.index ["locale"], name: "index_illustration_annotation_translations_on_locale"
  end

  create_table "illustration_annotations", force: :cascade do |t|
    t.bigint "illustration_id"
    t.integer "sort", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "x", precision: 5, scale: 4
    t.decimal "y", precision: 5, scale: 4
    t.index ["illustration_id"], name: "index_illustration_annotations_on_illustration_id"
    t.index ["sort"], name: "index_illustration_annotations_on_sort"
  end

  create_table "illustration_issues", force: :cascade do |t|
    t.bigint "illustration_id"
    t.bigint "issue_id"
    t.integer "page_number_start"
    t.integer "page_number_end"
    t.boolean "is_public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["illustration_id"], name: "index_illustration_issues_on_illustration_id"
    t.index ["is_public"], name: "index_illustration_issues_on_is_public"
    t.index ["issue_id"], name: "index_illustration_issues_on_issue_id"
  end

  create_table "illustration_publications", force: :cascade do |t|
    t.bigint "illustration_id"
    t.bigint "publication_id"
    t.integer "page_number_start"
    t.integer "page_number_end"
    t.boolean "is_public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["illustration_id"], name: "index_illustration_publications_on_illustration_id"
    t.index ["is_public"], name: "index_illustration_publications_on_is_public"
    t.index ["publication_id"], name: "index_illustration_publications_on_publication_id"
  end

  create_table "illustration_tags", force: :cascade do |t|
    t.bigint "illustration_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["illustration_id"], name: "index_illustration_tags_on_illustration_id"
    t.index ["tag_id"], name: "index_illustration_tags_on_tag_id"
  end

  create_table "illustration_translations", force: :cascade do |t|
    t.integer "illustration_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "context"
    t.boolean "is_public", default: false
    t.date "date_publish_old"
    t.string "slug"
    t.datetime "published_at"
    t.index "to_tsvector('simple'::regconfig, (((title)::text || ' '::text) || context))", name: "idx_illustration_search", using: :gin
    t.index ["illustration_id"], name: "index_illustration_translations_on_illustration_id"
    t.index ["is_public"], name: "index_illustration_translations_on_is_public"
    t.index ["locale"], name: "index_illustration_translations_on_locale"
    t.index ["slug"], name: "index_illustration_translations_on_slug"
    t.index ["title"], name: "index_illustration_translations_on_title"
  end

  create_table "illustrations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_uid"
    t.string "slug"
    t.bigint "person_id"
    t.string "crop_alignment", default: "c"
    t.index ["person_id"], name: "index_illustrations_on_person_id"
    t.index ["slug"], name: "index_illustrations_on_slug", unique: true
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "publication_id"
    t.string "issue_number"
    t.date "date_publication"
    t.boolean "is_public", default: false
    t.date "date_publish_old"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover_image_uid"
    t.string "scanned_file_uid"
    t.string "slug"
    t.integer "scanned_file_size"
    t.string "crop_alignment", default: "c"
    t.datetime "published_at"
    t.index "to_tsvector('simple'::regconfig, (issue_number)::text)", name: "idx_issue_search", using: :gin
    t.index ["date_publication"], name: "index_issues_on_date_publication"
    t.index ["is_public"], name: "index_issues_on_is_public"
    t.index ["publication_id"], name: "index_issues_on_publication_id"
    t.index ["slug"], name: "index_issues_on_slug", unique: true
  end

  create_table "lit_incomming_localizations", id: :serial, force: :cascade do |t|
    t.text "translated_value"
    t.integer "locale_id"
    t.integer "localization_key_id"
    t.integer "localization_id"
    t.string "locale_str"
    t.string "localization_key_str"
    t.integer "source_id"
    t.integer "incomming_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["incomming_id"], name: "index_lit_incomming_localizations_on_incomming_id"
    t.index ["locale_id"], name: "index_lit_incomming_localizations_on_locale_id"
    t.index ["localization_id"], name: "index_lit_incomming_localizations_on_localization_id"
    t.index ["localization_key_id"], name: "index_lit_incomming_localizations_on_localization_key_id"
    t.index ["source_id"], name: "index_lit_incomming_localizations_on_source_id"
  end

  create_table "lit_locales", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_hidden", default: false
  end

  create_table "lit_localization_keys", id: :serial, force: :cascade do |t|
    t.string "localization_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_completed", default: false
    t.boolean "is_starred", default: false
    t.index ["localization_key"], name: "index_lit_localization_keys_on_localization_key", unique: true
  end

  create_table "lit_localization_versions", id: :serial, force: :cascade do |t|
    t.text "translated_value"
    t.integer "localization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["localization_id"], name: "index_lit_localization_versions_on_localization_id"
  end

  create_table "lit_localizations", id: :serial, force: :cascade do |t|
    t.integer "locale_id"
    t.integer "localization_key_id"
    t.text "default_value"
    t.text "translated_value"
    t.boolean "is_changed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["locale_id"], name: "index_lit_localizations_on_locale_id"
    t.index ["localization_key_id"], name: "index_lit_localizations_on_localization_key_id"
  end

  create_table "lit_sources", id: :serial, force: :cascade do |t|
    t.string "identifier"
    t.string "url"
    t.string "api_key"
    t.datetime "last_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "sync_complete"
  end

  create_table "news", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover_image_uid"
    t.string "slug"
    t.string "crop_alignment", default: "c"
    t.index ["slug"], name: "index_news_on_slug", unique: true
  end

  create_table "news_translations", force: :cascade do |t|
    t.integer "news_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "summary"
    t.text "text"
    t.boolean "is_public", default: false
    t.date "date_publish_old"
    t.string "slug"
    t.datetime "published_at"
    t.index "to_tsvector('simple'::regconfig, (((((title)::text || ' '::text) || summary) || ' '::text) || text))", name: "idx_news_search", using: :gin
    t.index ["is_public"], name: "index_news_translations_on_is_public"
    t.index ["locale"], name: "index_news_translations_on_locale"
    t.index ["news_id"], name: "index_news_translations_on_news_id"
    t.index ["slug"], name: "index_news_translations_on_slug"
    t.index ["title"], name: "index_news_translations_on_title"
  end

  create_table "page_content_translations", force: :cascade do |t|
    t.integer "page_content_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.index "to_tsvector('simple'::regconfig, content)", name: "idx_page_content_search2", using: :gin
    t.index ["locale"], name: "index_page_content_translations_on_locale"
    t.index ["page_content_id"], name: "index_page_content_translations_on_page_content_id"
  end

  create_table "page_contents", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('simple'::regconfig, (name)::text)", name: "idx_page_content_search1", using: :gin
    t.index ["name"], name: "index_page_contents_on_name"
  end

  create_table "people", force: :cascade do |t|
    t.date "date_birth"
    t.date "date_death"
    t.boolean "is_public", default: false
    t.string "image_uid"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crop_alignment", default: "c"
    t.index ["date_birth"], name: "index_people_on_date_birth"
    t.index ["date_death"], name: "index_people_on_date_death"
    t.index ["is_public"], name: "index_people_on_is_public"
    t.index ["slug"], name: "index_people_on_slug", unique: true
  end

  create_table "person_roles", force: :cascade do |t|
    t.bigint "person_id"
    t.string "person_roleable_type"
    t.bigint "person_roleable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_old"
    t.bigint "role_id"
    t.index ["person_id"], name: "index_person_roles_on_person_id"
    t.index ["person_roleable_type", "person_roleable_id"], name: "idx_person_roleable"
    t.index ["role_id"], name: "index_person_roles_on_role_id"
    t.index ["role_old"], name: "index_person_roles_on_role_old"
  end

  create_table "person_translations", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "bio"
    t.boolean "is_public", default: false
    t.date "date_publish_old"
    t.string "slug"
    t.string "first_name"
    t.string "last_name"
    t.datetime "published_at"
    t.index "to_tsvector('simple'::regconfig, (((((first_name)::text || ' '::text) || (last_name)::text) || ' '::text) || bio))", name: "idx_person_search", using: :gin
    t.index ["is_public"], name: "index_person_translations_on_is_public"
    t.index ["last_name", "first_name"], name: "idx_person_name"
    t.index ["locale"], name: "index_person_translations_on_locale"
    t.index ["person_id"], name: "index_person_translations_on_person_id"
    t.index ["slug"], name: "index_person_translations_on_slug"
  end

  create_table "publication_editor_translations", force: :cascade do |t|
    t.integer "publication_editor_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_publication_editor_translations_on_locale"
    t.index ["publication_editor_id"], name: "index_publication_editor_translations_on_publication_editor_id"
  end

  create_table "publication_editors", force: :cascade do |t|
    t.bigint "publication_id"
    t.integer "year_start"
    t.integer "year_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_publication_editors_on_publication_id"
  end

  create_table "publication_language_translations", force: :cascade do |t|
    t.integer "publication_language_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language"
    t.string "slug"
    t.index "to_tsvector('simple'::regconfig, (language)::text)", name: "idx_publication_language_search", using: :gin
    t.index ["locale"], name: "index_publication_language_translations_on_locale"
    t.index ["publication_language_id"], name: "index_3b9f159e130bba83a1635d416364467009519f06"
    t.index ["slug"], name: "index_publication_language_translations_on_slug"
  end

  create_table "publication_languages", force: :cascade do |t|
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["is_active"], name: "index_publication_languages_on_is_active"
    t.index ["slug"], name: "index_publication_languages_on_slug", unique: true
  end

  create_table "publication_translations", force: :cascade do |t|
    t.integer "publication_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "about"
    t.boolean "is_public", default: false
    t.date "date_publish_old"
    t.string "slug"
    t.datetime "published_at"
    t.index "to_tsvector('simple'::regconfig, (((title)::text || ' '::text) || about))", name: "idx_publication_search", using: :gin
    t.index ["is_public"], name: "index_publication_translations_on_is_public"
    t.index ["locale"], name: "index_publication_translations_on_locale"
    t.index ["publication_id"], name: "index_publication_translations_on_publication_id"
    t.index ["slug"], name: "index_publication_translations_on_slug"
    t.index ["title"], name: "index_publication_translations_on_title"
  end

  create_table "publications", force: :cascade do |t|
    t.integer "publication_type"
    t.bigint "publication_language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.string "cover_image_uid"
    t.string "scanned_file_uid"
    t.string "slug"
    t.integer "scanned_file_size"
    t.string "crop_alignment", default: "c"
    t.index ["publication_language_id"], name: "index_publications_on_publication_language_id"
    t.index ["publication_type"], name: "index_publications_on_publication_type"
    t.index ["slug"], name: "index_publications_on_slug", unique: true
    t.index ["year"], name: "index_publications_on_year"
  end

  create_table "related_items", force: :cascade do |t|
    t.integer "related_item_type"
    t.integer "news_itemable_id"
    t.string "news_itemable_type"
    t.bigint "publication_id"
    t.bigint "illustration_id"
    t.bigint "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "person_id"
    t.index ["illustration_id"], name: "index_related_items_on_illustration_id"
    t.index ["issue_id"], name: "index_related_items_on_issue_id"
    t.index ["news_itemable_id", "news_itemable_type"], name: "idx_related_items_news"
    t.index ["person_id"], name: "index_related_items_on_person_id"
    t.index ["publication_id"], name: "index_related_items_on_publication_id"
    t.index ["related_item_type"], name: "index_related_items_on_related_item_type"
  end

  create_table "research_translations", force: :cascade do |t|
    t.integer "research_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "summary"
    t.text "text"
    t.boolean "is_public", default: false
    t.date "date_publish_old"
    t.string "slug"
    t.datetime "published_at"
    t.index "to_tsvector('simple'::regconfig, (((((title)::text || ' '::text) || summary) || ' '::text) || text))", name: "idx_research_search", using: :gin
    t.index ["is_public"], name: "index_research_translations_on_is_public"
    t.index ["locale"], name: "index_research_translations_on_locale"
    t.index ["research_id"], name: "index_research_translations_on_research_id"
    t.index ["slug"], name: "index_research_translations_on_slug"
    t.index ["title"], name: "index_research_translations_on_title"
  end

  create_table "researches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover_image_uid"
    t.string "slug"
    t.string "crop_alignment", default: "c"
    t.index ["slug"], name: "index_researches_on_slug", unique: true
  end

  create_table "role_translations", force: :cascade do |t|
    t.integer "role_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.index "to_tsvector('simple'::regconfig, (name)::text)", name: "idx_role_search", using: :gin
    t.index ["locale"], name: "index_role_translations_on_locale"
    t.index ["name"], name: "index_role_translations_on_name"
    t.index ["role_id"], name: "index_role_translations_on_role_id"
    t.index ["slug"], name: "index_role_translations_on_slug"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_illustrator", default: false
    t.string "slug"
    t.index ["is_illustrator"], name: "index_roles_on_is_illustrator"
    t.index ["slug"], name: "index_roles_on_slug", unique: true
  end

  create_table "slideshow_translations", force: :cascade do |t|
    t.integer "slideshow_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "caption"
    t.index ["locale"], name: "index_slideshow_translations_on_locale"
    t.index ["slideshow_id"], name: "index_slideshow_translations_on_slideshow_id"
  end

  create_table "slideshows", force: :cascade do |t|
    t.integer "sort", default: 0
    t.string "image_uid"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_slideshows_on_imageable_type_and_imageable_id"
    t.index ["sort"], name: "index_slideshows_on_sort"
  end

  create_table "tag_translations", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.index "to_tsvector('simple'::regconfig, (name)::text)", name: "idx_tag_search", using: :gin
    t.index ["locale"], name: "index_tag_translations_on_locale"
    t.index ["name"], name: "index_tag_translations_on_name"
    t.index ["slug"], name: "index_tag_translations_on_slug"
    t.index ["tag_id"], name: "index_tag_translations_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "thumbs", force: :cascade do |t|
    t.string "uid"
    t.string "job"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job"], name: "index_thumbs_on_job"
    t.index ["uid"], name: "index_thumbs_on_uid"
  end

  create_table "translations", force: :cascade do |t|
    t.string "locale"
    t.string "key"
    t.text "value"
    t.text "interpolations"
    t.boolean "is_proc", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locale", "key"], name: "index_translations_on_locale_and_key"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "name"
    t.datetime "deleted_at"
    t.index "to_tsvector('simple'::regconfig, (((name)::text || ' '::text) || (email)::text))", name: "idx_user_search", using: :gin
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "transaction_id"
    t.string "locale"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

end
