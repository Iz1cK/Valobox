local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)
local smokeControlNetSpace = Red.Client("Abilities")

local smokes = {}
local camera: Camera = workspace.CurrentCamera
local mouse: Mouse = game.Players.LocalPlayer:GetMouse()
local direction: Vector3

function module:Init()
	return module
end

function module:Activate(player, state: Enum.UserInputState, ...)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	print(string.format("Ability %s activated on player %s", tostring(self.Name), player.Name))
	smokes[player] = smokes[player] or {}
	local character: Model = player.Character or player.CharacterAdded:Wait()
	local smokePart: Part = ReplicatedStorage.ReplicatedAssets.Smoke:Clone()
	local characterCFrame = character:GetPivot()
	local smokePosition = characterCFrame + characterCFrame.LookVector.Unit * 3 + characterCFrame.RightVector.Unit * 3.5

	smokePart:PivotTo(smokePosition)

	smokePart.Parent = workspace
	table.insert(smokes[player], smokePart)

	local runService = game:GetService("RunService")
	local smokePartLinearVelocity = Instance.new("LinearVelocity")
	smokePartLinearVelocity.Parent = smokePart

	local connection = runService.RenderStepped:Connect(function(dt)
		module:changeSmokePosition(player, dt)
	end)

	smokePart.Touched:Connect(function(hitPart)
		if hitPart.Name == "Baseplate" or hitPart:IsA("Terrain") then
			smokePart.Anchored = true
			smokePart.CanCollide = false
			smokePart.Size = smokePart.Size + Vector3.new(10, 10, 10)
			connection:Disconnect()
			smokePart.Touched:Connect(function() end)
			table.remove(smokes[player], 1)
		end
	end)
end

function module:GetAbilityData(player)
	return
end

function module:changeSmokePosition(player, dt, ...)
	if not smokes[player] then
		return
	end
	local smokePart = smokes[player][1]
	local gravity = Vector3.new(0, -workspace.Gravity, 0)
	local unpacked = { ... }
	if unpacked[1] then
		direction = unpacked[1]
	end
	if not direction then
		local toMouseFlat = Vector3.new(mouse.Hit.Position.X, smokePart.Position.Y, mouse.Hit.Position.Z)
			- smokePart.Position
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

		local combinedDirection = (horizontalDirection * 5 + verticalDirection * 10).Unit
		local desiredVelocity = combinedDirection * 100

		local currentVelocity = smokePart.AssemblyLinearVelocity + gravity * dt

		-- Smooth the velocity transition
		local smoothedVelocity = currentVelocity:Lerp(desiredVelocity, 0.1)
		smokePart.AssemblyLinearVelocity = smoothedVelocity
		smokeControlNetSpace:Fire("SmokePosChange", dt, smoothedVelocity)
	else
		if not smokePart then
			return
		end
		if player ~= game.Players.LocalPlayer then
			smokePart.AssemblyLinearVelocity = direction
			smokeControlNetSpace:Fire("SmokePosChange", dt, direction)
		end
	end
end
return module
