local module = {}

local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local abilityData = require(ReplicatedStorage.GeneralData.Phoenix.Flash)

local camera: Camera = workspace.CurrentCamera

local flashes = {}

function module:Init()
	return module
end

function module:Activate(player, state: Enum.UserInputState, ...)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	print(string.format("Ability %s activated on player %s", tostring(self.Name), player.Name))
	flashes[player] = flashes[player] or {}
	local flashPart = ReplicatedStorage.ReplicatedAssets.Flash:Clone()
	local character: Model = player.Character or player.CharacterAdded:Wait()
	local characterCFrame = character:GetPivot()
	local flashPosition = characterCFrame.Position
		+ characterCFrame.RightVector.Unit * 2
		+ characterCFrame.LookVector.Unit * 2
	flashPosition = CFrame.new(flashPosition)
	flashPart:PivotTo(flashPosition)

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = flashPart
	weld.Part1 = character.PrimaryPart
	weld.Parent = flashPart
	flashPart.Massless = true

	ContextActionService:BindAction("FireFlashRight", function(_, currState)
		if currState ~= Enum.UserInputState.Begin then
			return
		end
		module:fireFlash(player, "right")
		table.remove(flashes[player], 1)
	end, false, Enum.KeyCode.Y)

	ContextActionService:BindAction("FireFlashLeft", function(_, currState)
		if currState ~= Enum.UserInputState.Begin then
			return
		end
		module:fireFlash(player, "left")
		table.remove(flashes[player], 1)
	end, false, Enum.KeyCode.T)

	flashPart.Parent = workspace
	table.insert(flashes[player], flashPart)
end

function module:GetAbilityData(player)
	return player, self.Name
end

function module:fireFlash(player, side: string, ...)
	local unpacked = { ... }
	local flashDirection = unpacked[1] or nil

	local flashPart: Part = flashes[player][1]
	if not flashPart then
		return
	end
	flashPart.Massless = true
	flashPart.CanCollide = true
	flashPart.Anchored = false
	local knifeConstraint = flashPart:FindFirstChildOfClass("WeldConstraint")
	knifeConstraint:Destroy()

	local attachment = flashPart:FindFirstChildOfClass("Attachment")
	local character = player.Character
	local sideVector = character.PrimaryPart.CFrame.RightVector

	if side == "left" then
		sideVector *= -1
	end
	local direction = flashDirection or camera.CFrame.LookVector
	flashPart:ApplyImpulse(direction * abilityData.Speed)

	local Mass = flashPart.AssemblyMass
	local vectorForce = Instance.new("VectorForce")

	vectorForce.Force = Vector3.new(0, Mass * workspace.Gravity, 0) + sideVector * abilityData.Strength
	vectorForce.ApplyAtCenterOfMass = true
	vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	vectorForce.Attachment0 = attachment
	vectorForce.Parent = flashPart
end

function module:CanUseAbility(player, ...)
	flashes[player] = flashes[player] or {}
	if #flashes[player] == 1 then
		print("Flash already out")
		return false
	end
	return true
end

return module
