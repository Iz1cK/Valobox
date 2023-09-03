local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Red = require(Packages.Red)
local playerStatsNetSpace = Red.Server("PlayerStats")

playerStatsNetSpace:On("KnifeHit", function(player, target: Player)
	print("Knife hit registered on player " .. player.Name .. " with damage ")
	playerStatsNetSpace:FireAllExcept(player, "KnifeHitDone", player, target)
end)
