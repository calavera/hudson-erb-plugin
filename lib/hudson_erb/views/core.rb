module Hudson
  module View
    # The core Tags from the JSTL plus Jelly extensions.
    #
    # Missing elements:
    #   * arg
    #   * break
    #   * case
    #   * catch
    #   * choose
    #   * default
    #   * expr
    #   * file
    #   * getStatic
    #   * if
    #   * import
    #   * include
    #   * invoke
    #   * invokeStatic
    #   * jelly
    #   * mute
    #   * new
    #   * otherwise
    #   * parse
    #   * remove
    #   * scope
    #   * set
    #   * setProperties
    #   * switch
    #   * thread
    #   * useBean
    #   * useList
    #   * when
    #   * while
    #   * whitespace
    module Core
      # Iterates over a collection, iterator or an array of objects.
      #
      # @param [String, Symbol] items is the collection to iterate over
      # @param [Hash] options are used to render additional attributes
      # @param [Block] block is used to render nested elements
      #
      # @example given this code
      #   <% for_each :runtimes do %>
      #     <%= option :runtime, 'it.name' %>
      #   <% end %>
      #
      # @exaple generates that jelly template
      #   <j:forEach var="it" items="${descriptor.runtimes}">
      #     <f:option selected="${it.name == instance.runtime}">${it.name}</f:option>
      #   </j:forEach>
      #
      def for_each(items, options = {}, &block)
        var = options.delete(:var) || 'it'
        collection = items =~ %r{^\$\{.+\}$} ? items : "${descriptor.#{items}}"

        @output ||= ''
        @output << %Q{<j:forEach var="#{var}" items="#{collection}" }
        @output << map_to_attrs(options) << '>'
        yield(var) if block_given?
        @output << '</j:forEach>'
      end
    end
  end
end
