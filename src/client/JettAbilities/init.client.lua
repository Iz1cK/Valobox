-- !strict
-- Services
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)
local abilitiesNetSpace = Red.Client("Abilities")
-- Enums
local Abilities = require(ReplicatedStorage.Shared.Abilities)
-- Variables
local players = game:GetService("Players")
local mouse = players.LocalPlayer:GetMouse()
local abilities = {}
local abilitiesCount = {}
-- Functions
for _, module in script:GetChildren() do
	abilities[module.Name] = require(module)
	abilities[module.Name]:Init()
	abilitiesCount[module.Name] = 2
end

local function characterAdded() -- character:Model
	for name in Abilities.Jett do
		local module = abilities[name]
		ContextActionService:BindAction(name, function(actionName, inputState, inputObject)
			if not (inputState == Enum.UserInputState.Begin) then
				return
			end

			if abilitiesCount[name] == 0 then
				print("Cant use ability" .. name)
				return
			end

			abilitiesNetSpace:Call("useAbility", name):Then(function(Result: { success: boolean, message: string })
				if not Result.success then
					print("Cant use ability" .. name)
					return
				end
				abilitiesCount[name] -= 1
				print(Result)
			end)
		end, false, module.KEYBIND)
	end
end

local function playerAdded(player: Player)
	player.CharacterAdded:Connect(characterAdded)
	abilitiesNetSpace:On("abilityUsed", function(player: Player, ability: Abilities.Jett)
		print("abilityUsed invoked on ability " .. tostring(ability))
		abilities[ability]:Activate(mouse)
	end)

	abilitiesNetSpace:On("NewSmokePos", function(player: Player, smokePart: Part, smoothedVelocity: number)
		local smokePartClone: Part = smokePart:Clone()
		smokePartClone.Parent = workspace
	end)
end
-- Listeners

players.PlayerAdded:Connect(playerAdded)

for _, player in players:GetPlayers() do
	playerAdded(player)
	characterAdded()
end

-- tool.Unequipped:Connect(function(mouse)
--     for name, module in pairs(abilities) do
--         ContextActionService:UnbindAction(name)
--     end
-- end)
