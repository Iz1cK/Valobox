local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local Red = require(ReplicatedStorage.Packages.Red)
local abilitesNetSpace = Red.Client("Abilities")
local knifes = {}

local playerState = {}
type Setup = { type: "Setup" }
type Fire = { type: "Fire" }
type playerState = Setup | Fire

playerState = table.freeze({
	Setup = { type = "Setup" } :: Setup,
	Fire = { type = "Fire" } :: Fire,
})

local currentState = playerState.Setup
local camera: Camera = workspace.CurrentCamera

function module:Init()
	return module
end

function module:Activate(player, state: Enum.UserInputState, ...)
	print(string.format("Ability %s activated on player %s", script.Parent.Name .. script.Name, player.Name))
	if state ~= Enum.UserInputState.Begin then
		return
	end
	local unpacked = { ... }
	local knifeDirection
	if unpacked[2] then
		currentState = unpacked[1]
		knifeDirection = unpacked[2]
	else
		currentState = unpacked[1]
	end
	knifes[player] = knifes[player] or {}
	if player == game.Players.LocalPlayer and #knifes[game.Players.LocalPlayer] == 0 then
		currentState = playerState.Setup
		ContextActionService:UnbindAction("FireKnife")
	elseif player == game.Players.LocalPlayer and #knifes[game.Players.LocalPlayer] > 0 then
		currentState = playerState.Fire
	end
	print(currentState)
	print(playerState.Setup)
	print(playerState.Fire)
	if currentState == playerState.Setup then
		local character: Model = player.Character or player.CharacterAdded:Wait()
		for i = -2, 2, 1 do
			local knifePart: MeshPart = ReplicatedStorage.ReplicatedAssets.Knife:Clone()
			local characterCFrame = character:GetPivot()
			local knifePosition = characterCFrame.Position
				+ characterCFrame.LookVector.Unit * (-math.abs(i) + 3)
				+ characterCFrame.RightVector.Unit * i

			knifePosition = CFrame.new(knifePosition, knifePosition + characterCFrame.LookVector.Unit * 100)
				* CFrame.Angles(math.rad(90), 0, math.rad(90))

			knifePart:PivotTo(knifePosition)
			knifePart.Massless = true
			knifePart.Parent = workspace
			local knifeConstraint = Instance.new("WeldConstraint")
			knifeConstraint.Part0 = knifePart
			knifeConstraint.Part1 = character.PrimaryPart
			knifeConstraint.Parent = knifePart
			table.insert(knifes[player], knifePart)
		end
		currentState = playerState.Fire

		ContextActionService:BindAction("FireKnife", function(_, inputState, _)
			-- if player ~= game.Players.LocalPlayer and knifeDirection == nil then
			-- 	return
			-- end
			if player ~= game.Players.LocalPlayer then
				return
			end
			if inputState ~= Enum.UserInputState.Begin then
				return
			end
			print("click")
			if currentState ~= playerState.Fire then
				return
			end
			local knifePart: MeshPart = knifes[player][1]
			knifePart.Massless = true
			knifePart.CanCollide = true
			knifePart.Anchored = false
			local knifeConstraint = knifePart:FindFirstChildOfClass("WeldConstraint")
			knifeConstraint:Destroy()

			local attachment = knifePart:FindFirstChildOfClass("Attachment")
			local angular = Instance.new("AngularVelocity")
			angular.AngularVelocity = Vector3.new(0, 0, 0)
			angular.Attachment0 = attachment
			angular.Parent = knifePart
			angular.MaxTorque = math.huge

			local direction = knifeDirection or camera.CFrame.LookVector
			knifePart:ApplyImpulse(direction)

			local Mass = knifePart:GetMass()
			local up = Instance.new("VectorForce")
			up.Force = Vector3.new(0, 0, Mass * workspace.gravity) --?? not sure why applying to z axis is working
			up.Attachment0 = attachment
			up.Parent = knifePart

			knifePart.Parent = workspace
			table.remove(knifes[player], 1)
			currentState = playerState.Fire
			if #knifes[player] == 0 then
				currentState = playerState.Setup
				print("No more knifes")
			end
			abilitesNetSpace:Fire("KnifeShot", knifeDirection)
		end, false, Enum.UserInputType.MouseButton1)
	end
	-- create on left click listener with ContextActionService that fires a remote event using Red package to server to fire knife event on server side
end

function module:GetAbilityData(player)
	return currentState
end

return module
