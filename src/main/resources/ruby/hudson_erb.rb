require 'erb'
require 'hudson_view'

module Hudson
  class ERB
    include Hudson::View

    def render(resources)
      erb_files = Dir["#{resources}/**/*.erb"]

      erb_files.each do |file|
        erb = ::ERB.new(IO.read(file), nil, nil, "@output")
        File.open(file.sub('.erb', ''), 'w+') {|f| f.write erb.result(binding)}
      end
    end
  end
end

Hudson::ERB.new.render(resources)
