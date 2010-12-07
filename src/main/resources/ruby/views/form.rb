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

      def textarea(name, prefix = nil, options = {})
        content_tag 'textarea', name, prefix, 'value', options
      end

      def checkbox(name, prefix = nil, options = {})
        content_tag 'checkbox', name, prefix, 'checked', options
      end

      private
      def content_tag(tag_name, name, prefix = nil, field_value = 'value', options = {})
        field_name = prefix.nil? ? name : "#{prefix}.#{name}"
        value = "${instance.#{name}}"

        attrs = {
          :name => field_name,
          field_value => value
        }.merge options

        "<f:#{tag_name} #{map_to_attrs(attrs)}/>"
      end
    end
  end
end
