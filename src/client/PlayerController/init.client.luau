--!strict
--#region Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
--#endregion

--#region Packages
local Red = require(Packages.Red)
local abilityData = require(ReplicatedStorage.GeneralData.Jett.Knives)
--#endregion

--#region Variables
local playerStatsNet = Red.Client("PlayerStats")
--#endregion

--#region Functions

local function init()
	playerStatsNet:On("KnifeHitDone", function(player: Player, target, ...)
		print("Knife hit registered on player " .. player.Name .. " with damage " .. abilityData.Damage)
		-- do any extra effects if needed, might add knife stuck to target
	end)
end

local function start() end
--#endregion

init()
start()
