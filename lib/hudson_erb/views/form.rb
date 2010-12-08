module Hudson
  module View
    module Form
      def entry(name, options = {}, &block)
        attrs = {:name => name}.merge options

        @output ||= ''
        @output << "<f:entry #{map_to_attrs(attrs)}>"
        yield if block_given?
        @output << '</f:entry>'
      end

      def textbox(name, options = {})
        content_tag 'textbox', name, 'value', options
      end

      def expandable_textbox(name, options = {})
        content_tag 'expandableTextbox', name, 'value', options
      end

      def textarea(name, options = {})
        content_tag 'textarea', name, 'value', options
      end

      def checkbox(name, options = {})
        content_tag 'checkbox', name, 'checked', options
      end

      private
      def content_tag(tag_name, name, field_value = 'value', options = {})
        field_name = name.split('.')[-1]
        value = "${instance.#{field_name}}"

        attrs = {
          :name => name,
          field_value => value
        }.merge options

        "<f:#{tag_name} #{map_to_attrs(attrs)}/>"
      end
    end
  end
end
