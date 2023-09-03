local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local AbilitesData = ReplicatedStorage.GeneralData
local Red = require(Packages.Red)
local Net = Red.Server("Abilities")

local usedAbilities = {}

local function canUseAbility(player, agentName: string, abilityName: string)
	if usedAbilities[player] == nil then
		return true
	end
	if usedAbilities[player][agentName] == nil then
		return true
	end
	if usedAbilities[player][agentName][abilityName] == nil then
		return true
	end
	if usedAbilities[player][agentName][abilityName]["Count"] == nil then
		return true
	end
	local abilityData = require(AbilitesData[agentName][abilityName])
	if abilityData.MaxCasts and usedAbilities[player][agentName][abilityName]["Count"] >= abilityData.MaxCasts then
		return false
	end
	return true
end

Net:On("useAbility", function(player, ability: string, state: Enum.UserInputState, ...)
	print(string.format("Ability %s registered on player %s", ability, player.Name))
	local split = string.split(ability, "_")
	local agentName = split[1]
	local abilityName = split[2]
	if not canUseAbility(player, agentName, abilityName) then
		print("Can't use ability " .. abilityName .. " on player " .. player.Name)
		return
	end
	usedAbilities[player] = usedAbilities[player] or {}
	usedAbilities[player][agentName] = usedAbilities[player][agentName] or {}
	usedAbilities[player][agentName][abilityName] = usedAbilities[player][agentName][abilityName] or {}
	usedAbilities[player][agentName][abilityName]["Count"] = usedAbilities[player][agentName][abilityName]["Count"] or 0
	usedAbilities[player][agentName][abilityName]["Count"] += 1
	Net:FireAll("abilityUsed", player, ability, state, ...)
end)

Net:On("KnifeShot", function(player, direction: Vector3, ...)
	print("Knife shot registered on player " .. player.Name)
	Net:FireAllExcept(player, "KnifeShotDone", player, direction, ...)
end)

Net:On("SmokePosChange", function(player, dt, direction: Vector3, ...)
	print("Smoke position change registered on player " .. player.Name .. " with direction " .. tostring(direction))
	Net:FireAllExcept(player, "SmokePosChangeDone", player, dt, direction, ...)
end)
