-- ██████████████████████████████████████████████████████████████████████
-- ██████████████████████████████████████████████████████████████████████
-- ██
-- ██   ⚠⚠⚠   À  R E G A R D E R   A V A N T   D E   F A I R E   Q U O I   Q U E   C E   S O I T   !!!   ⚠⚠⚠
-- ██
-- ██   Juste en dessous : la RÉFÉRENCE COMPLÈTE de l'API de l'UI (Ui-Lib Simple V9.18b).
-- ██   Toute nouvelle feature / option d'UI doit utiliser ces noms exacts (ne rien deviner).
-- ██   Rappels : un bloc prend  ImageID = "rbxassetid://..."  (pas « Icon »)  ·  Tab:CreateBlock({ Name, Side, ImageID })
-- ██            CreateColorPicker / CreateKeybind existent  ·  un Toggle accepte  Keybind = true
-- ██
-- ██   ⚠ RÈGLE ICÔNES : la taille des icônes est de 22 x 22 px et DOIT l'être, partout. La lib l'impose toute seule
-- ██     (Library.IconSize = 22 : onglets, sous-onglets, blocs, réglages, listes). Ne jamais agrandir / réduire une icône
-- ██     à la main (pas de ICON_SCALE, pas de redimensionnement par script, pas d'autre taille).
-- ██
-- ██████████████████████████████████████████████████████████████████████
-- ██████████████████████████████████████████████████████████████████████

--[==[
================================================================================================
  RÉFÉRENCE DES API — Ui-Lib Simple (V9.18b)        (à coller à la fin de ton script : tout est en commentaire)
================================================================================================

local Library = loadstring(readfile("Ui-Lib-Simple.lua"))()
local Win = Library:CreateWindow({ ... })
local Tab = Win:CreateTab("Nom", nil, "rbxassetid://icone")     -- icône : TOUJOURS 22 x 22 px
local Blk = Tab:CreateBlock({ Name = "Bloc", Side = "Left" | "Right", Collapsed = false, ImageID = "rbxassetid://..." })
Tab:CreateXxx(...) marche aussi directement (le bloc est créé tout seul).

------------------------------------------------------------------------------------------------
 1. FENÊTRE : Library:CreateWindow({ ... })
------------------------------------------------------------------------------------------------
 Title, Version, Size, MinSize, Position, Transparency, Theme, Style, Shape, LayoutStyle ("Classique" | "Éclipse" | "Carré"),
 Compact (true = menu en icônes), Eclipse = { Tagline, Status, SidebarWidth, UserCard, FooterBar, Subtitle, DefaultSubtitle },
 Columns, ToggleKey, ToggleStyle, Background ("full" | "light" | "off"), Blur, Stars, Animations, AnimSpeed, WindowAnim,
 LockPosition, FreeCursor, BlockGameKeys, BlockedKeys, NoCanvasGroup, RememberLayout, ShowStats,
 ConfigFolder, AutoLoad, AutoLoadDelay, UpdateURL, UpdateInterval,
 Home / HomeName / HomeIcon, Settings / SettingsName / SettingsIcon, CustomIcon

 Méthodes de la fenêtre (Win:) :
   CreateTab(nom, _, icône) · CreateHomeTab(nom, icône, cfg) · CreateSettingsTab(nom, icône, docked) · CreateConfigTab(nom, icône)
   CreateFavoritesTab(nom, icône) · CreateRecentTab(nom, icône) · CreateNotifLogTab(nom, icône) · CreateConsoleTab(nom, icône)
   SetTitle · Toggle · SetMinimized / IsMinimized · SetOpacity · SetScale · SetColumns / GetColumns
   SetBackground / GetBackground · SetBackgroundImage(id, transparence) · SetStars / GetStars · SetStats
   SetLayoutStyle / GetLayoutStyle / RefreshLayoutStyle · ApplyStyle · ApplyTitle · ApplyLayout · Reset · Destroy
   AddDialog({ ... })   (voir §6)

------------------------------------------------------------------------------------------------
 2. ONGLETS (Tab:)
------------------------------------------------------------------------------------------------
   CreateBlock({ Name, Side, Collapsed, ImageID })      SetSubtitle(texte)      SetColumns(n)
   ClearBlocks() · CollapseAll() · ExpandAll()
   CreateSubTabs({ "A", "B", { Name = "C", Icon = "rbxassetid://..." } }) -> sous-onglets (subs[1] / subs.A, tab:SelectSub("B"), GetSubTab)
   CreateChildTab(nom, _, icône) · CreateChildTabs(liste) · GetChildTab(nom) · SelectChild(nom) · SetExpanded(bool) · ToggleExpanded()
   AddWarningBox({ Title, Text, Type = "Warning" | "Error" | "Info" | "Success", Dismissable })  -> bandeau en haut de l'onglet
        .SetText / SetTitle / SetType / SetVisible / Destroy
   Bloc : blk:SetCollapsed(bool)

------------------------------------------------------------------------------------------------
 3. OPTIONS COMMUNES À TOUS LES ÉLÉMENTS  (blk:CreateXxx({ ... }))
------------------------------------------------------------------------------------------------
   Name · Flag (nom sauvegardé dans les configs) · Callback(valeur) · Tooltip / Tip · Favorite
   ShowIf / HideIf = élément | "flag" | fonction | { Item =, Equals / NotEquals / In / Contains / Min / Max } | { cond1, cond2 }
   Enabled = false (grisé) · DisabledReason = "pourquoi" (affiché au survol)
   Risky = true · RiskyText = "texte"    (barre rouge + info-bulle)
   Méthodes communes : item.SetEnabled(bool, raison) · item.IsEnabled() · item.Destroy() · item:OnChanged(fn) -> h (h:Disconnect())
                       item.ClearChanged() · item.SetRisky(bool, texte) · item.IsRisky() · item.SetDisabledReason(texte)

------------------------------------------------------------------------------------------------
 4. ÉLÉMENTS  (options · méthodes)
------------------------------------------------------------------------------------------------
 CreateSection("Titre")                          · SetText
 CreateLabel({ Text, TextColor, TextSize })      · Set / SetText · Instance
 CreateParagraph({ Title, Content })             · Set / SetText / SetTitle
 CreateDivider()

 CreateButton({ Name, Callback, Cooldown = 3, CooldownText = false, Confirm / ConfirmText,
                DoubleClick = true, DoubleClickHint, DoubleClickTime,
                SubButton = { Name = "⚙", Callback = f, Tooltip = "..." } })
     · SetText · IsCooling · GetCooldown · SetCooldown(n) · ResetCooldown
 CreateConfirmButton({ Name, Confirm, Callback })

 CreateToggle({ Name, Default, Flag, Callback, Keybind = true|false, KeyMode, KeyCallback, ModeCallback,
                Loop = function(dt, item) end, LoopEvent = "Heartbeat" | "RenderStepped" | "Stepped", LoopInterval,
                Bind = { Target = instance | fonction | "Lighting", Property = "WalkSpeed", On = 50, Off = 16 },   -- ou Properties = {...}
                Keep = true })
     · Get · Set · GetKey / SetKey · GetMode / SetMode · IsLooping

 CreateSlider({ Name, Min, Max, Default, Step | Increment, Rounding, Suffix, Flag, Callback })        · Get · Set
 CreateRangeSlider({ Name, Min, Max, DefaultLow, DefaultHigh, MinGap, Step, Suffix, Flag, Callback }) · Get · Set · GetLow / GetHigh · SetLow / SetHigh
 CreateStepper({ Name, Min, Max, Default, Step, Wrap, Suffix, Flag, Callback })                       · Get · Set · Increment · Decrement · SetRange

 CreateDropdown({ Name, Items = { "a", { Name = "b", Icon = "rbxassetid://", Desc = "texte", Color = Color3 } },
                  Default, Multi = true, Search = true|false, Keys, Flag, Callback })
     · Get · Set · SetItems(liste) · Refresh · Open · Close
 CreatePlayerPicker({ Name, Multi = true, IncludeLocal, Filter = function(p) end, Avatars = false, Flag, Callback })
     · Get (objets Player) · Set(player | nom) · Clear · GetNames
 CreateRadio({ Name, Items, Default, Flag, Callback })        · Get · Set · GetIndex
 CreateChips({ Name, Items, Default, Multi, Max, AllowNone, Flag, Callback })
     · Get · Set · Toggle(nom) · IsSelected(nom) · SelectAll · Clear · SetItems

 CreateInput({ Name, Default, Placeholder, Numeric, ClearOnFocus, LiveUpdate, MaxHeight, Flag, Callback })   · Get · Set
 CreateTextArea({ Name, Default, Placeholder, Height, AutoGrow, MaxHeight, MaxLength, ReadOnly, LiveUpdate, Flag, Callback }) · Get · Set · SetText
 CreateKeybind({ Name, Default = Enum.KeyCode.X, Mode = "Toggle" | "Hold" | "Always", OnState, ModeCallback, Flag, Callback })
     · Get · Set · GetMode / SetMode · IsActive
 CreateColorPicker({ Name, Default = Color3, Alpha / Opacity, DefaultAlpha, Flag, Callback })   · Get · Set · GetHex · GetAlpha · SetAlpha

 CreateProgress({ Name, Min, Max, Value, Color, Format, Suffix, Text })
     · Set · Get · GetRatio · SetMax · SetColor · SetName · SetText · SetIndeterminate · Countdown · Cancel
 CreateTimer({ Name, Duration (compte à rebours ; sans = chronomètre), AutoStart, Tenths, Flag, Callback(état, secondes) })
     · Start · Pause · Toggle · Reset · Get · GetElapsed · IsRunning · Set · SetDuration
 CreateStats({ Items, Columns, CellHeight, ValueSize })       · Set · SetName · SetNumber
 CreateGraph({ Name, Max, Samples, Unit, Height, Colored, ColorFn, MinMax })    · Push · Clear · Flush
 CreateTable({ Name, Columns, Rows, MaxRows, Sortable, Flag, Callback })        · AddRow · RemoveRow · SetRows · Set · Get · GetSelected · Sort · Clear
 CreateImage({ Name, Image / Source, Height, ScaleType, Color })                · Set / SetImage · SetHeight · SetColor · Get
 CreateVideo({ Video = "rbxassetid://...", Height, Looped, Volume, Autoplay })  · Play · Pause · SetVideo · SetVolume
 CreateConsole({ Name, Title, Description, Height, MaxLines, Timestamp, Prompt, Filters, Events, Save, Flag })
     · Add / AddLine · AddCommand · RemoveCommand · Clear · Export · GetLines · Save · SetTitle · SetDescription · Refresh
 CreatePreview3D({ Name, Height, Info, Theme, Toolbar, Avatar, Character, RigType, ... })
     · Bind / BindAll / Unbind · BindPicker(picker) · Set / Get · SetInfo · Ragdoll · GetUp · Jump · PlayEmote · Refresh · ResetView · SetRotation
 CreateAvatarWave({ Height, RigType })     · Refresh · Jump · Welcome · GetModel

 STRUCTURE (V9.18) :
 CreateTabbox({ Tabs = { "A", "B" }, Default, Callback })     tb.A:CreateToggle(...) · tb[2]:CreateSlider(...) · tb:Select("B") · tb.Get()
 CreateDependencyBox({ Depends = élément | "flag" | { Item=, Equals= } })   dep:CreateXxx(...)   (visible seulement si la condition est vraie)

------------------------------------------------------------------------------------------------
 5. LIBRARY : OUTILS
------------------------------------------------------------------------------------------------
 Notifications :
   Library:Notify({ Title, Content, Type = "Info" | "Success" | "Warning" | "Error" | "Loading", Duration, Progress (0..1), Loading,
                    Actions = { { Text, Callback, Keep } }, OnClick, OnDismiss, Stack, Force, Dismissable })
     n:Update({...}) · n:SetProgress(x) · n:SetTitle · n:SetContent · n:SetType · n:Dismiss() · n:Pause() · n:Resume() · n:IsAlive()
   NotifyInfo / NotifySuccess / NotifyWarning / NotifyError (titre, contenu, durée) · NotifyProgress({...}) · ClearNotifications()
   SetNotifMuted · GetNotifHistory / ClearNotifHistory · SetNotifPosition · SetNotifDuration · SetNotifMax · SetNotifWidth
   SetNotifSound / SetNotifVolume / SetNotifSoundEnabled · SilenceNotif / UnsilenceNotif / UnsilenceAllNotifs · SetNotifExit / SetNotifEntry

 Flags / valeurs :
   Library.Flags[flag] · Library.Items[flag] · GetItem(flag) · GetFlag(flag) · SetFlag(flag, valeur) · Snapshot() · Restore(snapshot)
   WatchFlag(flag, fn(nouvelle, ancienne), { Immediate = true }) · Link(source, cible, transformation) · WaitForFlag(flag, attendu, timeout)
   RefreshConditions() · Group({ toggle1, toggle2 }, { Exclusive = true, AllowNone = false }) -> g.Set / Toggle / Select / Get / GetActive / OnChanged

 Temps :
   Every(secondes, fn, immédiat) -> h:Disconnect() · Debounce(fn, attente) · Throttle(fn, intervalle)

 Configs / thèmes :
   SaveConfig / LoadConfig / DeleteConfig / DuplicateConfig / RenameConfig / ResetConfig / ListConfigs / ExportConfig / ImportConfig
   SetAutoLoad(nom) / GetAutoLoad() / AutoLoad() · SaveSettings / LoadSettings
   GetTheme / ApplyTheme / ApplyPreset(nom) / SaveTheme / LoadTheme / DeleteTheme / ListThemes / ExportTheme / ImportTheme
   SetColor / SetColors / SetAccent / SetGradient

 Apparence :
   SetStyle("Standard" | "Verre" | "Givré" | "Mat" | "Néon") · SetShape · SetCornerRadius · SetFont · SetFontScale · SetBlur · SetStars
   SetBackground("full" | "light" | "off") · SetBackgroundImage(id, transparence) · SetLayoutStyle / GetLayoutStyle · SetCompact(bool) / GetCompact()
   SetEclipseOption(clé, valeur) · SetSquareOption · SetToggleStyle(nom) / NextToggleStyle · SetWindowAnim · SetAnimations · SetAnimSpeed
   SetTabTransition · SetSmoothScroll · SetLockPosition / ToggleLockPosition · SetMiniBarVisible · SetOption(nom, valeur)

 Sons : PlayUISound · SetUISoundEnabled / SetUISoundPack / SetUISoundVolume / SetUISoundHover / SetUISoundReverb · GetSoundPresets
 HUD / divers : SetHud · SetHudKeys · SetHudScale · SetHudOnlyClosed · ResetHudPosition · AddChangelog · CopyText(texte) · LogEvent
 Disposition : SetLayoutEdit(bool) · ResetBlockLayout · AttachBlock / DetachBlock / AttachAllBlocks · SetFavorite · RevealElement · GetModified
 Destroy : Library:Destroy()

------------------------------------------------------------------------------------------------
 6. DIALOGUES (V9.18)
------------------------------------------------------------------------------------------------
 local d = Library:Dialog({ Title, Content, Width = 340, Dismissable = true, OnClose = f,
                            Buttons = { { Name = "Annuler" }, { Name = "OK", Primary = true, Danger = false, Keep = false, Callback = function(d) end } } })
   d.Close() · d.IsOpen()
 Library:Confirm("Titre", "Texte", function() oui end, function() non end)      (ou Library:Confirm({ Title, Content, YesText, NoText, Danger, OnYes, OnNo }))
 Win:AddDialog({ ... })  = Library:Dialog({ ... })

------------------------------------------------------------------------------------------------
 7. WIDGETS FLOTTANTS DÉPLAÇABLES (V9.18)   (restent à l'écran, option Flag = position sauvegardée)
------------------------------------------------------------------------------------------------
 Library:AddDraggableLabel({ Text, X, Y, TextSize, TextColor, Transparency, RichText, Visible, Flag,
                             Update = function() return "texte" end, Interval = 0.5 })
     · SetText / GetText · SetVisible · SetPosition(x, y) / GetPosition() · Destroy
 Library:AddDraggableButton({ Text, Size = 52, X, Y, Toggle = true, Default, Callback(on), Visible, Flag })
     · SetText · Get / Set · SetVisible · SetPosition · Destroy
 Library:AddDraggableMenu({ Title, X, Y, Width = 190, Collapsed, Visible, Flag })
     · m:AddLabel(texte) · m:AddButton(nom, fn) · m:AddToggle(nom, défaut, fn) · m:Clear() · m:Collapse(bool) · m:SetTitle · m:SetVisible · m:Destroy()

------------------------------------------------------------------------------------------------
 8. EXEMPLE MINIMAL
------------------------------------------------------------------------------------------------
 local Library = loadstring(readfile("Ui-Lib-Simple.lua"))()
 local Win = Library:CreateWindow({ Title = "Mon script", Compact = false })
 local Tab = Win:CreateTab("Combat")
 local Blk = Tab:CreateBlock({ Name = "Général", Side = "Left" })
 local adv = Blk:CreateToggle({ Name = "Avancé", Flag = "adv", Risky = true, RiskyText = "Peut être détecté" })
 local dep = Blk:CreateDependencyBox({ Depends = adv })
 dep:CreateSlider({ Name = "Force", Min = 1, Max = 10, Default = 5, Flag = "force" })
 Blk:CreateButton({ Name = "Reset", DoubleClick = true, Callback = function() Library:Notify({ Title = "OK", Type = "Success" }) end })
 Tab:AddWarningBox({ Title = "Attention", Text = "Réglages expérimentaux" })
 Library:AddDraggableLabel({ Text = "FPS : ...", Update = function() return "Force : " .. tostring(Library:GetFlag("force")) end })

]==]

-- =========================================================================
-- INVINCIBLE — organisation du script en 3 gros blocs
--
--   BLOC 1 — DÉBUT    : tout ce qui prépare le script (nettoyage, services,
--                       bibliothèque UI, fenêtre, onglets, outils Notify / Feature)
--   BLOC 2 — CONTENU  : les features, rangées onglet par onglet
--                       (onglet Player)
--   BLOC 3 — FIN      : le modèle pour ajouter une feature + la notification finale
--
-- Règle : chaque feature = un bloc  Feature("Nom", function(F) ... end)  placé dans le BLOC 2,
--   sous l'onglet qui lui correspond.
--   F.Tabs, F.Library, F.Window, F.Notify, F.Track* … sont fournis ; une feature qui plante n'en casse pas une autre.
-- =========================================================================

-- ████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████
-- ██  BLOC 1 — DÉBUT
-- ██  Préparation : nettoyage, services, bibliothèque UI, fenêtre, onglets, outils
-- ████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████

-- ───── 1.1  INFRASTRUCTURE (debug, pcall sûr, chargement distant) ──────────
_G.INVINCIBLE_Debug = _G.INVINCIBLE_Debug or false   -- true = affiche les erreurs avalées par pcall

function _dbg(...)
    if _G.INVINCIBLE_Debug then print(...) end
end
local function _warn(...)
    if _G.INVINCIBLE_Debug then warn(...) end
end

if not _G.INVINCIBLE_RawPcall then _G.INVINCIBLE_RawPcall = pcall end
local function _pcallCheck(ok, ...)
    if not ok and _G.INVINCIBLE_Debug then warn("[pcall]", ...) end
    return ok, ...
end
pcall = function(f, ...) return _pcallCheck(_G.INVINCIBLE_RawPcall(f, ...)) end

-- Charge un script distant (retourne nil si le téléchargement / la compilation / l'exécution échoue)
function _SafeLoad(url, label)
    local okGet, body = _G.INVINCIBLE_RawPcall(function() return game:HttpGet(url) end)
    if not okGet or type(body) ~= "string" or body == "" then
        _warn("[INVINCIBLE] Téléchargement impossible : " .. tostring(label or url))
        return nil
    end
    local fn, err = loadstring(body)
    if not fn then
        _warn("[INVINCIBLE] Script invalide (" .. tostring(label or url) .. ") : " .. tostring(err))
        return nil
    end
    local okRun, res = _G.INVINCIBLE_RawPcall(fn)
    if not okRun then
        _warn("[INVINCIBLE] Erreur d'exécution (" .. tostring(label or url) .. ") : " .. tostring(res))
        return nil
    end
    return res
end

-- ───── 1.2  CLEANUP (relance propre du script) ─────────────────────────────
-- Relance du script : on nettoie l'ancienne instance d'abord
if _G.INVINCIBLE_Cleanup then pcall(_G.INVINCIBLE_Cleanup) end
_G.INVINCIBLE_RunId = {}   -- les boucles longues s'arrêtent quand il change : while _G.INVINCIBLE_RunId == myId do …

-- Table partagée : les features s'y échangent des états (ex. Look Figures actif, Anti Grab actif, TP en attente)
_G.INVINCIBLE_Shared = {}

local _Connections, _SpawnedItems, _VisualParts, _ActiveFlags, _CleanupHooks = {}, {}, {}, {}, {}

function _TrackConn(conn)
    if conn then table.insert(_Connections, conn) end
    return conn
end
function _TrackItem(itemName) _SpawnedItems[itemName] = true end
function _TrackPart(part)
    if part then table.insert(_VisualParts, part) end
    return part
end
function _SetFlag(key, val) _ActiveFlags[key] = val end
-- Enregistre une fonction appelée à la fermeture du script (remettre la caméra, détruire un GUI, …)
function OnCleanup(fn) table.insert(_CleanupHooks, fn) end

_G.INVINCIBLE_Cleanup = function()
    _G.INVINCIBLE_RunId = nil
    for _, fn in ipairs(_CleanupHooks) do pcall(fn) end
    table.clear(_CleanupHooks)
    for k in pairs(_ActiveFlags) do _ActiveFlags[k] = false end
    for _, c in ipairs(_Connections) do pcall(function() c:Disconnect() end) end
    table.clear(_Connections)
    for _, p in ipairs(_VisualParts) do pcall(function() if p and p.Parent then p:Destroy() end end) end
    table.clear(_VisualParts)

    -- détruit les toys spawnés par le script
    local inv = workspace:FindFirstChild(game.Players.LocalPlayer.Name .. "SpawnedInToys")
    if inv then
        for name in pairs(_SpawnedItems) do
            local item = inv:FindFirstChild(name) or inv:FindFirstChild("V2_" .. name)
            if item then
                pcall(function() game:GetService("ReplicatedStorage").MenuToys.DestroyToy:FireServer(item) end)
            end
        end
    end
    table.clear(_SpawnedItems)
    _dbg("[INVINCIBLE] Cleanup effectué.")
end

_TrackConn(game.Players.LocalPlayer.AncestryChanged:Connect(function() pcall(_G.INVINCIBLE_Cleanup) end))

-- ───── 1.3  SERVICES ROBLOX ────────────────────────────────────────────────
local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = workspace
local LocalPlayer      = Players.LocalPlayer

-- ───── 1.4  BIBLIOTHÈQUE UI + FENÊTRE ──────────────────────────────────────
local Library = _SafeLoad("https://raw.githubusercontent.com/MadeByBlue-UI/UI/refs/heads/main/UIV67", "UI Library")
if not Library then
    error("[INVINCIBLE] Impossible de charger la librairie UI (réseau coupé ou lien mort).")
end

local Window = Library:CreateWindow({
    Title         = "INVINCIBLE",
    CustomIcon    = "",
    Theme         = {
        Main = Color3.fromRGB(0, 0, 0), Second = Color3.fromRGB(10, 10, 15),
        Accent = Color3.fromRGB(255, 255, 255), ElementAccent = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(255, 255, 255),
        GradientStart = Color3.fromRGB(255, 255, 255), GradientEnd = Color3.fromRGB(180, 180, 180),
        BGTransparency = 5,
    },
    ToggleKey     = Enum.KeyCode.RightShift,
    Transparency  = 0.05,
    ShowWatermark = { Enabled = false },
    ConfigFolder  = "INVINCIBLE_Config",
    Size          = UDim2.new(0, 560, 0, 560),
    Position      = UDim2.new(1, -580, 0.5, -280),
})

-- ───── 1.5  ONGLETS ────────────────────────────────────────────────────────
-- Onglet principal (Home est créé automatiquement par la bibliothèque)
_G.INVINCIBLE_Tabs = {
    Player = Window:CreateTab("Player",     true, "rbxassetid://117259180607823"),
}
local Tabs = _G.INVINCIBLE_Tabs

-- Icônes : la bibliothèque force TOUTES les icônes de l'UI à 22 x 22 px (Library.IconSize = 22) : plus rien à redimensionner ici.

-- ───── 1.6  BANNIÈRE CONSOLE (seule sortie de la console) ──────────────────
do
    local _banner = [[
██╗███╗   ██╗██╗   ██╗██╗███╗   ██╗ ██████╗██╗██████╗ ██╗     ███████╗
██║████╗  ██║██║   ██║██║████╗  ██║██╔════╝██║██╔══██╗██║     ██╔════╝
██║██╔██╗ ██║██║   ██║██║██╔██╗ ██║██║     ██║██████╔╝██║     █████╗  
██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╗██║██║     ██║██╔══██╗██║     ██╔══╝  
██║██║ ╚████║ ╚████╔╝ ██║██║ ╚████║╚██████╗██║██████╔╝███████╗███████╗
╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝╚═════╝ ╚══════╝╚══════╝

INVINCIBLE - Version 1.0.0
Made by Blue
UI by Blue
]]
    -- une ligne = un print : la console ajoute l'heure devant chaque print, donc toutes les lignes restent alignées
    for _, line in ipairs(string.split(_banner, "\n")) do
        print(line == "" and " " or line)
    end
end

-- ───── 1.7  OUTILS (Notify + Feature) ──────────────────────────────────────
-- Raccourci de notification
function Notify(title, content, kind, duration)
    return Library:Notify({ Title = title, Content = content or "", Type = kind or "Info", Duration = duration or 4 })
end

-- Chaque feature est isolée dans son pcall : si elle plante, la suivante se charge quand même.
local function Feature(name, build)
    local ok, err = _G.INVINCIBLE_RawPcall(build, {
        Library = Library, Window = Window, Tabs = Tabs,
        Players = Players, RS = ReplicatedStorage, RunService = RunService,
        UIS = UserInputService, LP = LocalPlayer, Workspace = Workspace,
        Notify = Notify,
    })
    if not ok then
        _warn("[INVINCIBLE] Feature « " .. name .. " » : " .. tostring(err))
        pcall(function() Library:NotifyError("INVINCIBLE", "Feature « " .. name .. " » : " .. tostring(err), 8) end)
    end
end

-- ████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████
-- ██  BLOC 2 — CONTENU DU SCRIPT
-- ██  Les features, rangées par onglet (un onglet = une section ci-dessous)
-- ████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████

-- ───── ONGLET  Player  (F.Tabs.Player) ─────────────────────────────────────
-- Porté de Resonance : Values / Character / Teleporting / Players / Look Event Figures / Animations
-- (la vue caméra / highlight / China Hat est dans « Player View », les formes en noix de coco dans « Create Forms », plus bas)
Feature("Player", function(F)
    local Players, RS, RunService, UIS, LP, Workspace = F.Players, F.RS, F.RunService, F.UIS, F.LP, F.Workspace
    local Tab = F.Tabs.Player
    local runId = _G.INVINCIBLE_RunId
    local function alive() return _G.INVINCIBLE_RunId == runId end
    local function cam() return Workspace.CurrentCamera end

    local S = {}   -- états ON/OFF
    local V = { WalkSpeed = 16, JumpPower = 24, FlightSpeed = 1, SpinSpeed = 15 }   -- valeurs des sliders

    -- (personnage, racine, humanoïde) d'un joueur ; rien si incomplet
    local function Char(plr)
        plr = plr or LP
        local char = plr.Character
        if not char or not char.Parent then return end
        local root = char:FindFirstChild("realHrp") or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if root and root.Parent and hum and hum.Parent then return char, root, hum end
    end
    local function isAlive()
        local _, _, hum = Char()
        return hum ~= nil and hum.Health > 0
    end

    -- connexions « runtime » : une par nom, créées à l'activation, coupées à la désactivation
    local runtime = {}
    local function SetConn(name, signal, on, fn)
        local c = runtime[name]
        if not on then
            if c then c:Disconnect() end
            runtime[name] = nil
            return
        end
        if c and c.Connected then return end
        runtime[name] = _TrackConn(signal:Connect(fn))
    end

    -- ======================= collisions / téléportation =======================
    local LIGHT = PhysicalProperties.new(0.01, 0.01, 0.01, 0.01, 0.01)
    local function ToggleCollisions(char, canCollide, keepRagdollLimbs, light)
        local props = light and LIGHT or nil
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("BasePart") then
                if canCollide then
                    if (child.Name == "Torso" or child.Name == "Head") and not child.CanCollide then child.CanCollide = true end
                else
                    if child.CanCollide then child.CanCollide = false end
                    if not keepRagdollLimbs then
                        local limb = child:FindFirstChild("RagdollLimbPart")
                        if limb and limb.CanCollide then limb.CanCollide = false end
                    end
                end
                if child.Name ~= "HumanoidRootPart" and child.CustomPhysicalProperties ~= props then
                    child.CustomPhysicalProperties = props
                end
            end
        end
    end

    local function Teleport(part, target, offset)   -- target : CFrame | Vector3 | BasePart
        if not part or not part:IsA("BasePart") or not target then return false end
        local cf
        if typeof(target) == "CFrame" then cf = target
        elseif typeof(target) == "Vector3" then cf = CFrame.new(target)
        elseif typeof(target) == "Instance" and target:IsA("BasePart") then cf = target.CFrame
        else return false end
        if offset then cf = cf + offset end
        -- Anti Grab (futur) : si actif, il verrouille la position du torse ; on lui donne la destination à appliquer
        local myChar = Char()
        if myChar and part:IsDescendantOf(myChar) and (part.Name == "HumanoidRootPart" or part.Name == "Torso")
            and _G.INVINCIBLE_Shared.AntiGrabActive then
            _G.INVINCIBLE_Shared.PendingTeleportCF = cf
        end
        part.CFrame = cf
        part.AssemblyLinearVelocity = Vector3.zero
        part.AssemblyAngularVelocity = Vector3.zero
        return true
    end

    -- ============================== VOL (Flight) ==============================
    local bodyVel, bodyGyro, controlModule
    local function StopFly()
        if bodyVel then bodyVel:Destroy() bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        local _, _, hum = Char()
        if hum then hum.PlatformStand = false end
    end
    local function StartFly(root)
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 90000
        bodyGyro.D = 1000
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.Velocity = Vector3.zero
        bodyVel.Parent = root
    end
    local function UpdateFlight()
        local char, root, hum = Char()
        if not (char and hum.Health > 0) then
            if bodyVel or bodyGyro then StopFly() end
            return
        end
        if not bodyVel or bodyVel.Parent ~= root or not bodyGyro or bodyGyro.Parent ~= root then
            StopFly()
            StartFly(root)
        end
        if not hum.Sit then hum.PlatformStand = true end

        local fwd, side, up = 0, 0, 0
        if UIS:IsKeyDown(Enum.KeyCode.W) then fwd = 1 end
        if UIS:IsKeyDown(Enum.KeyCode.S) then fwd -= 1 end
        if UIS:IsKeyDown(Enum.KeyCode.A) then side = -1 end
        if UIS:IsKeyDown(Enum.KeyCode.D) then side += 1 end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then up = 2 end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then up -= 2 end

        if UIS.TouchEnabled and not UIS.KeyboardEnabled then   -- mobile : joystick + bouton saut
            if not controlModule then
                local ok, m = pcall(function()
                    return require(LP.PlayerScripts:FindFirstChild("PlayerModule"):FindFirstChild("ControlModule"))
                end)
                if ok then controlModule = m end
            end
            if controlModule then
                local mv = controlModule:GetMoveVector()
                side += mv.X
                fwd -= mv.Z
                if hum.Jump then up += 2 end
            end
        end

        local c = cam()
        local dir = c.CFrame.RightVector * side + c.CFrame.LookVector * fwd + Vector3.new(0, up, 0)
        if dir.Magnitude > 1 then dir = dir.Unit end
        local alpha = dir.Magnitude > 0 and 0.22 or 0.12
        bodyVel.Velocity = bodyVel.Velocity:Lerp(dir * V.FlightSpeed * 50, alpha)
        bodyGyro.CFrame = c.CFrame
    end

    -- ============================ WALKSPEED (translation) ============================
    -- Assis sur un CreatureBlobman : la vitesse s'applique au HumanoidCreature du blobman, pas à ton perso
    local creatureModel, seatConn
    local function trackSeat()
        if seatConn then seatConn:Disconnect() seatConn = nil end
        local _, _, hum = Char()
        if not hum then return end
        seatConn = hum.Seated:Connect(function(active, seat)
            if active and seat and seat.Parent and seat.Parent.Name == "CreatureBlobman" then
                creatureModel = seat.Parent
            else
                creatureModel = nil
            end
        end)
    end
    trackSeat()
    _TrackConn(LP.CharacterAdded:Connect(function() task.wait(0.5) trackSeat() end))

    local function creatureHumanoid()
        return creatureModel and creatureModel.Parent and creatureModel:FindFirstChild("HumanoidCreature")
    end
    local function UpdateWalkSpeed(dt)
        local char, _, hum = Char()
        if char and hum.Health > 0 then
            local hc = creatureHumanoid()
            if hc then
                hc.WalkSpeed = V.WalkSpeed
                return
            end
            if hum.MoveDirection.Magnitude > 0 then
                char:TranslateBy(hum.MoveDirection * V.WalkSpeed * dt)
            end
        end
    end

    -- ============================ SPIN / JERK OFF ============================
    local spinGen, jerkGen = 0, 0
    local function SetSpin(on)
        S.Spin = on
        spinGen += 1
        if not on then return end
        local gen = spinGen
        task.spawn(function()
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(0, math.huge, 0)
            while S.Spin and spinGen == gen and alive() do
                local _, root, hum = Char()
                if root then
                    bav.Parent = root
                    bav.AngularVelocity = Vector3.new(0, V.SpinSpeed, 0)
                end
                if hum then hum.AutoRotate = false end
                task.wait()
            end
            bav:Destroy()
            if spinGen == gen or not S.Spin then
                local _, _, hum = Char()
                if hum then hum.AutoRotate = true end
            end
        end)
    end

    local function SetJerkOff(on)
        S.JerkOff = on
        jerkGen += 1
        if not on then return end
        local gen = jerkGen
        local function running() return S.JerkOff and jerkGen == gen and alive() end
        task.spawn(function()
            local anim = Instance.new("Animation")
            anim.Name = "JerkOff"
            anim.AnimationId = "rbxassetid://168268306"
            local track
            local function load()
                local _, _, hum = Char()
                local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 2))
                if animator then
                    track = animator:LoadAnimation(anim)
                    track:Play()
                end
            end
            load()
            while running() do
                task.wait(0.1)
                if not isAlive() then
                    if track then track:Stop() track = nil end
                    repeat task.wait(0.2) until not running() or isAlive()
                    if running() then task.wait(0.5) load() end
                elseif track then
                    track.TimePosition = 0.3
                end
            end
            if track then track:Stop() end
        end)
    end

    -- boucle JumpPower / Noclip (légère : ne fait rien tant que les deux sont OFF)
    task.spawn(function()
        while alive() do
            task.wait(0.03)
            if S.JumpPower or S.Noclip then
                local char, _, hum = Char()
                if S.JumpPower and hum then
                    hum.UseJumpPower = true
                    if hum.JumpPower ~= V.JumpPower then hum.JumpPower = V.JumpPower end
                end
                if S.Noclip and char then ToggleCollisions(char, false, true) end
            end
        end
    end)

    _TrackConn(UIS.JumpRequest:Connect(function()
        if S.InfJump then
            local _, _, hum = Char()
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end))

    -- ============================ POSITION DESYNC ============================
    local DesyncSupported = type(sethiddenproperty) == "function" and type(setfflag) == "function" and type(getfflag) == "function"
    local DesyncToggle
    local dRoot, dBusy, dReadyAt, dOrigRate, dCheckAt, dGen = nil, false, 0, nil, 0, 0

    local function setSenderRate(rate)
        for _, v in ipairs({ tostring(rate), rate }) do
            pcall(setfflag, "S2PhysicsSenderRate", v)
            local ok, res = pcall(getfflag, "S2PhysicsSenderRate")
            if ok and tonumber(res) == rate then return true end
        end
        return false
    end
    local function resetDesyncRoot()
        dGen += 1
        if dRoot and dRoot.Parent then pcall(sethiddenproperty, dRoot, "PhysicsRepRootPart", nil) end
        dRoot, dBusy, dReadyAt = nil, false, 0
    end
    local SetDesync
    local function failDesync()
        SetDesync(false)
        if DesyncToggle then pcall(function() DesyncToggle:Set(false) end) end
    end
    local function UpdateDesync()
        if not alive() or not S.Desync then return end
        local now = os.clock()
        if dCheckAt <= now then
            dCheckAt = now + 1
            local ok, res = pcall(getfflag, "S2PhysicsSenderRate")
            if (not ok or tonumber(res) ~= 1000) and not setSenderRate(1000) then return failDesync() end
        end
        local char, root, hum = Char()
        local bad = char ~= LP.Character or not (char and char.Parent and root and hum and hum.Health > 0)
        if bad then
            if dRoot then resetDesyncRoot() end
            return
        end
        if root ~= dRoot then
            resetDesyncRoot()
            dRoot = root
            dReadyAt = now + 0.14
        end
        if dBusy then return end
        if now < dReadyAt then
            if not pcall(sethiddenproperty, dRoot, "PhysicsRepRootPart", dRoot) then return failDesync() end
            return
        end
        dBusy = true
        local myRoot, myGen = dRoot, dGen
        if not pcall(sethiddenproperty, myRoot, "PhysicsRepRootPart", nil) then return failDesync() end
        task.wait(0.1)
        if myGen ~= dGen or not alive() or not S.Desync or myRoot ~= dRoot then return end
        if not myRoot.Parent or char ~= LP.Character or hum.Health <= 0 then return resetDesyncRoot() end
        if not pcall(sethiddenproperty, myRoot, "PhysicsRepRootPart", myRoot) then return failDesync() end
        dBusy = false
        dReadyAt = os.clock() + 0.14
    end
    SetDesync = function(on)
        local want = on == true and alive() and DesyncSupported
        if S.Desync == want then return end
        SetConn("Desync", nil, false)
        S.Desync = want
        if want then
            local ok, res = pcall(getfflag, "S2PhysicsSenderRate")
            if ok and tonumber(res) then dOrigRate = tonumber(res) end
            if dOrigRate == nil then return failDesync() end
            dCheckAt = os.clock() + 1
            if not setSenderRate(1000) then return failDesync() end
        else
            resetDesyncRoot()
            if dOrigRate ~= nil then setSenderRate(dOrigRate) end
        end
        SetConn("Desync", RunService.Heartbeat, want, UpdateDesync)
    end

    -- ============================ LOOK EVENT FIGURES ============================
    local look = RS:FindFirstChild("CharacterEvents") and RS.CharacterEvents:FindFirstChild("Look")
    -- Look Figures exige que ces 2 scripts du jeu soient coupés (= « Anti Lag » de Resonance) : on les coupe tant que c'est actif,
    -- puis on remet leur état d'avant. _G.INVINCIBLE_Shared.LookFiguresActive permet à un futur toggle Anti Lag de rester forcé sur ON.
    local ANTILAG_SCRIPTS = { "CharacterAndBeamMove", "StickyPartsTouchDetection" }
    local savedScriptStates
    local function lookAntiLag(on)
        local ps = LP:FindFirstChild("PlayerScripts")
        if not ps then return end
        if on then
            savedScriptStates = {}
            for _, name in ipairs(ANTILAG_SCRIPTS) do
                local sc = ps:FindFirstChild(name)
                if sc then
                    savedScriptStates[name] = sc.Enabled
                    sc.Enabled = false
                end
            end
        elseif savedScriptStates then
            for name, was in pairs(savedScriptStates) do
                local sc = ps:FindFirstChild(name)
                if sc then sc.Enabled = was end
            end
            savedScriptStates = nil
        end
    end
    local LF = { Enabled = false, Preview = true, Figure = "Sideways", Clock = 0, Cycle = 0 }
    local function ClearLookChar()
        if LF.Root and LF.Root.Parent and LF.Saved then LF.Root.C0 = LF.Saved[2] end
        LF.Character, LF.Root, LF.Saved = nil, nil, nil
    end
    local function UpdateLookFigures(dt)
        if not alive() or not LF.Enabled or not look then return end
        local char, root, hum = Char()
        local torso = char and char:FindFirstChild("Torso")
        local neck = torso and torso:FindFirstChild("Neck")
        local rootJoint = root and root:FindFirstChild("RootJoint")
        local shoulder = torso and torso:FindFirstChild("Right Shoulder")
        if not (hum and hum.Health > 0 and neck and rootJoint and shoulder) then return ClearLookChar() end
        if LF.Character ~= char or LF.Root ~= rootJoint then
            ClearLookChar()
            LF.Character, LF.Root = char, rootJoint
            LF.Saved = { neck.C0, rootJoint.C0, shoulder.C0 }
        end
        local angle = LF.Figure == "Upside Down" and math.pi or math.pi / 2
        local figureC0 = CFrame.Angles(0, 0, angle) * LF.Saved[2]
        local localC0 = LF.Preview and figureC0 or LF.Saved[2]
        if rootJoint.C0 ~= localC0 then rootJoint.C0 = localC0 end

        LF.Clock += dt
        if LF.Clock < 0.05 then return end
        LF.Cycle = LF.Cycle % 20 + 1
        LF.Clock = LF.Clock % 0.05
        look:FireServer(LF.Saved[1], figureC0, LF.Saved[3], "high")
        if LF.Cycle % 5 == 0 then look:FireServer(LF.Saved[1], figureC0, LF.Saved[3], "medium") end
        if LF.Cycle % 10 == 0 then look:FireServer(LF.Saved[1], figureC0, LF.Saved[3], "low") end
        if LF.Cycle == 20 then look:FireServer(LF.Saved[1], figureC0, LF.Saved[3], "lowest") end
    end
    local function SetLookFigures(on)
        local want = on and alive() and look ~= nil
        if LF.Enabled == want then return end
        LF.Enabled = want
        _G.INVINCIBLE_Shared.LookFiguresActive = want
        if want then
            lookAntiLag(true)
            UpdateLookFigures(0)
        else
            local saved = LF.Character == LP.Character and LF.Saved
            ClearLookChar()
            LF.Clock, LF.Cycle = 0, 0
            if saved and look then
                for _, q in ipairs({ "high", "medium", "low", "lowest" }) do look:FireServer(saved[1], saved[2], saved[3], q) end
            end
            lookAntiLag(false)
        end
        SetConn("LookFigures", RunService.Heartbeat, want, UpdateLookFigures)
    end

    -- ============================ ANIMATIONS ============================
    local ANIMS = {
        Struggle = 7047322890, Faint = 181526230, ["Floor Faint"] = 181525546, Levitate = 313762630,
        Spinner = 188632011, ["Spin Dance"] = 429730430, ["Spin Dance 2"] = 186934910, ["Float Sit"] = 179224234,
        Scared = 180612465, ["Floating Head"] = 121572214, Crouch = 182724289, ["Moving Dance"] = 429703734,
        ["Bow Down"] = 204292303, ["Sword Slam"] = 204295235, Insane = 33796059, ["Mega Insane"] = 184574340,
        ["Sword Slice"] = 35978879, ["Loop Head"] = 35154961, ["Floor Crawl"] = 282574440, ["Dino Walk"] = 204328711,
        ["Weird Back"] = 215384594, ["Moon Dance"] = 45834924, ["Full Punch"] = 204062532, ["Full Swing"] = 218504594,
        ["Arm Turbine"] = 259438880, ["Barrel Roll"] = 136801964, ["Arm Detach"] = 33169583, ["Insane Arms"] = 27432691,
    }
    local animNames = {}
    for name in pairs(ANIMS) do table.insert(animNames, name) end
    table.sort(animNames)

    local animTrack, animChoice, animSpeed = nil, animNames[1], 1
    local function StopAnim()
        if animTrack then
            pcall(function() animTrack:Stop() animTrack:Destroy() end)
            animTrack = nil
        end
    end
    local function PlayAnim()
        StopAnim()
        if not S.Anim or not animChoice then return end
        local _, _, hum = Char()
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        local id = ANIMS[animChoice]
        if not animator or not id then return end
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. id
        animTrack = animator:LoadAnimation(a)
        animTrack.Looped = true
        animTrack:Play()
        animTrack:AdjustSpeed(animSpeed)
    end
    _TrackConn(LP.CharacterAdded:Connect(function()
        task.wait(1)
        if S.Anim and alive() then PlayAnim() end
    end))

    -- ============================ TÉLÉPORTATION : lieux ============================
    local locNames, locMap = {}, {}
    local function addLoc(name, part) table.insert(locNames, name) locMap[name] = part end
    local wp = Workspace:FindFirstChild("Waypoints")
    if wp then
        for _, c in ipairs(wp:GetChildren()) do
            if c.Name ~= "CharacterWaypoint" and c:IsA("BasePart") then addLoc(c.Name, c) end
        end
    end
    local spawnLoc = Workspace:FindFirstChild("SpawnLocation")
    if spawnLoc then addLoc("SpawnLocation", spawnLoc) end
    local safe = Instance.new("Part")   -- plateforme sûre, loin de la map
    safe.Name = "Safe Platform"
    safe.Size = Vector3.new(250, 5, 250)
    safe.Position = Vector3.new(math.random(-25000, 25000), -500, math.random(-25000, 25000))
    safe.Anchored = true
    safe.CanCollide = true
    safe.Material = Enum.Material.Neon
    safe.Parent = Workspace
    _TrackPart(safe)
    addLoc("Safe Platform", safe)
    local locChoice = locMap["BlueHouse"] and "BlueHouse" or locNames[1]

    -- ============================ UI ============================
    -- ---- Values ----
    local Values = Tab:CreateBlock({ Name = "Values", Side = "Left" })
    Values:CreateSlider({ Name = "Walk Speed", Min = 5, Max = 1000, Default = 16, Step = 1, Flag = "player.walkspeed",
        Callback = function(v) V.WalkSpeed = v end })
    Values:CreateSlider({ Name = "Jump Power", Min = 24, Max = 1000, Default = 24, Step = 1, Flag = "player.jumppower",
        Callback = function(v) V.JumpPower = v end })
    Values:CreateSlider({ Name = "Flight Speed", Min = 1, Max = 20, Default = 1, Step = 1, Flag = "player.flightspeed",
        Callback = function(v) V.FlightSpeed = v end })
    Values:CreateSlider({ Name = "Spin Speed", Min = 5, Max = 1000, Default = 15, Step = 1, Flag = "player.spinspeed",
        Callback = function(v) V.SpinSpeed = v end })

    -- ---- Character ----
    local Character = Tab:CreateBlock({ Name = "Character", Side = "Left" })
    Character:CreateToggle({ Name = "Flight", Flag = "player.flight", Callback = function(on)
        S.Flight = on
        SetConn("Flight", RunService.RenderStepped, on, UpdateFlight)
        if not on then StopFly() end
    end })
    Character:CreateToggle({ Name = "Walkspeed", Flag = "player.walkspeed_on", Callback = function(on)
        S.WalkSpeed = on
        SetConn("WalkSpeed", RunService.Heartbeat, on, UpdateWalkSpeed)
        if not on then
            local hc = creatureHumanoid()
            if hc then hc.WalkSpeed = 20 end   -- vitesse normale du blobman
        end
    end })
    Character:CreateToggle({ Name = "Jump Power", Flag = "player.jumppower_on", Callback = function(on)
        S.JumpPower = on
        if not on then
            local _, _, hum = Char()
            if hum then hum.JumpPower = 24 end
        end
    end })
    Character:CreateToggle({ Name = "Character Spin", Flag = "player.spin", Callback = SetSpin })
    Character:CreateDivider()
    Character:CreateToggle({ Name = "Noclip", Flag = "player.noclip", Callback = function(on)
        S.Noclip = on
        if not on then
            local char = Char()
            if char then ToggleCollisions(char, true) end
        end
    end })
    Character:CreateToggle({ Name = "Inf Jump", Flag = "player.infjump", Callback = function(on) S.InfJump = on end })
    Character:CreateToggle({ Name = "Jerk Off", Flag = "player.jerkoff", Callback = SetJerkOff })
    Character:CreateDivider()
    DesyncToggle = Character:CreateToggle({
        Name = "Position Desync", Flag = "player.desync",
        Tooltip = "Quasi-invisibilité : ton personnage reste immobile pour les autres joueurs, mais pas pour le serveur.",
        Callback = function(on)
            if on and not DesyncSupported then
                F.Notify("Position Desync", "Ton exécuteur ne supporte pas cette feature.", "Warning")
                if DesyncToggle then pcall(function() DesyncToggle:Set(false) end) end
                return
            end
            SetDesync(on)
        end,
    })
    Character:CreateLabel({ Text = "À utiliser seulement avec 100 FPS ou plus !" })

    -- ---- Teleporting ----
    local Teleporting = Tab:CreateBlock({ Name = "Teleporting", Side = "Right" })
    Teleporting:CreateDropdown({ Name = "Location", Items = locNames, Default = locChoice, Flag = "player.tp_location",
        Callback = function(name) if locMap[name] then locChoice = name end end })
    Teleporting:CreateButton({ Name = "Teleport to Location", Callback = function()
        local _, root = Char()
        if root and locMap[locChoice] then Teleport(root, locMap[locChoice], Vector3.new(0, 3, 0)) end
    end })
    Teleporting:CreateToggle({ Name = "Make Spawn Location", Flag = "player.spawn_loc", Callback = function(on)
        SetConn("SpawnLoc", LP.CharacterAdded, on, function(char)
            local root = char:WaitForChild("HumanoidRootPart", 0.5)
            if root and locMap[locChoice] then Teleport(root, locMap[locChoice], Vector3.new(0, 3, 0)) end
        end)
    end })
    local loopLocGen = 0
    Teleporting:CreateToggle({ Name = "Loop TP to Location", Flag = "player.loop_tp_loc", Callback = function(on)
        S.LoopTpLoc = on
        loopLocGen += 1
        if not on then return end
        local gen = loopLocGen
        task.spawn(function()
            while S.LoopTpLoc and loopLocGen == gen and alive() do
                local _, root = Char()
                if root and locMap[locChoice] then Teleport(root, locMap[locChoice], Vector3.new(0, 10, 0)) end
                task.wait()
            end
        end)
    end })

    -- ---- Players ----
    local PlayersBlock = Tab:CreateBlock({ Name = "Players", Side = "Right" })
    local targetName
    local function playerNames()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(list, p.Name) end
        end
        table.sort(list)
        return list
    end
    local PlayerDropdown = PlayersBlock:CreateDropdown({ Name = "Targets", Items = playerNames(), Flag = "player.tp_target",
        Callback = function(name) targetName = name end })
    local function refreshPlayers()
        if PlayerDropdown then pcall(function() PlayerDropdown:Refresh(playerNames(), false) end) end
        if targetName and not Players:FindFirstChild(targetName) then targetName = nil end
    end
    _TrackConn(Players.PlayerAdded:Connect(refreshPlayers))
    _TrackConn(Players.PlayerRemoving:Connect(function() task.defer(refreshPlayers) end))

    local specGen = 0
    local function restoreCamSubject()
        local _, _, hum = Char()
        if hum and cam() then cam().CameraSubject = hum end
    end
    PlayersBlock:CreateToggle({ Name = "Spectate Player", Flag = "player.spectate", Callback = function(on)
        S.Spectate = on
        specGen += 1
        if not on then restoreCamSubject() return end
        local gen = specGen
        task.spawn(function()
            while S.Spectate and specGen == gen and alive() do
                local target = targetName and Players:FindFirstChild(targetName)
                local tHum
                if target then local _, _, h = Char(target) tHum = h end
                local _, _, myHum = Char()
                if tHum then cam().CameraSubject = tHum elseif myHum then cam().CameraSubject = myHum end
                task.wait()
            end
            if specGen == gen then restoreCamSubject() end
        end)
    end })
    local loopPlrGen = 0
    PlayersBlock:CreateToggle({ Name = "Loop TP to Player", Flag = "player.loop_tp_player", Callback = function(on)
        S.LoopTpPlayer = on
        loopPlrGen += 1
        if not on then return end
        local gen = loopPlrGen
        task.spawn(function()
            while S.LoopTpPlayer and loopPlrGen == gen and alive() do
                local target = targetName and Players:FindFirstChild(targetName)
                local tRoot
                if target then local _, r = Char(target) tRoot = r end
                local _, root = Char()
                if root and tRoot then root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2) end
                task.wait()
            end
        end)
    end })

    -- ---- Look Event Figures ----
    local LookBlock = Tab:CreateBlock({ Name = "Look Event Figures", Side = "Right" })
    LookBlock:CreateDropdown({ Name = "Figure", Items = { "Sideways", "Upside Down" }, Default = "Sideways", Flag = "player.look_figure",
        Callback = function(v) LF.Figure = v if LF.Enabled then UpdateLookFigures(0) end end })
    LookBlock:CreateToggle({ Name = "Enabled", Flag = "player.look_enabled", Callback = SetLookFigures })
    LookBlock:CreateToggle({ Name = "Show Locally", Default = true, Flag = "player.look_preview",
        Callback = function(v) LF.Preview = v if LF.Enabled then UpdateLookFigures(0) end end })

    -- ---- Animations ----
    local AnimBlock = Tab:CreateBlock({ Name = "Animations", Side = "Right" })
    AnimBlock:CreateDropdown({ Name = "Animation to Play", Items = animNames, Default = animNames[1], Searchable = true, Flag = "player.anim_choice",
        Callback = function(name)
            animChoice = name
            if S.Anim then PlayAnim() end
        end })
    AnimBlock:CreateSlider({ Name = "Animation Speed", Min = 0, Max = 100, Default = 1, Step = 1, Flag = "player.anim_speed",
        Callback = function(v)
            animSpeed = v
            if animTrack then animTrack:AdjustSpeed(v) end
        end })
    AnimBlock:CreateToggle({ Name = "Toggle Animation", Flag = "player.anim_on", Callback = function(on)
        S.Anim = on
        if on then PlayAnim() else StopAnim() end
    end })

    -- ============================ CLEANUP ============================
    OnCleanup(function()
        S.Spin, S.JerkOff, S.LoopTpLoc, S.Spectate, S.LoopTpPlayer, S.Noclip, S.JumpPower, S.Anim = false, false, false, false, false, false, false, false
        StopFly()
        StopAnim()
        pcall(function() SetDesync(false) end)
        pcall(function() SetLookFigures(false) end)
        local char = Char()
        if char then pcall(ToggleCollisions, char, true) end
        restoreCamSubject()
    end)
end)

-- ───── ONGLET  Player — Extras (caméra, monde, utilitaires) ────────────────
Feature("Player Extras", function(F)
    local RunService, UIS, LP, Workspace = F.RunService, F.UIS, F.LP, F.Workspace
    local Tab = F.Tabs.Player
    local runId = _G.INVINCIBLE_RunId
    local function alive() return _G.INVINCIBLE_RunId == runId end
    local function cam() return Workspace.CurrentCamera end

    local S = {}                            -- états ON/OFF
    local V = { FOV = 70, Gravity = 196, Hip = 2 }   -- valeurs des sliders
    local orig = {}                         -- valeurs d'origine, remises quand on désactive

    -- (personnage, racine, humanoïde) ; rien si incomplet
    local function Char()
        local char = LP.Character
        if not char or not char.Parent then return end
        local root = char:FindFirstChild("realHrp") or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if root and root.Parent and hum and hum.Parent then return char, root, hum end
    end

    -- connexions « runtime » : une par nom, créées à l'activation, coupées à la désactivation
    local runtime = {}
    local function SetConn(name, signal, on, fn)
        local c = runtime[name]
        if not on then
            if c then c:Disconnect() end
            runtime[name] = nil
            return
        end
        if c and c.Connected then return end
        runtime[name] = _TrackConn(signal:Connect(fn))
    end

    -- téléportation (compatible avec l'Anti Grab du script)
    local function TeleportTo(cf)
        local _, root = Char()
        if not root then return false end
        if _G.INVINCIBLE_Shared.AntiGrabActive then _G.INVINCIBLE_Shared.PendingTeleportCF = cf end
        root.CFrame = cf
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        return true
    end

    -- ---- Camera ----
    local Camera = Tab:CreateBlock({ Name = "Camera", Side = "Left" })
    Camera:CreateSlider({ Name = "FOV", Min = 30, Max = 120, Default = 70, Step = 1, Flag = "player.fov",
        Callback = function(v) V.FOV = v end })
    Camera:CreateToggle({ Name = "Custom FOV", Flag = "player.fov_on", Callback = function(on)
        if on then
            local c = cam()
            if c and orig.FOV == nil then orig.FOV = c.FieldOfView end
        end
        SetConn("FOV", RunService.RenderStepped, on, function()
            local c = cam()
            if c then c.FieldOfView = V.FOV end
        end)
        if not on and orig.FOV then
            local c = cam()
            if c then c.FieldOfView = orig.FOV end
            orig.FOV = nil
        end
    end })
    Camera:CreateToggle({ Name = "Unlimited Zoom", Flag = "player.zoom_on",
        Tooltip = "Enlève la limite de dézoom de la caméra.",
        Callback = function(on)
            if on then
                if orig.Zoom == nil then orig.Zoom = LP.CameraMaxZoomDistance end
                LP.CameraMaxZoomDistance = 100000
            elseif orig.Zoom then
                LP.CameraMaxZoomDistance = orig.Zoom
                orig.Zoom = nil
            end
        end })

    -- ---- World ----
    local World = Tab:CreateBlock({ Name = "World", Side = "Left" })
    World:CreateSlider({ Name = "Gravity", Min = 0, Max = 400, Default = 196, Step = 1, Flag = "player.gravity",
        Callback = function(v) V.Gravity = v end })
    World:CreateToggle({ Name = "Custom Gravity", Flag = "player.gravity_on", Callback = function(on)
        if on and orig.Gravity == nil then orig.Gravity = Workspace.Gravity end
        SetConn("Gravity", RunService.Heartbeat, on, function() Workspace.Gravity = V.Gravity end)
        if not on and orig.Gravity then
            Workspace.Gravity = orig.Gravity
            orig.Gravity = nil
        end
    end })

    -- ---- Utility ----
    local Utility = Tab:CreateBlock({ Name = "Utility", Side = "Right" })
    Utility:CreateToggle({ Name = "Anti AFK", Flag = "player.antiafk",
        Tooltip = "Évite d'être déconnecté pour inactivité.",
        Callback = function(on)
            SetConn("AntiAFK", LP.Idled, on, function()
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end)
        end })
    Utility:CreateToggle({ Name = "Click TP", Flag = "player.clicktp",
        Tooltip = "Ctrl + clic gauche : te téléporte là où pointe ta souris.",
        Callback = function(on)
            SetConn("ClickTP", UIS.InputBegan, on, function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    local hit = LP:GetMouse().Hit
                    if hit then TeleportTo(CFrame.new(hit.Position + Vector3.new(0, 3, 0))) end
                end
            end)
        end })
    Utility:CreateDivider()

    local savedCF
    Utility:CreateButton({ Name = "Save Position", Callback = function()
        local _, root = Char()
        if not root then return F.Notify("Position", "Personnage introuvable.", "Warning") end
        savedCF = root.CFrame
        F.Notify("Position", "Position sauvegardée.", "Success", 2)
    end })
    Utility:CreateButton({ Name = "TP to Saved Position", Callback = function()
        if not savedCF then return F.Notify("Position", "Aucune position sauvegardée.", "Warning") end
        if not TeleportTo(savedCF) then F.Notify("Position", "Personnage introuvable.", "Warning") end
    end })
    Utility:CreateButton({ Name = "Copy Position", Callback = function()
        local _, root = Char()
        if not root then return F.Notify("Position", "Personnage introuvable.", "Warning") end
        local copy = setclipboard or toclipboard
        if not copy then return F.Notify("Position", "Ton exécuteur ne supporte pas le presse-papiers.", "Warning") end
        local p = root.Position
        copy(string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z))
        F.Notify("Position", "Coordonnées copiées.", "Success", 2)
    end })
    Utility:CreateDivider()
    Utility:CreateButton({ Name = "Reset Character", DoubleClick = true, Callback = function()
        local _, _, hum = Char()
        if hum then hum.Health = 0 end
    end })
    Utility:CreateButton({ Name = "Rejoin Server", DoubleClick = true, Callback = function()
        pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
    end })

    -- ---- Ragdoll : utilise le vrai système du jeu (ReplicatedStorage.CharacterEvents.RagdollRemote) ----
    -- Le serveur ragdoll le personnage pendant N secondes : RagdollRemote:FireServer(racine, N). Avec 0 il le relâche.
    -- Tant que le toggle est actif, on renvoie la demande avant la fin du délai.
    local function GetRagdollRemote()
        local events = F.RS:FindFirstChild("CharacterEvents") or F.RS:WaitForChild("CharacterEvents", 0.5)
        return events and (events:FindFirstChild("RagdollRemote") or events:WaitForChild("RagdollRemote", 0.5))
    end
    local ragLoopRunning = false
    local RagdollToggle
    local function RagdollOff()
        S.Ragdoll = false   -- arrête la boucle
        local remote = GetRagdollRemote()
        local _, root = Char()
        if remote and root then pcall(function() remote:FireServer(root, 0) end) end
    end
    local function RagdollLoop(remote)
        if ragLoopRunning then return end
        ragLoopRunning = true
        task.spawn(function()
            while S.Ragdoll and alive() do
                local _, root, hum = Char()
                if root and hum and hum.Health > 0 then
                    pcall(function() remote:FireServer(root, 0.5) end)
                end
                task.wait(0.25)
            end
            ragLoopRunning = false
        end)
    end

    -- ---- Body ----
    local Body = Tab:CreateBlock({ Name = "Body", Side = "Left" })
    Body:CreateSlider({ Name = "Hip Height", Min = 0, Max = 50, Default = 2, Step = 1, Flag = "player.hipheight",
        Callback = function(v) V.Hip = v end })
    Body:CreateToggle({ Name = "Custom Hip Height", Flag = "player.hipheight_on",
        Tooltip = "Soulève ou abaisse ton personnage par rapport au sol.",
        Callback = function(on)
            if on and orig.Hip == nil then
                local _, _, hum = Char()
                if hum then orig.Hip = hum.HipHeight end
            end
            SetConn("Hip", RunService.Heartbeat, on, function()
                local _, _, hum = Char()
                if hum then hum.HipHeight = V.Hip end
            end)
            if not on and orig.Hip then
                local _, _, hum = Char()
                if hum then hum.HipHeight = orig.Hip end
                orig.Hip = nil
            end
        end })
    Body:CreateButton({ Name = "Sit / Stand", Callback = function()
        local _, _, hum = Char()
        if hum then hum.Sit = not hum.Sit end
    end })
    RagdollToggle = Body:CreateToggle({ Name = "Ragdoll", Flag = "player.ragdoll",
        Tooltip = "Ton avatar s'effondre comme dans le jeu (ragdoll du serveur, visible par les autres joueurs).",
        Callback = function(on)
            if on then
                local remote = GetRagdollRemote()
                if not remote then
                    F.Notify("Ragdoll", "Remote de ragdoll introuvable dans ce jeu.", "Warning")
                    if RagdollToggle then pcall(function() RagdollToggle:Set(false) end) end
                    return
                end
                S.Ragdoll = true
                RagdollLoop(remote)
            else
                RagdollOff()
            end
        end })

    -- remet tout comme avant à la fermeture du script
    OnCleanup(function()
        for _, c in pairs(runtime) do pcall(function() c:Disconnect() end) end
        table.clear(runtime)
        local c = cam()
        if c and orig.FOV then c.FieldOfView = orig.FOV end
        if orig.Zoom then LP.CameraMaxZoomDistance = orig.Zoom end
        if orig.Gravity then Workspace.Gravity = orig.Gravity end
        local _, _, hum = Char()
        if hum and orig.Hip then hum.HipHeight = orig.Hip end
        pcall(RagdollOff)
    end)
end)

-- ───── ONGLET  Player — Vue & personnage (porté de Resonance) ──────────────
-- Third Person (+ touche) / Camera Noclip / Realistic First Person (+ transparence) /
-- Highlight Your Character / China Hat (cosmétique)
Feature("Player View", function(F)
    local RunService, UIS, LP, Workspace = F.RunService, F.UIS, F.LP, F.Workspace
    local Tab = F.Tabs.Player
    local function cam() return Workspace.CurrentCamera end
    local function Char()
        local c = LP.Character
        if c and c.Parent then return c end
    end

    -- connexions « runtime » : une par nom, créées à l'activation, coupées à la désactivation
    local runtime = {}
    local function SetConn(name, signal, on, fn)
        local c = runtime[name]
        if not on then
            if c then c:Disconnect() end
            runtime[name] = nil
            return
        end
        if c and c.Connected then return end
        runtime[name] = _TrackConn(signal:Connect(fn))
    end

    -- ============================ THIRD PERSON ============================
    local TP = { On = false, Orig = nil }
    local ThirdToggle
    local function SetThirdPerson(on)
        if on == TP.On then return end
        TP.On = on
        if on then
            if not TP.Orig then
                TP.Orig = { Mode = LP.CameraMode, Max = LP.CameraMaxZoomDistance, Min = LP.CameraMinZoomDistance }
            end
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMaxZoomDistance = 100000
            LP.CameraMinZoomDistance = 0.5
        else
            LP.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end
    -- ============================ CAMERA NOCLIP ============================
    -- 1) on neutralise le « Popper » du module caméra (la caméra ne se rapproche plus des murs)
    -- 2) si l'exécuteur ne sait pas hooker, repli sur DevCameraOcclusionMode = Invisicam
    local CN = { On = false, Popper = nil, Occ = nil }
    local function SetOcc(mode)
        if pcall(function() LP.DevCameraOcclusionMode = mode end) and LP.DevCameraOcclusionMode == mode then
            return true
        end
        return sethiddenproperty ~= nil and pcall(sethiddenproperty, LP, "DevCameraOcclusionMode", mode)
    end
    local function SetPopper(on)
        if not on then
            if not CN.Popper then return true end
            local p = CN.Popper
            local ok = pcall(p[1], p[2], p[3])
            if ok then CN.Popper = nil end
            return ok
        end
        if CN.Popper then return true end
        local hook = hookfunction or replaceclosure
        local m = LP:FindFirstChild("PlayerScripts")
        m = m and m:FindFirstChild("PlayerModule")
        m = m and m:FindFirstChild("CameraModule")
        m = m and m:FindFirstChild("ZoomController")
        m = m and m:FindFirstChild("Popper")
        if not hook or not m then return false end
        local ok, popper = pcall(require, m)
        if not ok or type(popper) ~= "function" then return false end
        local ok2, old = pcall(hook, popper, function(_, targetDistance) return targetDistance end)
        if ok2 then CN.Popper = { hook, popper, old } end
        return ok2
    end
    local function SetCameraNoclip(on)
        CN.On = on
        local popperOk = on and SetPopper(true)
        if on then
            if CN.Occ == nil then CN.Occ = LP.DevCameraOcclusionMode end
            if not popperOk then SetOcc(Enum.DevCameraOcclusionMode.Invisicam) end
        end
        SetConn("CameraNoclip", LP:GetPropertyChangedSignal("DevCameraOcclusionMode"), on and not popperOk, function()
            if CN.On and LP.DevCameraOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam then
                SetOcc(Enum.DevCameraOcclusionMode.Invisicam)
            end
        end)
        if not on then
            SetPopper(false)
            if CN.Occ ~= nil then
                SetOcc(CN.Occ)
                CN.Occ = nil
            end
        end
    end

    -- ======================== REALISTIC FIRST PERSON ========================
    -- Les membres (sauf tête / racine / torse) restent visibles en vue FPS, avec la transparence du slider.
    local RFP = { Alpha = 0.3 }
    local function ApplyRFP(mod)
        local char = Char()
        if not (char and char:FindFirstChild("Head")) then return end
        local c = cam()
        if not c then return end
        if (c.CFrame.Position - c.Focus.Position).Magnitude > 1.5 then mod = 0 end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("BasePart") and child.Name ~= "Head" and child.Name ~= "HumanoidRootPart" and child.Name ~= "Torso" then
                child.LocalTransparencyModifier = mod
            end
        end
    end
    local function SetRFP(on)
        SetConn("RealisticFirstPerson", RunService.RenderStepped, on, function() ApplyRFP(RFP.Alpha) end)
        if on then ApplyRFP(RFP.Alpha) else ApplyRFP(1) end
    end

    -- ======================= HIGHLIGHT YOUR CHARACTER =======================
    -- Matériau ForceField + couleur sur toutes les parties du personnage (remis à l'identique à la désactivation)
    local HL = { On = false, Color = Color3.fromRGB(0, 170, 255), AffectHat = true, Parts = {}, Char = nil, CharConn = nil }
    local Hat = { On = false, Color = Color3.fromRGB(255, 170, 70), Part = nil }

    local function UpdateHat()
        local hat = Hat.Part
        if not (hat and hat.Parent) then return end
        local hl = HL.On and HL.AffectHat
        local mat = hl and Enum.Material.ForceField or Enum.Material.Neon
        local col = hl and HL.Color or Hat.Color
        local tr = hl and 0 or 0.75
        if hat.Material ~= mat then hat.Material = mat end
        if hat.Color ~= col then hat.Color = col end
        if hat.Transparency ~= tr then hat.Transparency = tr end
    end

    local function RestorePart(part, rec)
        HL.Parts[part] = nil
        rec.MatC:Disconnect()
        rec.ColC:Disconnect()
        if part.Parent then
            part.Material = rec.Material
            part.Color = rec.Color
        end
    end
    local function ApplyPart(part)
        if not HL.On or not part:IsA("BasePart") or HL.Parts[part] then return end
        local rec = { Material = part.Material, Color = part.Color }
        rec.MatC = part:GetPropertyChangedSignal("Material"):Connect(function()
            if HL.On and HL.Parts[part] == rec and part.Material ~= Enum.Material.ForceField then
                part.Material = Enum.Material.ForceField
            end
        end)
        rec.ColC = part:GetPropertyChangedSignal("Color"):Connect(function()
            if HL.On and HL.Parts[part] == rec and part.Color ~= HL.Color then
                part.Color = HL.Color
            end
        end)
        HL.Parts[part] = rec
        part.Material = Enum.Material.ForceField
        part.Color = HL.Color
    end
    local function ClearHighlight()
        for part, rec in pairs(HL.Parts) do RestorePart(part, rec) end
        if HL.CharConn then HL.CharConn:Disconnect() HL.CharConn = nil end
        HL.Char = nil
    end
    local function AttachHighlight(char)
        if not HL.On or not char then return end
        ClearHighlight()
        HL.Char = char
        HL.CharConn = char.DescendantAdded:Connect(ApplyPart)
        for _, d in ipairs(char:GetDescendants()) do ApplyPart(d) end
    end
    local function UpdateHighlight()
        if HL.On then
            for part in pairs(HL.Parts) do
                if part.Color ~= HL.Color then part.Color = HL.Color end
            end
        end
        UpdateHat()
    end
    local function SetHighlight(on)
        HL.On = on
        ClearHighlight()
        SetConn("HighlightRespawn", LP.CharacterAdded, on, function(c) task.defer(AttachHighlight, c) end)
        if on then AttachHighlight(LP.Character) end
        UpdateHat()
    end

    -- ============================== CHINA HAT ==============================
    local function ClearHat()
        if Hat.Part then Hat.Part:Destroy() Hat.Part = nil end
    end
    local function CreateHat(char)
        local head = char and char:WaitForChild("Head", 5)
        if not Hat.On or char ~= LP.Character or not head then return end
        ClearHat()
        local mp = Instance.new("MeshPart")
        mp.Name = "INVChinaHat"
        pcall(function() mp.MeshId = "rbxassetid://1778999" end)
        mp.Size = Vector3.new(3, 0.7, 3)
        mp.Transparency = 0.75
        mp.CanCollide = false
        mp.CanTouch = false
        mp.CanQuery = false
        mp.Massless = true
        mp.CastShadow = false
        mp.DoubleSided = true
        mp.CFrame = head.CFrame * CFrame.new(0, 1, 0)
        mp.Parent = cam()
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = mp
        weld.Part1 = head
        weld.Parent = mp
        Hat.Part = _TrackPart(mp)
        UpdateHat()
    end
    local function SetHat(on)
        Hat.On = on
        SetConn("ChinaHatRespawn", LP.CharacterAdded, on, function(c) task.defer(CreateHat, c) end)
        SetConn("ChinaHatVisibility", RunService.RenderStepped, on, function()
            local hat, c = Hat.Part, cam()
            if hat and hat.Parent and c then
                hat.LocalTransparencyModifier = (c.CFrame.Position - c.Focus.Position).Magnitude <= 0.6 and 1 or 0
            end
        end)
        if on then task.defer(CreateHat, LP.Character) else ClearHat() end
    end

    -- ============================ RGB (arc-en-ciel) ============================
    local RGB = { HL = false, Hat = false }
    local function UpdateRainbow()
        SetConn("ViewRainbow", RunService.RenderStepped, RGB.HL or RGB.Hat, function()
            local c = Color3.fromHSV((os.clock() * 0.25) % 1, 1, 1)
            if RGB.HL then HL.Color = c UpdateHighlight() end
            if RGB.Hat then Hat.Color = c UpdateHat() end
        end)
    end

    -- ================================= UI =================================
    -- ---- Camera View ----
    local View = Tab:CreateBlock({ Name = "Camera View", Side = "Left" })
    ThirdToggle = View:CreateToggle({ Name = "Third Person", Flag = "player.thirdperson", Keybind = true,
        Tooltip = "Force la vue à la troisième personne. Touche : clic sur l'icône de touche du toggle (3 par défaut).",
        Callback = SetThirdPerson })
    pcall(function() ThirdToggle:SetKey(Enum.KeyCode.Three) end)
    View:CreateToggle({ Name = "Camera Noclip", Flag = "player.cameranoclip",
        Tooltip = "La caméra traverse les murs au lieu de se coller dessus.",
        Callback = SetCameraNoclip })
    View:CreateDivider()
    View:CreateToggle({ Name = "Realistic First Person", Flag = "player.rfp",
        Tooltip = "Vraie vue à la première personne : on voit ses bras et ses jambes.",
        Callback = SetRFP })
    View:CreateSlider({ Name = "Limb Transparency", Min = 0, Max = 1, Default = 0.3, Step = 0.01, Rounding = 2, Flag = "player.rfp_transparency",
        Callback = function(v)
            RFP.Alpha = v
            if runtime.RealisticFirstPerson then ApplyRFP(RFP.Alpha) end
        end })

    -- ---- Sélecteur de couleur (CreateColorPicker de la bibliothèque) ----
    local function AddColor(block, label, default, flag, onColor)
        block:CreateColorPicker({ Name = label, Default = default, Flag = flag,
            Callback = function(c)
                if typeof(c) == "Color3" then onColor(c) end
            end })
    end

    -- ---- Highlight Your Character ----
    local HLBlock = Tab:CreateBlock({ Name = "Highlight Your Character", Side = "Right" })
    HLBlock:CreateToggle({ Name = "Highlight Your Character", Flag = "player.highlight_char",
        Tooltip = "Surbrillance (matériau ForceField) autour de ton avatar.",
        Risky = true, RiskyText = "Change le matériau de ton perso : les autres joueurs peuvent le voir.",
        Callback = SetHighlight })
    local hlChosen = HL.Color
    AddColor(HLBlock, "Highlight Color", hlChosen, "player.highlight_color", function(c)
        hlChosen = c
        if not RGB.HL then HL.Color = c UpdateHighlight() end
    end)
    HLBlock:CreateToggle({ Name = "RGB Highlight", Flag = "player.highlight_rgb", Callback = function(on)
        RGB.HL = on
        UpdateRainbow()
        if not on then HL.Color = hlChosen UpdateHighlight() end
    end })
    HLBlock:CreateToggle({ Name = "Affect China Hat", Default = true, Flag = "player.highlight_hat",
        Callback = function(on) HL.AffectHat = on UpdateHat() end })

    -- ---- China Hat ----
    local HatBlock = Tab:CreateBlock({ Name = "China Hat", Side = "Right" })
    HatBlock:CreateToggle({ Name = "China Hat", Flag = "player.chinahat",
        Tooltip = "Chapeau purement cosmétique au-dessus de ta tête.",
        Callback = SetHat })
    local hatChosen = Hat.Color
    AddColor(HatBlock, "Hat Color", hatChosen, "player.chinahat_color", function(c)
        hatChosen = c
        if not RGB.Hat then Hat.Color = c UpdateHat() end
    end)
    HatBlock:CreateToggle({ Name = "RGB China Hat", Flag = "player.chinahat_rgb", Callback = function(on)
        RGB.Hat = on
        UpdateRainbow()
        if not on then Hat.Color = hatChosen UpdateHat() end
    end })

    -- remet tout comme avant à la fermeture du script
    OnCleanup(function()
        RGB.HL, RGB.Hat = false, false
        pcall(SetCameraNoclip, false)
        pcall(SetRFP, false)
        pcall(SetHighlight, false)
        pcall(SetHat, false)
        for _, c in pairs(runtime) do pcall(function() c:Disconnect() end) end
        table.clear(runtime)
        if TP.Orig then
            pcall(function()
                LP.CameraMode = TP.Orig.Mode
                LP.CameraMaxZoomDistance = TP.Orig.Max
                LP.CameraMinZoomDistance = TP.Orig.Min
            end)
        end
    end)
end)

-- ───── ONGLET  Player — Create Forms (porté de « Coconut Forms » de Resonance) ─────
-- Des noix de coco (toy FoodCoconut) forment des ailes / une cape / un « 67 » autour de ton perso.
-- Visible par les autres joueurs (ce sont de vrais toys), transparence locale réglable.
Feature("Create Forms", function(F)
    local RS, RunService, LP, Workspace = F.RS, F.RunService, F.LP, F.Workspace
    local Tab = F.Tabs.Player
    local ICON = "rbxassetid://14189347195"
    local runId = _G.INVINCIBLE_RunId
    local function alive() return _G.INVINCIBLE_RunId == runId end

    local function Char()
        local char = LP.Character
        if not char or not char.Parent then return end
        local root = char:FindFirstChild("realHrp") or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if root and root.Parent and hum and hum.Parent then return char, root, hum end
    end

    -- ---------------- remotes du jeu ----------------
    local function remote(folder, name)
        local f = RS:WaitForChild(folder, 0.5)
        return f and f:WaitForChild(name, 0.5)
    end
    local R = {
        Spawn = remote("MenuToys", "SpawnToyRemoteFunction"),
        Destroy = remote("MenuToys", "DestroyToy"),
        SetOwner = remote("GrabEvents", "SetNetworkOwner"),
    }
    if not (R.Spawn and R.Destroy and R.SetOwner) then
        error("remotes du jeu introuvables (Create Forms ne marche pas dans ce jeu)")
    end

    -- ---------------- état ----------------
    local Z = {
        On = false, Form = "Wings", Transparency = 0.5,
        WingSpacing = 1.1, Spacing67 = 0.4, Display67 = "Show to Back", CapeMode = "4x3",
        Limit = 13,
        Counts = { Wings = 12, Cape = 12, ["67"] = 13 },
        Points67 = {
            Vector2.new(-1.75, 1.65), Vector2.new(-0.65, 1.65), Vector2.new(-1.75, 0.55), Vector2.new(-1.75, -0.55),
            Vector2.new(-0.65, -0.55), Vector2.new(-1.75, -1.65), Vector2.new(-0.65, -1.65), Vector2.new(0.5, 1.65),
            Vector2.new(1.6, 1.65), Vector2.new(2.7, 1.65), Vector2.new(2.15, 0.55), Vector2.new(1.6, -0.55),
            Vector2.new(1.05, -1.65),
        },
        Offsets = {}, Models = {}, Parts = {}, Acquiring = {}, WingRipple = {},
        WingStart = nil, CapeStart = nil,
        WingPhase = 0, WingSpeed = 1.4, WingClock = nil,
        CapePhase = 0, CapeSpeed = 0, CapeWind = Vector3.zero,
        Generation = 0, Spawning = false,
    }
    local STOP_WHITELIST = { ["180426354"] = true, ["168268306"] = true }   -- animations à ne pas couper

    -- ---------------- utilitaires toys ----------------
    local function IsPartOwner(part)
        if not (part and part:IsA("BasePart")) then return false end
        local po = part:FindFirstChild("PartOwner")
        if po then return po.Value == LP.Name end
        local m = part.Parent and part.Parent:FindFirstChild("PartOwner", true)
        return m ~= nil and m.Value == LP.Name
    end

    local velCache = setmetatable({}, { __mode = "k" })
    local function CustomVelocity(part)   -- vitesse lissée (la vitesse physique d'un toy tenu n'est pas fiable)
        local now, pos = os.clock(), part.Position
        local rec = velCache[part]
        if not rec then
            velCache[part] = { Position = pos, Time = now, Linear = Vector3.zero }
            return Vector3.zero
        end
        local dt = now - rec.Time
        if dt < 0.001 then return rec.Linear end
        local v = (pos - rec.Position) / dt
        if dt > 0.25 or v.Magnitude > 300 then
            rec.Linear = Vector3.zero
        else
            rec.Linear = rec.Linear:Lerp(v, 1 - math.exp(-dt * 40))
            if rec.Linear.Magnitude < 0.05 then rec.Linear = Vector3.zero end
        end
        rec.Position, rec.Time = pos, now
        return rec.Linear
    end

    local function DestroyToy(model)
        if model and model:IsA("Model") then pcall(function() R.Destroy:FireServer(model) end) end
    end

    local function GrabPart(part)   -- demande la propriété réseau du toy
        local _, root, hum = Char()
        if not root or hum.Health <= 0 or not part or not part.Parent then return end
        local from = (root.CFrame * CFrame.new(0, 1.593, 0)).Position
        pcall(function() R.SetOwner:FireServer(part, CFrame.new(from, part.Position)) end)
    end
    local function TakeOwnership(part, timeout)
        if IsPartOwner(part) then return true end
        local t0 = tick()
        while alive() and part.Parent and not IsPartOwner(part) and tick() - t0 < (timeout or 0.65) do
            RunService.Heartbeat:Wait()
            GrabPart(part)
        end
        return IsPartOwner(part)
    end

    -- fait « lâcher » le toy par le système de prise du jeu pour que sa soudure à la main disparaisse
    local function BreakHoldable(model)
        local char, _, hum = Char()
        local arm = char and char:FindFirstChild("Left Arm")
        local grip = arm and arm:FindFirstChild("LeftGripAttachment")
        local holdPart = model and model:FindFirstChild("HoldPart")
        local holdFn = holdPart and holdPart:WaitForChild("HoldItemRemoteFunction", 0.45)
        local dropFn = holdFn and holdPart:WaitForChild("DropItemRemoteFunction", 0.45)
        local rigid = dropFn and holdPart:WaitForChild("RigidConstraint", 0.45)
        if not (char and hum and grip and holdFn and dropFn and rigid) then return false end

        local t0 = tick()
        while char.Parent and model.Parent and grip.Parent and rigid.Parent and rigid.Attachment1 ~= grip and tick() - t0 < 0.6 do
            task.spawn(function() pcall(holdFn.InvokeServer, holdFn, model, char) end)
            task.wait()
        end
        if rigid.Attachment1 ~= grip then return false end

        task.spawn(function() pcall(dropFn.InvokeServer, dropFn, model) end)
        dropFn:Destroy()
        local t1 = tick()
        while rigid.Parent and rigid.Attachment1 == grip and tick() - t1 <= 0.45 do
            RunService.Heartbeat:Wait()
        end
        local animator = hum:FindFirstChildOfClass("Animator")
        for _, track in ipairs(animator and animator:GetPlayingAnimationTracks() or hum:GetPlayingAnimationTracks()) do
            local id = track.Animation and track.Animation.AnimationId:match("%d+")
            if not (id and STOP_WHITELIST[id]) then track:Stop() end
        end
        return rigid.Parent ~= nil and rigid.Attachment1 ~= grip
    end

    -- fait apparaître un FoodCoconut dans l'inventaire de toys ; nil si échec
    local lastFail = 0
    local spawnLock = false
    local function SpawnCoconut()
        if spawnLock or tick() - lastFail < 2 then return end
        local inv = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
        local _, root = Char()
        if not inv or not root then return end
        local inPlot, owned = LP:FindFirstChild("InPlot"), LP:FindFirstChild("InOwnedPlot")
        if inPlot and owned and inPlot.Value and not owned.Value then return end   -- plot d'un autre joueur
        spawnLock = true
        local can = LP:FindFirstChild("CanSpawnToy")
        if can and can.Value == false then
            local t0 = tick()
            repeat task.wait() until can.Value or tick() - t0 > 3 or not alive()
        end
        local found
        local conn = inv.ChildAdded:Connect(function(child) if child.Name == "FoodCoconut" then found = child end end)
        local at = CFrame.new((root.CFrame + Vector3.new(0, 15, 0)).Position) + Vector3.new(0, 0, 20)
        local orient = Workspace:FindFirstChild("RotateOrientPart")
        local rot = orient and orient.Rotation or Vector3.zero
        task.spawn(function() pcall(function() R.Spawn:InvokeServer("FoodCoconut", at, rot) end) end)
        local t0 = tick()
        while not found and tick() - t0 < 1.3 and alive() do RunService.Heartbeat:Wait() end
        conn:Disconnect()
        if not found then lastFail = tick() end
        spawnLock = false
        return found
    end

    -- ---------------- disposition ----------------
    local function Refresh()
        local offsets = {}
        Z.WingStart, Z.CapeStart = nil, nil
        Z.Counts.Cape = Z.CapeMode == "2x3" and 6 or 12
        local form = Z.Form
        if Z.Counts[form] and Z.Counts[form] <= Z.Limit then
            if form == "Wings" then
                Z.WingStart = 1
                for _ = 1, 12 do offsets[#offsets + 1] = CFrame.identity end
            elseif form == "Cape" then
                Z.CapeStart = 1
                local perRow = Z.Counts.Cape / 3
                for i = 0, Z.Counts.Cape - 1 do
                    local x = i % perRow - (perRow - 1) / 2
                    offsets[#offsets + 1] = i < perRow and (CFrame.new(x * 1.3, 0.55, 0.55) * CFrame.Angles(0.1, 0, 0)) or CFrame.identity
                end
            elseif form == "67" then
                local flip = Z.Display67 == "Show to Front" and -1 or 1
                for k, p in ipairs(Z.Points67) do
                    local side = k <= 7 and -1 or 1
                    offsets[#offsets + 1] = CFrame.new((p.X + side * Z.Spacing67 * 0.5) * flip, p.Y, 0.75)
                end
            end
        end
        if not Z.CapeStart then
            Z.CapeSpeed = 0
            Z.CapeWind = Vector3.zero
        end
        Z.Offsets = offsets
        Z.Generation += 1
        for i = #Z.Models, #offsets + 1, -1 do
            local m = table.remove(Z.Models, i)
            Z.Parts[m] = nil
            DestroyToy(m)
        end
    end

    local function SpawnMissing()
        if Z.Spawning or not Z.On or #Z.Models >= #Z.Offsets then return end
        Z.Spawning = true
        local gen = Z.Generation
        task.spawn(function()
            while alive() and Z.On and gen == Z.Generation and #Z.Models < #Z.Offsets do
                local coco = SpawnCoconut()
                local sound = coco and coco:WaitForChild("SoundPart", 0.5)
                local hold = coco and coco:WaitForChild("HoldPart", 0.5)
                local rigid = hold and hold:WaitForChild("RigidConstraint", 0.5)
                if not (sound and rigid and BreakHoldable(coco) and TakeOwnership(sound, 0.4)) then
                    DestroyToy(coco)
                    break
                end
                for _, d in ipairs(coco:GetDescendants()) do
                    if d:IsA("BasePart") then
                        d.CanCollide, d.CanQuery, d.CanTouch = false, false, false
                        d.LocalTransparencyModifier = Z.Transparency
                    end
                end
                if Z.On and gen == Z.Generation and #Z.Models < #Z.Offsets then
                    Z.Parts[coco] = { Root = sound, Rigid = rigid }
                    Z.Models[#Z.Models + 1] = coco
                    _TrackItem("FoodCoconut")
                else
                    DestroyToy(coco)
                end
            end
            Z.Spawning = false
            if alive() and Z.On and #Z.Models < #Z.Offsets then task.delay(0.5, SpawnMissing) end
        end)
    end

    -- ---------------- animation (ailes qui battent, cape qui flotte) ----------------
    local conn
    local function Update()
        local char, root, hum = Char()
        if not (root and hum and hum.Health > 0) then return end
        local flight = root:FindFirstChildOfClass("BodyVelocity") ~= nil and root:FindFirstChildOfClass("BodyGyro") ~= nil
        local now = os.clock()
        local dt = math.min(now - (Z.WingClock or now), 0.1)
        Z.WingClock = now

        Z.WingSpeed += ((flight and 7.5 or 1.4) - Z.WingSpeed) * math.min(dt * 5, 1)
        Z.WingPhase += dt * Z.WingSpeed
        local wp = Z.WingStart and Z.WingPhase
        local flap
        if wp then
            flap = flight and (-0.08 + math.sin(wp) * 0.52 + math.sin(wp * 2 - 0.6) * 0.07) or (-0.3 + math.sin(wp) * 0.06)
        end

        local base = (char:FindFirstChild("Torso") or root).CFrame
        local leftWing, rightWing
        if wp then
            local anchor = base * CFrame.new(0, 0.5, 0.55)
            local pitch = flight and -0.12 or 0
            leftWing = anchor * CFrame.Angles(pitch, 0, -flap)
            rightWing = anchor * CFrame.Angles(pitch, 0, flap)
            for i = 1, 6 do
                Z.WingRipple[i] = math.sin(wp - (i - 1) * (flight and 0.22 or 0.35)) * (flight and 0.18 or 0.035)
            end
        end

        local capeSpeedTarget = 0
        local wind = Vector3.zero
        if Z.CapeStart then
            local v = CustomVelocity(root)
            if not flight and hum.MoveDirection.Magnitude > 0.01 then
                local md = hum.MoveDirection * hum.WalkSpeed
                v = v:Lerp(Vector3.new(md.X, v.Y, md.Z), 0.45)
            end
            local lv = base:VectorToObjectSpace(v)
            local flat = Vector3.new(lv.X, 0, lv.Z).Magnitude
            local sway = math.sin(now * 0.72) + math.sin(now * 1.31 + 0.8) * 0.45
            capeSpeedTarget = lv.Magnitude
            local idle = Vector3.new(sway * 0.18, 0.08 + math.sin(now * 0.58 + 1.4) * 0.06, 0.38 + sway * 0.14)
            local x = math.clamp(-lv.X * 0.05, -2.25, 2.25)
            local y = math.clamp(flat * (flight and 0.045 or 0.018) - lv.Y * 0.025 + (flight and 0.55 or 0), -0.9, flight and 2.8 or 1.3)
            local z = math.clamp(-lv.Z * 0.06 + flat * 0.015 + (flight and 0.8 or 0), -0.15, flight and 5 or 3.5)
            wind = idle + Vector3.new(x, y, z)
        end
        Z.CapeSpeed += (capeSpeedTarget - Z.CapeSpeed) * math.min(dt * 8, 1)
        if Z.CapeStart then Z.CapePhase += dt * (2.2 + math.min(Z.CapeSpeed * 0.055, 5)) end
        Z.CapeWind = Z.CapeWind:Lerp(wind, math.min(dt * (flight and 12 or 10), 1))
        local rows = Z.Counts.Cape / 3
        local amp = 0.09 + math.min(Z.CapeSpeed * 0.004, 0.28) + (flight and 0.1 or 0)
        local slow = now * 1.17

        for i = #Z.Models, 1, -1 do
            local model = Z.Models[i]
            local rec = Z.Parts[model]
            local part, rigid = rec and rec.Root, rec and rec.Rigid
            if not (model.Parent and part and part.Parent and rigid and rigid.Parent) or rigid.Attachment1 then
                if model and model.Parent then DestroyToy(model) end
                Z.Parts[model] = nil
                table.remove(Z.Models, i)
            elseif IsPartOwner(part) then
                local off, frame = Z.Offsets[i], base
                if wp and i >= Z.WingStart and i < Z.WingStart + 12 then
                    local k = i - Z.WingStart
                    local side = k < 6 and -1 or 1
                    local n = k % 6 + 1
                    local spread = (n - 1) * Z.WingSpacing
                    local rip = Z.WingRipple[n]
                    frame = side == -1 and leftWing or rightWing
                    off = CFrame.new(side * (0.55 + spread), 0.05 - spread / 1.1 * (flight and 0.1 or 0.16) + rip, spread / 1.1 * 0.06 + rip * 0.35)
                        * CFrame.Angles(rip * 0.6, side * (flight and -0.1 or -0.18), side * (rip * 0.8 - 0.1))
                elseif Z.CapeStart and i >= Z.CapeStart + rows and i < Z.CapeStart + Z.Counts.Cape then
                    local k = i - Z.CapeStart
                    local col = k % rows - (rows - 1) / 2
                    local row = math.floor(k / rows)
                    local depth = row / 2
                    local w = Z.CapeWind * depth
                    local wave = (math.sin(Z.CapePhase - row * 0.9 + col * 0.48) + math.sin(slow + row * 0.55 - col * 0.75) * 0.45) * amp * depth
                    local roll = -w.X * 0.14 + col * wave * 0.06
                    off = CFrame.new(col * (1.3 + row * 0.12) + w.X, 0.55 - row * 1.65 + w.Y + wave * 0.28, 0.55 + depth * 0.65 + w.Z + wave + math.abs(col) * 0.08 * depth)
                        * CFrame.Angles(0.1 + depth * 0.18 + math.clamp(-w.Y * 0.16 + wave * 0.3, -0.65, 0.65), math.clamp(col * wave * 0.08, -0.18, 0.18), math.clamp(roll, -0.5, 0.5))
                end
                local target = frame * off
                if part.CFrame ~= target then part.CFrame = target end
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            elseif not Z.Acquiring[part] then
                Z.Acquiring[part] = true
                task.spawn(function()
                    TakeOwnership(part, 0.25)
                    Z.Acquiring[part] = nil
                end)
            end
        end
        if #Z.Models < #Z.Offsets then SpawnMissing() end
    end

    local function Clear()
        Z.On = false
        Z.Generation += 1
        if conn then conn:Disconnect() conn = nil end
        for _, m in ipairs(Z.Models) do DestroyToy(m) end
        table.clear(Z.Models)
        table.clear(Z.Parts)
        table.clear(Z.WingRipple)
        table.clear(Z.Acquiring)
    end
    local function SetForms(on)
        if on == Z.On then return end
        if not on then Clear() return end
        Z.On = true
        Refresh()
        if not conn then conn = _TrackConn(RunService.Heartbeat:Connect(Update)) end
        SpawnMissing()
    end

    -- ---------------- UI ----------------
    local Main = Tab:CreateBlock({ Name = "Create Forms", Side = "Left", ImageID = ICON })
    Main:CreateToggle({ Name = "Create Forms", Flag = "player.forms",
        Tooltip = "Des noix de coco forment la forme choisie autour de ton perso (toys visibles par tous).",
        Risky = true, RiskyText = "Fait apparaître des toys visibles par tout le monde.",
        Callback = SetForms })
    local FormDropdown = Main:CreateDropdown({ Name = "Form", Items = { "Wings", "Cape", "67" }, Default = "Wings", Flag = "player.forms_choice",
        Callback = function(v)
            if Z.Counts[v] then Z.Form = v if Z.On then Refresh() SpawnMissing() end end
        end })
    Main:CreateSlider({ Name = "Transparency", Min = 0, Max = 1, Default = 0.5, Step = 0.01, Rounding = 2, Flag = "player.forms_transparency",
        Callback = function(v)
            Z.Transparency = v
            for _, m in ipairs(Z.Models) do
                for _, d in ipairs(m:GetDescendants()) do
                    if d:IsA("BasePart") then d.LocalTransparencyModifier = Z.Transparency end
                end
            end
        end })

    local Opt = Tab:CreateBlock({ Name = "Forms Settings", Side = "Left", ImageID = ICON })
    Opt:CreateSlider({ Name = "Wings Spacing", Min = 0.9, Max = 3, Default = 1.1, Step = 0.01, Rounding = 2, Flag = "player.forms_wingspacing",
        ShowIf = { Item = FormDropdown, Equals = "Wings" },
        Callback = function(v) Z.WingSpacing = v end })
    Opt:CreateDropdown({ Name = "Cape Layout", Items = { "2x3", "4x3" }, Default = "4x3", Flag = "player.forms_cape",
        ShowIf = { Item = FormDropdown, Equals = "Cape" },
        Callback = function(v)
            Z.CapeMode = v
            if Z.On then Refresh() SpawnMissing() end
        end })
    Opt:CreateSlider({ Name = "67 Spacing", Min = 0, Max = 3, Default = 0.4, Step = 0.01, Rounding = 2, Flag = "player.forms_spacing67",
        ShowIf = { Item = FormDropdown, Equals = "67" },
        Callback = function(v) Z.Spacing67 = v if Z.On and Z.Form == "67" then Refresh() end end })
    Opt:CreateDropdown({ Name = "67 Display", Items = { "Show to Back", "Show to Front" }, Default = "Show to Back", Flag = "player.forms_display67",
        ShowIf = { Item = FormDropdown, Equals = "67" },
        Callback = function(v) Z.Display67 = v if Z.On and Z.Form == "67" then Refresh() end end })
    Opt:CreateLabel({ Text = "13 noix de coco maximum à la fois." })

    OnCleanup(function() pcall(Clear) end)
end)

-- ████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████
-- ██  BLOC 3 — FIN
-- ██  Modèle pour ajouter une feature + notification finale
-- ████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████

-- ───── 3.1  MODÈLE POUR AJOUTER UNE FEATURE ────────────────────────────────
-- À copier dans le BLOC 2, sous l'onglet voulu (pas ici) :
--
-- Feature("Exemple", function(F)
--     local bloc = F.Tabs.Player:CreateBlock({ Name = "Exemple", Side = "Left" })
--     bloc:CreateToggle({ Name = "Option", Flag = "ex.option", Callback = function(on) print(on) end })
-- end)

-- ───── 3.2  NOTIFICATION FINALE ────────────────────────────────────────────
Library:Notify({
    Title = "INVINCIBLE", Content = "Prêt — RightShift pour ouvrir / fermer l'interface.",
    Duration = 4, Type = "Info",
})
