local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

function module:Init()
	return module
end

function module:Activate(player, ...)
	print(string.format("Ability %s activated on player %s", tostring(self.Name), player.Name))
end

function module:GetAbilityData(player)
	return player, self.Name
end

return module
