local Duree = 0
local iCHeveux, IcCouleur = 1, 1
CoiffeurMenu = RageUI.CreateMenu("Coiffeur",  "Categorie.")


Citizen.CreateThread(function()
    while true do
        Duree = 250
        if IsNearOfZones() then
            Duree = 0
            
            if GetLastInputMethod(0) then
                Ninja_Core__DisplayHelpAlert("~INPUT_PICKUP~ pour ~b~intéragir")
            else
                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_EXTRA_OPTION~ pour ~b~intéragir")
			end
			
			if (IsControlJustReleased(0, 38) or IsControlJustReleased(0, 214)) then  
                BeginCoiffure()
                RageUI.Visible(CoiffeurMenu, not RageUI.Visible(CoiffeurMenu))
			end
        end

        if RageUI.Visible(CoiffeurMenu) == true then 
            DisableControlAction(0, 140, true) --> DESACTIVER LA TOUCHE POUR PUNCH
            DisableControlAction(0, 172,true) --DESACTIVE CONTROLL HAUT  
        end

       Citizen.Wait(Duree)
   end
end)


--> Coiffure Menu : 
Citizen.CreateThread(function()
    while (true) do
        RageUI.IsVisible(CoiffeurMenu, function()
			for i = 1, #Config.Locations do
                local cCheveux = Config.Locations[i]["menuPos"]
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local dist = getDistance(plyCoords, cCheveux, true)
				

                if dist <= 5.0 then
                    Duree = 0

                    --> Gestion des camera droite/face.
                    if (IsControlJustPressed(0, 89)) then
                        createcam(true)
                    elseif (IsControlJustPressed(0, 90)) then
                        createcam(false)
                    end

                    RageUI.List('Coupe de cheveux', tCheveuxLabel, iCHeveux, "", {}, true, {
                        onListChange = function(Index, Item)
                            iCHeveux = Index;
                            SetPedComponentVariation(GetPlayerPed(-1), 2, tCheveuxValue[iCHeveux][1], 0, 0)
                        end,
                        onSelected = function(Index, Item)
                            TriggerServerEvent("GTA_Coiffeur:NouvelCoupe", tCheveuxValue[iCHeveux][1], tCheveuxValue[iCHeveux][2])
                        end
                    })

                    RageUI.List('Couleur de cheveux', tCouleurLabel, IcCouleur, "", {}, true, {
                        onListChange = function(Index, Item)
                            IcCouleur = Index;
                            SetPedHairColor(PlayerPedId(), tCouleurValue[IcCouleur][1])
                        end,
                        onSelected = function(Index, Item)
                            TriggerServerEvent("GTA_Coiffeur:NouvelCouleur", tCouleurValue[IcCouleur][1], tCouleurValue[IcCouleur][2])
                        end
                    })
                end
            end
		end, function()end)
    Citizen.Wait(Duree)
    end
end)