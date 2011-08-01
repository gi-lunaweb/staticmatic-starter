
# Capture helpers
# http://api.rubyonrails.org/classes/ActionView/Helpers/CaptureHelper.html
module RailsCaptureHelper

  def content_for(name, content = nil, &block)
    @_content_for = {} unless instance_variable_defined? :@_content_for and not @_content_for.nil?
    @_content_for[name] = String.new unless @_content_for.key? name

    content = capture_haml(&block) if block_given?
    @_content_for[name] << content if content
    @_content_for[name] unless content
  end

  def content_for?(name)
    instance_variable_defined? :@_content_for and not @_content_for.nil? and @_content_for.key? name and @_content_for[name]
  end
  
end