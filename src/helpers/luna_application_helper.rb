
# Application helper
# https://lunaweb.codebasehq.com/luna/luna-rails-app-templates/blob/master/files/app/helpers/application_helper.rb
module LunaApplicationHelper

  TITLE_SEPARATOR = '-'

  # Help individual pages to set their HTML titles
  def meta_title_full
    "#{meta_title} #{TITLE_SEPARATOR} #{@site_name}".
      gsub(Regexp.new( "^([\s#{TITLE_SEPARATOR}]+)"), '').
      gsub(Regexp.new( "([\s#{TITLE_SEPARATOR}]+)$"), '') if instance_variable_defined? :@site_name
    meta_title unless instance_variable_defined? :@site_name
  end

  # Help individual pages to set their HTML titles
  def meta_title(title = nil, meta_title = false)
    page_title title if meta_title
    content_for(:meta_title, "#{title} #{TITLE_SEPARATOR} ") if title
    content_for(:meta_title).
      gsub(Regexp.new( "^([\s#{TITLE_SEPARATOR}]+)"), '').
      gsub(Regexp.new( "([\s#{TITLE_SEPARATOR}]+)$"), '') unless title
  end

  # Help individual pages to set their HTML meta descriptions
  def meta_description(description = nil)
    content_for(:meta_description, description)
  end

  # Help individual pages to set their HTML robots meta
  def meta_robots(text = nil)
    content_for(:meta_robots, text)
  end

  def body_class(klass = nil)
    content_for(:body_class, " #{klass}") if klass
    content_for(:body_class).strip unless klass
  end

  def page_title(title = nil)
    content_for(:page_title, title) if title and not content_for?(:page_title)
    content_for(:page_title) unless title
  end

end