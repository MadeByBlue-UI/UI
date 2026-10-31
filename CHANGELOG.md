# Changelog

## V9.3 — Champs de texte qui grandissent vers le bas
- `CreateInput` : quand le texte est trop long, il passe à la ligne et le champ (ainsi que sa ligne dans le bloc) s'agrandit
  vers le bas avec une transition, au lieu de s'étirer sur une seule longue ligne. Il se rétracte quand le texte raccourcit.
- `Entrée` valide le champ ; un texte collé avec des retours à la ligne est mis sur une seule ligne ; `MaxHeight` (200).
- `CreateTextArea` : grandit aussi vers le bas (`Height` = minimum, `MaxHeight` = 400, `AutoGrow = false` = hauteur fixe).
- `Library.AutoGrow = false` : retour à des hauteurs fixes.
- Les champs étant multi-ligne en interne, la sélection native de Roblox est utilisée.

## V9.2
- « Hi. » dans l'intro + son ; icône du jeu dans Home > Serveur.
- Fluidité : défilement à la molette refait, champ de texte plus fluide, fin des animations plus nette (ressorts).

## V9.1
- Chargement de config silencieux (une seule notification « Config chargée », liste des changements dans les Réglages).
- Home en R6 : animation de bienvenue, coucous et emotes.

## V9
- Intro de chargement « trou noir ».

## V5.9
- Transitions plus fluides : listes déroulantes, glisser-déposer de blocs, réduire / restaurer, color picker.

## V5.7
- Champ de texte extensible et sous-onglets refaits.
