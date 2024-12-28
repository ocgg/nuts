require 'readline'

# Liste des options
OPTIONS = ['option1', 'option2', 'option3'].freeze

# Procédure de génération d'options
gen = proc { |s| OPTIONS.select { |o| o.start_with?(s) } }

# Configuration de Readline
Readline.completion_append_character = " "
Readline.completer_word_break_characters = ""
Readline.completion_proc = gen

# Fonction principale
def main
  puts "Bienvenue dans mon application Ruby avec autosuggestion !"
  
  while line = Readline.readline('> ', true)
    case line
    when 'option1'
      puts "Vous avez sélectionné option1"
    when 'option2'
      puts "Vous avez sélectionné option2"
    when 'option3'
      puts "Vous avez sélectionné option3"
    else
      puts "Option non valide. Utilisez 'option1', 'option2' ou 'option3'."
    end
    
    # Afficher les suggestions
    print Readline::HISTORY.to_a.join("\n")
    puts "\n"
  end
end

main
