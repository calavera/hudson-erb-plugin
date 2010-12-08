# Run me with:
#   $ watchr specs.watchr

# --------------------------------------------------
# Rules
# --------------------------------------------------
watch( '^spec.*/.*_spec\.rb'                 )  { |m| ruby  m[0] }
watch( '^lib/(.*)\.rb'                       )  { |m| ruby "spec/#{m[1]}_spec.rb" }
watch( '^lib/hudson_erb/(.*)\.rb'                )  { |m| ruby "spec/hudson_erb/#{m[1]}_spec.rb" }
watch( '^lib/hudson_erb/views/(.*)\.rb' )  { |m| ruby "spec/hudson_erb/views/#{m[1]}_spec.rb" }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
Signal.trap('INT' ) { abort("\n") } # Ctrl-C

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def ruby(*paths)
  run "rspec --colour --format documentation -I.:lib:spec #{paths.flatten.join(' ')}"
end

def run( cmd )
  puts   cmd
  system cmd
end

def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end
