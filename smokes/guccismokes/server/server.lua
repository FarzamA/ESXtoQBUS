QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

for i=1, #Config.Smoke, 1 do

    QBCore.Functions.CreateUseableItem(Config.Smoke[i].Item, function(source)
        src = source
        local xPlayer = QBCore.Functions.GetPlayer(src)
        local lighter = xPlayer.Functions.GetItemByName(Config.Lighter)
        
        local item     = Config.Smoke[i].Item
        local prop     = Config.Smoke[i].Prop
        local size    = Config.Smoke[i].Size
        local type    = Config.Smoke[i].Type
        local time    = Config.Smoke[i].Time

        if type == 'vape' or type == 'bong' then
            TriggerClientEvent('devcore_smokev2:client:Smoke', src, item, size, prop, type, time)
        end
    	if type == 'cigar' or type == 'cigarette' or type == 'joint' then
            if lighter ~= nil then
                TriggerClientEvent('devcore_smokev2:client:Smoke', src, item, size, prop, type, time)
                xPlayer.Functions.RemoveItem(item, 1)
           -- xPlayer.Functions.RemoveItem(pack, 1)
            --xPlayer.Functions.AddItem(item, amount)
            else
                TriggerClientEvent('QBCore:Notify', source,'need_lighter', 'error')
            end
        end
            end)
    end


    for i=1, #Config.CigarettePack, 1 do

        QBCore.Functions.CreateUseableItem(Config.CigarettePack[i].PackItem, function(source)
            src = source
            local xPlayer = QBCore.Functions.GetPlayer(src)
            local pack     = Config.CigarettePack[i].PackItem
            local item     = Config.CigarettePack[i].CigaretteItem
            local amount    = Config.CigarettePack[i].Amount
        
            TriggerClientEvent('devcore_smokev2:client:CigarettesUnPack', src)
            Citizen.Wait(3000)
                xPlayer.Functions.RemoveItem(pack, 1)
                xPlayer.Functions.AddItem(item, amount)
                end)
        end

        QBCore.Functions.CreateUseableItem(Config.Rollingpaper, function(source)
            src = source
            local xPlayer = QBCore.Functions.GetPlayer(src)
            for i=1, #Config.ItemWeed, 1 do
            local weed = xPlayer.Functions.GetItemByName(Config.ItemWeed[i])
            if weed.count > 0 then
                TriggerClientEvent('esx_crafting:OpenMenu', source)
                end
            end
        end)

        RegisterServerEvent("devcore_smokev2:server:RemoveItem")
        AddEventHandler("devcore_smokev2:server:RemoveItem", function(item, size, prop, type, time)
            src = source
            local xPlayer = QBCore.Functions.GetPlayer(src)
            xPlayer.Functions.RemoveItem(item, 1)
        end)
        
        RegisterServerEvent("devcore_smokev2:server:AddItem")
        AddEventHandler("devcore_smokev2:server:AddItem", function(item, size, prop, type, time)
            src = source
            local xPlayer = QBCore.Functions.GetPlayer(src)
            xPlayer.Functions.AddItem(item, 1)
        end)
        

RegisterServerEvent("devcore_smokev2:server:StartPropSmoke")
AddEventHandler("devcore_smokev2:server:StartPropSmoke", function(propsmoke, type)
    TriggerClientEvent("devcore_smokev2:client:StartPropSmoke", -1, propsmoke, type)
end)

RegisterServerEvent("devcore_smokev2:server:CheckItem")
AddEventHandler("devcore_smokev2:server:CheckItem", function(type)
    local xPlayer = QBCore.Functions.GetPlayer(source)
	local liquid = xPlayer.Functions.GetItemByName(Config.ItemVapeLiquid)
	
		if liquid.count > 0 then
			xPlayer.Functions.RemoveItem(Config.ItemVapeLiquid, 1)
			TriggerClientEvent('devcore_smokev2:client:AddLiquid', source)
		else
            TriggerClientEvent('QBCore:Notify', source, 'need_liquid', 'error')
            
		end
end)



RegisterServerEvent("devcore_smokev2:server:checkbong")
AddEventHandler("devcore_smokev2:server:checkbong", function(itemName)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local xItem = xPlayer.Functions.GetItemByName(itemName)

	if xItem.count < 1 then
        TriggerClientEvent('QBCore:Notify', source,'dont_have', 'error')
		return
	end

	xPlayer.Functions.RemoveItem(xItem.name, 1)
	TriggerClientEvent('devcore_smokev2:client:AddBong', source)
end)


RegisterServerEvent('devcore_smokev2:server:Receiver')
AddEventHandler('devcore_smokev2:server:Receiver', function(target, item, size, prop, type, time)
    local _source 	 = QBCore.Functions.GetPlayer(target).source
    TriggerClientEvent("devcore_smokev2:client:Receiver", _source, item, size, prop, type, time)
end)

--Effect
RegisterServerEvent("devcore_smokev2:server:StopPropSmoke")
AddEventHandler("devcore_smokev2:server:StopPropSmoke", function(propsmoke)
    TriggerClientEvent("devcore_smokev2:client:StopPropSmoke", -1, propsmoke)
end)
-- mouth particle
RegisterServerEvent("devcore_smokev2:server:StartMouthSmoke")
AddEventHandler("devcore_smokev2:server:StartMouthSmoke", function(mouthsmoke, type)
    TriggerClientEvent("devcore_smokev2:client:StartMouthSmoke", -1, mouthsmoke, type)
end)

RegisterServerEvent("devcore_smokev2:server:StopMouthSmoke")
AddEventHandler("devcore_smokev2:server:StopMouthSmoke", function(mouthsmoke)
    TriggerClientEvent("devcore_smokev2:client:StopMouthSmoke", -1, mouthsmoke)
end)