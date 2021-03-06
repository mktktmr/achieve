module ApplicationHelper
end

module ActionView
  module Helpers
    module FormHelper

      def profile_img(user, options = {})
        
        options.store(:alt, user.name)
        
        return image_tag(user.avatar, options) if user.avatar?

        if user.provider.blank?
          img_url = 'no_image.png'
        else
          img_url = user.image_url
        end

        image_tag(img_url, options)
      end

      def error_messages!(object_name, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if !resource || resource.errors.empty?

        messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

        html = <<-HTML
          <div class="alert alert-danger">
            <ul>#{messages}</ul>
          </div>
        HTML

        html.html_safe
      end

      def error_css(object_name, method, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if resource.errors.empty?

        resource.errors.include?(method) ? 'has-error' : ''
      end
    end

    class FormBuilder
      def error_messages!(options = {})
        @template.error_messages!(@object_name, options.merge(object: @object))
      end

      def error_css(method, options = {})
        @template.error_css(@object_name, method, options.merge(object: @object))
      end
    end
  end
end
