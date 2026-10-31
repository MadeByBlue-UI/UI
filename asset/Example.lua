  ============================================================================
  EXEMPLE COMPLET — Invincible UI
  ============================================================================
  Ce fichier montre TOUT ce que la lib sait faire, dans l'ordre :

    ---PARTIE 1  Charger la lib et créer la fenêtre (avec ses options)
    ---PARTIE 2  Onglet « Éléments » avec 4 sous-onglets :
          Bases      → boutons, toggles, labels, paragraphes, séparateurs
          Valeurs    → sliders, listes, couleurs, touches, compteurs, jauges, radio
          Texte      → champs de texte qui grandissent vers le bas + zone de texte
          Affichage  → tableau, image, stats, graphique, aperçu 3D
     ---PARTIE 3  Onglet « Combat » avec des onglets enfants (menu déroulant dans la barre de gauche)
     ---PARTIE 4  Notifications (simples, avec boutons, avec progression)
     ---PARTIE 5  Onglets prêts à l'emploi : Config, Favoris, Console, Historique
     ---PARTIE 6  Contrôler la lib depuis le script (style, flou, colonnes, lire les valeurs...)
      
  
  Lance-le dans ton exécuteur. Ouvre / ferme l'interface avec RightShift.
  Dans l'interface : clic droit sur un toggle = lui assigner une touche, ★ = mettre en favori, Ctrl+K = palette de commandes.

  ── RÈGLES À RETENIR ────────────────────────────────────────────────────────
      • Tout élément se crée avec  bloc:CreateXxx({ options })  et renvoie un objet qu'on peut garder.
      • Options communes :
            Name      texte affiché sur la ligne
            Default   valeur de départ
            Callback  fonction appelée quand la valeur change (elle reçoit la nouvelle valeur)
            Flag      identifiant UNIQUE : l'élément est alors sauvegardé dans les configs et sa valeur
                      est lisible partout avec  Library.Flags["identifiant"]
            Tooltip   bulle d'aide au survol            Favorite = false   retire l'étoile ★
      • Objet renvoyé : :Get() lit la valeur · :Set(v) la change (et appelle le Callback) · .Instance = l'objet Roblox.

-- ============================================================================
-- PARTIE 1 — CHARGER LA LIB ET CRÉER LA FENÊTRE
-- ============================================================================
-- loadstring télécharge et exécute UI.lua ; il te renvoie l'objet « Library ».
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MadeByBlue-UI/UI/main/UI.lua"))()

-- Les onglets « Home » et « Réglages » sont créés AUTOMATIQUEMENT (Home = false / Settings = false pour les retirer).
local Window = Library:CreateWindow({
    Title = "Invincible",                  -- nom dans la barre de titre
    Version = "1.0",                       -- version affichée
    ToggleKey = Enum.KeyCode.RightShift,   -- touche pour ouvrir / fermer l'interface
    ConfigFolder = "Invincible",           -- dossier où les configs sont enregistrées (si l'exécuteur le permet)

    -- Options facultatives (toutes modifiables ensuite dans l'onglet Réglages) :
    -- Size = UDim2.new(0, 676, 0, 560),   -- taille de départ
    -- Columns = 2,                        -- nombre de colonnes de blocs (1 à 4)
    -- Style = "Verre",                    -- "Standard" | "Verre" | "Givré" | "Mat" | "Néon"
    -- Blur = 14,                          -- flou du jeu derrière l'interface (0 à 56)
    -- Stars = 40,                         -- étoiles qui rebondissent sur les bords de l'écran (0 = aucune)
    -- ShowStats = false,                  -- cache le FPS / ping dans la barre de titre
    -- Home = false, Settings = false,     -- retire les onglets automatiques
})

-- Notes de version affichées dans l'onglet Home (facultatif).
Library:AddChangelog("1.0", { "Première version", "Champs de texte qui grandissent vers le bas" })

-- ============================================================================
-- PARTIE 2 — ONGLET « ÉLÉMENTS » AVEC SOUS-ONGLETS
-- ============================================================================
-- Window:CreateTab(nom, _, icone) : un onglet dans la barre de gauche (l'icône est facultative : "rbxassetid://...").
local Elements = Window:CreateTab("Éléments")

-- Tab:CreateSubTabs({...}) : barre de sous-onglets en haut de la page. Renvoie une liste ; on crée les blocs DANS chaque sous-onglet.
local subs = Elements:CreateSubTabs({ "Bases", "Valeurs", "Texte", "Affichage" })

-- ----------------------------------------------------------------------------
-- Sous-onglet 1 : BASES
-- ----------------------------------------------------------------------------
-- Un bloc = un cadre repliable avec un titre. Side = "left" ou "right" = la colonne.
local Bases = subs[1]:CreateBlock({ Name = "Boutons et interrupteurs", Side = "left" })

Bases:CreateSection("Boutons")   -- petit titre en majuscules avec une ligne dessous

-- Bouton : Callback est appelé à chaque clic.
Bases:CreateButton({
    Name = "Dire bonjour",
    Tooltip = "Affiche une notification",
    Callback = function()
        Library:Notify({ Title = "Bonjour", Content = "Le bouton marche !", Duration = 3, Type = "Success" })
    end,
})

-- Bouton à double confirmation : 1er clic = « Êtes-vous sûr ? », 2e clic = exécute (le 1er se désarme après 3 s).
Bases:CreateConfirmButton({
    Name = "Action dangereuse",
    ConfirmText = "Clique encore pour confirmer",
    Callback = function() print("Action confirmée") end,
})

Bases:CreateDivider()   -- ligne de séparation (alias : CreateSeparator)
Bases:CreateSection("Interrupteurs")

-- Toggle : ON / OFF. Callback reçoit true ou false.
Bases:CreateToggle({
    Name = "Option simple",
    Default = false,
    Flag = "demo.option",
    Callback = function(actif) print("Option simple :", actif) end,
})

-- Toggle avec touche : clic droit sur la ligne = changer la touche.
-- KeyMode : "Toggle" (appuyer = inverser) · "Hold" (actif tant que la touche est tenue) · "Always" (toujours actif).
Bases:CreateToggle({
    Name = "Option avec touche",
    Keybind = Enum.KeyCode.X,
    KeyMode = "Hold",
    Flag = "demo.hold",
    Callback = function(actif) print("Option avec touche :", actif) end,
})

-- Second bloc, colonne de droite : du texte purement informatif.
local Infos = subs[1]:CreateBlock({ Name = "Textes", Side = "right" })

Infos:CreateLabel({ Text = "Un label : simple texte qui passe à la ligne tout seul quand il est long." })
Infos:CreateParagraph({
    Title = "Un paragraphe",                  -- titre en gras (facultatif)
    Content = "Un titre et un texte plus long, dans un cadre. Pratique pour expliquer une option ou donner des consignes.",
})

-- ----------------------------------------------------------------------------
-- Sous-onglet 2 : VALEURS
-- ----------------------------------------------------------------------------
local Valeurs = subs[2]:CreateBlock({ Name = "Nombres et choix", Side = "left" })

-- Slider : curseur. Callback reçoit le nombre. On peut aussi cliquer sur le nombre pour le taper au clavier.
Valeurs:CreateSlider({
    Name = "Vitesse",
    Min = 0, Max = 100, Default = 16,
    Step = 1,              -- pas du curseur (facultatif)
    Suffix = " st/s",      -- texte ajouté après le nombre (facultatif)
    Flag = "demo.speed",
    Callback = function(v) print("Vitesse :", v) end,
})

-- Slider à DEUX poignées : Callback reçoit le bas et le haut.
Valeurs:CreateRangeSlider({
    Name = "Plage",
    Min = 0, Max = 100,
    Default = { Low = 20, High = 80 },
    MinGap = 5,            -- écart minimal entre les deux poignées
    Flag = "demo.range",
    Callback = function(bas, haut) print("Plage :", bas, haut) end,
})

-- Stepper : compteur - / valeur / + pour les entiers. Maintenir = répétition qui accélère, Maj = pas x10.
Valeurs:CreateStepper({
    Name = "Nombre de cibles",
    Min = 1, Max = 10, Step = 1, Default = 3,
    Wrap = false,          -- true = repart à Min après Max
    Flag = "demo.targets_count",
    Callback = function(v) print("Cibles :", v) end,
})

Valeurs:CreateDivider()

-- Dropdown : liste déroulante. Callback reçoit le choix.
Valeurs:CreateDropdown({
    Name = "Mode",
    Items = { "Normal", "Rapide", "Lent" },
    Default = "Normal",
    Flag = "demo.mode",
    Callback = function(choix) print("Mode :", choix) end,
})

-- Dropdown à choix multiples : Default est une liste, Callback reçoit les choix cochés.
Valeurs:CreateDropdown({
    Name = "Cibles",
    Items = { "Joueurs", "PNJ", "Objets" },
    Multi = true,
    Default = { "Joueurs" },
    Flag = "demo.targets",
    Callback = function(choix) print("Cibles :", choix) end,
})

-- Radio : barre de choix où UNE seule option est active. Callback reçoit (texte, numéro).
Valeurs:CreateRadio({
    Name = "Difficulté",
    Items = { "Facile", "Moyen", "Difficile" },
    Default = "Moyen",
    Flag = "demo.difficulty",
    Callback = function(choix, numero) print("Difficulté :", choix, numero) end,
})

local Controles = subs[2]:CreateBlock({ Name = "Couleurs, touches, jauges", Side = "right" })

-- Color picker : Callback reçoit (couleur, opacité). Opacity = false retire la barre d'opacité.
Controles:CreateColorPicker({
    Name = "Couleur",
    Default = Color3.fromRGB(255, 255, 255),
    Flag = "demo.color",
    Callback = function(couleur, opacite) print("Couleur :", couleur, opacite) end,
})

-- Keybind : l'utilisateur choisit une touche. Mode = "Toggle" | "Hold" | "Always".
-- Callback est appelé quand la touche est pressée ; OnState reçoit true/false selon le mode.
Controles:CreateKeybind({
    Name = "Touche d'action",
    Default = Enum.KeyCode.G,
    Mode = "Toggle",
    Flag = "demo.key",
    Callback = function() print("Touche pressée") end,
    OnState = function(actif) print("État de la touche :", actif) end,
})

-- Progress : jauge pilotée par TON script (cooldown, chargement...).
local Jauge = Controles:CreateProgress({
    Name = "Chargement",
    Min = 0, Max = 100, Default = 40,
    Suffix = " %",
})

Controles:CreateButton({
    Name = "Lancer un décompte de 5 s",
    Callback = function()
        -- Countdown : la jauge se vide en N secondes (Fill = true : elle se remplit à la place).
        Jauge:Countdown(5, { ShowTime = true, OnDone = function() Library:Notify({ Title = "Décompte fini" }) end })
    end,
})
Controles:CreateButton({
    Name = "Jauge à 75 %",
    Callback = function() Jauge:Set(75) end,   -- aussi : :Get() :SetMax(m) :SetText("...") :SetColor(c) :SetIndeterminate(true) :Cancel()
})

-- ----------------------------------------------------------------------------
-- Sous-onglet 3 : TEXTE
-- ----------------------------------------------------------------------------
-- Les champs de texte GRANDISSENT VERS LE BAS : quand le texte est trop long, il passe à la ligne et la boîte
-- (avec sa ligne dans le bloc) s'agrandit avec une transition. Elle se rétracte si tu effaces du texte.
local Textes = subs[3]:CreateBlock({ Name = "Champs qui grandissent", Side = "left" })

-- Input : une ligne qui passe à la ligne. Entrée = valider. Un texte collé est remis sur une seule ligne.
Textes:CreateInput({
    Name = "Message",
    Placeholder = "Tape un long texte...",   -- texte grisé quand le champ est vide
    MaxHeight = 160,                         -- hauteur maximale en pixels (200 par défaut)
    Flag = "demo.message",
    Callback = function(texte) print("Message :", texte) end,   -- appelé quand tu valides (ou quittes le champ)
})

-- LiveUpdate = true : le Callback est appelé à CHAQUE lettre. Numeric = true : seulement chiffres, point, signe moins.
Textes:CreateInput({
    Name = "Recherche en direct",
    LiveUpdate = true,
    Callback = function(texte) print("Tu cherches :", texte) end,
})
Textes:CreateInput({
    Name = "Nombre",
    Numeric = true,
    Default = 10,
    Callback = function(texte) print("Nombre :", tonumber(texte)) end,
})

-- Un champ qu'on garde pour le contrôler depuis le script (voir Partie 6).
local Pseudo = Textes:CreateInput({ Name = "Pseudo", Default = "Joueur", Placeholder = "ton pseudo" })

local Zones = subs[3]:CreateBlock({ Name = "Zones de texte", Side = "right" })

-- TextArea : zone multi-ligne (Entrée = nouvelle ligne).
-- Height = hauteur MINIMALE ; elle grandit avec le texte jusqu'à MaxHeight (400 par défaut).
Zones:CreateTextArea({
    Name = "Notes",
    Height = 64,
    MaxHeight = 300,
    MaxLength = 4000,                        -- nombre de caractères maximum
    Placeholder = "Plusieurs lignes possibles...",
    Flag = "demo.notes",
})

-- Même zone à hauteur FIXE : AutoGrow = false (le texte défile dedans).
Zones:CreateTextArea({ Name = "Zone fixe", Height = 80, AutoGrow = false })

-- Zone en lecture seule : sert à afficher du texte que l'utilisateur peut copier.
Zones:CreateTextArea({ Name = "Lecture seule", Height = 64, ReadOnly = true, Default = "Texte qu'on peut sélectionner et copier." })

-- ----------------------------------------------------------------------------
-- Sous-onglet 4 : AFFICHAGE
-- ----------------------------------------------------------------------------
local Tableau = subs[4]:CreateBlock({ Name = "Tableau et image", Side = "left" })

-- Table : Columns = les titres, Rows = les lignes (une liste par ligne, dans l'ordre des colonnes).
-- Callback reçoit la ligne cliquée et son numéro.
local Tab1 = Tableau:CreateTable({
    Name = "Joueurs",
    Columns = { "Nom", "Score" },
    Rows = { { "Alice", "120" }, { "Bob", "85" }, { "Chloé", "240" } },
    MaxRows = 5,                             -- nombre de lignes visibles avant le défilement
    Callback = function(ligne, numero) print("Ligne choisie :", numero, ligne and ligne[1]) end,
})
Tableau:CreateButton({
    Name = "Ajouter une ligne",
    Callback = function() Tab1:AddRow({ "Nouveau", tostring(math.random(10, 300)) }) end,   -- aussi : :RemoveRow :Clear :Sort :SetRows :GetSelected
})

-- Image : Image = "rbxassetid://ID". ScaleType = "Fit" (défaut) | "Crop" | "Stretch".
Tableau:CreateImage({
    Name = "Logo",
    Image = "rbxassetid://5436396975",
    Height = 80,
})

local Stats = subs[4]:CreateBlock({ Name = "Stats, graphique, aperçu", Side = "right" })

-- Stats : grille de tuiles chiffrées. On les met à jour avec  stats:Set(id, texte, couleur).
local Tuiles = Stats:CreateStats({
    Columns = 2,
    Items = {
        { Id = "fps",   Name = "FPS",     Value = "60" },
        { Id = "ping",  Name = "Ping",    Value = "40 ms" },
        { Id = "score", Name = "Score",   Value = "0" },
        { Id = "etat",  Name = "État",    Value = "OK" },
    },
})
Tuiles:Set("etat", "Prêt", Color3.fromRGB(90, 220, 120))

-- Graph : histogramme glissant. On ajoute une valeur avec  g:Push(v).
local Graphique = Stats:CreateGraph({ Name = "FPS", Samples = 90, Height = 64, Unit = " fps" })
task.spawn(function()
    -- Exemple : on pousse une valeur toutes les 0,5 s tant que la fenêtre existe.
    while Library.Window == Window do
        local fps = math.random(45, 62)
        Graphique:Push(fps)
        Tuiles:Set("fps", tostring(fps))
        task.wait(0.5)
    end
end)

-- Aperçu 3D : un rig R6 dans un ViewportFrame (Character = true pour afficher ton vrai personnage).
Stats:CreatePreview3D({ Name = "Aperçu 3D", Height = 200 })

-- ============================================================================
-- PARTIE 3 — ONGLETS ENFANTS (menu déroulant dans la barre de gauche)
-- ============================================================================
local Combat = Window:CreateTab("Combat")

-- CreateChildTab(nom, _, icone) : un onglet placé SOUS « Combat ». Un enfant est un onglet normal.
local Visee = Combat:CreateChildTab("Visée")
local Visuel = Combat:CreateChildTab("Visuel")
-- Autre façon : Combat:CreateChildTabs({ "Visée", { Name = "Visuel", Icon = "rbxassetid://..." } })

Visee:CreateBlock({ Name = "Réglages de visée", Side = "left" }):CreateToggle({
    Name = "Activer", Flag = "demo.aim", Callback = function(v) print("Visée :", v) end,
})
Visuel:CreateBlock({ Name = "Affichage", Side = "left" }):CreateToggle({
    Name = "Contours", Flag = "demo.outline", Callback = function(v) print("Contours :", v) end,
})

Combat:SetExpanded(true)   -- déplie le menu (aussi : Combat:ToggleExpanded())

-- ============================================================================
-- PARTIE 4 — NOTIFICATIONS
-- ============================================================================
local Notifs = Window:CreateTab("Notifications")
local N = Notifs:CreateBlock({ Name = "Tester les notifications", Side = "left" })

-- Type : "Info" | "Success" | "Warning" | "Error" ; Duration en secondes (0 = reste jusqu'à la fermeture).
N:CreateButton({ Name = "Info",    Callback = function() Library:Notify({ Title = "Info",    Content = "Message d'information.", Type = "Info" }) end })
N:CreateButton({ Name = "Succès",  Callback = function() Library:Notify({ Title = "Succès",  Content = "Tout s'est bien passé.", Type = "Success" }) end })
N:CreateButton({ Name = "Alerte",  Callback = function() Library:Notify({ Title = "Alerte",  Content = "Fais attention.",        Type = "Warning" }) end })
N:CreateButton({ Name = "Erreur",  Callback = function() Library:Notify({ Title = "Erreur",  Content = "Quelque chose a échoué.", Type = "Error" }) end })

-- Notification avec BOUTONS d'action et clic.
N:CreateButton({
    Name = "Avec boutons",
    Callback = function()
        Library:Notify({
            Title = "Mise à jour",
            Content = "Une nouvelle version est disponible.",
            Duration = 8,
            Actions = {
                { Text = "Installer", Callback = function(n) print("Installation...") end },
                { Text = "Plus tard", Callback = function(n) end },
            },
            OnDismiss = function(raison) print("Fermée :", raison) end,
        })
    end,
})

-- Notification qui ÉVOLUE : on garde la « poignée » renvoyée par Notify et on la met à jour.
N:CreateButton({
    Name = "Avec progression",
    Callback = function()
        local n = Library:Notify({ Title = "Téléchargement", Content = "En cours...", Progress = 0, Duration = 0 })
        task.spawn(function()
            for i = 1, 10 do
                task.wait(0.3)
                n:SetProgress(i / 10)            -- à 100 % la notification passe en « Succès »
            end
            n:SetContent("Terminé !")
        end)
    end,
})

-- ============================================================================
-- PARTIE 5 — ONGLETS PRÊTS À L'EMPLOI
-- ============================================================================
Window:CreateConfigTab("Config")          -- sauvegarder / charger / renommer / supprimer des configs (éléments avec Flag)
Window:CreateFavoritesTab("Favoris")      -- regroupe les éléments marqués d'une ★
Window:CreateConsoleTab("Console")        -- affiche les print / warn / erreurs du script (Library:ConsoleLog(texte, type))
Window:CreateNotifLogTab("Historique")    -- historique des notifications

-- ============================================================================
-- PARTIE 6 — CONTRÔLER LA LIB DEPUIS LE SCRIPT
-- ============================================================================
local Controle = Notifs:CreateBlock({ Name = "Contrôle depuis le script", Side = "right" })

-- Lire / modifier un élément qu'on a gardé dans une variable :
Controle:CreateButton({
    Name = "Lire puis changer le pseudo",
    Callback = function()
        print("Pseudo actuel :", Pseudo:Get())
        Pseudo:Set("Nouveau nom")              -- change la valeur (appelle aussi le Callback)
    end,
})

-- Lire une valeur sauvegardée avec Flag, de n'importe où :
Controle:CreateButton({
    Name = "Afficher la vitesse (Flag)",
    Callback = function()
        Library:Notify({ Title = "Vitesse", Content = tostring(Library.Flags["demo.speed"]) })
    end,
})

-- Changer l'apparence en direct :
Controle:CreateDropdown({
    Name = "Style de l'interface",
    Items = { "Standard", "Verre", "Givré", "Mat", "Néon" },
    Default = "Standard",
    Favorite = false,
    Callback = function(style) Library:SetStyle(style) end,
})
Controle:CreateSlider({
    Name = "Flou du jeu", Min = 0, Max = 56, Default = 0, Favorite = false,
    Callback = function(v) Library:SetBlur(v) end,
})
Controle:CreateStepper({
    Name = "Colonnes de blocs", Min = 1, Max = 4, Default = 2, Favorite = false,
    Callback = function(v) Library:SetColumns(v) end,
})

-- Sauvegarde / chargement de config à la demande (les mêmes que l'onglet Config) :
-- Library:SaveConfig("ma-config")   Library:LoadConfig("ma-config")   Library:ListConfigs()

Library:Notify({
    Title = "Prêt",
    Content = "Appuie sur RightShift pour ouvrir / fermer l'interface.",
    Duration = 5,
    Type = "Info",

    ----------------------------
    END--
    ----------------------------
