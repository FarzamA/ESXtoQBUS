local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}
ESX = nil
local PlayerData = {}

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

local CurrentCraft = nil
IsRolling = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

end)

-- NUI that get triggered on success
RegisterNUICallback('CraftingSuccess', function()
    SetNuiFocus(false, false)
    ClearPedTasks(GetPlayerPed(-1))
    IsRolling = false
    TriggerServerEvent("esx_crafting:CraftingSuccess", CurrentCraft)
end)

-- NUI that get triggered on fail
RegisterNUICallback('CraftingFailed', function()
    SetNuiFocus(false, false)
    ClearPedTasks(GetPlayerPed(-1))
    IsRolling = false
    TriggerServerEvent("esx_crafting:CraftingFailed", CurrentCraft)
end)


RegisterNetEvent('esx_crafting:OpenMenu')
AddEventHandler('esx_crafting:OpenMenu', function(source)
	OpenCraftMenu()
end)

function OpenCraftMenu()
    local elements = {}
        for item, v in pairs(Crafting.Items) do
            if v.threshold then
                local elementlabel = v.label .. ": "
                local somecount = 1
                for k, need in pairs(v.needs) do
                    if somecount == 1 then
                        somecount = somecount + 1
                        elementlabel = elementlabel .. need.label .. " ("..need.count..")"
                    else
                        elementlabel = elementlabel .. " - "..need.label .. " ("..need.count..")"
                    end
                end
                table.insert(elements, {value = item, label = elementlabel})
            end
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_actions', {
            title    = "Rolling Joints",
            elements = elements,
            align    = 'top-left',
        }, function(data, menu)
            menu.close()
            CurrentCraft = data.current.value
            ESX.TriggerServerCallback('esx_crafting:HasTheItems', function(result)
                if result then
                    SetNuiFocus(true,true)
                    SendNUIMessage({
                        action = "opengame",
                    })
                    IsRolling = true
                else
                    exports['mythic_notify']:DoHudText('inform', 'You dont have the necessary material')
                end
            end, CurrentCraft)

        end, function(data, menu)
            menu.close()
    end)
end


function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if IsRolling then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			--DisableControlAction(0, Keys['W'], true) -- W
			--DisableControlAction(0, Keys['A'], true) -- A
			--DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			--DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?
			DisableControlAction(0, Keys['U'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['V'], true) -- Disable changing view
			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen


			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth


			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'a_uncuff', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					playAnim('mp_arresting', 'a_uncuff', -1)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)
