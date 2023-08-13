-- !strict
-- Services
local ContextActionService = game:GetService('ContextActionService');
-- Enums
-- Variables
local players = game:GetService("Players");
local abilities = {}
-- Functions
local function playerAdded(player : Player)

end
-- Listeners

players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        for _, basePart in character:GetDescendants() do
            if basePart:IsA("BasePart") then
                basePart.Massless = true;
            end
        end
    end)
end)

tool.Equipped:Connect(function(mouse)
    for name, module in pairs(abilities) do
        ContextActionService:BindAction(name,
                                        function(actionName, inputState,
                                                 inputObject)
            module:Activate(mouse, actionName, inputState, inputObject)
        end, false, module.KEYBIND)
    end
end)
tool.Unequipped:Connect(function(mouse)
    for name, module in pairs(abilities) do
        ContextActionService:UnbindAction(name)
    end
end)

for _, module in script:GetChildren() do
    abilities[module.Name] = require(module)
    abilities[module.Name]:Init()
end

