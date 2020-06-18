--||@SuperCoolNinja.||--
local menuConfig = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/ConfigMenu.json'))

--> Event : 
RegisterNetEvent("GTA:CoupePayer")
AddEventHandler("GTA:CoupePayer", function()
	for i=1, #Config.Locations do
		local myPeds = Config.Locations[i]["sPed"]
		exports.nCoreGTA:Ninja_Core_PedsText("~b~Coiffeur ~w~ ~h~: Merci !", 2000)
		PlayAmbientSpeech2(myPeds["entity"], "GENERIC_THANKS", "SPEECH_PARAMS_FORCE_SHOUTED") --> Sert a faire parler le ped plus l'animer.
        exports.nCoreGTA:Ninja_Core_StartAnim(myPeds["entity"], "anim@mp_player_intupperthumbs_up", "enter")
	end
	CloseCreator()
end)


RegisterNetEvent("GTA:nLoadCoupeCheveux")
AddEventHandler("GTA:nLoadCoupeCheveux", function(args)
	local hairId = tonumber(args[1]) --> Represente notre variable (Index) pour la coupe de cheveux
    local cheveuxCouleur = tonumber(args[2]) --> Represente notre variable (Index) pour la couleur de nos cheveux
	SetPedComponentVariation(PlayerPedId(), 2,hairId,2,10)
	SetPedHairColor(PlayerPedId(),cheveuxCouleur)

	--print(hairId)
	--print(cheveuxCouleur)
end)


RegisterNetEvent("GTA:CoupeDefault")
AddEventHandler("GTA:CoupeDefault", function()
	for i=1, #Config.Locations do
        local myPeds = Config.Locations[i]["sPed"]
        exports.nCoreGTA:Ninja_Core_StartAnim(myPeds["entity"], "anim@mp_player_intupperthumbs_up", "enter")
        exports.nCoreGTA:Ninja_Core_PedsText("~r~Coiffeur ~w~ ~h~: Passez une bonne journée !", 7000)
	end
	
	CloseCreator()
	coiffeur.opened = false
	coiffeur.menu.from = 1
	SetPedComponentVariation(GetPlayerPed(-1), 2,tonumber(button.idCheveux),tonumber(button.couleur),0)
	coiffeur.menu.to = 10	
end)


--> MENU :
local coiffeur = {
	opened = false,
	title = "",
	currentmenu = "coiffeurMain",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.8 + 0.07,
		y = 0.05,
		width = 0.2 + 0.05,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["coiffeurMain"] = {
			title = "Coiffeur",
			name = "coiffeurMain",
			buttons = { 
				{name = "Coupes de cheveux", description = ""},
				{name = "Couleurs", description = ""},
			}
		},
		["coupes"] = {
			title = "Coupes de cheveux",
			name = "coupes",
			buttons = { 
				{name = "Cheveux 1", description = "", idCheveux = "0", couleur = "0", prix = 250},
				{name = "Cheveux 2", description = "", idCheveux = "1", couleur = "0", prix = 250},
				{name = "Cheveux 3", description = "", idCheveux = "2", couleur = "0", prix = 250},
				{name = "Cheveux 4", description = "", idCheveux = "3", couleur = "0", prix = 250},
				{name = "Cheveux 5", description = "", idCheveux = "4", couleur = "0", prix = 250},
				{name = "Cheveux 6", description = "", idCheveux = "5", couleur = "0", prix = 250},
				{name = "Cheveux 7", description = "", idCheveux = "6", couleur = "0", prix = 250},
				{name = "Cheveux 8", description = "", idCheveux = "7", couleur = "0", prix = 250},
				{name = "Cheveux 9", description = "", idCheveux = "8", couleur = "0", prix = 250},
				{name = "Cheveux 10", description = "", idCheveux = "9", couleur = "0", prix = 250},
			}
		},
		["couleurs"] = { 
			title = "Couleurs", 
			name = "couleurs",
			buttons = { 
				{name = "Noir", description = "", couleur = "0", prix = 150},
				{name = "Châtain clair", description = "", couleur = "2", prix = 150},
				{name = "Marron", description = "", couleur = "3", prix = 150},
				{name = "Brun", description = "", couleur = "4", prix = 150},
				{name = "Blond", description = "", couleur = "10", prix = 150},
				{name = "Roux", description = "", couleur = "19", prix = 150},
				{name = "Châtain", description = "", couleur = "17", prix = 150},
				{name = "Bleu", description = "", couleur = "38", prix = 150},
				{name = "Rose", description = "", couleur = "34", prix = 150},
				{name = "Vert", description = "", couleur = "39", prix = 150},
				{name = "Rouge", description = "", couleur = "54", prix = 150},
				{name = "Orange", description = "", couleur = "50", prix = 150},
			}
		},
  	}
}

--Function :
local Ninja_Core__DisplayHelpAlert = function(msg)
	BeginTextCommandDisplayHelp("STRING");  
    AddTextComponentSubstringPlayerName(msg);  
    EndTextCommandDisplayHelp(0, 0, 1, -1);
end


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function LocalPed()
	return GetPlayerPed(-1)
end

function OpenCreator()
	local ped = LocalPed()
	coiffeur.currentmenu = "coiffeurMain"
	coiffeur.opened = true
	coiffeur.selectedbutton = 1
	TriggerServerEvent("GTA:CoupeDefault") --> On charge la coupe du perso a l'ouverture du menu.
end

function CloseCreator()
	coiffeur.opened = false
	coiffeur.menu.from = 1
	coiffeur.menu.to = 10
	TriggerServerEvent("GTA:CoupeDefault") --> On charge la coupe du perso a la fermeture du menu pour eviter d'avoir des coupes gratuite.
end

function drawMenuButton(button,x,y,selected)
	local menu = coiffeur.menu

	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)

	for i=1, #menuConfig do 
		if selected then
			SetTextColour(menuConfig[i].couleurTextSelectMenu.r, menuConfig[i].couleurTextSelectMenu.g, menuConfig[i].couleurTextSelectMenu.b, menuConfig[i].couleurTextSelectMenu.a)
		else
			SetTextColour(menuConfig[i].couleurTextMenu.r, menuConfig[i].couleurTextMenu.g, menuConfig[i].couleurTextMenu.b, menuConfig[i].couleurTextMenu.a)
		end

		if selected then
			DrawRect(x,y,menu.width,menu.height,menuConfig[i].couleurRectSelectMenu.r,menuConfig[i].couleurRectSelectMenu.g,menuConfig[i].couleurRectSelectMenu.b,menuConfig[i].couleurRectSelectMenu.a)
		else
			DrawRect(x,y,menu.width,menu.height,0,0,0,150)
		end
	end

	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuRight(txt,x,y,selected)
	local menu = coiffeur.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
	local menu = coiffeur.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	for i=1, #menuConfig do 
		DrawRect(x,y,menu.width,menu.height, menuConfig[i].couleurTopMenu.r, menuConfig[i].couleurTopMenu.g, menuConfig[i].couleurTopMenu.b, menuConfig[i].couleurTopMenu.a)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do 
		count = count + 1 
	end
	return count
end

local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for shop = 1, #Config.Locations do
           local sPed = Config.Locations[shop]["sPed"]
           local plyCoords = GetEntityCoords(LocalPed(), false)
           local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), sPed["x"], sPed["y"], sPed["z"], true)

           if dist <= 2 then
               if GetLastInputMethod(0) then
                   Ninja_Core__DisplayHelpAlert("~INPUT_TALK~ pour ~b~intéragir ~w~ avec le ~g~vendeur")
               else
                   Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~b~intéragir ~w~ avec le ~g~vendeur")
               end
           
               if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then 
                   --open menu :
                    if not coiffeur.opened then
                        for i=1, #Config.Locations do
							local myPeds = Config.Locations[i]["sPed"]
							PlayAmbientSpeech2(myPeds["entity"], "GENERIC_HI", "SPEECH_PARAMS_FORCE_SHOUTED") --> Sert a faire parler le ped plus l'animer.
                            exports.nCoreGTA:Ninja_Core_StartAnim(myPeds["entity"], "anim@mp_player_intupperwave", "enter")
                            exports.nCoreGTA:Ninja_Core_PedsText("~r~Coiffeur ~w~ ~h~: Hey, bien le bonjour !", 7000)
                        end
					    OpenCreator()
				    end
               end

               if coiffeur.opened then
                    DisableControlAction(0, 172,true) --DESACTIVE CONTROLL HAUT
                    local ped = LocalPed()
                    local menu = coiffeur.menu[coiffeur.currentmenu]
                    drawMenuTitle(menu.title, coiffeur.menu.x,coiffeur.menu.y + 0.08)
                    local y = coiffeur.menu.y + 0.12
                    buttoncount = tablelength(menu.buttons)
                    local selected = false
                    for i,button in pairs(menu.buttons) do
                        if i >= coiffeur.menu.from and i <= coiffeur.menu.to then
                            if i == coiffeur.selectedbutton then
								selected = true
								if coiffeur.currentmenu == "couleurs" then
									SetPedComponentVariation(LocalPed(), 2,tonumber(saveIDCheveux),2,10) --> ID Draw cheveux
									SetPedHairColor(PlayerPedId(),tonumber(button.couleur)) --> ID couleur cheveux
								elseif coiffeur.currentmenu == "coiffeurMain" then
									--Nothing On fait rien, pour éviter de changer votre coupe a l'ouverture du menu.
								else
									SetPedComponentVariation(PlayerPedId(), 2,tonumber(button.idCheveux),2,10)
								end
                            else
                                selected = false
                            end
						drawMenuButton(button,coiffeur.menu.x,y,selected)
						if button.prix ~= nil then
							drawMenuRight(button.prix.."$",coiffeur.menu.x,y,selected)
						end
                        y = y + 0.04
                            if selected and IsControlJustPressed(1,201) then
                                ButtonSelected(button)
                            end
                        end
                    end
                end

                if coiffeur.opened then
                    if IsControlJustPressed(1,202) then
                        Back()
                    end
                    if IsControlJustReleased(1,202) then
                        backlock = false
                    end
                    if IsControlJustPressed(1,188) then
                        if coiffeur.selectedbutton > 1 then
                            coiffeur.selectedbutton = coiffeur.selectedbutton -1
                            if buttoncount > 10 and coiffeur.selectedbutton < coiffeur.menu.from then
                                coiffeur.menu.from = coiffeur.menu.from -1
                                coiffeur.menu.to = coiffeur.menu.to - 1
                            end
                        end
                    end
                    if IsControlJustPressed(1,187)then
                        if coiffeur.selectedbutton < buttoncount then
                            coiffeur.selectedbutton = coiffeur.selectedbutton +1
                            if buttoncount > 10 and coiffeur.selectedbutton > coiffeur.menu.to then
                                coiffeur.menu.to = coiffeur.menu.to + 1
                                coiffeur.menu.from = coiffeur.menu.from + 1
                            end
                        end
                    end
                end
           end
       end
   end
end)

function ButtonSelected(button)
	local this = coiffeur.currentmenu
	local btn = button.name
	if this == "coiffeurMain" then --> Menu Principale : Tittre Coiffeur.
		if btn == "Coupes de cheveux" then --> Selection 1 : Titre Coupes de cheveux.
			OpenMenu("coupes") --> Button 1 : Coupes.
		elseif btn == "Couleurs" then --> Selection 2 : Titre Couleurs.
			OpenMenu("couleurs") --> Button 2 : couleurs.
		end	 
elseif this == "coupes" then 
		saveIDCheveux =  button.idCheveux 
		TriggerServerEvent("GTA:PayerCoupeCheveux", button.idCheveux, button.couleur, button.prix)
	elseif this == "couleurs" then --> Sous menu couleur de cheveux
		TriggerServerEvent("GTA:PayerCouleurCheveux", button.couleur, button.prix)
	end
end

function OpenMenu(open_menu)
	coiffeur.currentmenu = open_menu
	coiffeur.opened = true
	coiffeur.selectedbutton = 1
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if coiffeur.currentmenu == "coiffeurMain" then
		CloseCreator()
	elseif coiffeur.currentmenu == "coupes" then
		OpenMenu('coiffeurMain')
	elseif coiffeur.currentmenu == "couleurs" then
		OpenMenu('coiffeurMain')
	else
		OpenMenu(coiffeur.lastmenu)
	end
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


function table.HasValue( t, val )
	for k, v in pairs( t ) do
		if ( v == val ) then return true end
	end
	return false
end



RegisterNetEvent("GTA:CouleurPayer")
AddEventHandler("GTA:CouleurPayer", function()
	for i=1, #Config.Locations do
        local myPeds = Config.Locations[i]["sPed"]
        exports.nCoreGTA:Ninja_Core_StartAnim(myPeds["entity"], "anim@mp_player_intupperthumbs_up", "enter")
        exports.nCoreGTA:Ninja_Core_PedsText("~r~Coiffeur ~w~ ~h~: Passez une bonne journée !", 7000)
	end

	CloseCreator()
	coiffeur.opened = false
	coiffeur.menu.from = 1
	coiffeur.menu.to = 10	
end)

RegisterNetEvent("GTA:ArgentManquante")
AddEventHandler("GTA:ArgentManquante", function()
	for i=1, #Config.Locations do
		local myPeds = Config.Locations[i]["sPed"]
		exports.nCoreGTA:Ninja_Core_PedsText("~b~Coiffeur ~w~ ~h~:  (choqué) !", 2000)
		PlayAmbientSpeech2(myPeds["entity"], "GENERIC_FRIGHTENED_HIGH", "SPEECH_PARAMS_FORCE_SHOUTED") --> Sert a faire parler le ped plus l'animer.
        exports.nCoreGTA:Ninja_Core_StartAnim(myPeds["entity"], "anim@mp_player_intupperwave", "enter")
	end
	CloseCreator()
	coiffeur.opened = false
	coiffeur.menu.from = 1
	coiffeur.menu.to = 10	
end)