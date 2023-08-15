local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Abilities = require(ReplicatedStorage.Shared.Abilities)
local Red = require(Packages.Red)
local Net = Red.Server("Abilities")

local function canUseAbility(...)
	return true
end

Net:On("useAbility", function(player, ability: Abilities.Abilities)
	print(string.format("Ability %s registered on player %s", tostring(ability), player.Name))
	if not canUseAbility(player, ability) then
		return { success = false, message = "You can not use this ability" }
	end

	Net:FireAll("abilityUsed", player, ability)

	return { success = true, message = "You can use this ability" }
end)

Net:On("SmokePosChange", function(player, smokePart, smoothedVelocity)
	Net:FireAll("NewSmokePos", player, smokePart, smoothedVelocity)
end)

print("Hello its a me mario")
