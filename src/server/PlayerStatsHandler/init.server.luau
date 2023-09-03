local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Red = require(Packages.Red)
local AbilityData = require(ReplicatedStorage.GeneralData.Jett.Knives)
local playerStatsNetSpace = Red.Server("PlayerStats")

local function hitAllowed(player, target: Part)
	return true
end

playerStatsNetSpace:On("KnifeHit", function(player, targetPart: Part)
	print("Knife hit registered on player " .. player.Name .. " with damage " .. AbilityData.Damage)
	if not hitAllowed(player, targetPart) then
		return
	end
	local target = targetPart.Parent
	local humanoid = target:FindFirstChild("Humanoid")
	humanoid:TakeDamage(AbilityData.Damage)
	playerStatsNetSpace:FireAllExcept(player, "KnifeHitDone", player, target)
end)
