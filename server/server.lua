--||@SuperCoolNinja.||--

RegisterServerEvent("GTA:PayerCoupeCheveux")
AddEventHandler("GTA:PayerCoupeCheveux", function(cheveuxID, couleurs, prix) --: TODO--> Argument to update
	local source = source
	local license = GetPlayerIdentifiers(source)[1]
	TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
		local argentPropre = data.argent_propre
		if (tonumber(argentPropre) >= prix) then
			exports.ghmattimysql:execute("UPDATE gta_joueurs_humain SET cheveux=@cheveuxID WHERE license=@license", {['@license'] = license,['@cheveuxID'] = cheveuxID})
			TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prix))
			TriggerClientEvent("GTA:CoupePayer", source)
		else
			TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Tu n'as pas suffisamment d'argent !")
			TriggerClientEvent('GTA:ArgentManquante', source)
		end
	end)
end)

RegisterServerEvent("GTA:PayerCouleurCheveux")
AddEventHandler("GTA:PayerCouleurCheveux", function(couleurs, prix)--: TODO--> Argument id couleur to update
	local source = source
	local license = GetPlayerIdentifiers(source)[1]
	TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
		local argentPropre = data.argent_propre
		if (tonumber(argentPropre) >= prix) then
			exports.ghmattimysql:execute("UPDATE gta_joueurs_humain SET couleurCheveux=@couleurs WHERE license=@license", {['@license'] = license,['@couleurs'] = couleurs})
			
			TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prix))
			TriggerClientEvent("GTA:CouleurPayer", source)
		else
			TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Tu n'as pas suffisamment d'argent !")
			TriggerClientEvent('GTA:ArgentManquante', source)
		end
	end)
end)

RegisterServerEvent("GTA:CoupeDefault")
AddEventHandler("GTA:CoupeDefault", function()
	local source = source
	local license = GetPlayerIdentifiers(source)[1]
	exports.ghmattimysql:execute("SELECT cheveux,couleurCheveux FROM gta_joueurs_humain WHERE license=@user",{['@user']=license}, function(result)
		TriggerClientEvent("GTA:nLoadCoupeCheveux",source,{result[1].cheveux, result[1].couleurCheveux})
	end)
end)