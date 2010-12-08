require 'views/form'

module Hudson
  # This module includes methods to generate jelly general templates
  #
  module View
    include Form

    # Generates jelly view tags. It includes these namespaces by default:
    #   * xmlns:j  => jelly:code
    #   * xmlns:st => jelly:stapler
    #   * xmlns:d  => jelly:define
    #   * xmlns:l  => /lib/layout
    #   * xmlns:t  => /lib/hudson
    #   * xmlns:f  => /lib/form
    #
    # @param [Hash] options that are set as attributes for the element
    # @param [Block] block that's executed to render nested elements
    #
    # @example given this code
    #   <% wiew do %>
    #     <h1>This is a jelly view</h1>
    #   <% end %>
    #
    # @example generates this jelly template
    #   <j:jelly xmlns:j="jelly:core" xmlns:st="jelly:stapler" xmlns:d="jelly:define" xmlns:l="/lib/layout"
    #       xmlns:t="/lib/hudson" xmlns:f="/lib/form" >
    #     <h1>This is a jelly view</h1>
    #   </j:jelly>
    #
    def view(options = {}, &block)
      namespaces = 'xmlns:j="jelly:core" xmlns:st="jelly:stapler" xmlns:d="jelly:define" xmlns:l="/lib/layout"
         xmlns:t="/lib/hudson" xmlns:f="/lib/form" '

      namespaces << map_to_attrs(options)

      @output = "<j:jelly #{namespaces}>"
      yield if block_given?
      @output << '</j:jelly>'
    end

    # Helper method to convert a hash with options to a string separated by
    # spaces.
    def map_to_attrs(options)
      options.empty? ? '' : options.map {|k,v| %Q{#{k}="#{v}"} }.join(' ')
    end
  end
end

