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
local activeAbilities = {}
local player = game.Players.LocalPlayer

--#endregion

--#region Functions
local function useAbility(ability: string, state: Enum.UserInputState)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if not abilityModules[ability] then
		return
	end
	if not abilityModules[ability]:CanUseAbility(player, abilityModules[ability]:GetAbilityData(player)) then
		print("Can't use ability " .. ability .. " right now")
		return
	end
	print("Firing ability " .. ability)
	activeAbilities[ability] = true
	abilitesNetSpace:Fire("useAbility", ability, state, abilityModules[ability]:GetAbilityData(player))
	return Enum.ContextActionResult.Sink
end

local function init()
	for _, agent: ModuleScript in script:GetChildren() do
		for _, ability in agent:GetChildren() do
			if ability:IsA("ModuleScript") then
				local abilityName = agent.Name .. "_" .. ability.Name
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
		abilityModules["Jett_Knives"]:fireKnife(player, direction, ...)
	end)

	abilitesNetSpace:On("SmokePosChangeDone", function(player: Player, dt, direction: Vector3, ...)
		abilityModules["Jett_Smoke"]:changeSmokePosition(player, dt, direction, ...)
	end)
end

local function start()
	ContextActionService:BindAction("Jett_Dash", useAbility, false, Enum.KeyCode.E)
	ContextActionService:BindAction("Jett_Smoke", useAbility, false, Enum.KeyCode.C)
	-- ContextActionService:BindAction("Jett_UpDraft", useAbility, false, Enum.KeyCode.Q)
	ContextActionService:BindAction("Jett_Knives", useAbility, false, Enum.KeyCode.X)
	ContextActionService:BindAction("Phoenix_Flash", useAbility, false, Enum.KeyCode.Q)
end
--#endregion

init()
start()
