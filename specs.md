- 1 table "notes", 1 "folders" qui se réfère à elle-même avec un "folder_id" pour les sous-dossiers
- option "to files" pour convertir les notes en fichiers avec l'arborescence
- 1 fichier générique "quicknotes" ou un truc comme ça qui stocke toutes les notes rapides (1 ou quelques lignes) par date
- table "quicknotes" ?
- mise en forme basique de markdown (titres, liens, code avec coloration, tableaux, ...)
  - coloration en fonction de la couleur de fond du terminal

Utilisation:

- 100% ligne de commande

```bash
nuts add blabla # ouvre l'éditeur de texte par défaut pour une nouvelle note appelée blabla (ou sans nom)
nuts quick blabla blabla # ajoute "blabla blabla" dans les quicknotes
nuts last 3 # affiche les 3 dernières notes
nuts search ... # affiche une liste de notes qui contiennent le(s) mot(s) clé "..."
nuts find ... # affiche la 1ère note qui correspond à ...
nuts edit blabla # affiche une liste de notes à ouvrir dans l'éditeur (ou en ouvre une direct)
nuts remove blabla # pareil pour supprimer, avec confirmation
nuts read # Ouvre toutes les notes une par une comme un bouquin
nuts # affiche l'arborescence avec toutes les notes à sélectionner
```

- possibilité de faire des quicknotes custom ? style `nuts todo blablabla`

- 1 file ? Pour avoir un "carnet de notes" portable & partageable
