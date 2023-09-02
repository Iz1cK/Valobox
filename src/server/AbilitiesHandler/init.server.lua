local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Red = require(Packages.Red)
local Net = Red.Server("Abilities")

local function canUseAbility(...)
	return true
end

Net:On("useAbility", function(player, ability: string, state: Enum.UserInputState, ...)
	print(string.format("Ability %s registered on player %s", ability, player.Name))
	if not canUseAbility(player, ability) then
		return
	end
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
