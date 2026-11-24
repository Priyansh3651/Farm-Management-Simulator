-- Place in: StarterPlayer > StarterPlayerScripts
--
-- Plays a multi-panel "comic strip" ending: the camera moves through a
-- series of shots over your farm while story captions fade in and out,
-- comic-book style (white panel, black border, bold caption).
--
-- OPTIONAL polish: create a Folder in Workspace named "EndingCameraPoints"
-- and put Parts inside it named "Shot1", "Shot2", "Shot3", "Shot4", "Shot5"
-- — position/rotate each one wherever you want that panel's camera to look
-- (e.g. a wide shot of the whole farm, a close-up on the grown crops, a
-- shot of the house). If you skip this, the cutscene automatically orbits
-- around your character instead, so it works right out of the box.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local remotesFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local playEnding = remotesFolder:WaitForChild("PlayEndingCutscene")

-- The story, one line per panel. Edit freely, add/remove lines as you like.
local PANELS = {
	"Plant by plant, season by season, the farm came alive.",
	"Every major crop had been grown to full harvest.",
	"The farm's economy started thriving, profits rolling in.",
	"Using those profits, a brand new house was built.",
	"THE END",
}

local SHOT_DURATION = 5     -- seconds each panel's caption stays on screen
local CAMERA_PUSH_TIME = 5  -- seconds of slow push-in during each shot

local function getCameraShots()
	local pointsFolder = Workspace:FindFirstChild("EndingCameraPoints")
	local shots = {}

	if pointsFolder then
		local i = 1
		while true do
			local part = pointsFolder:FindFirstChild("Shot" .. i)
			if not part then break end
			table.insert(shots, part.CFrame)
			i += 1
		end
	end

	if #shots > 0 then
		return shots
	end

	-- Fallback: auto-orbit around the player's character
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local center = root.Position + Vector3.new(0, 3, 0)

	local radius = 25
	local height = 12
	for i = 0, #PANELS - 1 do
		local angle = (i / #PANELS) * math.pi * 2
		local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
		local camPos = center + offset
		table.insert(shots, CFrame.new(camPos, center))
	end

	return shots
end

local function createGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EndingCutsceneGui"
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 100
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local blackout = Instance.new("Frame")
	blackout.Size = UDim2.new(1, 0, 1, 0)
	blackout.BackgroundColor3 = Color3.new(0, 0, 0)
	blackout.BackgroundTransparency = 1
	blackout.ZIndex = 1
	blackout.Parent = screenGui

	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(0, 560, 0, 140)
	panel.AnchorPoint = Vector2.new(0.5, 1)
	panel.Position = UDim2.new(0.5, 0, 1, -60)
	panel.BackgroundColor3 = Color3.new(1, 1, 1)
	panel.BackgroundTransparency = 1
	panel.ZIndex = 2
	panel.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = panel

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 4
	stroke.Color = Color3.new(0, 0, 0)
	stroke.Transparency = 1
	stroke.Parent = panel

	local caption = Instance.new("TextLabel")
	caption.Size = UDim2.new(1, -30, 1, -20)
	caption.Position = UDim2.new(0, 15, 0, 10)
	caption.BackgroundTransparency = 1
	caption.Font = Enum.Font.GothamBlack
	caption.TextColor3 = Color3.new(0, 0, 0)
	caption.TextTransparency = 1
	caption.TextWrapped = true
	caption.TextScaled = true
	caption.Text = ""
	caption.Parent = panel

	return screenGui, blackout, panel, stroke, caption
end

local function fadeProps(tweenTime, targets)
	local firstTween = nil
	for instance, props in pairs(targets) do
		local tween = TweenService:Create(instance, TweenInfo.new(tweenTime, Enum.EasingStyle.Sine), props)
		tween:Play()
		if not firstTween then
			firstTween = tween
		end
	end
	if firstTween then
		firstTween.Completed:Wait()
	end
end

local function lockPlayer(lock)
	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = lock and 0 or 16
		humanoid.JumpPower = lock and 0 or 50
	end
end

local function playCutscene()
	lockPlayer(true)

	local screenGui, blackout, panel, stroke, caption = createGui()
	fadeProps(0.6, { [blackout] = { BackgroundTransparency = 0 } })

	local camera = Workspace.CurrentCamera
	local originalCameraType = camera.CameraType
	camera.CameraType = Enum.CameraType.Scriptable

	local shots = getCameraShots()

	for i, shotCFrame in ipairs(shots) do
		camera.CFrame = shotCFrame

		fadeProps(0.6, {
			[blackout] = { BackgroundTransparency = 1 },
			[panel] = { BackgroundTransparency = 0.1 },
			[stroke] = { Transparency = 0 },
			[caption] = { TextTransparency = 0 },
		})

		caption.Text = PANELS[i] or ""

		local pushTween = TweenService:Create(camera, TweenInfo.new(CAMERA_PUSH_TIME, Enum.EasingStyle.Sine), {
			CFrame = shotCFrame * CFrame.new(0, 0, -2),
		})
		pushTween:Play()

		task.wait(SHOT_DURATION)

		fadeProps(0.5, {
			[panel] = { BackgroundTransparency = 1 },
			[stroke] = { Transparency = 1 },
			[caption] = { TextTransparency = 1 },
		})
		fadeProps(0.4, { [blackout] = { BackgroundTransparency = 0 } })
	end

	task.wait(1.5)

	camera.CameraType = originalCameraType
	lockPlayer(false)
	screenGui:Destroy()
end

playEnding.OnClientEvent:Connect(function()
	playCutscene()
end)
