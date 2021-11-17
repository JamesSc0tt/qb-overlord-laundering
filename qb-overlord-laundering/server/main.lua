RegisterServerEvent('qb-overlord-laundering:use', function(key)
	local machine = CONFIG['Machines'][key]
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.money.cash >= tonumber(machine.cost) then
		Player.Functions.RemoveMoney('cash', tonumber(machine.cost), machine.name)
		TriggerClientEvent('cpl-cleanmoney:client:cleanmoney', source, machine.perc)
	else
		TriggerClientEvent('QBCore:Notify', source, "You cannot afford this!", "error")
	end
end)

RegisterServerEvent('qb-overlord-laundering:load', function(machine)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not CONFIG['Machines'][machine]['available'] then return end

	CONFIG['Machines'][machine]['available'] = false
	CONFIG['Machines'][machine]['finished'] = false
	TriggerClientEvent('qb-overlord-laundering:state', -1, machine, false, false)

	local num_bags = 0
	local total_worth = 0

	for itemkey, item in pairs(Player.PlayerData.items) do
		if item.name == 'markedbills' then
			num_bags = num_bags + 1
			if type(item.info) ~= 'string' and tonumber(item.info.worth) then
				total_worth = total_worth + tonumber(item.info.worth)
				Player.Functions.RemoveItem(item.name, 1) -- need to work out how to take this specific one...
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "remove")
			end
		end
	end

	if num_bags < 1 then
		TriggerClientEvent('QBCore:Notify', src, 'Missing item...', 'error')
		CONFIG['Machines'][machine]['available'] = true
		CONFIG['Machines'][machine]['finished'] = false
		TriggerClientEvent('qb-overlord-laundering:state', -1, machine, true, false)
		return
	end

	local real_worth = total_worth * CONFIG['Machines'][machine].perc
	local timer = CONFIG['BaseTime'] * 60000

	if num_bags > 1 then
		-- add multiplier
		local plus = CONFIG['TimePerItem'] * 60000
		plus = plus * num_bags

		timer = timer + plus
	end

	if CONFIG['PoliceIncrease'] then
		local num_police = 0
		for k, v in pairs(QBCore.Functions.GetPlayers()) do
			local job = QBCore.Functions.GetPlayer(v).PlayerData.job
			if job.name == 'police' and job.onduty then
				num_police = num_police + 1
			end
		end

		local plus = real_worth * CONFIG['PoliceIncrease']
		plus = plus * num_police

		real_worth = real_worth + plus
	end

	CONFIG['Machines'][machine]['player'] = src
	CONFIG['Machines'][machine]['worth'] = math.floor(real_worth) -- floor it cause % be .000314010401!

	TriggerClientEvent('QBCore:Notify', src, 'You loaded '..num_bags..'x '..QBCore.Shared.Items['markedbills'].label..' ($'..total_worth..')', 'success')

	Citizen.Wait(timer) -- probably a better way to do this but not too fussed about serverside performance

	TriggerClientEvent('qb-phone:client:LaunderNotify', src)

	CONFIG['Machines'][machine]['available'] = false
	CONFIG['Machines'][machine]['finished'] = true
	TriggerClientEvent('qb-overlord-laundering:state', -1, machine, false, true)
end)

RegisterServerEvent('qb-overlord-laundering:collect', function(machine)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if CONFIG['Machines'][machine]['player'] ~= src then return end -- only original player can unload!
	if not CONFIG['Machines'][machine]['finished'] then return end

	Player.Functions.AddMoney("cash", CONFIG['Machines'][machine]['worth'])

	CONFIG['Machines'][machine]['player'] = 0
	CONFIG['Machines'][machine]['worth'] = 0

	CONFIG['Machines'][machine]['available'] = true
	CONFIG['Machines'][machine]['finished'] = false
	TriggerClientEvent('qb-overlord-laundering:state', -1, machine, true, false)
end)