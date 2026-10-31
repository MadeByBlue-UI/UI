# Invincible UI

Librairie d'interface pour Roblox (Luau) : thème noir & blanc, animations fluides (ressorts), onglets, blocs repliables,
config sauvegardable, notifications, onglets **Home** et **Réglages** créés automatiquement.

> Basée sur le dépôt d'origine [bestdubai67-creator/UI](https://github.com/bestdubai67-creator/UI).

## Démarrage rapide

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MadeByBlue-UI/UI/main/UI.lua"))()

local Window = Library:CreateWindow({
    Title = "Invincible",
    ToggleKey = Enum.KeyCode.RightShift,   -- ouvrir / fermer l'interface
    ConfigFolder = "Invincible",           -- dossier des configs sauvegardées
})

local Tab   = Window:CreateTab("Principal")
local Block = Tab:CreateBlock({ Name = "Général", Side = "left" })

Block:CreateToggle({ Name = "Option", Default = false, Callback = function(v) print("Option :", v) end })
Block:CreateInput({ Name = "Pseudo", Placeholder = "Écris ici...", Callback = function(t) print(t) end })
```

Les exemples complets sont dans [`examples/`](examples) :

| Fichier | Contenu |
|---|---|
| [`basic.lua`](examples/basic.lua) | Fenêtre, onglet, bloc, bouton, toggle, slider, dropdown, notification |
| [`inputs.lua`](examples/inputs.lua) | Champs de texte qui grandissent vers le bas, zone de texte, keybind |

## Éléments disponibles

`CreateSection` · `CreateLabel` · `CreateParagraph` · `CreateDivider` · `CreateButton` · `CreateToggle` · `CreateSlider` ·
`CreateRangeSlider` · `CreateDropdown` · `CreateInput` · `CreateTextArea` · `CreateKeybind` · `CreateColorPicker` ·
`CreateProgress` · `CreateStepper` · `CreateConfirmButton` · `CreateRadio` · `CreateTable` · `CreateImage` ·
`CreatePreview3D` · `CreateStats` · `CreateGraph`

Chaque élément accepte `Name`, `Callback` et (pour ceux qui ont une valeur) `Flag` pour la sauvegarde dans les configs.

### Champs de texte

- `CreateInput` : une ligne qui **passe à la ligne et grandit vers le bas** (avec une transition) quand le texte est long.
  `Entrée` valide. Options : `Default`, `Placeholder`, `Numeric`, `LiveUpdate`, `ClearOnFocus`, `MaxHeight` (200).
- `CreateTextArea` : zone multi-ligne qui grandit aussi avec le texte. Options : `Height` (minimum), `MaxHeight` (400),
  `MaxLength`, `ReadOnly`, `AutoGrow = false` pour une hauteur fixe.
- `Library.AutoGrow = false` : désactive la croissance automatique partout.

## Notifications

```lua
Library:Notify({ Title = "Salut", Content = "Ça marche.", Duration = 4, Type = "Info" })
```

## Mise à jour automatique

Passe `UpdateURL` (lien Raw du fichier) à `CreateWindow` pour que la lib sache où chercher sa dernière version :

```lua
Library:CreateWindow({ Title = "Invincible", UpdateURL = "https://raw.githubusercontent.com/MadeByBlue-UI/UI/main/UI.lua" })
```

## Versions

Voir [`CHANGELOG.md`](CHANGELOG.md).

## Compatibilité

Nécessite un exécuteur qui fournit `loadstring` et `game:HttpGet`. Les configs utilisent `readfile` / `writefile` /
`makefolder` si l'exécuteur les propose.
