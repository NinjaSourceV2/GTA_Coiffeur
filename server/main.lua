--||@SuperCoolNinja.||--


--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '1.7'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_Coiffeur/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_Coiffeur]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

RegisterServerEvent("GTA_Coiffeur:GetPlayerSexe")
AddEventHandler("GTA_Coiffeur:GetPlayerSexe", function()
	local source = source
	local license = GetPlayerIdentifiers(source)[1]

    MySQL.Async.fetchAll("SELECT data_personnage FROM gta_joueurs_humain WHERE license = @username", {['@username'] = license}, function(res)
		if (res) then
			local decodeData = json.decode(res[1].data_personnage)
	        TriggerClientEvent("GTA_Coiffeur:GetSexPlayer", source, decodeData["sex"])
		end
	end)
end)


RegisterServerEvent("GTA_Coiffeur:NouvelCoupe")
AddEventHandler("GTA_Coiffeur:NouvelCoupe", function(drawID, prix)
    prix = prix or 0
    local source = source	
    local player = GetPlayerIdentifiers(source)[1]
    TriggerEvent('GTA_Inventaire:GetItemQty', source, "cash", function(qtyItem, itemid)
        if (qtyItem >= prix) then 
            print(drawID)
            MySQL.Async.execute('UPDATE gta_joueurs_humain SET data_personnage = JSON_REPLACE(data_personnage, "$.cheveux", '..drawID..') WHERE license = @license;', {['@license'] = player})
            TriggerClientEvent('GTA_Inventaire:RetirerItem', source, "cash", tonumber(prix))
            TriggerClientEvent("GTAO:NotificationIcon", source, "CHAR_BANK_MAZE", "Maze Bank", "Paiement accepté !", "")
        else
            TriggerClientEvent("GTA_NUI_ShowNotif_client", source, "Paiement refusé !", "warning", "fa fa-exclamation-circle fa-2x", "row", "warning")
        end
        TriggerClientEvent("GTA_Coiffeur:LoadOldCoiffure", source)
    end)
end)

RegisterServerEvent("GTA_Coiffeur:NouvelCouleur")
AddEventHandler("GTA_Coiffeur:NouvelCouleur", function(drawID, prix)
    prix = prix or 0
    local source = source	
    local player = GetPlayerIdentifiers(source)[1]
    TriggerEvent('GTA_Inventaire:GetItemQty', source, "cash", function(qtyItem, itemid)
        if (qtyItem >= prix) then 
            TriggerClientEvent('GTA_Inventaire:RetirerItem', source, "cash", tonumber(prix))
            TriggerClientEvent("GTA_NUI_ShowNotif_client", source, "Paiement accepté !", "success", "fa fa-check fa-2x","row", "success")
            MySQL.Async.execute('UPDATE gta_joueurs_humain SET data_personnage = JSON_REPLACE(data_personnage, "$.couleur_cheveux", '..drawID..') WHERE license = @license;', {['@license'] = player})
        else
            TriggerClientEvent("GTA_NUI_ShowNotif_client", source, "Paiement refusé !", "warning", "fa fa-exclamation-circle fa-2x","row", "warning")
        end
        TriggerClientEvent("GTA_Coiffeur:LoadOldCoiffure", source)
    end)
end)

RegisterServerEvent("GTA_Coiffeur:LoadCoupeCheveux")
AddEventHandler("GTA_Coiffeur:LoadCoupeCheveux",function()
	local source = source
	local license = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll("SELECT data_personnage FROM gta_joueurs_humain WHERE license = @license", { ['@license'] = license}, function(res2)
		local decodeData = json.decode(res2[1].data_personnage)
		TriggerClientEvent("GTA_Coiffeur:UpdateCheveux", source, decodeData)
	end)
end)