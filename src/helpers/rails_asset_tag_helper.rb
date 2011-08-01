
# Asset Tag helpers
# http://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html
module RailsAssetTagHelper

  def image_tag(source, options = {})
    if size = options.delete(:size)
      options[:width], options[:height] = *size.split('x')
    end
    img source, { :alt => options.delete(:alt), :width => options.delete(:width), :height => options.delete(:height) }
  end

  def javascript_include_tag(*sources)
    javascripts(sources)
  end

  def stylesheet_link_tag(*sources)
    stylesheets(sources)
  end

end