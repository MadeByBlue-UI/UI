--[[
	SaveManager  —  Ui-Lib Simple
	Gestion des configurations (sauvegarder, charger, écraser, supprimer, auto-chargement, import / export).

	Utilisation
		local Library     = loadstring(game:HttpGet(REPO .. "Ui-Lib-Simple.lua"))()
		local SaveManager = loadstring(game:HttpGet(REPO .. "SaveManager.lua"))()

		SaveManager:SetLibrary(Library)
		SaveManager:SetIgnoreIndexes({ "MonFlagQuiNeSauvePas" })   -- facultatif
		local Window = Library:CreateWindow({ ConfigFolder = "MonScript", ... })
		local Tab    = Window:CreateTab("Paramètres")

		SaveManager:BuildConfigSection(Tab)        -- crée le bloc « Configuration » (ou : BuildConfigSection(Tab, "Left"))
		-- ou : SaveManager:BuildConfigBlock(bloc) -- dans un bloc que tu as déjà créé
		SaveManager:LoadAutoloadConfig()           -- à appeler une fois tous tes éléments créés

	Ce qui est enregistré : tous les éléments de ton script créés avec un « Flag ».
	Les réglages d'apparence (flags « ui.* ») ne sont PAS dans les configs : la lib les sauvegarde déjà toute seule
	(<ConfigFolder>/_settings.json). SaveManager.IgnoreUi = false pour les inclure quand même.

	API
		SaveManager:SetLibrary(Library)
		SaveManager:SetFolder(dossier)                 -- préfère CreateWindow({ ConfigFolder = ... })
		SaveManager:SetIgnoreIndexes({ "flag1", ... })
		SaveManager:List() -> { noms }
		SaveManager:Save(nom) / Load(nom) / Delete(nom)         -> ok, erreur
		SaveManager:GetAutoload() / SetAutoload(nom) / ResetAutoload() / LoadAutoloadConfig()
		SaveManager:Export() -> "UILIB-CONFIG:{...}"  ·  SaveManager:Import(texte)
]]

local HttpService = game:GetService("HttpService")

local SaveManager = {}
SaveManager.Library = nil
SaveManager.Ignore = {}        -- [flag] = true
SaveManager.IgnoreUi = true    -- ignorer les flags « ui.* » (apparence, déjà sauvegardée par la lib)

local PREFIX = "UILIB-CONFIG:"

--// Utilitaires \\--
local function safeName(n)
	local s = tostring(n or "")
	s = s:gsub("[^%w%-_ ]", ""):gsub("^%s+", ""):gsub("%s+$", "")
	return s
end

local function lib(self)
	assert(self.Library, "SaveManager : appelle d'abord SaveManager:SetLibrary(Library)")
	return self.Library
end

local function pathOf(self, name)
	return lib(self).ConfigFolder .. "/" .. name .. ".json"
end

local function ensureFolder(self)
	local folder = lib(self).ConfigFolder
	pcall(function()
		if makefolder and isfolder and not isfolder(folder) then makefolder(folder) end
	end)
end

function SaveManager:SetLibrary(library)
	self.Library = library
end

function SaveManager:SetFolder(folder)
	lib(self).ConfigFolder = folder
	ensureFolder(self)
end

function SaveManager:SetIgnoreIndexes(list)
	for _, flag in ipairs(list) do self.Ignore[flag] = true end
end

function SaveManager:IgnoreThemeSettings()
	self.IgnoreUi = true
end

-- Copie des flags à enregistrer / appliquer (sans les flags ignorés ni les valeurs non sérialisables)
function SaveManager:_filter(flags)
	local out = {}
	for flag, value in pairs(flags) do
		local base = tostring(flag):gsub("%.keys?$", "")   -- « x.key » / « x.keys » suivent le flag « x »
		local skip = self.Ignore[flag] or self.Ignore[base]
			or tostring(flag):sub(1, 2) == "__"
			or (self.IgnoreUi and tostring(flag):sub(1, 3) == "ui.")
		if not skip and pcall(HttpService.JSONEncode, HttpService, { v = value }) then
			out[flag] = value
		end
	end
	return out
end

-- Applique des flags déjà filtrés (en gardant la liste des changements de la lib quand elle existe)
function SaveManager:_apply(data, label)
	local L = lib(self)
	data = self:_filter(data)
	if L._applyFlags then
		L:_applyFlags(data, label)
	else
		for flag, value in pairs(data) do
			local item = L.Items[flag]
			if item and item.Set then pcall(item.Set, item, value) end
		end
	end
end

--// Configs \\--
function SaveManager:List()
	return lib(self):ListConfigs()
end

function SaveManager:Save(name)
	name = safeName(name)
	if name == "" then return false, "aucune config sélectionnée" end
	if not writefile then return false, "writefile indisponible" end
	ensureFolder(self)

	local ok, encoded = pcall(HttpService.JSONEncode, HttpService, self:_filter(lib(self).Flags))
	if not ok then return false, "échec de l'encodage" end

	local wrote, err = pcall(writefile, pathOf(self, name), encoded)
	if not wrote then return false, tostring(err) end
	return true
end

function SaveManager:Load(name)
	name = safeName(name)
	if name == "" then return false, "aucune config sélectionnée" end
	if not (readfile and isfile) then return false, "readfile indisponible" end
	if not isfile(pathOf(self, name)) then return false, "fichier introuvable" end

	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(pathOf(self, name))) end)
	if not ok or type(data) ~= "table" then return false, "fichier invalide" end

	self:_apply(data, name)
	return true
end

function SaveManager:Delete(name)
	name = safeName(name)
	if name == "" then return false, "aucune config sélectionnée" end
	if not lib(self):DeleteConfig(name) then return false, "suppression impossible" end
	return true
end

--// Auto-chargement \\--
function SaveManager:GetAutoload()
	return lib(self):GetAutoLoad()      -- nom ou nil
end

function SaveManager:SetAutoload(name)
	name = safeName(name)
	if name == "" then return false, "aucune config sélectionnée" end
	if not table.find(self:List(), name) then return false, "sauvegarde d'abord cette config" end
	lib(self):SetAutoLoad(name)
	return true
end

function SaveManager:ResetAutoload()
	lib(self):SetAutoLoad("")
	return true
end

-- La lib charge déjà l'auto-config ~1,2 s après CreateWindow ; cet appel le fait tout de suite, une seule fois.
function SaveManager:LoadAutoloadConfig()
	local L = lib(self)
	local name = L:GetAutoLoad()
	if not name or L._autoDone then return end
	L._autoDone = true
	local ok, err = self:Load(name)
	L:Notify({
		Title = "Config", Type = ok and "Success" or "Error", Duration = 3,
		Content = ok and ("Auto-chargée : " .. name) or ("Auto-chargement impossible : " .. tostring(err)),
	})
end

--// Partage \\--
function SaveManager:Export()
	return PREFIX .. HttpService:JSONEncode(self:_filter(lib(self).Flags))
end

function SaveManager:Import(text)
	text = tostring(text or ""):gsub("^%s+", ""):gsub("^" .. PREFIX:gsub("%-", "%%-"), ""):gsub("%s+$", "")
	local ok, data = pcall(HttpService.JSONDecode, HttpService, text)
	if not ok or type(data) ~= "table" then return false, "code invalide" end
	self:_apply(data, "import")
	return true
end

--// Interface \\--
function SaveManager:BuildConfigBlock(blk)
	local L = lib(self)

	local function toast(ok, okMsg, errMsg)
		L:Notify({ Title = "Config", Content = ok and okMsg or errMsg, Type = ok and "Success" or "Error", Duration = 3 })
	end

	blk:CreateSection("Fichier")
	local nameBox = blk:CreateInput({ Name = "Nom", Placeholder = "ma-config", Favorite = false })
	local list = blk:CreateDropdown({
		Name = "Configs", Items = self:List(), Favorite = false,
		UpdateList = function() return self:List() end,
	})
	local function refresh(clear) list.Refresh(self:List(), clear) end
	local function selected()
		local n = list.Get()
		if not n or n == "" then toast(false, "", "Choisis d'abord une config dans la liste.") return nil end
		return n
	end

	blk:CreateButton({ Name = "Créer", Favorite = false, Callback = function()
		local name = safeName(nameBox.Get())
		if name == "" then toast(false, "", "Nom de config vide.") return end
		local ok, err = self:Save(name)
		toast(ok, ("Config créée : %s"):format(name), "Échec : " .. tostring(err))
		if ok then nameBox.Set("") refresh(true) end
	end })
	blk:CreateButton({ Name = "Charger", Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok, err = self:Load(n)
		toast(ok, ("Config chargée : %s"):format(n), "Échec : " .. tostring(err))
	end })
	blk:CreateButton({ Name = "Écraser", Confirm = true, Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok, err = self:Save(n)
		toast(ok, ("Config écrasée : %s"):format(n), "Échec : " .. tostring(err))
	end })
	blk:CreateButton({ Name = "Supprimer", Confirm = true, Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok, err = self:Delete(n)
		toast(ok, ("Config supprimée : %s"):format(n), "Échec : " .. tostring(err))
		if ok then refresh(true) end
	end })
	blk:CreateButton({ Name = "Actualiser la liste", Favorite = false, Callback = function() refresh(true) end })

	blk:CreateSection("Démarrage")
	local info = blk:CreateParagraph({ Title = "Auto-chargement", Content = "" })
	local function showAutoload()
		local a = self:GetAutoload()
		info.Set({ Title = "Auto-chargement : " .. (a or "aucun"),
			Content = a and "Cette config s'applique toute seule à chaque lancement."
				or "Choisis une config, puis « Charger au lancement »." })
	end
	showAutoload()
	blk:CreateButton({ Name = "Charger au lancement", Favorite = false, Callback = function()
		local n = selected() if not n then return end
		local ok, err = self:SetAutoload(n)
		toast(ok, ("Auto-chargement : %s"):format(n), "Échec : " .. tostring(err))
		showAutoload()
	end })
	blk:CreateButton({ Name = "Désactiver l'auto-chargement", Favorite = false, Callback = function()
		self:ResetAutoload()
		toast(true, "Auto-chargement désactivé", "")
		showAutoload()
	end })

	blk:CreateSection("Partage")
	local code = blk:CreateInput({ Name = "Code", Placeholder = "colle un code de config ici", Favorite = false })
	blk:CreateButton({ Name = "Exporter (copie le code)", Favorite = false, Callback = function()
		local s = self:Export()
		code.Set(s)
		local copied = L:CopyText(s)
		toast(true, copied and "Code copié dans le presse-papiers." or "Presse-papiers indisponible : copie le code du champ.", "")
	end })
	blk:CreateButton({ Name = "Importer depuis le champ", Favorite = false, Callback = function()
		local ok, err = self:Import(code.Get())
		toast(ok, "Config importée", "Échec : " .. tostring(err))
	end })

	blk:CreateSection("Valeurs")
	blk:CreateButton({ Name = "Réinitialiser les options du script", Confirm = true, Favorite = false,
		Tooltip = "Remet chaque option du script à sa valeur de départ (l'apparence n'est pas touchée).",
		Callback = function()
			toast(true, L:ResetConfig(false) .. " options réinitialisées", "")
		end })
end

function SaveManager:BuildConfigSection(tab, side)
	lib(self)
	self:BuildConfigBlock(tab:CreateBlock({ Name = "Configuration", Side = side or "Right" }))
end

return SaveManager
