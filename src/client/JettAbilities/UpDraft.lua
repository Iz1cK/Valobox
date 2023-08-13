local module = {}
--Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')

--Enums
module.KEYBIND = Enum.KeyCode.Q
module.MAX_CASTS = 2
module.COOLDOWN_DURATION = 0.3
module.ERROR_MESSAGE = {
	['ONCOOLDOWN'] = 'This ability is still on cooldown '
}
module.ERROR_MESSAGE.__index = module.ERROR_MESSAGE
--Variables
local lastUsed = 0
local amountUsed = 0
local player = game:GetService("Players").LocalPlayer
local character : Model = player.Character or player.CharacterAdded:Wait()
--Functions
function module:Activate(mouse, actionName, inputState, inputObject)
	if tick() - lastUsed <= module.COOLDOWN_DURATION then
		print(module.ERROR_MESSAGE.ONCOOLDOWN .. module.COOLDOWN_DURATION - (tick() - lastUsed))
		return
	end
	--if amountUsed == module.MAX_CASTS then
	--	print("You dont have any more updrafts!")
	--	return
	--end
	amountUsed += 1
	lastUsed = tick()
	print("UpDrafting...")
	local PrimaryPart = character.PrimaryPart
	local Mass = PrimaryPart.AssemblyMass
	local DirectionVector = Vector3.new(0,1,0)
	PrimaryPart:ApplyImpulse(100 * Mass * DirectionVector)
end

function module:Init() 

end

--Listeners

return module
