-- Drop this into your FarmingSystem.server.lua

-- 1. At the top of the script, require the module:
local RealSoilMoisture = require(game:GetService("ServerScriptService"):WaitForChild("RealSoilMoisture"))

-- 2. Where you currently use a fixed GROW_TIME, replace it with a function
--    that checks the real-world moisture and speeds up / slows down growth:

local BASE_GROW_TIME = 30 -- your normal grow time in seconds

local function getGrowTime()
	local moisture = RealSoilMoisture.GetValue() -- 0-100

	if moisture >= 60 then
		return BASE_GROW_TIME * 0.6   -- well-watered real plant -> 40% faster growth
	elseif moisture <= 20 then
		return BASE_GROW_TIME * 1.8   -- dry real plant -> much slower growth
	else
		return BASE_GROW_TIME          -- normal
	end
end

-- 3. Then, wherever you currently do:
--      task.delay(GROW_TIME, function() ... end)
--    change it to:
--      task.delay(getGrowTime(), function() ... end)
