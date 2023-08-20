local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

-- Here we load a file just like in the first example
local file = fs.readFile("oldworld.rbxl")
local game = roblox.deserializePlace(file)
local workspace = game:GetService("Workspace")

-- Make sure a directory exists to save our models in
fs.writeDir("assets/Workspace")

-- -- Then we save all of our instances in Workspace as model files, in our new directory
-- -- Note that a model file can actually contain several instances at once, so we pass a table here
for _, child in workspace:GetChildren() do
	file = roblox.serializeModel({ child })
	print(child.Name)
	fs.writeFile("assets/Workspace/" .. child.Name .. ".rbxm", file)
end
