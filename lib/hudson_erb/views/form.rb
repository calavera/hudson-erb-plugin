module Hudson
  module View
    # This module includes methods to generate jelly form templates.
    #
    # Missing elements:
    #   * description
    #   * descriptorList
    #   * descriptorRadioList
    #   * dropdownDescriptorSelector
    #   * dropdownList
    #   * dropdownListBlock
    #   * editableComboBoxValue
    #   * enum
    #   * enumSet
    #   * helpArea
    #   * hetero-list
    #   * invisibleEntry
    #   * nested
    #   * option
    #   * optionalProperty
    #   * password
    #   * prepareDatabinding
    #   * property
    #   * radio
    #   * readOnlyTextbox
    #   * repeatable
    #   * repeatableDeleteButton
    #   * richtextarea
    #   * rowSet
    #   * select
    #   * slave-mode
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
      # @param [Block] block is the process executed to render nested elements
      #
      # @example given this code
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
        separation :advanced, nil, &block
      end

      # Section header with an horizontal line bellow.
      #
      # @param [String] title is the label that shows as section's title
      # @param [Block] block is the process executed to render nested elements
      #
      # @example given this code
      #   <% section 'Job options' do %>
      #     <%= textbox :foo %>
      #   <% end %>
      #
      # @example generates this jelly template
      #   <f:section title="Job options">
      #     <f:textbox name="foo" value="${instance.foo}"/>
      #   </f:section>
      #
      def section(title, &block)
        separation :section, title, &block
      end

      # Foldable block expanded when the menu item is checked.
      #
      # @param [String, Symbol] name is name of the checkbox
      # @param [String] title is the readable text that follows the checkbox
      # @param [Boolean] checked is the inital status of the checkbox
      # @param [Block] block is the process executed to render nested elements
      #
      # @example given this code
      #   <% optional_block :dynamic, 'Use dynamic view' do %>
      #     <%= textbox :foo %>
      #   <% end %>
      #
      # @example generates this jelly template
      #   <f:optionalBlock name="dynamic" title="Use dynamic view" checked="false">
      #     <f:textbox name="foo" value="${instance.foo}"/>
      #   </f:optionalBlock>
      #
      def optional_block(name, title, checked = false)
        @output ||= ''
        @output << %Q{<f:optionalBlock name="#{name}" title="#{title}" checked="#{checked}">}
        yield if block_given?
        @output << '</f:optionalBlock>'
      end

      # Block of elements
      #
      # @param [Block] block is the process executed to render nested elements
      #
      # @example given this code
      #   <% block do %>
      #     <%= textbox :foo %>
      #   <% end %>
      #
      # @example generates this jelly template
      #   <f:block>
      #     <f:textbox name="foo" value="${instance.foo}"/>
      #   </f:block>
      #
      def block(&block)
        separation :block, nil, &block
      end

      # Binds a boolean field to two radio buttons that say Yes/No OK/Cancel Top/Bottom.
      #
      # @param [String, Symbol] field is the data binding field
      # @param [String] false_value is the text to be displayed for the `false` value
      # @param [String] true_value is the text to be displayed for the `true` value
      #
      # @example given this code
      #   <%= boolean_radio :option %>
      #
      # @example generates this jelly template
      #   <f:booleanRadio field="option" false="No" true="Yes"/>
      #
      def boolean_radio(field, false_value = 'No', true_value = 'Yes')
        %Q{<f:booleanRadio field="#{field}" false="#{false_value}" true="#{true_value}"/>}
      end

      # Editable drop-down combo box that supports the data binding and AJAX updates.
      # Your descriptor should have the 'doFillXyzItems' method, which returns a ComboBoxModel representation of the items.
      #
      # @param [String, Symbol] field is the data binding field
      # @param [String, Symbol] clazz is the addition css classes that the element gets
      #
      # @example given this code
      #   <%= combobox :countries %>
      #
      # @example generates this jelly template
      #   <f:combobox field="countries" />
      #
      def combobox(field, clazz = nil)
        content_tag_two_elements 'combobox', ['field', field], ['clazz', clazz]
      end

      # Outer-most tag of the entire form taglib, that generates <form> element.
      #
      # @param [String, Symbol] name is the value for the name attribute. Required for testing and page scraping
      # @param [String] action is the URL where the submissionis sent
      # @param [Hash] options are other attributes that this element support
      # @param [Block] block is the process executed to render nested elements
      #
      # @example given this code
      #   <% form :config, '/config/submit' do %>
      #     <%= textbox :name %>
      #   <% end %>
      #
      # @example generates this jelly template
      #   <f:form name="config" action="/config/submit" method="post">
      #     <f:textbox name="name" value="${instance.name}"/>
      #   </f:form>
      #
      def form(name, action, options = {}, &block)
        method = options.delete(:method) || 'post'

        @output ||= ''
        @output << %Q{<f:form name="#{name}" action="#{action}" method="#{method}" }
        @output << map_to_attrs(options) << '>'
        yield if block_given?
        @output << '</f:form>'
      end

      # Submit button themed by YUI. This should be always used instead of the plain <input tag.
      #
      # @param [String, Symbol] value is the text of the submit button
      # @param [String, Symbol] name is the value of the attribute name if it's specified
      #
      # @example given this code
      #   <%= submit :OK %>
      #
      # @example generates this jelly template
      #   <f:submit value="OK"/>
      #
      def submit(value, name = nil)
        content_tag_two_elements 'submit', ['value', value], ['name', name]
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

      def content_tag_two_elements(tag_name, mandatory, optional)
        content_tag = %Q{<f:#{tag_name} #{mandatory[0]}="#{mandatory[1]}"}
        content_tag << %Q{ #{optional[0]}="#{optional[1]}"} if optional[1]
        content_tag << '/>'
      end

      def separation(tag_name, title = nil, &block)
        @output ||= ''
        @output << %Q{<f:#{tag_name}}
        @output << %Q{ title="#{title}"} if title
        @output << '>'
        yield if block_given?
        @output << %Q{</f:#{tag_name}>}
      end
    end
  end
end
