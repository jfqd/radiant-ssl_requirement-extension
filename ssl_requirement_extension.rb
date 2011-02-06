require_dependency 'application_controller'

class SslRequirementExtension < Radiant::Extension
  version "0.3"
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
          # you may wanna change this
          local_request? || RAILS_ENV == 'test' || RAILS_ENV == 'development' ? false : true
        end
      }
    end
    
    # remove ssl requirement from site_contoller
    ApplicationController::SiteController.class_eval do
      include SslRequirement
      def ssl_required?
        false
      end
    end
    
    # add compatibility for the sitemap_xml extension (http://blog.aissac.ro/radiant/sitemap-xml-extension/)
    if defined?(SitemapXmlExtension)
      SitemapXmlController.class_eval {
        def ssl_required?
          false
        end
      }
    end

    # add compatability for the mailer extension
    if defined?(MailerExtension)
      MailController.class_eval {
        def ssl_required?
          false
        end
      }
    end

  end
  
  def deactivate
    # will never happen
  end
  
end
