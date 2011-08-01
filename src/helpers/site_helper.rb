module SiteHelper

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
  
end