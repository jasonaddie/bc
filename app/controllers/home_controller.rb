class HomeController < ApplicationController

  before_action :set_pagination_values
  before_action :clean_search_query


  def index
    @publications = Publication.published.sort_published_desc.limit(3)
    @news = News.published.sort_published_desc.limit(3)
    @illustrations = Illustration.published.sort_published_desc.limit(3)
    @stats = get_stats
    @highlights = Highlight.published.sort_published_desc

    @page = PageContent.with_translations(I18n.locale).find_by_name('homepage_intro')
  end

  def sources
    @publications = Publication.published
                      .filter({search: params[:search], type: params[:type], language: params[:language],
                                date_start: convert_date_param(:date_start), date_end: convert_date_param(:date_end)})
                      .sort_name_asc.page(params[:page]).per(@pagination_per_large)
    @filter_source_types = Publication.publication_types_for_select2
    @filter_languages = PublicationLanguage.active.sort_language.with_published_publications
  end

  def source
    @publication = Publication.friendly.published.find(params[:id])
  end

  def issue
    @publication = Publication.friendly.published.find(params[:publication_id])
    @issue = @publication.issues.friendly.published.find(params[:id]) if @publication
  end

  # def illustrations
    # @illustrations = Illustration.published.filter({search: params[:search], type: params[:type], illustrator: params[:illustrator]}).sort_published_desc.page(params[:page]).per(@pagination_per_large)
    # @filter_source_types = Publication.publication_types_for_select2
    # @filter_illustrators = Person.illustrator.published.sort_name
  # end

  # def illustration
  #   @illustration = Illustration.friendly.published.find(params[:id])
  # end

  def images
    @illustrations = Illustration.published
                        .filter({search: params[:search], type: params[:type], illustrator: params[:illustrator],
                                date_start: convert_date_param(:date_start), date_end: convert_date_param(:date_end)})
                        .sort_published_desc.page(params[:page]).per(@pagination_per_large)
    @filter_source_types = Publication.publication_types_for_select2
    @filter_illustrators = Person.with_illustrations.published.sort_name_asc
  end

  def image
    @illustration = Illustration.friendly.published.find(params[:id])
  end

  # def illustrators
  #   @illustrators = Illustrator.published.sort_published_desc
  # end

  # def illustrator
  #   @illustrator = Illustrator.friendly.published.find(params[:id])
  # end

  def people
    @people = Person.published
                .filter({search: params[:search], role: params[:role],
                          date_start: convert_date_param(:date_start), date_end: convert_date_param(:date_end)})
                .sort_name_asc.page(params[:page]).per(@pagination_per_large)
    @filter_roles = Role.roles_assigned_to_published_people.sort_name.uniq
  end

  def person
    @person = Person.friendly.published.find(params[:id])
  end

  def news
    @news = News.published
                .filter({search: params[:search],
                        date_start: convert_date_param(:date_start), date_end: convert_date_param(:date_end)})
                .sort_published_desc.page(params[:page]).per(@pagination_per_small)
  end

  def news_item
    @news_item = News.friendly.published.find(params[:id])
  end

  def researches
    @researches = Research.published
                          .filter({search: params[:search],
                                    date_start: convert_date_param(:date_start), date_end: convert_date_param(:date_end)})
                          .sort_published_desc.page(params[:page]).per(@pagination_per_small)
  end

  def research
    @research = Research.friendly.published.find(params[:id])
  end

  def about
    @page = PageContent.with_translations(I18n.locale).find_by_name('about')
  end

  def robots
    # load the robots.text file
  end

private

  # get counts for the following:
  # journal issues | issue illustrations
  # book | book illustrations
  # original | original illustrations
  # illustrator | illustrator illustration
  def get_stats
    stats = {}

      # issues
      ids = Issue.published.pluck(:id)
      stats[:journal_issues] = {}
      stats[:journal_issues][:count] = ids.count
      stats[:journal_issues][:illustrations] = IllustrationIssue.where(issue_id: ids).count

      # books
      ids = Publication.published.book.pluck(:id)
      stats[:books] = {}
      stats[:books][:count] = ids.count
      stats[:books][:illustrations] = IllustrationPublication.where(publication_id: ids).count

      # originals
      ids = Publication.published.original.pluck(:id)
      stats[:originals] = {}
      stats[:originals][:count] = ids.count
      stats[:originals][:illustrations] = IllustrationPublication.where(publication_id: ids).count

      # illustrators
      ids = PersonRole.illustrators
      stats[:illustrators] = {}
      stats[:illustrators][:count] = ids.map{|x| x.person_id}.uniq.length
      stats[:illustrators][:illustrations] = Illustration.published.where(id: ids.map{|x| x.person_roleable_id}.uniq).count

    return stats
  end


  def set_pagination_values
    if params[:page].nil? || params[:page].to_i == 0
      params[:page] = 1
    end

    @pagination_per_large = 12
    @pagination_per_small = 4
  end

  def clean_search_query
    params[:search] = params[:search].present? ? params[:search].gsub("'", "").gsub('"', '') : nil
  end

  def convert_date_param(param_key)
    d = nil
    if params[param_key].present?
      begin
        if /^\d\d\d\d-[0-1][1-9]-[0-3]\d$/.match?(params[param_key])
          d = Date.parse(params[param_key])
        else
          # reset the param value
          params[param_key] = nil
        end
      rescue
        # do nothing
      end
    end

    return d
  end
end
