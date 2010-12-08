require 'erb'
require 'hudson_view'
begin
  require 'ext'
rescue LoadError
end
# Module that includes classes and utilities to convert ERB templates to Jelly templates.
#
module Hudson
  # This class is used by the JRuby scripting container to collect the ERB
  # templates and generate the Jelly files.
  class ERB
    include Hudson::View

    # Converts the ERB templates to Jelly templates and writes them under
    # the same directory but without the extension .erb. The template search
    # is recursive under the given directory.
    #
    # @param [String] resources directory where the ERB templates are. It should be set by the JRuby scripting container.
    def render(resources)
      erb_files = Dir["#{resources}/**/*.erb"]

      erb_files.each do |file|
        erb = ::ERB.new(IO.read(file), nil, nil, "@output")
        File.open(file.sub('.erb', ''), 'w+') {|f| f.write erb.result(binding)}
      end
    end
  end
end

if __FILE__ == $0
  Hudson::ERB.new.render(resources)
end
