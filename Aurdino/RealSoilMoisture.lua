-- Place in: ServerScriptService (as a ModuleScript named "RealSoilMoisture")
-- Polls your Adafruit IO feed for the latest real-world soil moisture
-- reading and makes it available to any other server script.
--
-- Requires: Game Settings > Security > "Allow HTTP Requests" = ON

local HttpService = game:GetService("HttpService")

local RealSoilMoisture = {}
RealSoilMoisture.CurrentValue = 50 -- default until the first successful fetch

-- ---- FILL THESE IN ----
local AIO_USERNAME = "your_adafruit_username"
local AIO_KEY = "your_aio_key"
local FEED_NAME = "soil-moisture"
local POLL_INTERVAL = 10 -- seconds between fetches
-- ------------------------

local url = "https://io.adafruit.com/api/v2/" .. AIO_USERNAME .. "/feeds/" .. FEED_NAME .. "/data/last"

local function fetchMoisture()
	local success, result = pcall(function()
		return HttpService:GetAsync(url, false, {
			["X-AIO-Key"] = AIO_KEY,
		})
	end)

	if not success then
		warn("RealSoilMoisture: request failed - " .. tostring(result))
		return
	end

	local decodeOk, data = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	if decodeOk and data and data.value then
		local value = tonumber(data.value)
		if value then
			RealSoilMoisture.CurrentValue = value
		end
	end
end

-- Call this once from a startup script to begin polling.
function RealSoilMoisture.Start()
	fetchMoisture()
	task.spawn(function()
		while true do
			task.wait(POLL_INTERVAL)
			fetchMoisture()
		end
	end)
end

-- Call this from anywhere to get the latest known reading (0-100).
function RealSoilMoisture.GetValue()
	return RealSoilMoisture.CurrentValue
end

return RealSoilMoisture
