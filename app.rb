NOTES_DIRNAME = '~/shared/notes/'

notes_dir = File.expand_path(NOTES_DIRNAME)

files = Dir.glob("**/*", base: notes_dir)
folders = files.select { |f| File.directory?(File.join(notes_dir, f)) }
notes = files.select { |f| File.file?(File.join(notes_dir, f)) }

# p folders
# p notes

# Go fzf
# selected = `echo "#{notes.join("\n")}" | fzf`.strip
# puts `less "#{File.join(notes_dir, selected)}"`
# p File.join(notes_dir, selected)

loop do
  a = STDIN.getc
  p a
  STDIN.ungetc
  print '>'
end
