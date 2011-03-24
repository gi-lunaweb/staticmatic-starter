module SiteHelper

  def content_for(name, content = nil, &block)
    @_content_for = {} unless instance_variable_defined? :@_content_for and not @_content_for.nil?
    @_content_for[name] = String.new unless @_content_for.key? name

    content = capture_haml(&block) if block_given?
    @_content_for[name] << content if content
    @_content_for[name] unless content
  end

  def page_title(title = nil)
    content_for(:page_title, "#{title} - ") if title
    content_for(:page_title).gsub(/^([\s-]+)/, '').gsub(/([\s-]+)$/, '') unless title
  end

  def page_description(description = nil)
    content_for(:page_description, description)
  end

  def body_class(klass = nil)
    content_for(:body_class, " #{klass}") if klass
    content_for(:body_class).strip unless klass
  end

  def navigation(depth = 1)
    pages_list 'navigation', pages_yml, depth * 2
  end

  def sitemap(depth = 3)
    active = @current_page || nil
    
    nav = "<dl>\n"
    pages_yml.each do |page|
      unless page["hide_in_sitemap"]
        nav << %(  <dt>#{page['title']}</dt>\n)
        nav << %(  <dd>\n)
        if page['children']
          nav_children, active = pages_list('sitemap', page['children'], depth * 2, 2)
          nav_children.gsub!(' class="active"', '')
          
          nav << nav_children
        end
        nav << %(  </dd>\n)
      end
    end
    nav << '</dl>'
  end

  def link_to(name, label = nil)
    get = lambda do |pages|
      find = nil
      pages.each do |page|
        if page['name'] == name.to_s
          find = page
          break
        else
          child = get.call page['children'] if page['children']
          if child
            find = child
            break
          end
        end
      end
      find
    end
    
    page = get.call pages_yml
    if page
      label ||= page['title']
      return %(<a href="#{page['url']}">#{label}</a>)
    end
    ''
  end

  private
  
  def pages_list(type, pages, max_indice = 2, indice = 0)
    active = @current_page || nil
    
    has_active = false
    prefix = "  " * indice
    nav = %(#{prefix}<ul>\n)
    
    pages.each_with_index do |page, i|
      unless page["hide_in_#{type}"]
        has_active = (active == page['name'])
        if page['children']
          nav_children = ''
          if max_indice > (indice + 2)
            nav_children, active = pages_list(type, page['children'], max_indice, indice + 2)
            has_active ||= active
          end
        end
        
        id = indice == 0 ? %( id="n#{i + 1}") : ''
        klass = has_active ? %( class="active") : ''
        
        nav << %(#{prefix}  <li#{id}#{klass}>\n)
        nav << %(#{prefix}    <a href="#{page['url']}">#{page['title']}</a>)
        
        if page['children'] && !nav_children.blank?
          nav << "\n#{nav_children}"
        else
          nav << "\n"
        end
        
        nav << %(#{prefix}  </li>\n)
      end
    end
    
    nav << %(#{prefix}</ul>\n)
    
    if indice == 0
      nav
    else
      [nav, has_active]
    end
  end
  
  def pages_yml
    @pages ||= YAML.load(File.open(File.expand_path('../../../config/pages.yml', __FILE__)))
  end
  
end