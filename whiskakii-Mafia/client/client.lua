ESX = nil

menuClosed = true

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function (xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

CreateThread(function() 
    while not ESX.IsPlayerLoaded() do Wait(500) end 
	while ESX.GetPlayerData().job == nil do Wait(10) end  
 
	local blip = AddBlipForCoord(Config.pedCoords)
	SetBlipSprite(blip, 437)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.0)
	SetBlipColour(blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Create Your Own Gang")
	EndTextCommandSetBlipName(blip)
 
    RequestModel(GetHashKey("s_m_y_dealer_01")) 
    while not HasModelLoaded(GetHashKey("s_m_y_dealer_01")) do Wait(1) end
	
	local npc = CreatePed(2, GetHashKey("s_m_y_dealer_01"), Config.pedCoords, Config.pedHeading, false, true)  
	FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true) 
	SetPedDiesWhenInjured(npc, false)
	SetPedCanPlayAmbientAnims(npc, true)
	SetPedCanRagdollFromPlayerImpact(npc, false) 
	TaskStartScenarioInPlace(npc, "WORLD_HUMAN_SMOKING", 0, true)
	local sleep 
	while true do  
		sleep = 1000
		local coords = GetEntityCoords(PlayerPedId(), false) 
		if ( #(Config.pedCoords - coords) < 2.0 ) then
			sleep = 2
			ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to interact with ~r~Whiskakii", true, false)
			if ( IsControlJustPressed(1, 38) ) then 
				openMenu()
			end  
		end
		Wait(sleep)
	end 
end)


--[[ Net Events ]]

RegisterNetEvent('whiskakii-Mafia:closeMenu')
AddEventHandler('whiskakii-Mafia:closeMenu', function()
    closeMenu()
end)

--[[ NUI Callbacks ]]

RegisterNUICallback('onPlayerCreation', function(data)
    mafiaName = string.lower(data.value)

    for k,v in pairs(Config.BlackListedJobs) do

        if PlayerData.job.name ~= v then
            TriggerServerEvent('whiskakii-Mafia:sendCreationData', mafiaName)
            return
        else
            ESX.ShowNotification('You can\'t create gang because of your job: '..PlayerData.job.label)
            break
        end
    end

end)


RegisterNUICallback('closeNUI', function()
    closeMenu()
end)


--[[ Functions ]]

openMenu = function()

    if menuClosed then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'show',
            data = {
                cost = Config.Price,
                currency = Config.CurrencyLabel
            }
        })
    end
    
    menuClosed = false

end

closeMenu = function()

    if not menuClosed then
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'hide'
        })
    end

    menuClosed = true

end
