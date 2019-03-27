# == Schema Information
#
# Table name: people
#
#  id         :bigint(8)        not null, primary key
#  date_birth :date
#  date_death :date
#  image_uid  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Person < ApplicationRecord

  #################
  ## HISTORY TRACKING ##
  #################
  has_paper_trail

  #################
  ## ATTACHED FILES ##
  #################
  dragonfly_accessor :image do
    default Rails.root.join('public','images','default-square.png')
  end

  #################
  ## ASSOCIATIONS ##
  #################
  has_many :person_roles, dependent: :destroy
  has_many :illustrations, dependent: :nullify
  has_many :related_items, dependent: :nullify

  #################
  ## TRANSLATIONS ##
  #################
  translates :name, :bio, :is_public, :date_publish, :slug, :versioning => :paper_trail
  accepts_nested_attributes_for :translations, allow_destroy: true

  #################
  ## SLUG
  #################
  extend FriendlyId
  friendly_id :name, use: [:globalize, :history, :slugged]

  # override to use all locales and not the locales that exist in the
  # translation record
  # from: https://github.com/norman/friendly_id-globalize/blob/master/lib/friendly_id/globalize.rb
  def set_slug(normalized_slug = nil)
    (I18n.available_locales.presence || [::Globalize.locale]).each do |locale|
      ::Globalize.with_locale(locale) { super_set_slug(normalized_slug) }
    end
  end

  # override to test if the base value (i.e., name) is present and if so, generate slug
  # from: https://github.com/norman/friendly_id-globalize/blob/master/lib/friendly_id/globalize.rb
  def should_generate_new_friendly_id?
    send("#{friendly_id_config.base}_translations")[::Globalize.locale.to_s].present? && translation_for(::Globalize.locale).send(friendly_id_config.slug_column).nil?
  end


  # for locale sensitive transliteration with friendly_id
  def normalize_friendly_id(input)
    input.to_s.to_url
  end

  #################
  ## VALIDATION ##
  #################
  validates_size_of :image, maximum: 5.megabytes
  validates_property :ext, of: :image, in: ['jpg', 'jpeg', 'png', 'JPG', 'JPEG', 'PNG']

  #################
  ## CALLBACKS ##
  #################
  before_save :set_translation_publish_dates
  validate :check_self_public_required_fields
  # before_validation :remove_blanks

  #################
  ## SCOPES ##
  #################
  scope :published, -> { with_translations(I18n.locale).where('person_translations.is_public': true) }
  scope :sort_published_desc, -> { order(date_publish: :desc) }
  scope :sort_name, -> { with_translations(I18n.locale).order('person_translations.name asc') }

  #################
  ## METHODS ##
  #################
  def illustration_count
    self.illustrations.count
  end

  def unique_role_names
    self.person_roles.unique_roles.map{|x| x[:name]}
  end

  def has_dates?
    self.date_birth.present? || self.date_death.present?
  end

  #################
  ## RAILS ADMIN CONFIGURATION ##
  #################
  rails_admin do
    # add to a navigration group
    navigation_label I18n.t('navigation_groups.primary')

    configure :translations, :globalize_tabs
    # control the order in the admin nav menu
    weight 100

    # configuration
    configure :date_birth do
      date_format :default
      datepicker_options showTodayButton: false, format: 'YYYY-MM-DD', viewMode: 'years', minDate: '1800-01-01', maxDate: "#{Time.now.year}-12-31"
    end
    configure :date_death do
      date_format :default
      datepicker_options showTodayButton: false, format: 'YYYY-MM-DD', viewMode: 'years', minDate: '1800-01-01', maxDate: "#{Time.now.year}-12-31"
    end
    configure :bio do
      pretty_value do
        value.nil? ? nil : value.html_safe
      end
    end
    configure :image do
      html_attributes required: required? && !value.present?, accept: 'image/*'
    end
    configure :is_public do
      # build an inline list that shows the status of each language
      pretty_value do
        bindings[:view].content_tag(:ul, class: 'list-inline is-public-status') do
          I18n.available_locales.collect do |locale|
            bindings[:view].content_tag(
              :li,
              locale.upcase,
              class: bindings[:object].send("is_public_translations")[locale] ? 'public' : 'not-public',
              title: I18n.t("languages.#{locale}") + ' - ' + I18n.t("status.#{bindings[:object].send("is_public_translations")[locale]}")
            )
          end.join.html_safe
        end
      end
    end

    # list page
    list do
      field :is_public
      field :image
      field :name
      field :date_birth
      field :date_death
      field :illustration_count do
        label I18n.t('labels.illustration_count')
      end
      field :date_publish
    end

    # show page
    show do
      field :is_public
      field :image
      field :name
      field :bio
      field :date_birth
      field :date_death
      field :illustration_count do
        label I18n.t('labels.illustration_count')
      end
      field :date_publish
      field :created_at
      field :updated_at
    end

    # form
    edit do
      field :translations do
        label I18n.t('labels.translations')
      end
      field :image do
        help I18n.t('admin.help.image')
      end
      field :date_birth
      field :date_death
    end
  end


  #################
  ## PRIVATE METHODS ##
  #################
  private

  def check_self_public_required_fields
    # call the methohd in the application record base object
    super(%w(name bio))
  end
end