# Md Cli Renderer

Restructurer l'app comme suit:

- Main class (= controller), le point d'entrée
- Main envoie le fichier brut au Parser qui retourne un MdDocument
- MdDocument est globalement un array de Block (paragraphe, list, text, title etc.)

  - Chaque Block a un type (title/list), un sous-type (h3/unordered), (plus?), un contenu
  - Le contenu est un array de Text, ou un hash (dans le cas d'une liste: arborescence)
  - Chaque Text a des styles (normal / bold, italic) et un contenu

- Main envoie le MdDocument au Renderer qui:

  - Gère le rendu chaque type de Block
  - Incorpore les séquences d'échappement dans les Text
  - Retourne un array de string à Main

- Main affiche les lignes selon les options passées en ligne de commande

## TODO LA MAINTENANT

- Rendu de liste: keep indent au retour à la ligne sur un point indenté
- DU COUP => le bordel de to_lines_with_style à réécrire

## TODO NEXT

- séparer le repo de md_renderer. C'est un projet à part entière
- lists: word wrap cassé
- lists: longue lignes: ça se décale...
- H1 & h2 peuvent être sur 2 lignes avec /title\n=+/ ou /title\n-+/
- \&nbsp; à la place du dernier espace avant le dernier char d'un titre
- inline codeblock avec backticks dedans: ``inline_code(`with backticks`);``
- meilleurs tableaux
- inline styles dans les tableaux
- lastopened: checks
- divers input checks (new, ..)

### MD features

- rendu de listes
  - ordonnée
  - checkboxes
- blockquotes
- links
- links variables
- Gérer les images avec des liens
- liens vers fichiers ?

## BUGFIXES TODO

## TODO DANS LONGTEMPS

- inline style: checker ça: "**,,,**c. s**,,,** censé rendre ",,,c. s,,," en gras
- TESTS: ça devrait être facile à écrire.
- mettre un message si bat/ruby/tty-table pas installé
- utiliser une alternative native pour bat (chépucomment source truc)
- utiliser mdtt pour modifier un tableau
- afficher les longues notes sur 2 colonnes si termwidth > 160
- arg completion (note names, cl args)
- réécrire module Tables,
- refacto modules InlineBlocks

## TODO DANS TRÈS LONGTEMPS VOIRE JAMAIS

- Implémenter HTML basique
- pack: empaqueter dans un one file (db sqlite?)
- unpack: créer les notes à partir de ce fichier
