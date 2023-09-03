local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local abilityData = require(ReplicatedStorage.GeneralData.Jett.UpDraft)

function module:Init()
	return module
end

function module:Activate(player: Player, state: Enum.UserInputState, ...)
	if state ~= Enum.UserInputState.Begin then
		return
	end

	print(string.format("Ability %s activated on player %s", tostring(self.Name), player.Name))
	local character: Model = player.Character or player.CharacterAdded:Wait()

	local PlayerOrientation = Instance.new("AlignOrientation")
	PlayerOrientation.CFrame = character:GetPivot()
	PlayerOrientation.Parent = character

	local PrimaryPart: BasePart = character.PrimaryPart :: BasePart
	local direction = Vector3.new(0, 1, 0)
	local Mass = PrimaryPart.AssemblyMass
	PrimaryPart:ApplyImpulse(
		Mass * direction * abilityData.Strength
			- Vector3.new(0, math.round(PrimaryPart.AssemblyLinearVelocity.Y), 0) * Mass
	)
end

function module:GetAbilityData(player)
	return player, self.Name
end

return module
