--||@SuperCoolNinja.||--


--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '1.4'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_Coiffeur/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_Coiffeur]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)


RegisterServerEvent("GTA_Coiffeur:NouvelCoupe")
AddEventHandler("GTA_Coiffeur:NouvelCoupe", function(drawID, prix)
    prix = prix or 0
    local source = source	
    local player = GetPlayerIdentifiers(source)[1]
    TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
        if (data.argent_propre >= prix) then 
            TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prix))
			TriggerClientEvent('nMenuNotif:showNotification', source, "Paiement accepté !")
            MySQL.Async.execute(
                "UPDATE gta_joueurs_humain SET cheveux=@drawID WHERE license=@license", {
                ['@license'] = player,
                ['@drawID'] = drawID
            })
        else
			TriggerClientEvent('nMenuNotif:showNotification', source, "Paiement refusé !")
        end
        TriggerClientEvent("GTA_Coiffeur:LoadOldCoiffure", source)
    end)
end)

RegisterServerEvent("GTA_Coiffeur:NouvelCouleur")
AddEventHandler("GTA_Coiffeur:NouvelCouleur", function(drawID, prix)
    prix = prix or 0
    local source = source	
    local player = GetPlayerIdentifiers(source)[1]
    TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
        if (data.argent_propre >= prix) then 
            TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prix))
			TriggerClientEvent('nMenuNotif:showNotification', source, "Paiement accepté !")
            MySQL.Async.execute(
                "UPDATE gta_joueurs_humain SET couleurCheveux=@drawID WHERE license=@license", {
                ['@license'] = player,
                ['@drawID'] = drawID
            })
        else
			TriggerClientEvent('nMenuNotif:showNotification', source, "Paiement refusé !")
        end
        TriggerClientEvent("GTA_Coiffeur:LoadOldCoiffure", source)
    end)
end)

RegisterServerEvent("GTA_Coiffeur:LoadCoupeCheveux")
AddEventHandler("GTA_Coiffeur:LoadCoupeCheveux",function()
	local source = source
	local license = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll("SELECT * FROM gta_joueurs_humain WHERE license = @license", { ['@license'] = license}, function(res2)
		TriggerClientEvent("GTA_Coiffeur:UpdateCheveux", source, res2[1].cheveux, res2[1].couleurCheveux)
	end)
end)