-- Jerry Optimize 🔧 v6.2 (Functional Boost FPS & Compact UI)
-- Custom UI Built with Pure Luau

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
    local old = guiParent:FindFirstChild("JerryOptimizeModern")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "JerryOptimizeModern"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

-- States
local isFlying = false

-- Backup original settings for restore
local originalShadows = Lighting.GlobalShadows
local originalTech = Lighting.Technology
local terrain = Workspace:FindFirstChildOfClass("Terrain")
local originalDecoration = false
if terrain then pcall(function() originalDecoration = terrain.Decoration end) end

--=========================================
-- REAL FPS BOOST FUNCTION
--=========================================
local function applyBoost(state)
    if state then
        -- Turn off shadows and use lightweight lighting
        Lighting.GlobalShadows = false
        pcall(function() Lighting.Technology = Enum.LightingTechnology.Compatibility end)
        
        if terrain then
            pcall(function()
                terrain.WaterWaveSize = 0
                terrain.WaterTransparency = 1
                terrain.Decoration = false
            end)
        end
        
        -- Disable heavy particles, trails, beams to boost FPS
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                pcall(function() v.Enabled = false end)
            end
        end
    else
        -- Restore original settings
        Lighting.GlobalShadows = originalShadows
        pcall(function() Lighting.Technology = originalTech end)
        
        if terrain then
            pcall(function()
                terrain.WaterWaveSize = 0.5
                terrain.WaterTransparency = 0.6
                terrain.Decoration = originalDecoration
            end)
        end
        
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                pcall(function() v.Enabled = true end)
            end
        end
    end
end

--=========================================
-- FLOATING OPEN BUTTON (Wrench Icon)
--=========================================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 46, 0, 46)
openBtn.Position = UDim2.new(0, 15, 0.4, -23)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
openBtn.Text = "🔧"
openBtn.TextSize = 22
openBtn.Font = Enum.Font.GothamBold
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.AutoButtonColor = true
openBtn.Parent = gui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(147, 51, 234)
openStroke.Thickness = 2
openStroke.Parent = openBtn

--=========================================
-- MAIN WINDOW (Compact Size: 480 x 330)
--=========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 330)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -165)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 13, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(110, 40, 190)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

--=========================================
-- TOP BAR (Header)
--=========================================
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 250, 0, 20)
titleLabel.Position = UDim2.new(0, 15, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Jerry Optimize 🔧"
titleLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
titleLabel.TextSize = 17
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local subTitle = Instance.new("TextLabel")
subTitle.Size = UDim2.new(0, 250, 0, 15)
subTitle.Position = UDim2.new(0, 15, 0, 24)
subTitle.BackgroundTransparency = 1
subTitle.Text = "Delta Executor Menu (Compact)"
subTitle.TextColor3 = Color3.fromRGB(140, 130, 170)
subTitle.TextSize = 11
subTitle.Font = Enum.Font.Gotham
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.Parent = topBar

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Minimize Button (-)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -68, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

--=========================================
-- SIDEBAR (Left Menu)
--=========================================
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -85)
sidebar.Position = UDim2.new(0, 12, 0, 48)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = sidebar

--=========================================
-- CONTENT CONTAINER (Right Panel)
--=========================================
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -155, 1, -85)
contentContainer.Position = UDim2.new(0, 150, 0, 48)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local pages = {}

local function createPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.Visible = false
    p.Parent = contentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = p
    
    pages[name] = p
    return p
end

local mainPage = createPage("Main")
mainPage.Visible = true
local playerPage = createPage("Player")
local visualsPage = createPage("Visuals")
local worldPage = createPage("World")
local settingsPage = createPage("Settings")
local creditsPage = createPage("Credits")

--=========================================
-- BUILD TABS BUTTONS IN SIDEBAR
--=========================================
local tabButtons = {}

local function createTabButton(name, iconText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    
    if name == "Main" then
        btn.BackgroundColor3 = Color3.fromRGB(126, 34, 206)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
        btn.TextColor3 = Color3.fromRGB(170, 160, 200)
    end
    
    btn.Text = "   " .. iconText .. "  " .. name
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        for tabName, page in pairs(pages) do
            page.Visible = (tabName == name)
        end
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
            b.TextColor3 = Color3.fromRGB(170, 160, 200)
        end
        btn.BackgroundColor3 = Color3.fromRGB(126, 34, 206)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(tabButtons, btn)
end

createTabButton("Main", "🏠")
createTabButton("Player", "👤")
createTabButton("Visuals", "👁️")
createTabButton("World", "🌍")
createTabButton("Settings", "⚙️")
createTabButton("Credits", "ℹ️")

--=========================================
-- POPULATE MAIN PAGE CONTENT
--=========================================
local function createToggleCard(title, desc, initialOn, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    card.Parent = mainPage
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -65, 0, 18)
    titleL.Position = UDim2.new(0, 12, 0, 9)
    titleL.BackgroundTransparency = 1
    titleL.Text = title
    titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleL.TextSize = 13
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.Parent = card
    
    local descL = Instance.new("TextLabel")
    descL.Size = UDim2.new(1, -65, 0, 20)
    descL.Position = UDim2.new(0, 12, 0, 27)
    descL.BackgroundTransparency = 1
    descL.Text = desc
    descL.TextColor3 = Color3.fromRGB(140, 130, 170)
    descL.TextSize = 10
    descL.Font = Enum.Font.Gotham
    descL.TextXAlignment = Enum.TextXAlignment.Left
    descL.Parent = card
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
    
    if initialOn then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(126, 34, 206)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    end
    
    toggleBtn.Text = ""
    toggleBtn.Parent = card
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    
    if initialOn then
        circle.Position = UDim2.new(1, -19, 0.5, -8)
    else
        circle.Position = UDim2.new(0, 3, 0.5, -8)
    end
    
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggleBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local isOn = initialOn
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        local goalPos, goalColor
        if isOn then
            goalPos = UDim2.new(1, -19, 0.5, -8)
            goalColor = Color3.fromRGB(126, 34, 206)
        else
            goalPos = UDim2.new(0, 3, 0.5, -8)
            goalColor = Color3.fromRGB(45, 40, 60)
        end
        
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = goalPos}):Play()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        
        callback(isOn)
    end)
    
    return card
end

-- Connect actual functions
createToggleCard("Optimize", "Optimize rendering and system performance.", false, function(state)
    applyBoost(state)
end)

createToggleCard("Boost FPS", "Boost FPS and reduce lag in game.", false, function(state)
    applyBoost(state)
end)

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, 0, 0, 20)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "💻 System Info"
infoTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
infoTitle.TextSize = 12
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.Parent = mainPage

local statsRow = Instance.new("Frame")
statsRow.Size = UDim2.new(1, -4, 0, 50)
statsRow.BackgroundTransparency = 1
statsRow.Parent = mainPage

local function createStatBox(name, valText, xPos)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0.32, 0, 1, 0)
    box.Position = UDim2.new(xPos, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    box.Parent = statsRow
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    
    local l1 = Instance.new("TextLabel")
    l1.Size = UDim2.new(1, 0, 0, 15)
    l1.Position = UDim2.new(0, 0, 0, 6)
    l1.BackgroundTransparency = 1
    l1.Text = name
    l1.TextColor3 = Color3.fromRGB(140, 130, 170)
    l1.TextSize = 10
    l1.Font = Enum.Font.GothamBold
    l1.Parent = box
    
    local l2 = Instance.new("TextLabel")
    l2.Name = "Value"
    l2.Size = UDim2.new(1, 0, 0, 20)
    l2.Position = UDim2.new(0, 0, 0, 22)
    l2.BackgroundTransparency = 1
    l2.Text = valText
    l2.TextColor3 = Color3.fromRGB(74, 222, 128)
    l2.TextSize = 13
    l2.Font = Enum.Font.GothamBold
    l2.Parent = box
    
    return l2
end

local fpsVal = createStatBox("FPS", "60", 0)
local pingVal = createStatBox("Ping", "50ms", 0.34)
local playersVal = createStatBox("Players", "12", 0.68)

--=========================================
-- PLAYER PAGE
--=========================================
local playerListHeader = Instance.new("TextLabel")
playerListHeader.Size = UDim2.new(1, 0, 0, 20)
playerListHeader.BackgroundTransparency = 1
playerListHeader.Text = "👥 Select a Player to Teleport / Fly"
playerListHeader.TextColor3 = Color3.fromRGB(200, 160, 255)
playerListHeader.TextSize = 12
playerListHeader.Font = Enum.Font.GothamBold
playerListHeader.TextXAlignment = Enum.TextXAlignment.Left
playerListHeader.Parent = playerPage

local scrollPlayers = Instance.new("ScrollingFrame")
scrollPlayers.Size = UDim2.new(1, -4, 0, 130)
scrollPlayers.BackgroundTransparency = 1
scrollPlayers.ScrollBarThickness = 3
scrollPlayers.Parent = playerPage

local pLayout = Instance.new("UIListLayout")
pLayout.Padding = UDim.new(0, 4)
pLayout.Parent = scrollPlayers

local stopFlyBtn = Instance.new("TextButton")
stopFlyBtn.Size = UDim2.new(1, -4, 0, 30)
stopFlyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopFlyBtn.Text = "🛑 Stop Flying"
stopFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopFlyBtn.Font = Enum.Font.GothamBold
stopFlyBtn.TextSize = 12
stopFlyBtn.Visible = false
stopFlyBtn.Parent = playerPage
Instance.new("UICorner", stopFlyBtn).CornerRadius = UDim.new(0, 6)

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
    stopFlyBtn.Visible = false
end

stopFlyBtn.MouseButton1Click:Connect(stopFlying)

local function flyToTarget(targetName)
    local targetPlr = Players:FindFirstChild(targetName)
    if not targetPlr or not targetPlr.Character or not targetPlr.Character:FindFirstChild("HumanoidRootPart") then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = player.Character.HumanoidRootPart
    local targetHrp = targetPlr.Character.HumanoidRootPart

    local distance = (hrp.Position - targetHrp.Position).Magnitude
    local flyTime = math.clamp(distance / 150, 0.5, 5)

    local bv = hrp:FindFirstChild("JerryFlyBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "JerryFlyBV"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
    end
    hrp.Anchored = false

    flyTween = TweenService:Create(hrp, TweenInfo.new(flyTime, Enum.EasingStyle.Linear), {CFrame = targetHrp.CFrame * CFrame.new(0,0,3)})
    isFlying = true
    stopFlyBtn.Visible = true

    noclipLoop = RunService.Stepped:Connect(function()
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end)

    flyTween:Play()
    flyTween.Completed:Connect(function() stopFlying() end)
end

local function loadPlayerList()
    for _, child in pairs(scrollPlayers:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            count += 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
            btn.Text = "        " .. p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 11
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = scrollPlayers
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            local avatar = Instance.new("ImageLabel")
            avatar.Size = UDim2.new(0, 22, 0, 22)
            avatar.Position = UDim2.new(0, 5, 0.5, -11)
            avatar.BackgroundColor3 = Color3.fromRGB(15, 13, 22)
            avatar.Parent = btn
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
            
            task.spawn(function()
                local success, img = pcall(function()
                    return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                end)
                if success and img then avatar.Image = img end
            end)

            btn.MouseButton1Click:Connect(function()
                if not isFlying then flyToTarget(p.Name) end
            end)
        end
    end
    scrollPlayers.CanvasSize = UDim2.new(0, 0, 0, count * 36)
end

loadPlayerList()
Players.PlayerAdded:Connect(loadPlayerList)
Players.PlayerRemoving:Connect(loadPlayerList)

local function setPlaceholder(page, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 35)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(140, 130, 170)
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.Parent = page
end
setPlaceholder(visualsPage, "👁️ Visuals Features coming soon...")
setPlaceholder(worldPage, "🌍 World Features coming soon...")
setPlaceholder(settingsPage, "⚙️ Custom Settings coming soon...")
setPlaceholder(creditsPage, "ℹ️ Jerry Optimize • Built for Delta Executor")

--=========================================
-- FOOTER
--=========================================
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.Text = "Jerry Optimize 🔧 • Compact Edition | Made with ❤️ by Jerry"
footer.TextColor3 = Color3.fromRGB(110, 100, 140)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

--=========================================
-- LIVE STATS
--=========================================
local frames, lastTime = 0, os.clock()
RunService.RenderStepped:Connect(function()
    frames += 1 
    local now = os.clock()
    if now - lastTime >= 1 then
        fpsVal.Text = tostring(frames)
        pingVal.Text = math.floor(player:GetNetworkPing() * 1000) .. "ms"
        playersVal.Text = tostring(#Players:GetPlayers())
        frames = 0 
        lastTime = now
    end
end)

--=========================================
-- DRAGGING LOGIC
--=========================================
local function makeDraggable(guiItem, dragHandle)
    local drag, start, pos, dragged
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag, dragged = true, false 
            start, pos = input.Position, guiItem.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - start
            if delta.Magnitude > 5 then 
                dragged = true 
                guiItem.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y) 
            end
        end
    end)
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            drag = false 
        end
    end)
    return function() return dragged end
end

local isDragged = makeDraggable(openBtn, openBtn)
openBtn.MouseButton1Click:Connect(function() 
    if not isDragged() then 
        mainFrame.Visible = not mainFrame.Visible 
    end 
end)

makeDraggable(mainFrame, topBar)

print("Jerry Optimize 🔧 v6.2 (Compact & Functional) Loaded Successfully!")
