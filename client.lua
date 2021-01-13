ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local shisha = {4037417364}
local shishaHasStarted = false
local distX, distY, distZ = 0, 0, 0
local buyad = false
local sessionStarted = false
local endCallback = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            for i = 1, #shisha do
                local closestShisha = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, shisha[i], false, false, false)
                local shishaPos = GetEntityCoords(closestShisha)
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, shishaPos.x, shishaPos.y, shishaPos.z, true)

                if dist < 3.5 then
                    local loc = vector3(shishaPos.x, shishaPos.y, shishaPos.z)
					
					if not buyad then
						ESX.Game.Utils.DrawText3D(vector3(shishaPos.x, shishaPos.y, shishaPos.z+1), "[~y~E~w~] Inciar sesion. (10€)", 0.7)
					end

						-- Start Session
						if not sessionStarted then
                    if IsControlJustReleased(0, 38) then
						buyad = true
						sessionStarted = true
					    endCallback = true
                        --ESX.ShowNotification("~g~You've started a session and paid ~r~20$.", false, false)
						ShishaFunctions()
						TriggerEvent("chema_shisha:anim")
						
						
							local playerPed  = GetPlayerPed(-1)
							local coords     = GetEntityCoords(playerPed)

								local x,y,z = table.unpack(GetEntityCoords(ped))
								local prop_name = "v_corp_lngestoolfd"
								VapeMod = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
								AttachEntityToEntity(VapeMod, ped, GetPedBoneIndex(ped, 18905), 0.08, -0.00, 0.03, -150.0, 90.0, -10.0, true, true, false, true, 1, true)

							helmet = true
							
						
						TriggerServerEvent("chema_shisha:pay")
						Citizen.CreateThread(function()
							while true do
								if sessionStarted == true then
									ESX.Game.Utils.DrawText3D(vector3(shishaPos.x, shishaPos.y, shishaPos.z+0.4), "~b~\"H\"~c~ para fumar.", 0.7)
									ESX.Game.Utils.DrawText3D(loc, "~b~\"F\"~c~ para terminar sesion.", 0.7)
								end
								Citizen.Wait(0)
							end
						end)
                    end
					end
                else
                    Citizen.Wait(500)
                end
            end
    end
end)

function ShishaFunctions()
Citizen.CreateThread(function()
    while true do
	local ped = GetPlayerPed(-1)
        Citizen.Wait(0)
        if IsControlJustPressed(0, 74) then -- Normal: H
			TriggerEvent("chema_shisha:Drag", PedToNet(ped))
			TriggerEvent("chema_shisha:Drag", 0)
        end
		
		if IsControlJustReleased(0, 23) then -- Normal: F
			if endCallback == true then
				sessionStarted = false
				buyad = false
				ESX.Game.DeleteObject(VapeMod)
				DeleteObject(VapeMod)
				DeleteObject(mobilehooka)
				ClearPedTasksImmediately(ped)
				ClearPedSecondaryTask(ped)
				TriggerEvent("chema_shisha:delete", -1, entity)
				--ESX.ShowNotification("~r~You ended the session.", false, false)
				endCallback = false
			end
		end
    end
end)
end

AddEventHandler("chema_shisha:anim", function(source)
	local ped = GetPlayerPed(-1)
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end)




p_smoke_location = {
	20279,
}
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core" 
RegisterNetEvent("c_eff_smokes")
AddEventHandler("c_eff_smokes", function(c_ped)
	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
			createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
			createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 0.2, 0.0, 0.0, 0.0)
			Wait(2800)
			--Wait(250)
			while DoesParticleFxLoopedExist(createdSmoke) do
				StopParticleFxLooped(createdSmoke, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(createdPart) do
				StopParticleFxLooped(createdPart, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle) do
				StopParticleFxLooped(p_smoke_particle, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle_asset) do
				StopParticleFxLooped(p_smoke_particle_asset, 1)
			  Wait(0)
			end
			Wait(2800*3)
			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)

RegisterNetEvent("chema_shisha:Drag")
AddEventHandler("chema_shisha:Drag", function()
	
		local ped = GetPlayerPed(-1)
		local PedPos = GetEntityCoords(ped)
		local ad = "mp_player_inteat@burger"
		local anim = "mp_player_int_eat_burger"
		if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
			while (not HasAnimDictLoaded(ad)) do
				RequestAnimDict(ad)
			  Wait(1)
			end
			local VapeFailure = math.random(1,99999)
			if VapeFailure == 1 then
				TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
				PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
					Wait(250)
				AddExplosion(PedPos.x, PedPos.y, PedPos.z+1.00, 34, 0.00, true, false, 1.00)
				ApplyDamageToPed(ped, 200, false)
				TriggerServerEvent("Vape:Failure", 0)
			else
				TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
				PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
			  		Wait(950)
				TriggerServerEvent("eff_smokes", PedToNet(ped))
			  		Wait(1000)
				TriggerEvent("Vape:VapeAnimFix", 0)
			end
		end

end)

RegisterNetEvent("chema_shisha:delete")
AddEventHandler("chema_shisha:delete", function(source)



	for i = 1, #shisha do
		local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
		local closestShisha = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, shisha[i], false, false, false)
		local shishaPos = GetEntityCoords(closestShisha)
		local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, shishaPos.x, shishaPos.y, shishaPos.z, true)

		if dist < 3.5 then
			local loc = vector3(shishaPos.x, shishaPos.y, shishaPos.z)
			
			ESX.Game.DeleteObject(mobilehooka)
			--ESX.ShowNotification("~g~The hookah was taken down.", false, false)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent("chema_shisha:spawn")
AddEventHandler("chema_shisha:spawn", function(source, xPlayer)
	
	
	--ESX.ShowNotification("~g~La Sesion Ha Comenzado", false, false)
	local playerPed  = GetPlayerPed(-1)
	local coords     = GetEntityCoords(playerPed)
	ESX.Game.SpawnObject('prop_bong_01', {
		x = coords.x+0.5,
		y = coords.y+0.1,
		z = coords.z-0.7
	}, function(mobilehooka)
	end)
end)