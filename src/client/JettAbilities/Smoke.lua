local module = {}
--Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')

--Enums
module.KEYBIND = Enum.KeyCode.C
module.MAX_CASTS = 3
module.COOLDOWN_DURATION = 0.3
module.ERROR_MESSAGE = {
	['ONCOOLDOWN'] = 'This ability is still on cooldown '
}
module.ERROR_MESSAGE.__index = module.ERROR_MESSAGE
--Variables
local lastUsed = 0
local amountUsed = 0
local player : Player = game:GetService("Players").LocalPlayer
local character : Model = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
--Functions
function module:Activate(mouse, actionName, inputState, inputObject)
	if tick() - lastUsed <= module.COOLDOWN_DURATION then
		print(module.ERROR_MESSAGE.ONCOOLDOWN .. module.COOLDOWN_DURATION - (tick() - lastUsed))
		return
	end
	--if amountUsed == module.MAX_CASTS then
	--	print("You dont have any more smokes!")
	--	return
	--end
	amountUsed += 1
	lastUsed = tick()
	--print("Smoking...")
	local smokePart : Part = ReplicatedStorage.Smoke:Clone()
	local characterCFrame = character:GetPivot()
	local characterLV = characterCFrame.LookVector
	local smokePosition = characterCFrame + characterCFrame.LookVector.Unit * 3 + characterCFrame.RightVector.Unit * 3.5

	smokePart:PivotTo(smokePosition)

	smokePart.Parent = workspace
	local referencePoint = characterCFrame.Position

	local direction = (mouse.Hit.Position - referencePoint).Unit
	smokePart:ApplyImpulse(direction*smokePart:GetMass()*100)

	local runService = game:GetService("RunService")
	local gravity = Vector3.new(0, -workspace.Gravity, 0)

	local connection
	connection = runService.RenderStepped:Connect(function(dt)
		local toMouseFlat = Vector3.new(mouse.Hit.Position.X, smokePart.Position.Y, mouse.Hit.Position.Z) - smokePart.Position
		local horizontalDirection = toMouseFlat.Unit

		local viewDirection = (mouse.Hit.Position - camera.CFrame.Position).Unit
		local toPoint = smokePart.Position - mouse.Hit.Position
		local dotProduct = viewDirection:Dot(toPoint)
		local projectedPoint = mouse.Hit.Position + viewDirection * dotProduct

		-- Determine vertical direction
		local verticalDirection
		if projectedPoint.Y > smokePart.Position.Y then
			verticalDirection = Vector3.new(0, 1, 0)
		else
			verticalDirection = Vector3.new(0, -1, 0)
		end

		local combinedDirection = (horizontalDirection*5 + verticalDirection*10).Unit
		local desiredVelocity = combinedDirection * 100
		local currentVelocity = smokePart.AssemblyLinearVelocity + gravity * dt

		-- Smooth the velocity transition
		local smoothedVelocity = currentVelocity:Lerp(desiredVelocity, 0.1)

		smokePart.AssemblyLinearVelocity = smoothedVelocity
	end)

	smokePart.Touched:Connect(function(hitPart)
		if hitPart.Name == "Baseplate" or hitPart:IsA("Terrain") then 
			smokePart.Anchored = true
			smokePart.CanCollide = false
			smokePart.Size = smokePart.Size + Vector3.new(10, 10, 10)
			connection:Disconnect()
			smokePart.Touched:Connect(function() end)
		end
	end)
end

function module:Init() 

end

--Listeners

return module
