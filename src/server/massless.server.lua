-- Services
local players = game:GetService("Players")

-- Enums
-- Variables
-- Functions
-- Listeners

players.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(character)
		for _, basePart in character:GetDescendants() do
			if basePart:IsA("BasePart") then
				basePart.Massless = true
			end
		end
	end)
end)
