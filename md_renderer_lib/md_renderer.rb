require_relative "md_doc"
require_relative "renderer"

md_doc = MdDoc.new(ARGV[1], Renderer.new)

# puts md_doc.formatted_string
puts md_doc.send(ARGV.first)
