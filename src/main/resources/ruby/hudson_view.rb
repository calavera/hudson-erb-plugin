require 'views/form'

module Hudson
  module View
    include Form

    def view(options = {}, &block)
      namespaces = 'xmlns:j="jelly:core" xmlns:st="jelly:stapler" xmlns:d="jelly:define" xmlns:l="/lib/layout"
         xmlns:t="/lib/hudson" xmlns:f="/lib/form" '

      namespaces << map_to_attrs(options)

      @output = "<j:jelly #{namespaces}>"
      yield if block_given?
      @output << '</j:jelly>'
    end

    def map_to_attrs(options)
      options.empty? ? '' : options.map {|k,v| %Q{#{k}="#{v}"} }.join(' ')
    end
  end
end

