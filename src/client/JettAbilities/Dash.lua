local module = {}
--Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local player = game:GetService("Players").LocalPlayer
local character : Model = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator : Animator = humanoid:WaitForChild("Animator")

--Enums
module.KEYBIND = Enum.KeyCode.E
module.COOLDOWN_DURATION = 0.3
module.ERROR_MESSAGE = {
	['ONCOOLDOWN'] = 'This ability is still on cooldown '
}
module.ERROR_MESSAGE.__index = module.ERROR_MESSAGE
--Variables
local lastUsed = 0
local AbilityHandler = ReplicatedStorage:WaitForChild('AbilityHandler')
--Functions
function module:Activate(mouse,actionName,inputState,inputObject) 
	if(inputState == Enum.UserInputState.Begin) then
		if tick() - lastUsed <= module.COOLDOWN_DURATION then
			local cd = module.COOLDOWN_DURATION - (tick() - lastUsed)
			print(module.ERROR_MESSAGE.ONCOOLDOWN .. math.floor(cd*100)/100)
			return
		end
		lastUsed = tick()
		local idle : AnimationTrack = humanoid:LoadAnimation(script.Idle)
		idle:Play()
		local PrimaryPart = character.PrimaryPart
		local Mass = PrimaryPart.AssemblyMass
		local DirectionVector = PrimaryPart.CFrame.LookVector.Unit
		local PlayerOrientation = Instance.new("AlignOrientation")
		PlayerOrientation.CFrame = character:GetPivot()
		PlayerOrientation.Parent = character
		PrimaryPart:ApplyImpulse(100 * Mass * DirectionVector)
		task.delay(2, function ()
			idle:Stop()
		end)
	end
end

function module:Init() 

end

--Listeners



return module
