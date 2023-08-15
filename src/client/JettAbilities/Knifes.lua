local module = {}
--#region Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

--#endregion
--#region Enums
module.KEYBIND = Enum.KeyCode.X
module.MAX_CASTS = 3
module.COOLDOWN_DURATION = 0.3
module.ERROR_MESSAGE = {
	["ONCOOLDOWN"] = "This ability is still on cooldown ",
}
module.ERROR_MESSAGE.__index = module.ERROR_MESSAGE
--#endregion
--#region Variables
local lastUsed = 0
local amountUsed = 0
local player: Player = game:GetService("Players").LocalPlayer
local character: Model = player.Character or player.CharacterAdded:Wait()
local knifes = {}
--#endregion
--#region Functions
function module:Activate(mouse: Mouse)
	if tick() - lastUsed <= module.COOLDOWN_DURATION then
		print(module.ERROR_MESSAGE.ONCOOLDOWN .. module.COOLDOWN_DURATION - (tick() - lastUsed))
		return
	end
	amountUsed += 1
	lastUsed = tick()
	for i = -2, 2, 1 do
		local knifePart: MeshPart = ReplicatedStorage.ReplicatedAssets.Knife:Clone()
		local characterCFrame = character:GetPivot()
		local knifePosition = characterCFrame
			+ characterCFrame.LookVector.Unit * (-math.abs(i) + 3) -- closest
			+ characterCFrame.RightVector.Unit * i

		knifePart:PivotTo(knifePosition)
		local knifeConstraint = Instance.new("WeldConstraint")
		knifeConstraint.Part0 = knifePart
		knifeConstraint.Part1 = character.PrimaryPart
		knifeConstraint.Parent = knifePart
		knifePart.Parent = workspace
		table.insert(knifes, knifePart)
	end
	-- replace with bindAction instead
	-- UserInputService.InputBegan:Connect(function(input, isProcessed)
	-- 	if isProcessed then
	-- 		return
	-- 	end
	-- 	if input.UserInputType == Enum.UserInputType.MouseButton1 then
	-- 		print("SHOOT")
	-- 		Net:Fire("KnifeFire", knifes)
	-- 	end
	-- end)
	print(knifes)
end

function module:Init() end
--#endregion

--#region Listeners

--#endregion
return module
