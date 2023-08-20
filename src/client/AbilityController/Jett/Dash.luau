local module = {}

-- local x = 9

function module:Init()
	return module
end

function module:Activate(player: Player, state: Enum.UserInputState, ...)
	-- local _,_,_,otherX = unpack(...)
	print(string.format("Ability %s activated on player %s", tostring(self.Name), player.Name))
	local character: Model = player.Character or player.CharacterAdded:Wait()

	local PlayerOrientation = Instance.new("AlignOrientation")
	PlayerOrientation.CFrame = character:GetPivot()
	PlayerOrientation.Parent = character

	local PrimaryPart: BasePart = character.PrimaryPart :: BasePart
	local direction = PrimaryPart.CFrame.LookVector.Unit
	local Mass = PrimaryPart.AssemblyMass
	PrimaryPart:ApplyImpulse(Mass * direction * 50)
end

function module:GetAbilityData(player)
	return player, self.Name
	-- return player, self.Name, x
end

return module
