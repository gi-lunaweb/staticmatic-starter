module RailsRenderHelper
  
  # Does not support :update, :file, :inline or :text options
  # Does not support block (and will raise an Exception if a block is given)
  # Example :
  #
  #   render 'partial-name', :locals => { :name => 'value' }
  #   render { :partial => 'partial-name' }, { :name => 'value' }
  #
  def render(options = {}, local_assigns = {}, &block)
    raise Exception('Block syntax not supported') if block_given?
    case options
      when Hash
        p = options.delete(:partial)
      else
        p, options = options, {}
    end
    options[:locals] ||= local_assigns
    partial p, options
  end
  
end