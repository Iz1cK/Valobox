local module = {}
--Services
local player = game:GetService("Players").LocalPlayer
local character: Model = player.Character or player.CharacterAdded:Wait()

--Enums
module.KEYBIND = Enum.KeyCode.E
module.COOLDOWN_DURATION = 0.3
module.ERROR_MESSAGE = {
	["ONCOOLDOWN"] = "This ability is still on cooldown ",
}
module.ERROR_MESSAGE.__index = module.ERROR_MESSAGE
--Variables
--Functions
function module:Activate(mouse)
	local PrimaryPart = character.PrimaryPart
	local Mass = PrimaryPart.AssemblyMass
	local DirectionVector = PrimaryPart.CFrame.LookVector.Unit
	local PlayerOrientation = Instance.new("AlignOrientation")
	PlayerOrientation.CFrame = character:GetPivot()
	PlayerOrientation.Parent = character
	PrimaryPart:ApplyImpulse(100 * Mass * DirectionVector)
end

function module:Init() end

--Listeners

return module
