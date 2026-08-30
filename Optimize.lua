-- Jerry Optimize 🔧 v4.7 (Fixed UDim2.fromOffset Compatibility for Mobile Executors)
-- Performance Optimizer & Player Tracker

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Fix for Executors like Delta, Fluxus
local guiParent
if gethui then
    local success, res = pcall(function() return gethui() end)
    if success and res then guiParent = res end
end

if not guiParent then
    local success, _ = pcall(function() guiParent = game:GetService("CoreGui") end)
    if not success or not guiParent then
        guiParent = player:WaitForChild("PlayerGui")
    end
end

pcall(function()
    local old = guiParent:FindFirstChild("JerryOptimize")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "JerryOptimize"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

-- State
local optimizeOn = false
local boostOn = false
local isFlying = false
local customAssetPath = ""
local buttonImages = {}

-- Original settings
local originalShadows = Lighting.GlobalShadows
local terrain = Workspace:FindFirstChildOfClass("Terrain")
local originalDecoration = false
if terrain then pcall(function() originalDecoration = terrain.Decoration end) end

local effects = {}
for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then effects[v] = v.Enabled end
end

-- Open button (Icon 🔧)
local open = Instance.new("TextButton")
open.Size = UDim2.new(0, 50, 0, 50)
open.Position = UDim2.new(0, 15, 0.5, -25)
open.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
open.Text = "🔧"
open.TextSize = 25
open.Font = Enum.Font.GothamBold
open.TextColor3 = Color3.new(1, 1, 1)
open.AutoButtonColor = true
open.Parent = gui
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = open

-- Main menu
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 360, 0, 360) 
menu.Position = UDim2.new(0.5, -180, 0.5, -180)
menu.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
menu.BorderSizePixel = 0
menu.Visible = false 
menu.ClipsDescendants = true
menu.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = menu

--=========================================
-- ដាក់ Background Image ពី GitHub Raw Link របស់អ្នក
--=========================================
local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.ImageTransparency = 0.4
bgImage.ScaleType = Enum.ScaleType.Slice
bgImage.Parent = menu

task.spawn(function()
    pcall(function()
        if writefile and getcustomasset and game:HttpGet then
            local githubRawUrl = "https://raw.githubusercontent.com/jerryop9999-lgtm/Optimize-/refs/heads/main/6cb3179d9f63187af83a92c38eaa9d2e.webp.jpg"
            
            local success, response = pcall(function()
                return game:HttpGet(githubRawUrl)
            end)
            
            if success and response and not response:find("<!DOCTYPE html>") then
                local fileName = "JerryBg_" .. math.random(1000, 9999) .. ".png"
                writefile(fileName, response)
                customAssetPath = getcustomasset(fileName)
                
                bgImage.Image = customAssetPath
                
                for _, btn in ipairs(buttonImages) do
                    if btn and btn.Parent then
                        btn.Image = customAssetPath
                    end
                end
            end
        end
    end)
end)

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -20, 0, 48)
header.Position = UDim2.new(0, 10, 0, 5)
header.BackgroundTransparency = 1
header.Text = "Jerry Optimize 🔧 v4.7"
header.TextColor3 = Color3.fromRGB(255, 215, 0)
header.TextSize = 22
header.Font = Enum.Font.GothamBold
header.ZIndex = 2
header.Parent = menu

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 25)
status.Position = UDim2.new(0, 15, 0, 52)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.ZIndex = 2
status.Parent = menu

-- FPS
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -30, 0, 25)
fpsLabel.Position = UDim2.new(0, 15, 0, 76)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.TextSize = 14
fpsLabel.Font = Enum.Font.GothamSemibold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.ZIndex = 2
fpsLabel.Parent = menu

-- មុខងារបង្កើតប៊ូតុង
local function makeButton(text, y, parent)
    local b = Instance.new("ImageButton")
    b.Size = UDim2.new(1, -40, 0, 50)
    b.Position = UDim2.new(0, 20, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel = 0
    b.Image = customAssetPath
    b.ImageTransparency = 0.3
    b.ScaleType = Enum.ScaleType.Slice
    b.AutoButtonColor = true
    b.ZIndex = 2
    b.Parent = parent or menu
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = b
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.TextSize = 16
    txt.Font = Enum.Font.GothamSemibold
    txt.ZIndex = 3
    txt.Parent = b
    
    table.insert(buttonImages, b)
    return b
end

local optimizeButton = makeButton("Normal Optimize  [OFF]", 105)
local boostButton = makeButton("MAX FPS BOOST  [OFF]", 165)
boostButton:FindFirstChildOfClass("TextLabel").TextColor3 = Color3.fromRGB(255, 100, 100)
local tpMenuButton = makeButton("🎯 Open Player List", 225)
local stopFlyButton = makeButton("🛑 Stop Flying", 285)
stopFlyButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
stopFlyButton.Visible = false

--=========================================
-- Player List Menu (ទំហំ 300x300)
--=========================================
local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(0, 300, 0, 300)
tpFrame.Position = UDim2.new(1, 10, 0, 0)
tpFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
tpFrame.BackgroundTransparency = 0.1
tpFrame.BorderSizePixel = 0
tpFrame.Visible = false
tpFrame.ClipsDescendants = true
tpFrame.ZIndex = 3
tpFrame.Parent = menu
local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 16)
tpCorner.Parent = tpFrame

local tpBgImage = Instance.new("ImageLabel")
tpBgImage.Size = UDim2.new(1, 0, 1, 0)
tpBgImage.BackgroundTransparency = 1
tpBgImage.ImageTransparency = 0.4
tpBgImage.ZIndex = 3
tpBgImage.Parent = tpFrame

task.spawn(function()
    while customAssetPath == "" do task.wait(0.1) end
    tpBgImage.Image = customAssetPath
end)

local tpHeader = Instance.new("TextLabel")
tpHeader.Size = UDim2.new(1, -20, 0, 40)
tpHeader.Position = UDim2.new(0, 10, 0, 5)
tpHeader.BackgroundTransparency = 1
tpHeader.Text = "👥 Select a Player"
tpHeader.TextColor3 = Color3.fromRGB(100, 200, 255)
tpHeader.TextSize = 17
tpHeader.Font = Enum.Font.GothamBold
tpHeader.ZIndex = 4
tpHeader.Parent = tpFrame

local refreshBtn = Instance.new("ImageButton")
refreshBtn.Size = UDim2.new(0, 70, 0, 26)
refreshBtn.Position = UDim2.new(1, -80, 0, 12)
refreshBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
refreshBtn.BackgroundTransparency = 0.3
refreshBtn.BorderSizePixel = 0
refreshBtn.Image = customAssetPath
refreshBtn.ImageTransparency = 0.3
refreshBtn.ZIndex = 4
refreshBtn.Parent = tpFrame
local refCorner = Instance.new("UICorner")
refCorner.CornerRadius = UDim.new(0, 6)
refCorner.Parent = refreshBtn

local refTxt = Instance.new("TextLabel")
refTxt.Size = UDim2.new(1, 0, 1, 0)
refTxt.BackgroundTransparency = 1
refTxt.Text = "Refresh"
refTxt.TextColor3 = Color3.new(1,1,1)
refTxt.Font = Enum.Font.GothamBold
refTxt.TextSize = 11
refTxt.ZIndex = 5
refTxt.Parent = refreshBtn
table.insert(buttonImages, refreshBtn)

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, -16, 1, -55)
scrollList.Position = UDim2.new(0, 8, 0, 48)
scrollList.BackgroundTransparency = 1
scrollList.ScrollBarThickness = 5
scrollList.ZIndex = 4
scrollList.Parent = tpFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollList

tpMenuButton.MouseButton1Click:Connect(function()
    tpFrame.Visible = not tpFrame.Visible
end)

--=========================================
-- Fly Bypass Logic
--=========================================
local flyTween, noclipLoop

local function stopFlying()
    if flyTween then flyTween:Cancel() flyTween = nil end
    if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local bv = hrp:FindFirstChild("JerryFlyBV")
        if bv then bv:Destroy() end
        hrp.Anchored = false 
    end
    isFlying = false
    stopFlyButton.Visible = false
    status.Text = "Status: Flight Stopped."
end

local function flyToTarget(targetName)
    local targetPlr = Players:FindFirstChild(targetName)
    if not targetPlr or not targetPlr.Character or not targetPlr.Character:FindFirstChild("HumanoidRootPart") then 
        status.Text = "Status: Player not found or dead!"
        return 
    end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = player.Character.HumanoidRootPart
    local targetHrp = targetPlr.Character.HumanoidRootPart

    local distance = (hrp.Position - targetHrp.Position).Magnitude
    local speed = 150 
    local flyTime = distance / speed
    if flyTime < 0.5 then flyTime = 0.5 end 

    local bv = hrp:FindFirstChild("JerryFlyBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "JerryFlyBV"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
    end
    hrp.Anchored = false

    local tweenInfo = TweenInfo.new(flyTime, Enum.EasingStyle.Linear)
    local targetGoal = targetHrp.CFrame * CFrame.new(0, 0, 3) 
    flyTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetGoal})

    isFlying = true
    stopFlyButton.Visible = true
    
    noclipLoop = RunService.Stepped:Connect(function()
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)

    status.Text = "Status: Flying to " .. targetName .. "..."
    flyTween:Play()

    flyTween.Completed:Connect(function(playbackState)
        if playbackState == Enum.PlaybackState.Completed then
            stopFlying()
            status.Text = "Status: Arrived at " .. targetName
        end
    end)
end

stopFlyButton.MouseButton1Click:Connect(stopFlying)

local function loadPlayers()
    for _, child in pairs(scrollList:GetChildren()) do
        if child:IsA("ImageButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            count += 1
            local btn = Instance.new("ImageButton")
            btn.Size = UDim2.new(1, -8, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Image = customAssetPath
            btn.ImageTransparency = 0.3
            btn.ZIndex = 5
            btn.Parent = scrollList
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn

            local btnTxt = Instance.new("TextLabel")
            btnTxt.Size = UDim2.new(1, 0, 1, 0)
            btnTxt.BackgroundTransparency = 1
            btnTxt.Text = "            " .. p.Name .. " (@" .. p.DisplayName .. ")"
            btnTxt.TextColor3 = Color3.new(1,1,1)
            btnTxt.Font = Enum.Font.GothamSemibold
            btnTxt.TextSize = 11
            btnTxt.TextXAlignment = Enum.TextXAlignment.Left
            btnTxt.ZIndex = 6
            btnTxt.Parent = btn

            local avatar = Instance.new("ImageLabel")
            avatar.Size = UDim2.new(0, 28, 0, 28)
            avatar.Position = UDim2.new(0, 4, 0.5, -14)
            avatar.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
            avatar.ZIndex = 6
            avatar.Parent = btn
            
            local avatarCorner = Instance.new("UICorner")
            avatarCorner.CornerRadius = UDim.new(1, 0)
            avatarCorner.Parent = avatar
            
            task.spawn(function()
                local success, img = pcall(function()
                    return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                end)
                if success and img then
                    avatar.Image = img
                end
            end)

            table.insert(buttonImages, btn)

            btn.MouseButton1Click:Connect(function()
                if not isFlying then
                    flyToTarget(p.Name)
                end
            end)
        end
    end
    scrollList.CanvasSize = UDim2.new(0, 0, 0, count * 40)
end

refreshBtn.MouseButton1Click:Connect(loadPlayers)
loadPlayers()

-- Optimize Logic
local function applyOptimize()
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() if terrain then terrain.Decoration = false end end)
    for effect, _ in pairs(effects) do
        pcall(function() if effect.Parent then effect.Enabled = false end end)
    end
end
local function restoreOptimize()
    pcall(function() Lighting.GlobalShadows = originalShadows end)
    pcall(function() if terrain then terrain.Decoration = originalDecoration end end)
    for effect, enabled in pairs(effects) do
        pcall(function() if effect.Parent then effect.Enabled = enabled end end)
    end
end

optimizeButton.MouseButton1Click:Connect(function()
    optimizeOn = not optimizeOn
    local txtLabel = optimizeButton:FindFirstChildOfClass("TextLabel")
    if optimizeOn then
        applyOptimize()
        txtLabel.Text = "Normal Optimize  [ON]"
        optimizeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        status.Text = "Status: Optimized"
    else
        restoreOptimize()
        txtLabel.Text = "Normal Optimize  [OFF]"
        optimizeButton.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
        status.Text = "Status: Ready"
    end
end)

boostButton.MouseButton1Click:Connect(function()
    local txtLabel = boostButton:FindFirstChildOfClass("TextLabel")
    if not boostOn then
        boostOn = true
        txtLabel.Text = "MAX FPS BOOST  [ON]"
        boostButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "Status: Applying MAX Boost..."
        task.wait(0.1)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false Lighting.FogEnd = 9e9
            Lighting.Brightness = 1 Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        end)
        task.spawn(function()
            local c = 0
            for _, obj in pairs(Workspace:GetDescendants()) do
                c += 1 if c % 1000 == 0 then task.wait() end
                if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic obj.Reflectance = 0 obj.CastShadow = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
                    pcall(function() obj.Transparency = 1 end) pcall(function() obj.Enabled = false end)
                end
            end
            status.Text = "Status: MAX FPS BOOST ACTIVE!"
        end)
    else
        status.Text = "Status: Rejoin to disable MAX Boost!"
        task.wait(2) status.Text = "Status: MAX FPS BOOST ACTIVE!"
    end
end)

-- FPS Counter
local frames, lastTime = 0, os.clock()
RunService.RenderStepped:Connect(function()
    frames += 1 local now = os.clock()
    if now - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. frames
        frames = 0 lastTime = now
    end
end)

-- Dragging Logic
local function makeDraggable(guiItem, dragHandle)
    local drag, start, pos, dragged
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag, dragged = true, false start, pos = input.Position, guiItem.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - start
            if delta.Magnitude > 5 then dragged = true guiItem.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y) end
        end
    end)
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    return function() return dragged end
end

local isBtnDragged = makeDraggable(open, open)
open.MouseButton1Click:Connect(function() if not isBtnDragged() then menu.Visible = not menu.Visible end end)
makeDraggable(menu, header)

UIS.InputBegan:Connect(function(input, p)
    if not p and input.KeyCode == Enum.KeyCode.K then menu.Visible = not menu.Visible end
end)

print("Jerry Optimize 🔧 v4.7 Loaded Successfully!")
