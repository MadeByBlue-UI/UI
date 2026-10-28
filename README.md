=========================================
  
  Invincible — (v5.10.0)
  
  UI
  
  À quoi correspond cette UI
=========================================

QU'EST-CE QUE C'EST ?
---------------------
Invincible est une bibliothèque d'interface (UI) en Lua pour Roblox, destinée
aux scripts exécutés depuis un exécuteur. Elle fournit une fenêtre
complète (onglets, blocs, boutons, curseurs, listes, sélecteur de couleur,
etc.) que tu remplis avec les fonctions de ton script. Style : noir et
blanc, fond « trou noir » animé, animations fluides.

Elle est compatible avec le script « Help » (même API qu'avant).

CHARGEMENT
----------
  local Library = loadstring(readfile("Invincible.lua"))()

ou, si elle est hébergée :
  
  local Library = loadstring(game:HttpGet("TON_LIEN_RAW"))()

STRUCTURE
---------
  Library:CreateWindow({...})      -> Window
  Window:CreateTab(nom, _, icone)  -> Tab
  Tab:CreateBlock({Name, Side})    -> Block        (Side = "Left" / "Right")
  Tab:CreateSubTabs({ "A", "B" })  -> sous-onglets (chacun a ses blocs)

ÉLÉMENTS DISPONIBLES (dans un Block)
------------------------------------
  CreateSection, CreateLabel, CreateParagraph, CreateDivider,
  CreateButton, CreateToggle, CreateSlider, CreateRangeSlider,
  CreateDropdown, CreateInput, CreateTextArea, CreateRadio,
  CreateColorPicker, CreateKeybind, CreateProgress, CreateStepper,
  CreateTable, CreateImage, CreateStats, CreateGraph, CreatePreview3D
  Notifications : Library:Notify({ Title, Content, Type, Duration })

ONGLET HOME (créé automatiquement, en premier)
----------------------------------------------
  • Info        : aperçu 3D de ton personnage (avec animations et
                  emotes), FPS, ping, joueurs, mémoire, durée de session
                  et limite, heure et météo, infos du serveur.
  • Serveurs    : NOUVEAU (v5.10.0) — voir ci-dessous.
  • Explication : présentation de l'UI et démos en direct des éléments.
  • Mises à jour: version, vérification GitHub, nouveautés (changelog).

SOUS-ONGLET « SERVEURS »
------------------------
  Serveur actuel
    - Affiche l'ID du serveur (JobId), la Place et le maximum de joueurs.
    - « Copier l'ID du serveur ».
    - « Re-rejoindre ce serveur » : te téléporte de nouveau dans le même.
  Changer de serveur
    - Curseur à deux poignées : nombre de joueurs voulu (5 à 18 par
      défaut, borné par le maximum du jeu).
    - Boutons : serveur aléatoire / le plus vide / le plus rempli, parmi
      les serveurs publics de la plage choisie (API publique de Roblox).
  Rejoindre par ID
    - Colle l'ID d'un serveur public (format xxxxxxxx-xxxx-xxxx-xxxx-
      xxxxxxxxxxxx) et rejoins-le. Fonctionne pour le même jeu
      (même Place ID).
  Derniers serveurs
    - Garde les 5 derniers serveurs rejoints (ID). Au-delà de 5, le plus
      ancien est supprimé. Un clic sur une ligne rejoint ce serveur.
    - « Vider l'historique » (avec confirmation).
    - Sauvegardé automatiquement : retrouvé au prochain lancement.
    - Réglable : Library.ServerHistoryMax (5 par défaut).

FONCTIONNALITÉS GÉNÉRALES
-------------------------
  • Intro de chargement « trou noir » (clic = passer) et son « Hi. ».
  • Thèmes et préréglages de couleurs, éditeur de thème, dégradés.
  • Trois types de mise en page : Classique, Éclipse, Carré.
  • 1 à 4 colonnes de blocs, blocs déplaçables par glisser-déposer,
    mini-fenêtres détachables, réduction par double-clic.
  • Recherche globale (Ctrl+T) et Palette de commandes (Ctrl+K).
  • Favoris, HUD, keybinds (Toggle / Hold / Always, clavier ou souris).
  • Configs sauvegardables et chargeables (une seule notification
    « Config chargée », avec la liste des changements).
  • Réglages enregistrés automatiquement dans le dossier de config
    (fichier _settings.json) : thème, historique des serveurs, etc.
  • Défilement fluide, animations à ressort (désactivables).
  • Curseur libéré tant que la fenêtre est ouverte ; touches du jeu
    bloquables (W A S D Espace par défaut).
  • Mises à jour automatiques via le lien raw GitHub (UpdateURL).

OPTIONS UTILES DE CreateWindow
------------------------------
  Home = false          retire l'onglet Home
  ChangeLog = false     masque seulement les nouveautés
  LayoutStyle = "Carré" type d'interface
  UpdateURL = "..."     active les mises à jour automatiques

===================================================================================
