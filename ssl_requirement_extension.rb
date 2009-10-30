require_dependency 'application_controller'

class SslRequirementExtension < Radiant::Extension
  version "0.1"
  description "Add ssl requirement to admin pages."
  url "http://github.com/jfqd/radiant-ssl_requirement-extension"
  
  def activate
    # add ssl requirement to application_contoller
    ApplicationController.class_eval do
      include SslRequirement
      def ssl_required?
        # you may wanna change this
        local_request? || RAILS_ENV == 'test' || RAILS_ENV == 'development' ? false : true
      end
    end
    
    # remove ssl requirement from site_contoller
    ApplicationController::SiteController.class_eval do
      include SslRequirement
      def ssl_required?
        false
      end
    end

  end
  
  def deactivate
    # will never happen
  end
  
end
