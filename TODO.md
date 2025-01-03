- lastopened: checks
- divers input checks (new, ..)

- pack: empaqueter les notes en db sqlite
- unpack: créer les fichiers à partir d'une db sqlite

- Comment gérer les images ???

## TODO NEXT

- to_line_with_style WORD WRAP
- H1 & h2 peuvent être sur 2 lignes avec /title\n=+/ ou /title\n-+/
- Les inline styles imbriqués peuvent être foireux à cause de `\e[0m`
- \&nbsp; à la place du dernier espace avant le dernier char d'un titre
- rendu de listes
  - ordonnée
  - à puce
  - checkboxes
- codeblock: 1ère ligne séparateur = "--[ lang ]--------"
- codeblock: bgcolor ?
- inline codeblock avec backticks dedans: ``inline_code(`with backticks`);``
- links variables

## BUGFIXES TODO

- les inline styles matchent /_ dsfsdf _/
- Les tableaux sont complètement pétés

## TODO DANS LONGTEMPS

- mettre un message si bat/ruby/tty-table pas installé
- utiliser une alternative native pour bat (chépucomment source truc)
- utiliser mdtt pour modifier un tableau
- afficher les longues notes sur 2 colonnes si termwidth > 160
- Implémenter HTML basique
- arg completion (note names, cl args)
- réécrire module Tables,
- refacto modules InlineBlocks
