- lastopened: checks
- divers input checks (new, ..)

- pack: empaqueter les notes en db sqlite
- unpack: créer les fichiers à partir d'une db sqlite

## TODO NEXT

- H1 & h2 peuvent être sur 2 lignes avec /title\n=+/ ou /title\n-+/
- Les inline styles imbriqués peuvent être foireux à cause de `\e[0m`
- \&nbsp; à la place du dernier espace avant le dernier char d'un titre
- rendu de listes
  - ordonnée
  - checkboxes
- inline codeblock avec backticks dedans: ``inline_code(`with backticks`);``
- links
- links variables
- Gérer les images avec des liens
- liens vers fichiers ?
- meilleurs tableaux

## BUGFIXES TODO

- les inline styles matchent /_ dsfsdf _/

## TODO DANS LONGTEMPS

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
