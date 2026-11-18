--[[
	ThemeManager  —  Ui-Lib Simple
	Gestion des thèmes (présets, couleurs en direct, police, thèmes perso, import / export).

	Utilisation
		local Library      = loadstring(game:HttpGet(REPO .. "Ui-Lib-Simple.lua"))()
		local ThemeManager = loadstring(game:HttpGet(REPO .. "ThemeManager.lua"))()

		ThemeManager:SetLibrary(Library)
		local Window = Library:CreateWindow({ ... })
		local Tab    = Window:CreateTab("Paramètres")

		ThemeManager:ApplyToTab(Tab)            -- crée 2 blocs : « Thème » (gauche) et « Thèmes perso » (droite)
		-- ou : ThemeManager:ApplyToBlock(bloc) -- tout dans un seul bloc que tu as déjà créé

	API
		ThemeManager:SetLibrary(Library)
		ThemeManager:SetDefaultTheme("Océan" | { Main, Second, Accent, Text, ElementAccent })
			-> thème utilisé au lancement tant que l'utilisateur n'en a pas choisi un autre (à appeler AVANT ApplyToTab)
		ThemeManager:ApplyTheme(nom)            -- préset OU thème perso
		ThemeManager:GetPresets() / GetCustomThemes()
		ThemeManager:GetDefault() / SaveDefault(nom) / ResetDefault() / LoadDefault()
		ThemeManager:ApplyToTab(tab, sideA, sideB)  ·  ThemeManager:ApplyToBlock(block)

	Les couleurs utilisent les flags « ui.* » de la lib : elles sont donc sauvegardées automatiquement
	(<ConfigFolder>/_settings.json). N'utilise pas ce module en même temps que Window:CreateSettingsTab.
]]

local ThemeManager = {}
ThemeManager.Library = nil
ThemeManager.DefaultTheme = nil          -- nom de préset ou table de couleurs
ThemeManager.AppliedToTab = false

-- Ordre d'affichage des présets (les autres présets de la lib sont ajoutés ensuite, par ordre alphabétique)
ThemeManager.Order = { "Trou noir", "Océan", "Violet", "Violet rétro", "Rouge sang", "Émeraude", "Or", "Sakura", "Clair" }

-- Champs de couleur : { clé dans la lib, flag, libellé }
local COLORS = {
	{ "Accent",        "ui.accent",   "Accent" },
	{ "Main",          "ui.c.main",   "Fond" },
	{ "Second",        "ui.c.second", "Panneaux" },
	{ "Text",          "ui.c.text",   "Texte" },
	{ "ElementAccent", "ui.c.text2",  "Texte secondaire" },
}

--// Utilitaires \\--
local function safeName(n)
	local s = tostring(n or "")
	s = s:gsub("[^%w%-_ ]", ""):gsub("^%s+", ""):gsub("%s+$", "")
	return s
end

local function lib(self)
	assert(self.Library, "ThemeManager : appelle d'abord ThemeManager:SetLibrary(Library)")
	return self.Library
end

local function notify(self, ok, okMsg, errMsg)
	lib(self):Notify({
		Title = "Thèmes",
		Content = ok and okMsg or errMsg,
		Type = ok and "Success" or "Error",
		Duration = 3,
	})
end

function ThemeManager:SetLibrary(library)
	self.Library = library
end

--// Liste des thèmes \\--
function ThemeManager:GetPresets()
	local L, out, seen = lib(self), {}, {}
	for _, name in ipairs(self.Order) do
		if L.Presets[name] then out[#out + 1] = name seen[name] = true end
	end
	local rest = {}
	for name in pairs(L.Presets) do
		if not seen[name] then rest[#rest + 1] = name end
	end
	table.sort(rest)
	for _, name in ipairs(rest) do out[#out + 1] = name end
	return out
end

function ThemeManager:GetCustomThemes()
	return lib(self):ListThemes()
end

--// Appliquer \\--
function ThemeManager:ApplyTheme(name)
	local L = lib(self)
	if L.Presets[name] then
		return L:ApplyPreset(name)
	end
	return L:LoadTheme(name)
end

--// Thème par défaut (fichier <ConfigFolder>/Themes/_default.txt) \\--
local function defaultPath(self)
	return lib(self).ConfigFolder .. "/Themes/_default.txt"
end

function ThemeManager:GetDefault()
	local name
	pcall(function()
		if isfile and readfile and isfile(defaultPath(self)) then name = safeName(readfile(defaultPath(self))) end
	end)
	if name == "" then name = nil end
	return name
end

function ThemeManager:SaveDefault(name)
	name = safeName(name)
	if name == "" then return false, "nom vide" end
	local L = lib(self)
	local ok, err = pcall(function()
		if makefolder and isfolder then
			if not isfolder(L.ConfigFolder) then makefolder(L.ConfigFolder) end
			if not isfolder(L.ConfigFolder .. "/Themes") then makefolder(L.ConfigFolder .. "/Themes") end
		end
		writefile(defaultPath(self), name)
	end)
	return ok, err
end

function ThemeManager:ResetDefault()
	return (pcall(function()
		if delfile and isfile and isfile(defaultPath(self)) then delfile(defaultPath(self)) end
	end))
end

function ThemeManager:SetDefaultTheme(theme)
	assert(not self.AppliedToTab, "ThemeManager : SetDefaultTheme doit être appelé avant ApplyToTab")
	self.DefaultTheme = theme
end

-- Applique le thème enregistré par l'utilisateur, sinon le thème par défaut du script (s'il y en a un)
function ThemeManager:LoadDefault()
	local L = lib(self)
	local name = self:GetDefault()
	if name and (L.Presets[name] or table.find(self:GetCustomThemes(), name)) then
		self:ApplyTheme(name)
	elseif type(self.DefaultTheme) == "string" and L.Presets[self.DefaultTheme] then
		L:ApplyPreset(self.DefaultTheme)
	elseif type(self.DefaultTheme) == "table" then
		L:ApplyTheme({ Colors = self.DefaultTheme })
	end
end

--// Interface \\--
-- Bloc 1 : présets, couleurs, police
local function buildMain(self, blk)
	local L = lib(self)

	blk:CreateSection("Thème")
	local presets = blk:CreateDropdown({
		Name = "Préset", Items = self:GetPresets(), Search = false, Favorite = false,
		Callback = function(name)
			if name and name ~= "" then self:ApplyTheme(name) end
		end,
	})
	blk:CreateButton({ Name = "Définir comme thème par défaut", Favorite = false, Callback = function()
		local name = presets.Get()
		if not name or name == "" then
			notify(self, false, "", "Choisis d'abord un préset.")
			return
		end
		local ok, err = self:SaveDefault(name)
		notify(self, ok, ("Thème par défaut : %s"):format(name), "Échec : " .. tostring(err))
	end })

	blk:CreateSection("Couleurs")
	local T = L.GetTheme and L:GetTheme().Colors or {}
	for _, c in ipairs(COLORS) do
		local key, flag, label = c[1], c[2], c[3]
		blk:CreateColorPicker({
			Name = label, Flag = flag, Opacity = false, Favorite = false,
			Default = (T[key] and Color3.fromHex((T[key]:gsub("#", "")))) or Color3.new(1, 1, 1),
			Callback = function(color) L:SetColor(key, color) end,
		})
	end

	blk:CreateSection("Police")
	blk:CreateDropdown({
		Name = "Police", Flag = "ui.fontfamily", Items = L.FontFamilies, Search = false, Favorite = false,
		Default = L.FontFamily or "Gotham",
		Callback = function(name) L:SetFont(name) end,
	})

	blk:CreateButton({ Name = "Réinitialiser le thème", Confirm = true, Favorite = false, Callback = function()
		if L.DefaultTheme then L:ApplyTheme(L.DefaultTheme) end
		notify(self, true, "Thème d'origine restauré", "")
	end })
end

-- Bloc 2 : thèmes personnalisés + partage
local function buildCustom(self, blk)
	local L = lib(self)

	blk:CreateSection("Créer")
	local nameBox = blk:CreateInput({ Name = "Nom", Placeholder = "mon-theme", Favorite = false })
	blk:CreateButton({ Name = "Créer depuis l'apparence actuelle", Favorite = false, Callback = function()
		local name = safeName(nameBox.Get())
		if name == "" then notify(self, false, "", "Nom de thème vide.") return end
		local ok, err = L:SaveTheme(name)
		notify(self, ok, ("Thème créé : %s"):format(name), "Échec : " .. tostring(err))
		if ok then nameBox.Set("") end
	end })

	blk:CreateSection("Mes thèmes")
	local list = blk:CreateDropdown({
		Name = "Thèmes perso", Items = self:GetCustomThemes(), Favorite = false,
		UpdateList = function() return self:GetCustomThemes() end,
	})
	local function selected()
		local n = list.Get()
		if not n or n == "" then notify(self, false, "", "Choisis d'abord un thème perso.") return nil end
		return n
	end
	local function refresh() list.Refresh(self:GetCustomThemes(), true) end

	blk:CreateButton({ Name = "Charger", Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok, err = L:LoadTheme(n)
		notify(self, ok, ("Thème chargé : %s"):format(n), "Échec : " .. tostring(err))
	end })
	blk:CreateButton({ Name = "Écraser avec l'apparence actuelle", Confirm = true, Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok, err = L:SaveTheme(n)
		notify(self, ok, ("Thème mis à jour : %s"):format(n), "Échec : " .. tostring(err))
	end })
	blk:CreateButton({ Name = "Supprimer", Confirm = true, Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok = L:DeleteTheme(n)
		notify(self, ok, ("Thème supprimé : %s"):format(n), "Suppression impossible.")
		refresh()
	end })
	blk:CreateButton({ Name = "Actualiser la liste", Favorite = false, Callback = refresh })
	blk:CreateButton({ Name = "Définir comme thème par défaut", Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok, err = self:SaveDefault(n)
		notify(self, ok, ("Thème par défaut : %s"):format(n), "Échec : " .. tostring(err))
	end })
	blk:CreateButton({ Name = "Retirer le thème par défaut", Favorite = false, Callback = function()
		self:ResetDefault()
		notify(self, true, "Thème par défaut retiré", "")
	end })

	blk:CreateSection("Partage")
	local code = blk:CreateInput({ Name = "Code", Placeholder = "colle un code de thème ici", Favorite = false })
	blk:CreateButton({ Name = "Exporter (copie le code)", Favorite = false, Callback = function()
		local s = L:ExportTheme()
		code.Set(s)
		local copied = L:CopyText(s)
		notify(self, true, copied and "Code copié dans le presse-papiers." or "Presse-papiers indisponible : copie le code du champ.", "")
	end })
	blk:CreateButton({ Name = "Importer depuis le champ", Favorite = false, Callback = function()
		local ok, err = L:ImportTheme(code.Get())
		notify(self, ok, "Thème importé", "Échec : " .. tostring(err))
	end })
end

local function finish(self)
	self.AppliedToTab = true
	-- restaure les réglages sauvegardés (couleurs, police…) maintenant que les contrôles existent, puis le thème par défaut
	task.defer(function()
		pcall(function() self.Library:LoadSettings() end)
		pcall(function() self:LoadDefault() end)
	end)
end

--// Points d'entrée \\--
function ThemeManager:ApplyToTab(tab, sideMain, sideCustom)
	lib(self)
	buildMain(self, tab:CreateBlock({ Name = "Thème", Side = sideMain or "Left" }))
	buildCustom(self, tab:CreateBlock({ Name = "Thèmes perso", Side = sideCustom or "Left" }))
	finish(self)
end

function ThemeManager:ApplyToBlock(block)
	lib(self)
	buildMain(self, block)
	buildCustom(self, block)
	finish(self)
end

return ThemeManager
