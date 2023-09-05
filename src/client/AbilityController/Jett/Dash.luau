local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local abilityData = require(ReplicatedStorage.GeneralData.Jett.Dash)

function module:Init()
	return module
end

function module:Activate(player: Player, state: Enum.UserInputState, ...)
	print(string.format("Ability %s activated on player %s", tostring(self.Name), player.Name))
	local character: Model = player.Character or player.CharacterAdded:Wait()

	local PlayerOrientation = Instance.new("AlignOrientation")
	PlayerOrientation.CFrame = character:GetPivot()
	PlayerOrientation.Parent = character

	local PrimaryPart: BasePart = character.PrimaryPart :: BasePart
	local direction = PrimaryPart.CFrame.LookVector.Unit
	local Mass = PrimaryPart.AssemblyMass
	PrimaryPart:ApplyImpulse(Mass * direction * abilityData.Strength)
end

function module:CanUseAbility(player: Player, ...)
	return true
end

function module:GetAbilityData(player)
	return player, self.Name
end

return module
