-- FULL Fly Script Mobile (Buttons)
-- By SLKS Gaming

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
local run = game:GetService("RunService")

local flying = false
local speed = 60
local up = false
local down = false

local bv, bg

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function makeBtn(text, x, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 100, 0, 45)
	b.Position = UDim2.new(0, x, 0, y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.BorderSizePixel = 0
	b.Parent = gui
	return b
end

local flyBtn = makeBtn("FLY", 20, 300)
local upBtn  = makeBtn("UP", 20, 250)
local dnBtn  = makeBtn("DOWN", 20, 350)

-- Fly functions
local function startFly()
	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	flying = true
	flyBtn.Text = "STOP"
end

local function stopFly()
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	flying = false
	flyBtn.Text = "FLY"
end

flyBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

upBtn.MouseButton1Down:Connect(function()
	up = true
end)
upBtn.MouseButton1Up:Connect(function()
	up = false
end)

dnBtn.MouseButton1Down:Connect(function()
	down = true
end)
dnBtn.MouseButton1Up:Connect(function()
	down = false
end)

run.RenderStepped:Connect(function()
	if flying and bv and bg then
		local dir = cam.CFrame.LookVector * speed
		if up then
			dir = dir + Vector3.new(0, speed, 0)
		end
		if down then
			dir = dir - Vector3.new(0, speed, 0)
		end
		bv.Velocity = dir
		bg.CFrame = cam.CFrame
	end
end)
