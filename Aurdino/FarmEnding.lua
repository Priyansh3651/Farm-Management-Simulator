-- Place in: ServerScriptService (as a ModuleScript named "FarmEnding")
-- Call FarmEnding.TriggerEnding(player) from wherever your game logic
-- detects the win condition (e.g. all 6 crops grown/harvested).

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "RemoteEvents"
	remotesFolder.Parent = ReplicatedStorage
end

local playEnding = remotesFolder:FindFirstChild("PlayEndingCutscene")
if not playEnding then
	playEnding = Instance.new("RemoteEvent")
	playEnding.Name = "PlayEndingCutscene"
	playEnding.Parent = remotesFolder
end

local FarmEnding = {}

function FarmEnding.TriggerEnding(player)
	playEnding:FireClient(player)
end

return FarmEnding
