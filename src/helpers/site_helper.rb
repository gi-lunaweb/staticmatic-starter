module SiteHelper

  def content_for(name, content = nil, &block)
    @_content_for = {} unless instance_variable_defined? :@_content_for and not @_content_for.nil?
    @_content_for[name] = String.new unless @_content_for.key? name

    content = capture_haml(&block) if block_given?
    @_content_for[name] << content if content
    @_content_for[name] unless content
  end

  def seo_title(title = nil)
    content_for(:seo_title, "#{title} - ") if title
    content_for(:seo_title).gsub(/^([\s-]+)/, '').gsub(/([\s-]+)$/, '') unless title
  end

  def seo_description(desc = nil)
    content_for(:seo_description, desc)
  end

  def body_class(klass = nil)
    content_for(:body_class, " #{klass}") if klass
    content_for(:body_class).strip unless klass
  end
end