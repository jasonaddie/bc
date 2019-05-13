# == Schema Information
#
# Table name: news
#
#  id              :bigint(8)        not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cover_image_uid :string
#

class News < ApplicationRecord
  include FullTextSearch

  #################
  ## HISTORY TRACKING ##
  #################
  has_paper_trail

  #################
  ## ATTACHED FILES ##
  #################
  dragonfly_accessor :cover_image do
    default Rails.root.join('public','images','default-wide.png')
  end

  #################
  ## ASSOCIATIONS ##
  #################
  has_many :slideshows, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :slideshows, allow_destroy: true,
    reject_if: ->(slideshow){ slideshow['image'].blank?}
  has_many :related_items, as: :news_itemable, dependent: :destroy
  accepts_nested_attributes_for :related_items, allow_destroy: true,
    reject_if: ->(item){ item['related_item_type'].blank? && item['publication_id'].blank? && item['issue_id'].blank? &&
                        item['illustration_id'].blank? && item['illustrator_id'].blank?}

  #################
  ## TRANSLATIONS ##
  #################
  translates :title, :summary, :text, :is_public, :date_publish, :slug, :versioning => :paper_trail
  accepts_nested_attributes_for :translations, allow_destroy: true

  #################
  ## SLUG
  #################
  extend FriendlyId
  include GlobalizeFriendlyId # overriden and extra methods for friendly id located in concern folder
  friendly_id :slug_candidates, use: [:globalize, :history, :slugged]

  # give options of what to use when the slug is already in use by another record
  def slug_candidates
    [
      :title,
      [:title, :date_publish]
    ]
  end

  #################
  ## VALIDATION ##
  #################
  validates_size_of :cover_image, maximum: 5.megabytes
  validates_property :ext, of: :cover_image, in: ['jpg', 'jpeg', 'png', 'JPG', 'JPEG', 'PNG']

  #################
  ## CALLBACKS ##
  #################
  before_save :set_translation_publish_dates
  validate :check_self_public_required_fields

  #################
  ## SCOPES ##
  #################
  scope :published, -> { where(is_public: true) }
  scope :sort_published_desc, -> { order(date_publish: :desc) }

  # filter news by the following:
  # - search - string
  # - date_start - published after this date
  # - date_end - published before this date
  def self.filter(options={})
    x = self
    if options[:search].present?
      x = x.with_translations(I18n.locale)
            .where(build_full_text_search_sql(%w(news_translations.title news_translations.summary news_translations.text)),
              options[:search]
            )
    end

    if options[:date_start].present?
      x = x.with_translations(I18n.locale).where('news_translations.date_publish >= ?', options[:date_start])
    end

    if options[:date_end].present?
      x = x.with_translations(I18n.locale).where('news_translations.date_publish <= ?', options[:date_end])
    end

    return x.distinct
  end

  #################
  ## RAILS ADMIN CONFIGURATION ##
  #################
  rails_admin do
    # add to a navigration group
    navigation_label I18n.t('navigation_groups.news')

    configure :translations, :globalize_tabs
    # control the order in the admin nav menu
    weight 300

    # configuration
    configure :summary do
      pretty_value do
        value.nil? ? nil : value.html_safe
      end
    end
    configure :text do
      pretty_value do
        value.nil? ? nil : value.html_safe
      end
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
    configure :cover_image do
      html_attributes required: required? && !value.present?, accept: 'image/*'
    end
    configure :slideshows do
      # determine if the has many block should be open when page loads
      active do
        bindings[:object].slideshows.present?
      end

      # show list of images in slideshow
      pretty_value do
        bindings[:view].content_tag(:ul, class: 'list-unstyled') do
          bindings[:object].slideshows.sorted.collect do |slideshow_image|
            bindings[:view].content_tag(:li) do
              bindings[:view].tag(:img, { :src => slideshow_image.image.thumb('400x').url }) +
              bindings[:view].content_tag(:div, slideshow_image.caption, class: 'image-caption')
            end
          end.join.html_safe
        end
      end
    end

    # list page
    list do
      field :is_public
      field :cover_image
      field :title
      field :summary
      field :date_publish
    end

    # show page
    show do
      field :is_public
      field :cover_image
      field :title
      field :summary
      field :text
      field :slideshows
      field :date_publish
      field :created_at
      field :updated_at
    end

    # form
    edit do
      field :cover_image do
        help "#{I18n.t('admin.help.image_size.news')} #{I18n.t('admin.help.image')}"
      end
      field :translations do
        label I18n.t('labels.translations')
      end
      field :slideshows do
        partial "form_nested_many_sorting"
      end
      field :related_items
    end
  end

  #################
  ## PRIVATE METHODS ##
  #################
  private

  def check_self_public_required_fields
    # call the methohd in the application record base object
    super(%w(title summary text))
  end
end
