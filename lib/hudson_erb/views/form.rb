module Hudson
  module View
    module Form
      # Generates an entry element for a form field.
      #
      # @param [String, Symbol] name is the attribute `name` of the element
      # @param [Hash] options that are used as additional attributes for the element
      # @param [Block] block that's executed to render nested elements
      #
      # Example:
      #
      #   <% entry 'Address' do %>
      #     <input type="text" name="address"/>
      #   <% end %>
      #
      # Generates:
      #
      #   <f:entry name="Address">
      #     <input type="text" name="address"/>
      #   </f:entry>
      #
      def entry(name, options = {}, &block)
        attrs = {:name => name}.merge options

        @output ||= ''
        @output << "<f:entry #{map_to_attrs(attrs)}>"
        yield if block_given?
        @output << '</f:entry>'
      end

      # Generates a textbox
      #
      # @param [String, Symbol] name is the attribute `name` for the element
      # @param [Hash] options to render a additional attributes for the element
      #
      # Example:
      #
      #   <%= textbox :directory %>
      #
      # Generates:
      #
      #   <f:textbox name="directory" value="${instance.directory}"/>
      #
      def textbox(name, options = {})
        content_tag 'textbox', name, 'value', options
      end

      # Generates an expandable textbox
      #
      # @param [String, Symbol] name is the attribute `name` for the element
      # @param [Hash] options to render a additional attributes for the element
      #
      # Example:
      #
      #   <%= expandable_textbox :directories %>
      #
      # Generates:
      #
      #   <f:expandableTextbox name="directories" value="${instance.directories}"/>
      #
      def expandable_textbox(name, options = {})
        content_tag 'expandableTextbox', name, 'value', options
      end

      # Generates a textarea
      #
      # @param [String, Symbol] name is the attribute `name` for the element
      # @param [Hash] options to render a additional attributes for the element
      #
      # Example:
      #
      #   <%= textarea :script %>
      #
      # Generates:
      #
      #   <f:textarea name="script" value="${instance.script}"/>
      #
      def textarea(name, options = {})
        content_tag 'textarea', name, 'value', options
      end

      # Generates a checkbox
      #
      # @param [String, Symbol] name is the attribute `name` for the element
      # @param [Hash] options to render a additional attributes for the element
      #
      # Example:
      #
      #   <%= ckeckbox :verbose %>
      #
      # Generates:
      #
      #   <f:checkbox name="verbose" checked="${instance.verbose}"/>
      #
      def checkbox(name, options = {})
        content_tag 'checkbox', name, 'checked', options
      end

      private
      def content_tag(tag_name, name, field_value = 'value', options = {})
        field_name = name.to_s.split('.')[-1]
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
