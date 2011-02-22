require_dependency 'application_controller'
require 'fileutils'

class SslRequirementExtension < Radiant::Extension
  version "0.4"
  description "Add ssl requirement to admin pages."
  url "http://github.com/jfqd/radiant-ssl_requirement-extension"
  
  def activate
    # add ssl requirement to admin area
    if respond_to?(:tab) # 0.9
      controllers = [ApplicationController, Admin::ResourceController, Admin::PagesController]
    else
      controllers = [ApplicationController]
    end
    
    controllers.each do |c|
      c.class_eval {
        include SslRequirement
        def ssl_required?
          local_request? || RAILS_ENV == 'test' || RAILS_ENV == 'development' ? false : true
        end
      }
    end
    
    src = File.dirname(__FILE__) + '/ssl_requirement.yml'
    dest = RAILS_ROOT + '/config/ssl_requirement.yml'
    FileUtils.cp(src, dest) unless RAILS_ENV == 'test'

    reader = CompatabilityReader.new
    components = reader.read(dest)

    components.each do |c|
      if class_exists?(c.controller)
        klass = Module.const_get(c.controller)

        if c.ssl_required
          klass.class_eval {
            def ssl_required?
              true
            end
          }
        else
          klass.class_eval {
            def ssl_required?
              false
            end
          }
        end

      end
    end
  end
  
  def deactivate
    # will never happen
  end
  
  private 
    def class_exists?(class_name)
      klass = Module.const_get(class_name)
        return klass.is_a?(Class)
      rescue NameError
        return false
    end
end
