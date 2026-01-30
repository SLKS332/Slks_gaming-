-- HUTAD HUB | v0.2 FULL | MOBILE DELTA
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HUTAD_HUB"
gui.ResetOnSpawn = false

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,460,0,280)
main.Position = UDim2.new(0.5,-230,0.5,-140)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,32)
title.Text = "HUTAD HUB | v0.2 FULL"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.BorderSizePixel = 0

-- MINIMIZE
local mini = Instance.new("TextButton", title)
mini.Size = UDim2.new(0,32,1,0)
mini.Position = UDim2.new(1,-32,0,0)
mini.Text = "-"
mini.BackgroundTransparency = 1
mini.TextColor3 = Color3.new(1,1,1)

local minimized = false
mini.MouseButton1Click:Connect(function()
	minimized = not minimized
	main.Size = minimized and UDim2.new(0,460,0,32) or UDim2.new(0,460,0,280)
	mini.Text = minimized and "+" or "-"
end)

-- TAB BAR
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(0,120,1,-32)
tabBar.Position = UDim2.new(0,0,0,32)
tabBar.BackgroundColor3 = Color3.fromRGB(25,25,25)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-120,1,-32)
content.Position = UDim2.new(0,120,0,32)
content.BackgroundTransparency = 1

local function newTab()
	local f = Instance.new("Frame", content)
	f.Size = UDim2.new(1,0,1,0)
	f.Visible = false
	f.BackgroundTransparency = 1
	return f
end

local tabUpdate = newTab()
local tabPlayer = newTab()
local tabSetting = newTab()

local function show(tab)
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("Frame") then v.Visible = false end
	end
	tab.Visible = true
end

local function tabBtn(text,y,tab)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	b.MouseButton1Click:Connect(function() show(tab) end)
end

tabBtn("CẬP NHẬT",0,tabUpdate)
tabBtn("PLAYER",40,tabPlayer)
tabBtn("SETTING",80,tabSetting)
show(tabUpdate)

-- UPDATE TAB
local info = Instance.new("TextLabel", tabUpdate)
info.Size = UDim2.new(1,-20,1,-20)
info.Position = UDim2.new(0,10,0,10)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)
info.TextWrapped = true
info.TextYAlignment = Top
info.Text = "- Fly\n- ESP\n- Anti AFK\n\nUser: "..player.Name

-- PLAYER TAB
local fly, esp = false, false
local bv

local flyBtn = Instance.new("TextButton", tabPlayer)
flyBtn.Size = UDim2.new(0,180,0,36)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
	if not fly and bv then bv:Destroy() bv=nil end
end)

RunService.RenderStepped:Connect(function()
	if fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		if not bv then
			bv = Instance.new("BodyVelocity", hrp)
			bv.MaxForce = Vector3.new(1e9,1e9,1e9)
		end
		bv.Velocity = camera.CFrame.LookVector * 50
	end
end)

-- ESP
local espFolder = Instance.new("Folder", gui)

local function addESP(p)
	if p == player then return end
	local bb = Instance.new("BillboardGui", espFolder)
	bb.Adornee = p.Character and p.Character:WaitForChild("Head",3)
	bb.Size = UDim2.new(0,200,0,40)
	bb.AlwaysOnTop = true

	local t = Instance.new("TextLabel", bb)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.TextColor3 = Color3.new(1,1,1)
	t.TextScaled = true

	RunService.RenderStepped:Connect(function()
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local d = (player.Character.HumanoidRootPart.Position -
				p.Character.HumanoidRootPart.Position).Magnitude
			t.Text = p.Name.." ["..math.floor(d).."]"
		end
	end)
end

local espBtn = Instance.new("TextButton", tabPlayer)
espBtn.Size = UDim2.new(0,180,0,36)
espBtn.Position = UDim2.new(0,10,0,55)
espBtn.Text = "ESP: OFF"

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = esp and "ESP: ON" or "ESP: OFF"
	espFolder:ClearAllChildren()
	if esp then
		for _,p in pairs(Players:GetPlayers()) do addESP(p) end
	end
end)

-- SETTING TAB
local anti = true
local afkBtn = Instance.new("TextButton", tabSetting)
afkBtn.Size = UDim2.new(0,200,0,36)
afkBtn.Position = UDim2.new(0,10,0,10)
afkBtn.Text = "Anti AFK: ON"

afkBtn.MouseButton1Click:Connect(function()
	anti = not anti
	afkBtn.Text = anti and "Anti AFK: ON" or "Anti AFK: OFF"
end)

player.Idled:Connect(function()
	if anti then
		VirtualUser:Button2Down(Vector2.new(), camera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(), camera.CFrame)
	end
end)
