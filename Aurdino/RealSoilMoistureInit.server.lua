-- Place in: ServerScriptService
-- Starts the RealSoilMoisture polling loop when the game starts.

local RealSoilMoisture = require(game:GetService("ServerScriptService"):WaitForChild("RealSoilMoisture"))

RealSoilMoisture.Start()
