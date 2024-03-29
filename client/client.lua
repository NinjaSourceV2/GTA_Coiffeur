--||@SuperCoolNinja.||--
tCheveuxLabel, tCheveuxValue = {}, {}
tCouleurLabel, tCouleurValue = {}, {}
local tSex = {}
local playerSexe = " "

RegisterNetEvent("GTA_Coiffeur:GetSexPlayer")
AddEventHandler("GTA_Coiffeur:GetSexPlayer", function(sexe)
	playerSexe = sexe
    if(playerSexe ~= nil)then 
        Wait(150)

        getSex()
        
        GetLabelCoupeCheveux()
        GetLabelCouleursCheveux()
    end
end)

--> Blips Coiffeur : 
Citizen.CreateThread(function()
    for i = 1, #Config.Locations do
        local blip = Config.Locations[i]["Blip"]
        blip = AddBlipForCoord(blip["x"], blip["y"], blip["z"])

        SetBlipSprite(blip, 71)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Coiffeur")
        EndTextCommandSetBlipName(blip)
    end
end)

--> Retourne le sex de votre joueurs :
function getSex()
	for i = 1, #Config.Locations do
		if playerSexe == "mp_m_freemode_01" then
            tSex = Config.Locations[i]["Homme"]
			return
        elseif playerSexe == "mp_f_freemode_01" then
            tSex = Config.Locations[i]["Femme"]
			return
		end
	end
end

function Ninja_Core__DisplayHelpAlert(msg)
	BeginTextCommandDisplayHelp("STRING");  
    AddTextComponentSubstringPlayerName(msg);  
    EndTextCommandDisplayHelp(0, 0, 1, -1);
end

square = math.sqrt
function getDistance(a, b) 
  local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
  return square(x*x+y*y+z*z)
end

function createcam(default)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 138.45, -1711.05, 29.70, 0.0, 0.0, 45.00, 65.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 137.72, -1709.87, 29.90, 0.0, 0.0, 135.00, 85.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end

--> Setup l'animation du player sur la chaise : thanks to @CCasusensa.
function BeginCoiffure()
    --> Gestion de l'hud : 
    TriggerEvent('EnableDisableHUDFS', false)
    DisplayRadar(false)
    
    --> Gestion position du joueur : 
    TaskPedSlideToCoord(PlayerPedId(), 137.12, -1709.45, 29.3, 205.75, 1.0)
    SetEntityCoords(PlayerPedId(), 137.72, -1710.64, 28.60)
    SetEntityHeading(PlayerPedId(), 237.22)
    ClearPedTasks(GetPlayerPed(-1))
    local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
    TaskStartScenarioAtPosition(GetPlayerPed(-1), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", pos['x'], pos['y'], pos['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
    
    Wait(150)

    createcam(true)
end

--> Return vrais si vous êtes proche de la zone :
function IsNearOfZones()
    for i = 1, #Config.Locations do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

        local posCoiffeur = Config.Locations[i]["menuPos"]
        local dCoiffeur = getDistance(plyCoords, posCoiffeur, true)

        if (dCoiffeur <= 1.0) then
            return true
        else
            return false 
        end
    end
end

-- Get le nom des Coupe de cheveux : 
function GetLabelCoupeCheveux()
	for k, v in pairs(tSex["Coupe"]) do
        table.insert(tCheveuxLabel, k)
        table.insert(tCheveuxValue, v)
	end
end

-- Get le nom des Couleurs de cheveux : 
function GetLabelCouleursCheveux()
	for k, v in pairs(tSex["Couleur"]) do
        table.insert(tCouleurLabel, k)
        table.insert(tCouleurValue, v)
	end
end


--> Ici on recupère le "Sex" du character pour recevoir les bonne coupe de cheveux :
function refreshCoiffures()
    TriggerServerEvent("GTA_Coiffeur:GetPlayerSexe")
end

RegisterNetEvent("GTA_Coiffeur:UpdateCheveux")
AddEventHandler("GTA_Coiffeur:UpdateCheveux",function(data)
	SetPedComponentVariation(GetPlayerPed(-1), 2,data["cheveux"],2,10)
	SetPedHairColor(GetPlayerPed(-1),data["couleur_cheveux"])
end)

RegisterNetEvent("GTA_Coiffeur:LoadOldCoiffure")
AddEventHandler("GTA_Coiffeur:LoadOldCoiffure", function()
    TriggerServerEvent("GTA_Coiffeur:LoadCoupeCheveux")
end)

--> Executer une fois la ressource restart pour refresh les donnée du character Sex :
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
	end

    refreshCoiffures()
end)