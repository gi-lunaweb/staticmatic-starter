module SiteHelper
  def content_for(name, &block) 
    instance_variable_set("@content_for_#{name}", capture_haml(&block)) 
  end
end