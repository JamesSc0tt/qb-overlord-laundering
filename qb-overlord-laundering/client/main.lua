local QBCore = exports['qb-core']:GetCoreObject()

local currentMachine = -1
local globalCoords = vector3(0,0,0)

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		globalCoords = GetEntityCoords(PlayerPedId())

		local displayed = false
		for k,v in pairs(CONFIG['Machines']) do
			if k == currentMachine and not v.available and #(v.vec - globalCoords) < 5.0 then
				if v.finished then
					DrawText3Ds(v.vec.x, v.vec.y, v.vec.z, '~g~E~w~ - Collect')
					if IsControlJustPressed(0,38) then
						TriggerServerEvent('qb-overlord-laundering:collect', k)
						currentMachine = -1
					end
				else
					DrawText3Ds(v.vec.x, v.vec.y, v.vec.z, '~r~Washing...')
				end
			else
				if not displayed and #(v.vec - globalCoords) < 1.0 then
					if v.available then
						DrawText3Ds(v.vec.x, v.vec.y, v.vec.z, '~g~E~w~ - Load ($'..v.cost..')')
						if IsControlJustPressed(0,38) then
							TriggerServerEvent('qb-overlord-laundering:load', k)
							currentMachine = k
						end
					else
						DrawText3Ds(v.vec.x, v.vec.y, v.vec.z, '~r~Occupied')
					end
					displayed = true -- display one at a time for launder close to eachother
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		for k,v in pairs(CONFIG['Machines']) do
			if v.available == false then
				if #(v.vec - globalCoords) < 8.0 then
					if v.lastsound + math.random(15000, 25000) < GetGameTimer() then
						-- play sound
						if v.finished then
							-- play launder ready
							TriggerEvent('InteractSound_CL:PlayOnOne', 'washingmachinedone', 1.0)
						else
							-- play launder not ready
							TriggerEvent('InteractSound_CL:PlayOnOne', 'washingmachine', 0.1)
						end
						CONFIG['Machines'][k]['lastsound'] = GetGameTimer()
					end
				end
			end
		end
	end
end)

RegisterNetEvent('qb-overlord-laundering:state', function(machine, occupied, finished)
	CONFIG['Machines'][machine]['available'] = occupied
	CONFIG['Machines'][machine]['finished'] = finished
end)

RegisterNetEvent('qb-overlord-laundering:reset', function()
	--currentMachine = -1
end)