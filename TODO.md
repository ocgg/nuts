- 1.mdfile est récupérer par MdDoc
- 2.mdfile est formatté en chunks par Parser
- 3.les chunks sont stylisés par Renderer

- lastopened: checks
- divers input checks (new, ..)

- pack: empaqueter les notes en db sqlite
- unpack: créer les fichiers à partir d'une db sqlite

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
