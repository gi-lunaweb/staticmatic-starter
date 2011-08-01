module PageHelper

  def page_find(name, pages = nil)
    (pages ||= pages_yml).each do |page|
      return page if page['name'] == name.to_s
      return child if page['children'] and child = page_find(name, page['children'])
    end
    nil
  end

  def pages_yml
    @pages ||= YAML.load(File.open(File.expand_path('../../../config/pages.yml', __FILE__)))
  end

  private

    def pages_list(type, pages, max_depth = 2, depth = 0)
      
      active = @current_page || nil
      has_active = false
      prefix = "  " * depth

      nav = %(#{prefix}<ul>\n)

      pages.each_with_index do |page, i|
        next if page["hide_in_#{type}"]

        nav_children = ''
        has_active = (active == page['name'])

        if page['children'] and max_depth > (depth + 2)
          nav_children, active = pages_list(type, page['children'], max_depth, depth + 2)
          has_active ||= active
        end

        nav << <<-NAV.gsub(/^[\s]{8}/, '')
        #{prefix}  <li#{depth == 0 ? %( id="n#{i + 1}") : ''}#{has_active ? %( class="active") : ''}>
        #{prefix}    <a href="#{page['url']}">#{page['title']}</a>#{nav_children.blank? ? '' : "\n#{nav_children.gsub(/^[\s]/, "#{prefix}     ")}"}
        #{prefix}  </li>
        NAV
      end

      nav << %(#{prefix}</ul>\n)

      if depth == 0
        nav
      else
        [nav, has_active]
      end
    end

end