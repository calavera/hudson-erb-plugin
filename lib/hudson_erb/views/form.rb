module Hudson
  module View
    # This module includes methods to generate jelly form templates.
    #
    module Form
      # Generates an entry element for a form field.
      #
      # @param [String, Symbol] name is the attribute `name` of the element
      # @param [Hash] options that are used as additional attributes for the element
      # @param [Block] block that's executed to render nested elements
      #
      # @example given this code
      #   <% entry 'Address' do %>
      #     <input type="text" name="address"/>
      #   <% end %>
      #
      # @example generates this jelly template
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
      # @param [Hash] options used to render additional attributes for the element
      #
      # @example given this code
      #   <%= textbox :directory %>
      #
      # @example generates this jelly template
      #   <f:textbox name="directory" value="${instance.directory}"/>
      #
      def textbox(name, options = {})
        content_tag 'textbox', name, 'value', options
      end

      # Generates an expandable textbox
      #
      # @param [String, Symbol] name is the attribute `name` for the element
      # @param [Hash] options used to render additional attributes for the element
      #
      # @example given this code
      #   <%= expandable_textbox :directories %>
      #
      # @example generates this jelly template
      #   <f:expandableTextbox name="directories" value="${instance.directories}"/>
      #
      def expandable_textbox(name, options = {})
        content_tag 'expandableTextbox', name, 'value', options
      end

      # Generates a textarea
      #
      # @param [String, Symbol] name is the attribute `name` for the element
      # @param [Hash] options used to render additional attributes for the element
      #
      # @example given this code
      #   <%= textarea :script %>
      #
      # @example generates this jelly template
      #   <f:textarea name="script" value="${instance.script}"/>
      #
      def textarea(name, options = {})
        content_tag 'textarea', name, 'value', options
      end

      # Generates a checkbox
      #
      # @param [String, Symbol] name is the attribute `name` for the element
      # @param [Hash] options used to render additional attributes for the element
      #
      # @example given this code
      #   <%= ckeckbox :verbose %>
      #
      # @example generates this jelly template
      #   <f:checkbox name="verbose" checked="${instance.verbose}"/>
      #
      def checkbox(name, options = {})
        content_tag 'checkbox', name, 'checked', options
      end

      # Generates a list of options to wrap for a select element. It uses
      # the jelly element j:forEach to iterate over the options.
      #
      # @param [String, Symbol] items is the name of the collection from the items are selected
      # @param [String, Symbol] selected is the name of the attribute that stores the selected item in the object
      # @param [String, Symbol] var_name is the name used to iterate over the options
      # @param [String, Symbol] option_value is the attribute to compare the selected value across the options
      #
      # @example given this code
      #   <%= options_for :installations, :installation %>
      #
      # @example generates this jelly template
      #   <j:forEach var="option" items="${descriptor.installations}">
      #     <f:option selected="${option.name == instance.installation}">${option.name}</f:option>
      #   </j:forEach>
      #
      def options_for(items, selected, var_name = 'option', option_value = 'name')
        items_name = items =~ %r{^\$\{.+\}$} ? items : "${descriptor.#{items}}"
        instance_selected = selected =~ %r{^\$\{.+\}$} ? selected.gsub(%r{^\$\{(.+)\}$}, '\1') : "instance.#{selected}"

        option = "#{var_name}.#{option_value}"

        options = %Q{<j:forEach var="#{var_name}" items="#{items_name}">}
        options << %Q{<f:option selected="${#{option} == #{instance_selected}}">${#{option}}</f:option>}
        options << '</j:forEach>'
        options
      end

      # This tag creates a right-aligned button for performing server-side validation.
      #
      # @param [String, Symbol] title is the label that the button shows
      # @param [String] with is the field or list of fields separated by comma which values are sent to the server
      # @param [String, Symbol] method is the method invoked by the server without the prefix do. For instace method="test" will invoke the doTest method
      # @param [String] progress is the label that the button shows while it's waiting a response
      #
      # @example given this code
      #   <%= validate_button :Validate, 'accessKey' %>
      #
      # @example generates this jelly template
      #   <f:validateButton title="Validate" with="accessKey" method="test" progress="" />
      #
      def validate_button(title, with, method = 'validate', progress = '')
        %Q{<f:validateButton title="#{title}" with="#{with}" method="#{method}" progress="#{progress}"/>}
      end

      # Expandable section that shows "advanced..." button by default. Upon clicking it, a section unfolds.
      #
      # @example given that code
      #   <% advanced do %>
      #     <%= textbox :foo %>
      #   <% end %>
      #
      # @example generates this jelly template
      #   <f:advanced>
      #     <f:textbox name="foo" value="${instance.foo}"/>
      #   </f:advanced>
      #
      def advanced(&block)
        @output ||= ''
        @output << '<f:advanced>'
        yield if block_given?
        @output << '</f:advanced>'
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
