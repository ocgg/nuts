require_relative "md_doc"

md_doc = MdDoc.new(ARGV[1])

# puts md_doc.formatted_string
puts md_doc.send(ARGV.first)
