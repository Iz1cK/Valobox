--!strict
--#region Services
local Packages = game:GetService("ReplicatedStorage").Packages
local ContextActionService = game:GetService("ContextActionService")
--#endregion

--#region Packages
local Red = require(Packages.Red)
--#endregion

--#region Variables
local abilitesNetSpace = Red.Client("Abilities")
local abilityModules = {}
local player = game.Players.LocalPlayer
--#endregion

--#region Functions
local function useAbility(ability: string, state: Enum.UserInputState)
	if not abilityModules[ability] then
		return
	end
	print("Firing ability " .. ability)
	abilitesNetSpace:Fire("useAbility", ability, state, abilityModules[ability]:GetAbilityData(player))
	return Enum.ContextActionResult.Sink
end

local function init()
	for _, agent: ModuleScript in script:GetChildren() do
		for _, ability in agent:GetChildren() do
			if ability:IsA("ModuleScript") then
				local abilityName = agent.Name .. ability.Name
				print(abilityName)
				abilityModules[abilityName] = (require)(ability):Init()
			end
		end
	end

	abilitesNetSpace:On("abilityUsed", function(player: Player, ability: string, state: Enum.UserInputState, ...)
		print("Ability " .. ability .. " used by player " .. player.Name)
		abilityModules[ability]:Activate(player, state, ...)
	end)

	abilitesNetSpace:On("KnifeShotDone", function(player: Player, direction: Vector3, ...)
		print("Knife shot registered on player " .. player.Name)
		abilityModules["JettKnives"]:fireKnife(player, direction, ...)
	end)
end

local function start()
	ContextActionService:BindAction("JettDash", useAbility, false, Enum.KeyCode.E)
	ContextActionService:BindAction("JettSmoke", useAbility, false, Enum.KeyCode.C)
	ContextActionService:BindAction("JettUpDraft", useAbility, false, Enum.KeyCode.Q)
	ContextActionService:BindAction("JettKnives", useAbility, false, Enum.KeyCode.X)
end
--#endregion

init()
start()
