-- // Kali AiPad OS // v5.9 // executor // TikTok mini-serials
print("[Kali] start")

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

-- CLEANUP
local PG = LP:WaitForChild("PlayerGui")
for _, v in ipairs(PG:GetChildren()) do
    if v.Name == "KaliAiPadOS" or v.Name == "KaliAiPadUI" or v.Name == "KaliInventory" then
        v:Destroy()
    end
end
for _, v in ipairs(LP.Backpack:GetChildren()) do if v.Name == "Kali Ai Pad" then v:Destroy() end end
if LP.Character then
    for _, v in ipairs(LP.Character:GetChildren()) do
        if v.Name == "Kali Ai Pad" then v:Destroy() end
    end
end

-- STATE
_G.KaliAiPad = _G.KaliAiPad or {}
_G.KaliAiPad.settings = _G.KaliAiPad.settings or {
    accent = {0,255,150}, wallpaper = 1, brightness = 100, transparency = 10, clickSound = true,
}
_G.KaliAiPad.binds = _G.KaliAiPad.binds or {}
_G.KaliAiPad.positions = _G.KaliAiPad.positions or {}
_G.KaliAiPad.powered = true
_G.KaliAiPad.registry = {}

local themeElements = {}
local function registerTheme(el, kind) table.insert(themeElements, {element=el, kind=kind}) end
local function accent()
    local s = _G.KaliAiPad.settings.accent
    return Color3.fromRGB(s[1], s[2], s[3])
end
local function applyTheme()
    local col = accent()
    for _, item in ipairs(themeElements) do
        if item.element and item.element.Parent then
            pcall(function()
                if item.kind == "text" then item.element.TextColor3 = col
                elseif item.kind == "bg" then item.element.BackgroundColor3 = col
                elseif item.kind == "stroke" then item.element.Color = col
                elseif item.kind == "scroll" then item.element.ScrollBarImageColor3 = col
                end
            end)
        end
    end
end

local WALLPAPERS = {
    {{0,45,28},{0,12,8},{0,70,45}}, {{35,10,50},{8,0,20},{60,20,80}},
    {{50,25,10},{15,5,0},{80,40,15}}, {{5,25,50},{0,5,20},{10,45,75}},
    {{55,5,25},{20,0,10},{80,15,40}}, {{25,25,25},{10,10,10},{40,40,40}},
    {{10,40,40},{5,15,15},{20,60,60}}, {{40,10,10},{15,5,5},{60,20,20}},
}

-- TOOL
local Tool = Instance.new("Tool")
Tool.Name = "Kali AiPad"
Tool.RequiresHandle = true
Tool.CanBeDropped = false
local Handle = Instance.new("Part")
Handle.Name = "Handle"
Handle.Size = Vector3.new(1.3, 0.06, 1.9)
Handle.Color = Color3.fromRGB(12, 12, 12)
Handle.CanCollide = false
Handle.Massless = true
Handle.Parent = Tool
local ScreenPart = Instance.new("Part")
ScreenPart.Size = Vector3.new(1.15, 0.02, 1.7)
ScreenPart.Material = Enum.Material.Neon
ScreenPart.Color = Color3.fromRGB(0, 180, 110)
ScreenPart.CanCollide = false
ScreenPart.Massless = true
ScreenPart.Parent = Tool
local w1 = Instance.new("WeldConstraint", Handle)
w1.Part0 = Handle w1.Part1 = ScreenPart
Tool.Parent = LP.Backpack

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaliAiPadOS"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = true
ScreenGui.Parent = PG

local function playClick()
    if not _G.KaliAiPad.settings.clickSound then return end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://9125402735"
    s.Volume = 0.3
    s.Parent = ScreenGui
    s:Play()
    Debris:AddItem(s, 1)
end

-- BODY
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.AnchorPoint = Vector2.new(0.5, 0.5)
Body.Size = UDim2.new(0, 1100, 0, 740)
Body.Position = UDim2.new(0.5, 0, 0.5, 0)
Body.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Body.BorderSizePixel = 0
Body.Parent = ScreenGui
Instance.new("UICorner", Body).CornerRadius = UDim.new(0, 46)
local bodyGrad = Instance.new("UIGradient", Body)
bodyGrad.Rotation = 120
bodyGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(42,42,48)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18,18,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50,50,56)),
}
local bodyStroke = Instance.new("UIStroke", Body)
bodyStroke.Color = Color3.fromRGB(75, 75, 82)
bodyStroke.Thickness = 3

local function makePhysBtn(name, anchor, pos, size)
    local b = Instance.new("TextButton", Body)
    b.Name = name
    b.AnchorPoint = anchor
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    b.Text = ""
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(80, 80, 88)
    s.Thickness = 1
    return b
end

local physPower = makePhysBtn("PhysPower", Vector2.new(1,0), UDim2.new(1,18,0,20), UDim2.new(0,22,0,60))
local physVolUp = makePhysBtn("VolUp", Vector2.new(0,0), UDim2.new(0,-18,0,30), UDim2.new(0,20,0,46))
local physVolDown = makePhysBtn("VolDown", Vector2.new(0,0), UDim2.new(0,-18,0,86), UDim2.new(0,20,0,46))

local camPimple = Instance.new("Frame", Body)
camPimple.AnchorPoint = Vector2.new(0.5, 0)
camPimple.Position = UDim2.new(0.5, 0, 0, 6)
camPimple.Size = UDim2.new(0, 8, 0, 8)
camPimple.BackgroundColor3 = Color3.fromRGB(25,25,28)
camPimple.BorderSizePixel = 0
Instance.new("UICorner", camPimple).CornerRadius = UDim.new(1, 0)

local Screen = Instance.new("Frame")
Screen.AnchorPoint = Vector2.new(0.5, 0.5)
Screen.Position = UDim2.new(0.5, 0, 0.5, 0)
Screen.Size = UDim2.new(1, -50, 1, -50)
Screen.BackgroundColor3 = Color3.fromRGB(4, 8, 6)
Screen.BorderSizePixel = 0
Screen.ClipsDescendants = true
Screen.Parent = Body
Instance.new("UICorner", Screen).CornerRadius = UDim.new(0, 34)

local OffLayer = Instance.new("Frame", Screen)
OffLayer.Size = UDim2.new(1,0,1,0)
OffLayer.BackgroundColor3 = Color3.fromRGB(0,0,0)
OffLayer.BorderSizePixel = 0
OffLayer.Visible = false
OffLayer.ZIndex = 50
Instance.new("UICorner", OffLayer).CornerRadius = UDim.new(0, 34)
local OffHint = Instance.new("TextLabel", OffLayer)
OffHint.AnchorPoint = Vector2.new(0.5,0.5)
OffHint.Position = UDim2.new(0.5,0,0.5,0)
OffHint.Size = UDim2.new(1,0,0,60)
OffHint.BackgroundTransparency = 1
OffHint.Text = "выключено\nнажми боковую кнопку справа"
OffHint.TextColor3 = Color3.fromRGB(50,70,60)
OffHint.Font = Enum.Font.Gotham
OffHint.TextSize = 16

local BootLayer = Instance.new("Frame", Screen)
BootLayer.Size = UDim2.new(1,0,1,0)
BootLayer.BackgroundColor3 = Color3.fromRGB(0,0,0)
BootLayer.BorderSizePixel = 0
BootLayer.Visible = false
BootLayer.ZIndex = 40
Instance.new("UICorner", BootLayer).CornerRadius = UDim.new(0, 34)

local bootLogo = Instance.new("TextLabel", BootLayer)
bootLogo.AnchorPoint = Vector2.new(0.5,0.5)
bootLogo.Position = UDim2.new(0.5,0,0.42,0)
bootLogo.Size = UDim2.new(1,0,0,90)
bootLogo.BackgroundTransparency = 1
bootLogo.Text = "Kali AiPad"
bootLogo.TextColor3 = accent()
bootLogo.Font = Enum.Font.GothamBold
bootLogo.TextSize = 82
registerTheme(bootLogo, "text")

local bootSub = Instance.new("TextLabel", BootLayer)
bootSub.AnchorPoint = Vector2.new(0.5,0.5)
bootSub.Position = UDim2.new(0.5,0,0.42,84)
bootSub.Size = UDim2.new(1,0,0,24)
bootSub.BackgroundTransparency = 1
bootSub.Text = "os v5.9 • by Bean & Jack"
bootSub.TextColor3 = Color3.fromRGB(120,180,150)
bootSub.Font = Enum.Font.Gotham
bootSub.TextSize = 14

local bootBarBg = Instance.new("Frame", BootLayer)
bootBarBg.AnchorPoint = Vector2.new(0.5,0.5)
bootBarBg.Position = UDim2.new(0.5,0,0.62,0)
bootBarBg.Size = UDim2.new(0,340,0,6)
bootBarBg.BackgroundColor3 = Color3.fromRGB(25,35,30)
bootBarBg.BorderSizePixel = 0
Instance.new("UICorner", bootBarBg).CornerRadius = UDim.new(1,0)

local bootBarFill = Instance.new("Frame", bootBarBg)
bootBarFill.Size = UDim2.new(0,0,1,0)
bootBarFill.BackgroundColor3 = accent()
bootBarFill.BorderSizePixel = 0
Instance.new("UICorner", bootBarFill).CornerRadius = UDim.new(1,0)
registerTheme(bootBarFill, "bg")

local Desktop = Instance.new("Frame", Screen)
Desktop.Size = UDim2.new(1,0,1,0)
Desktop.BackgroundTransparency = 1
Desktop.ZIndex = 1

local wp = Instance.new("Frame", Desktop)
wp.Size = UDim2.new(1,0,1,0)
wp.BackgroundColor3 = Color3.fromRGB(6,10,8)
wp.BorderSizePixel = 0
local wpGrad = Instance.new("UIGradient", wp)
wpGrad.Rotation = 135
local function applyWallpaper()
    local W = WALLPAPERS[_G.KaliAiPad.settings.wallpaper] or WALLPAPERS[1]
    wpGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(W[1][1], W[1][2], W[1][3])),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(W[2][1], W[2][2], W[2][3])),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(W[3][1], W[3][2], W[3][3])),
    }
end
applyWallpaper()

local BrightOverlay = Instance.new("Frame", Desktop)
BrightOverlay.Size = UDim2.new(1,0,1,0)
BrightOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
BrightOverlay.BorderSizePixel = 0
BrightOverlay.ZIndex = 60
BrightOverlay.Active = false
local function applyBrightness()
    local b = math.clamp(_G.KaliAiPad.settings.brightness / 100, 0, 1)
    BrightOverlay.BackgroundTransparency = b
end
applyBrightness()

local StatusBar = Instance.new("Frame", Desktop)
StatusBar.Size = UDim2.new(1,0,0,40)
StatusBar.BackgroundTransparency = 1

local TimeLbl = Instance.new("TextLabel", StatusBar)
TimeLbl.Position = UDim2.new(0,30,0,0)
TimeLbl.Size = UDim2.new(0,120,1,0)
TimeLbl.BackgroundTransparency = 1
TimeLbl.Text = "00:00"
TimeLbl.TextColor3 = Color3.fromRGB(255,255,255)
TimeLbl.Font = Enum.Font.GothamMedium
TimeLbl.TextSize = 16
TimeLbl.TextXAlignment = Enum.TextXAlignment.Left
task.spawn(function()
    while TimeLbl.Parent do TimeLbl.Text = os.date("%H:%M") task.wait(5) end
end)

local batt = Instance.new("Frame", StatusBar)
batt.AnchorPoint = Vector2.new(1,0.5)
batt.Position = UDim2.new(1,-30,0.5,0)
batt.Size = UDim2.new(0,26,0,13)
batt.BackgroundColor3 = Color3.fromRGB(255,255,255)
batt.BackgroundTransparency = 0.4
batt.BorderSizePixel = 0
Instance.new("UICorner", batt).CornerRadius = UDim.new(0,3)
local bf = Instance.new("Frame", batt)
bf.Size = UDim2.new(0.85,0,1,-4)
bf.Position = UDim2.new(0,2,0,2)
bf.BackgroundColor3 = accent()
bf.BorderSizePixel = 0
Instance.new("UICorner", bf).CornerRadius = UDim.new(0,2)
registerTheme(bf, "bg")

local MainScreen = Instance.new("Frame", Desktop)
MainScreen.Position = UDim2.new(0,0,0,40)
MainScreen.Size = UDim2.new(1,0,1,-40)
MainScreen.BackgroundTransparency = 1

local LeftPanel = Instance.new("Frame", MainScreen)
LeftPanel.Size = UDim2.new(0.4,0,1,0)
LeftPanel.BackgroundTransparency = 1

local Header = Instance.new("TextLabel", LeftPanel)
Header.Position = UDim2.new(0,28,0,8)
Header.Size = UDim2.new(1,-52,0,44)
Header.BackgroundTransparency = 1
Header.Text = "Kali AiPad"
Header.TextColor3 = Color3.fromRGB(255,255,255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 38
Header.TextXAlignment = Enum.TextXAlignment.Left

local SubHeader = Instance.new("TextLabel", LeftPanel)
SubHeader.Position = UDim2.new(0,28,0,54)
SubHeader.Size = UDim2.new(1,-52,0,20)
SubHeader.BackgroundTransparency = 1
SubHeader.Text = "os v5.9 • by Bean & Jack"
SubHeader.TextColor3 = accent()
SubHeader.Font = Enum.Font.Gotham
SubHeader.TextSize = 13
SubHeader.TextXAlignment = Enum.TextXAlignment.Left
registerTheme(SubHeader, "text")

local GridScroll = Instance.new("ScrollingFrame", LeftPanel)
GridScroll.Position = UDim2.new(0,20,0,92)
GridScroll.Size = UDim2.new(1,-40,1,-240)
GridScroll.BackgroundTransparency = 1
GridScroll.BorderSizePixel = 0
GridScroll.ScrollBarThickness = 4
GridScroll.ScrollBarImageColor3 = accent()
GridScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
GridScroll.CanvasSize = UDim2.new(0,0,0,0)
registerTheme(GridScroll, "scroll")

local gridL = Instance.new("UIGridLayout", GridScroll)
gridL.CellSize = UDim2.new(0, 100, 0, 128)
gridL.CellPadding = UDim2.new(0, 10, 0, 14)
gridL.SortOrder = Enum.SortOrder.LayoutOrder

local appOrder = 0
local function makeApp(name, icon, color, cb)
    appOrder = appOrder + 1
    local App = Instance.new("TextButton")
    App.Size = UDim2.new(0, 100, 0, 128)
    App.BackgroundTransparency = 1
    App.Text = ""
    App.AutoButtonColor = false
    App.LayoutOrder = appOrder
    App.Parent = GridScroll

    local Icon = Instance.new("Frame", App)
    Icon.AnchorPoint = Vector2.new(0.5,0)
    Icon.Position = UDim2.new(0.5,0,0,0)
    Icon.Size = UDim2.new(0, 90, 0, 90)
    Icon.BackgroundColor3 = color
    Icon.BorderSizePixel = 0
    Instance.new("UICorner", Icon).CornerRadius = UDim.new(0, 22)

    local ig = Instance.new("UIGradient", Icon)
    ig.Rotation = 135
    ig.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,180)),
    }
    ig.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.75),
        NumberSequenceKeypoint.new(1, 0.95),
    }

    local g = Instance.new("TextLabel", Icon)
    g.Size = UDim2.new(1,0,1,0)
    g.BackgroundTransparency = 1
    g.Text = icon
    g.TextColor3 = Color3.fromRGB(255,255,255)
    g.Font = Enum.Font.GothamBold
    g.TextSize = 40

    local L = Instance.new("TextLabel", App)
    L.Position = UDim2.new(0,0,0,96)
    L.Size = UDim2.new(1,0,0,18)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(255,255,255)
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 11

    App.MouseButton1Click:Connect(function()
        playClick()
        Tween:Create(Icon, TweenInfo.new(0.08), {Size = UDim2.new(0,80,0,80)}):Play()
        task.wait(0.08)
        Tween:Create(Icon, TweenInfo.new(0.15), {Size = UDim2.new(0,90,0,90)}):Play()
        if cb then cb() end
    end)
    return App
end

local Dock = Instance.new("Frame", LeftPanel)
Dock.AnchorPoint = Vector2.new(0.5,1)
Dock.Position = UDim2.new(0.5,0,1,-16)
Dock.Size = UDim2.new(0,360,0,76)
Dock.BackgroundColor3 = Color3.fromRGB(255,255,255)
Dock.BackgroundTransparency = 0.82
Dock.BorderSizePixel = 0
Instance.new("UICorner", Dock).CornerRadius = UDim.new(0,22)
local dL = Instance.new("UIListLayout", Dock)
dL.FillDirection = Enum.FillDirection.Horizontal
dL.HorizontalAlignment = Enum.HorizontalAlignment.Center
dL.VerticalAlignment = Enum.VerticalAlignment.Center
dL.Padding = UDim.new(0,12)

local function makeDockApp(glyph, color, cb)
    local b = Instance.new("TextButton", Dock)
    b.Size = UDim2.new(0,52,0,52)
    b.BackgroundColor3 = color
    b.Text = ""
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
    local g = Instance.new("TextLabel", b)
    g.Size = UDim2.new(1,0,1,0)
    g.BackgroundTransparency = 1
    g.Text = glyph
    g.TextColor3 = Color3.fromRGB(255,255,255)
    g.Font = Enum.Font.GothamBold
    g.TextSize = 24
    b.MouseButton1Click:Connect(function() playClick() if cb then cb() end end)
end

local RightPanel = Instance.new("Frame", MainScreen)
RightPanel.AnchorPoint = Vector2.new(1,0)
RightPanel.Position = UDim2.new(1,0,0,0)
RightPanel.Size = UDim2.new(0.6,0,1,0)
RightPanel.BackgroundTransparency = 1

local allWins = {}
local function closeAllWins(except)
    for _, w in ipairs(allWins) do
        if w ~= except then w.Visible = false end
    end
end

local function makeWin(title)
    local Win = Instance.new("Frame")
    Win.Position = UDim2.new(0,10,0,10)
    Win.Size = UDim2.new(1,-20,1,-20)
    Win.BackgroundColor3 = Color3.fromRGB(10,14,12)
    Win.BackgroundTransparency = _G.KaliAiPad.settings.transparency / 100
    Win.BorderSizePixel = 0
    Win.Visible = false
    Win.Parent = RightPanel
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0,22)
    table.insert(allWins, Win)

    local h = Instance.new("Frame", Win)
    h.Size = UDim2.new(1,0,0,60)
    h.BackgroundColor3 = Color3.fromRGB(0,35,25)
    h.BackgroundTransparency = 0.3
    h.BorderSizePixel = 0
    Instance.new("UICorner", h).CornerRadius = UDim.new(0,22)

    local t = Instance.new("TextLabel", Win)
    t.Position = UDim2.new(0,18,0,8)
    t.Size = UDim2.new(0.78,0,0,44)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 20
    t.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("TextButton", Win)
    c.AnchorPoint = Vector2.new(1,0)
    c.Position = UDim2.new(1,-16,0,16)
    c.Size = UDim2.new(0,30,0,30)
    c.BackgroundColor3 = Color3.fromRGB(200,60,60)
    c.Text = "×"
    c.TextColor3 = Color3.fromRGB(255,255,255)
    c.Font = Enum.Font.GothamBold
    c.TextSize = 18
    c.BorderSizePixel = 0
    Instance.new("UICorner", c).CornerRadius = UDim.new(1,0)
    c.MouseButton1Click:Connect(function() playClick() Win.Visible = false end)

    local scroll = Instance.new("ScrollingFrame", Win)
    scroll.Position = UDim2.new(0,12,0,72)
    scroll.Size = UDim2.new(1,-24,1,-84)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = accent()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    registerTheme(scroll, "scroll")
    local l = Instance.new("UIListLayout", scroll)
    l.Padding = UDim.new(0,8)
    l.SortOrder = Enum.SortOrder.LayoutOrder

    return Win, scroll
end

local function makeCard(parent, height, order)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1,-10,0,height)
    card.BackgroundColor3 = Color3.fromRGB(20,26,22)
    card.BackgroundTransparency = _G.KaliAiPad.settings.transparency / 100
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)
    return card
end

-- ============================================
-- FLING v4
-- ============================================
local OldFPDH = workspace.FallenPartsDestroyHeight
local flinging = {}

local function SkidFling(TargetPlayer)
    if not TargetPlayer then return end
    if TargetPlayer == LP then return end
    if flinging[TargetPlayer] then return end
    flinging[TargetPlayer] = true
    
    local Character = LP.Character
    if not Character then flinging[TargetPlayer] = nil return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    if not (Humanoid and RootPart and TCharacter) then flinging[TargetPlayer] = nil return end
    
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    if not THumanoid then flinging[TargetPlayer] = nil return end
    local TRootPart = THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local AccessoryHandle = Accessory and Accessory:FindFirstChild("Handle")
    
    if THumanoid.Sit then flinging[TargetPlayer] = nil return end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then flinging[TargetPlayer] = nil return end
    
    local OldPos = RootPart.CFrame
    
    local function FPos(BasePart, Pos, Ang)
        if not RootPart or not RootPart.Parent then return end
        if not Character or not Character.Parent then return end
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        pcall(function() Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang) end)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    
    local function SFBasePart(BasePart)
        local TimeToWait = 0.4
        local Start = tick()
        local Angle = 0
        repeat
            if not (RootPart and RootPart.Parent) then break end
            if not THumanoid or not THumanoid.Parent then break end
            if BasePart.Velocity.Magnitude < 50 then
                Angle = Angle + 100
                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
            else
                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                task.wait()
            end
        until (tick() - Start > TimeToWait)
    end
    
    local prevFPDH = workspace.FallenPartsDestroyHeight
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    
    local BV = Instance.new("BodyVelocity")
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    pcall(function() Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)
    
    if TRootPart then SFBasePart(TRootPart)
    elseif THead then SFBasePart(THead)
    elseif AccessoryHandle then SFBasePart(AccessoryHandle) end
    
    if BV then BV:Destroy() end
    pcall(function() Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)
    
    if RootPart and RootPart.Parent and Character and Character.Parent then
        local sStart = tick()
        repeat
            if not RootPart or not RootPart.Parent then break end
            RootPart.CFrame = OldPos * CFrame.new(0, .5, 0)
            pcall(function() Character:SetPrimaryPartCFrame(OldPos * CFrame.new(0, .5, 0)) end)
            pcall(function() Humanoid:ChangeState("GettingUp") end)
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - OldPos.p).Magnitude < 25 or (tick() - sStart > 1.5)
    end
    pcall(function() workspace.FallenPartsDestroyHeight = prevFPDH end)
    
    task.wait(0.3)
    flinging[TargetPlayer] = nil
end

local flingAuraConn
local function applyFlingAura(on)
    if on then
        flingAuraConn = RunService.Heartbeat:Connect(function()
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character ~= c then
                    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        local d = (tHRP.Position - hrp.Position).Magnitude
                        if d < 4 then
                            task.spawn(function() pcall(SkidFling, plr) end)
                        end
                    end
                end
            end
        end)
    else
        if flingAuraConn then flingAuraConn:Disconnect() flingAuraConn=nil end
    end
end

local flingNormalConn
local function applyFlingNormal(on)
    if on then
        flingNormalConn = RunService.Heartbeat:Connect(function()
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character ~= c then
                    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        local d = (tHRP.Position - hrp.Position).Magnitude
                        if d < 8 then
                            task.spawn(function() pcall(SkidFling, plr) end)
                        end
                    end
                end
            end
        end)
    else
        if flingNormalConn then flingNormalConn:Disconnect() flingNormalConn=nil end
    end
end

local function flingNearest()
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local nearest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character ~= c then
            local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                local d = (tHRP.Position - hrp.Position).Magnitude
                if d < dist then dist = d nearest = plr end
            end
        end
    end
    if nearest then task.spawn(function() pcall(SkidFling, nearest) end) end
end

local function flingAll()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character ~= LP.Character then
            task.spawn(function() pcall(SkidFling, plr) end)
            task.wait(0.2)
        end
    end
end

-- ===== ФУНКЦИИ =====
local functionRegistry = {}
local keybinds = {}
local awaitingBind = nil
_G.KaliAiPad.registry = functionRegistry

local flyState = {vel=nil, gyro=nil, conn=nil}
local function applyFly(on)
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if on then
        hum.PlatformStand = true
        local v = Instance.new("BodyVelocity", hrp)
        v.Name = "KaliFlyVel"
        v.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        v.Velocity = Vector3.new(0,0,0)
        local g = Instance.new("BodyGyro", hrp)
        g.Name = "KaliFlyGyro"
        g.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
        g.P = 1000
        g.CFrame = hrp.CFrame
        flyState.vel = v
        flyState.gyro = g
        flyState.conn = RunService.RenderStepped:Connect(function()
            if not hrp.Parent or not flyState.vel then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            local spd = 80
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then spd = 160 end
            flyState.vel.Velocity = dir.Magnitude > 0 and dir.Unit * spd or Vector3.new(0,0,0)
            flyState.gyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        end)
    else
        if flyState.vel then flyState.vel:Destroy() flyState.vel=nil end
        if flyState.gyro then flyState.gyro:Destroy() flyState.gyro=nil end
        if flyState.conn then flyState.conn:Disconnect() flyState.conn=nil end
        hum.PlatformStand = false
    end
end

local infJumpConn
local function applyInfJump(on)
    if on then
        infJumpConn = UIS.JumpRequest:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() infJumpConn=nil end
    end
end

local noclipConn
local function applyNoclip(on)
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            if LP.Character then
                for _, p in ipairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn=nil end
    end
end

local origLighting
local function applyFullbright(on)
    if on then
        origLighting = {a=Lighting.Ambient, oa=Lighting.OutdoorAmbient, b=Lighting.Brightness, ct=Lighting.ClockTime, fe=Lighting.FogEnd}
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.FogEnd = 1e6
    else
        if origLighting then
            Lighting.Ambient = origLighting.a
            Lighting.OutdoorAmbient = origLighting.oa
            Lighting.Brightness = origLighting.b
            Lighting.ClockTime = origLighting.ct
            Lighting.FogEnd = origLighting.fe
        end
    end
end

local godConn
local function applyGod(on)
    if on then
        godConn = RunService.Heartbeat:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = hum.MaxHealth end
        end)
    else
        if godConn then godConn:Disconnect() godConn=nil end
    end
end

local antiAfkConn
local function applyAntiAfk(on)
    if on then
        antiAfkConn = LP.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn=nil end
    end
end

local function applySpeed(on)
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = on and 100 or 16 end
end

local function applyJump(on)
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = on and 150 or 50 end
end

local espActive = false
local function applyESP(on)
    espActive = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hl = Instance.new("Highlight", plr.Character)
                hl.Name = "KaliESP_HL"
                hl.FillColor = accent()
                hl.FillTransparency = 0.6
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local h = plr.Character:FindFirstChild("KaliESP_HL")
                if h then h:Destroy() end
            end
        end
    end
end

local autoFarmConn
local function applyAutoFarm(on)
    if on then
        autoFarmConn = RunService.Heartbeat:Connect(function()
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("collect") or obj.Name:lower():find("coin") or obj.Name:lower():find("drop")) then
                    hrp.CFrame = obj.CFrame + Vector3.new(0,3,0)
                    break
                end
            end
        end)
    else
        if autoFarmConn then autoFarmConn:Disconnect() autoFarmConn=nil end
    end
end

local auraConn
local function applyAura(on)
    if on then
        auraConn = RunService.Heartbeat:Connect(function()
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
                    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHum and tHRP then
                        if (tHRP.Position - hrp.Position).Magnitude < 8 then
                            tHum.Health = 0
                        end
                    end
                end
            end
        end)
    else
        if auraConn then auraConn:Disconnect() auraConn=nil end
    end
end

local invisConn
local function applyInvisible(on)
    local c = LP.Character
    if not c then return end
    if on then
        invisConn = RunService.Heartbeat:Connect(function()
            local char = LP.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.Transparency = 1
                end
            end
        end)
    else
        if invisConn then invisConn:Disconnect() invisConn=nil end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                if p.Name == "HumanoidRootPart" then p.Transparency = 1
                else p.Transparency = 0 end
            end
        end
    end
end

local yieldConn
local function applyInfiniteYield(on)
    if on then
        yieldConn = RunService.Stepped:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        end)
    else
        if yieldConn then yieldConn:Disconnect() yieldConn=nil end
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end

local antiFlingConn
local function applyAntiFling(on)
    if on then
        antiFlingConn = RunService.Stepped:Connect(function()
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, v in ipairs(hrp:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") 
                   or v:IsA("BodyGyro") or v:IsA("BodyThrust") 
                   or v:IsA("BodyForce") or v:IsA("BodyPosition") then
                    if v.Name ~= "KaliFlyVel" and v.Name ~= "KaliFlyGyro" then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
            if hrp.AssemblyLinearVelocity.Magnitude > 80 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y * 0.1, 0)
            end
            if hrp.AssemblyAngularVelocity.Magnitude > 30 then
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.PlatformStand then
                    local flyEntry = functionRegistry["fly"]
                    if not (flyEntry and flyEntry.enabled) then
                        hum.PlatformStand = false
                    end
                end
                if hum:GetState() == Enum.HumanoidStateType.Physics then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                if hum.WalkSpeed < 1 then hum.WalkSpeed = 16 end
                if hum.JumpPower < 1 then hum.JumpPower = 50 end
            end
        end)
    else
        if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn=nil end
    end
end

local function teleportAllToMe()
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then tHRP.CFrame = hrp.CFrame * CFrame.new(0,0,-4) end
        end
    end
end

local function registerFn(id, name, desc, icon, fn)
    functionRegistry[id] = {id=id, name=name, desc=desc, icon=icon, enabled=false, keybind=nil, toggleFn=fn}
end

registerFn("fly", "Fly", "WASD + Space/Ctrl", "✈", applyFly)
registerFn("speed", "Speed", "скорость 100", "⚡", applySpeed)
registerFn("infjump", "Infinite Jump", "беск. прыжок", "↑", applyInfJump)
registerFn("noclip", "Noclip", "сквозь стены", "◯", applyNoclip)
registerFn("fullbright", "Fullbright", "убрать тьму", "☀", applyFullbright)
registerFn("god", "God Mode", "бессмертие", "♥", applyGod)
registerFn("antiafk", "Anti-AFK", "не кикнет", "💤", applyAntiAfk)
registerFn("jump", "High Jump", "прыжок x3", "⇧", applyJump)
registerFn("esp", "ESP", "подсветка игроков", "👁", applyESP)
registerFn("autofarm", "Auto Farm", "сбор предметов", "🌾", applyAutoFarm)
registerFn("aura", "Kill Aura", "убить в радиусе", "💀", applyAura)
registerFn("invisible", "Invisible", "невидимость для себя", "👻", applyInvisible)
registerFn("yield", "Infinite Yield", "физ. состояние", "🧲", applyInfiniteYield)
registerFn("flingaura", "Touch Fling", "касание = отброс", "👆", applyFlingAura)
registerFn("flingnormal", "Fling Radius 8", "отброс в радиусе 8", "🌀", applyFlingNormal)
registerFn("antifling", "Anti-Fling", "защита от флинга", "🛡", applyAntiFling)

local function teleport(target)
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local tC = target.Character
    if not tC then return end
    local tHRP = tC:FindFirstChild("HumanoidRootPart")
    if hrp and tHRP then hrp.CFrame = tHRP.CFrame * CFrame.new(0,0,-3) end
end

-- ===== ОКНА =====
local BingWin, bScroll = makeWin("🎯 Bing Hack Tools")
local HackWin, hScroll = makeWin("⚡ Hack Tools")
local SetWin, setScroll = makeWin("⚙ Settings")
local PiWin, piScroll = makeWin("👤 Player Info")
local SiWin, siScroll = makeWin("🌐 Server Info")
local PosWin, posScroll = makeWin("📌 Positions")
local PowWin = makeWin("⏻ Power")
local TikTokWin = makeWin("📱 TikTok")

-- ============================================
-- TIKTOK с мини-сериалами
-- ============================================
for _, c in ipairs(TikTokWin:GetChildren()) do
    if c:IsA("ScrollingFrame") then c:Destroy() end
end

local tiktokFeed = Instance.new("ScrollingFrame", TikTokWin)
tiktokFeed.Position = UDim2.new(0, 0, 0, 60)
tiktokFeed.Size = UDim2.new(1, 0, 1, -60)
tiktokFeed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tiktokFeed.BorderSizePixel = 0
tiktokFeed.ScrollBarThickness = 0
tiktokFeed.AutomaticCanvasSize = Enum.AutomaticSize.Y
tiktokFeed.CanvasSize = UDim2.new(0, 0, 0, 0)
tiktokFeed.ScrollingDirection = Enum.ScrollingDirection.Y
Instance.new("UICorner", tiktokFeed).CornerRadius = UDim.new(0, 22)

local ttLayout = Instance.new("UIListLayout", tiktokFeed)
ttLayout.SortOrder = Enum.SortOrder.LayoutOrder
ttLayout.Padding = UDim.new(0, 0)

local currentTikTokSound = nil
local function stopTikTokSound()
    if currentTikTokSound then
        pcall(function() currentTikTokSound:Stop() end)
        pcall(function() currentTikTokSound:Destroy() end)
        currentTikTokSound = nil
    end
end

local videoHeight = 560

local tiktokVideos = {
    {
        user="@c_drama_king", desc="💰 МИЛЛИАРДЕР ПОЛЮБИЛ УБОРЩИЦУ | Серия 1 #cdrama #китай #любовь",
        likes="4.2M", comments="88K", shares="210K",
        music="китайская драма — саундтрек",
        soundId="rbxassetid://1837879082",
        frames = {
            {bg={Color3.fromRGB(60,10,20), Color3.fromRGB(120,20,40)}, emoji="🏢", title="КИТАЙСКИЙ МИЛЛИАРДЕР", sub="Серия 1: случайная встреча"},
            {bg={Color3.fromRGB(80,20,30), Color3.fromRGB(140,40,60)}, emoji="🧹", title="Она — простая уборщица", sub="работает в его офисе"},
            {bg={Color3.fromRGB(100,30,40), Color3.fromRGB(160,50,80)}, emoji="💼", title="Он — владелец корпорации", sub="¥ 8,000,000,000 на счету"},
            {bg={Color3.fromRGB(120,40,60), Color3.fromRGB(180,60,100)}, emoji="👁", title="Их взгляды встретились...", sub="«кто это?» — подумал он"},
            {bg={Color3.fromRGB(140,50,70), Color3.fromRGB(200,80,120)}, emoji="💗", title="Он влюбился с первого взгляда", sub="продолжение в серии 2..."},
        },
    },
    {
        user="@shaolin_master", desc="🐉 УЧЕНИК ПОБЕДИЛ МАСТЕРА КУНГ-ФУ #kungfu #боевик #китай",
        likes="2.8M", comments="42K", shares="120K",
        music="восточный барабан — epic",
        soundId="rbxassetid://1843773157",
        frames = {
            {bg={Color3.fromRGB(20,30,10), Color3.fromRGB(50,80,20)}, emoji="⛩", title="ШАОЛИНЬ. 3-Й ДЕНЬ ОБУЧЕНИЯ", sub="мастер сказал: «ты не готов»"},
            {bg={Color3.fromRGB(30,40,15), Color3.fromRGB(70,100,30)}, emoji="🥋", title="«ВСТАВАЙ И СРАЖАЙСЯ!»", sub="его удары летели со всех сторон"},
            {bg={Color3.fromRGB(40,50,20), Color3.fromRGB(90,120,40)}, emoji="👊", title="Ученик собрал силы...", sub="«х-х-а-а!»"},
            {bg={Color3.fromRGB(60,70,30), Color3.fromRGB(120,150,50)}, emoji="💥", title="ОДНИМ УДАРОМ — МАСТЕР ПАЛ", sub="«ты... стал сильнее...»"},
            {bg={Color3.fromRGB(80,90,40), Color3.fromRGB(150,180,60)}, emoji="🐲", title="НОВАЯ ЛЕГЕНДА НАЧАЛАСЬ", sub="серия 2 скоро..."},
        },
    },
    {
        user="@china_history", desc="👑 ИМПЕРАТОР ПРИЗВАЛ ДРАКОНА #китай #история #дракон",
        likes="3.1M", comments="56K", shares="180K",
        music="традиционный гуцинь",
        soundId="rbxassetid://1836315523",
        frames = {
            {bg={Color3.fromRGB(80,40,10), Color3.fromRGB(160,80,20)}, emoji="🏯", title="ЗАПРЕТНЫЙ ГОРОД, 1420 год", sub="император молил о помощи"},
            {bg={Color3.fromRGB(100,50,15), Color3.fromRGB(180,100,30)}, emoji="👑", title="«О дракон, услышь меня!»", sub="— сказал император в храме"},
            {bg={Color3.fromRGB(120,60,20), Color3.fromRGB(200,120,40)}, emoji="🐲", title="НЕБО РАЗВЕРЗЛОСЬ", sub="гигантский дракон спускался"},
            {bg={Color3.fromRGB(140,70,25), Color3.fromRGB(220,140,50)}, emoji="⚡", title="«ЧЕГО ТЫ ХОЧЕШЬ, СМЕРТНЫЙ?»", sub="голос сотрясал землю"},
            {bg={Color3.fromRGB(160,80,30), Color3.fromRGB(240,160,60)}, emoji="🗡", title="«Мир. Или я разрушу трон»", sub="окончание в финале..."},
        },
    },
    {
        user="@cat_money", desc="😹 КОТ-МИЛЛИОНЕР И ЕГО РАБ #комедия #смешно #китай",
        likes="5.6M", comments="120K", shares="340K",
        music="смешная китайская музыка",
        soundId="rbxassetid://904700482",
        frames = {
            {bg={Color3.fromRGB(50,50,50), Color3.fromRGB(100,100,100)}, emoji="🐱", title="КОТ-МИЛЛИОНЕР В КИТАЕ", sub="у него 3000 работников"},
            {bg={Color3.fromRGB(60,60,60), Color3.fromRGB(120,120,120)}, emoji="🧑‍💼", title="«БОСС, я готов!»", sub="сказал новый работник"},
            {bg={Color3.fromRGB(70,70,70), Color3.fromRGB(140,140,140)}, emoji="🐾", title="Кот поднял лапу...", sub="«Мяу». — «Что это значит?»"},
            {bg={Color3.fromRGB(80,80,80), Color3.fromRGB(160,160,160)}, emoji="💰", title="«Твоя зарплата — 5 рыб»", sub="работник в шоке"},
            {bg={Color3.fromRGB(90,90,90), Color3.fromRGB(180,180,180)}, emoji="😂", title="ОН СОГЛАСИЛСЯ", sub="потому что работа — мечта"},
        },
    },
    {
        user="@c_horror", desc="👻 ОНА ВЕРНУЛАСЬ ЧЕРЕЗ 1000 ЛЕТ #хоррор #китай",
        likes="3.4M", comments="72K", shares="150K",
        music="страшная китайская музыка",
        soundId="rbxassetid://1836315523",
        frames = {
            {bg={Color3.fromRGB(10,0,20), Color3.fromRGB(30,5,50)}, emoji="🌑", title="1000 ЛЕТ НАЗАД ОНА УМЕРЛА", sub="но дух вернулся..."},
            {bg={Color3.fromRGB(15,5,25), Color3.fromRGB(40,10,60)}, emoji="🕯", title="МОНАХ ЗАЖЁГ СВЕЧУ", sub="«что-то не так...»"},
            {bg={Color3.fromRGB(20,10,30), Color3.fromRGB(50,15,70)}, emoji="👤", title="В ДВЕРЯХ СТОЯЛА ТЕНЬ", sub="но у неё не было ног"},
            {bg={Color3.fromRGB(25,15,35), Color3.fromRGB(60,20,80)}, emoji="👻", title="«Я ВЕРНУЛАСЬ...»", sub="прошептала она"},
            {bg={Color3.fromRGB(30,20,40), Color3.fromRGB(70,25,90)}, emoji="💀", title="СТРАХ ТОЛЬКО НАЧАЛСЯ", sub="серия 2 скоро..."},
        },
    },
    {
        user="@metro_love", desc="🚇 СУДЬБА В МЕТРО #романтика #любовь #китай",
        likes="1.9M", comments="28K", shares="72K",
        music="romantic китайская скрипка",
        soundId="rbxassetid://1837824724",
        frames = {
            {bg={Color3.fromRGB(40,20,60), Color3.fromRGB(80,40,120)}, emoji="🚇", title="ПЕКИН, ЧАС ПИК", sub="два незнакомца в вагоне"},
            {bg={Color3.fromRGB(60,30,80), Color3.fromRGB(100,50,140)}, emoji="📱", title="Она уронила телефон", sub="он его поймал"},
            {bg={Color3.fromRGB(80,40,100), Color3.fromRGB(120,60,160)}, emoji="👀", title="«Спасибо...»", sub="их глаза встретились"},
            {bg={Color3.fromRGB(100,50,120), Color3.fromRGB(140,70,180)}, emoji="💞", title="«Может, кофе?»", sub="она улыбнулась"},
            {bg={Color3.fromRGB(120,60,140), Color3.fromRGB(160,80,200)}, emoji="☕", title="ГОД СПУСТЯ — СВАДЬБА", sub="тот день изменил всё"},
        },
    },
    {
        user="@hk_action", desc="🔫 ОН БЫЛ И ТО И ТО #боевик #экшн #китай",
        likes="2.2M", comments="34K", shares="88K",
        music="hardcore китайский рэп",
        soundId="rbxassetid://1843773157",
        frames = {
            {bg={Color3.fromRGB(15,15,25), Color3.fromRGB(40,40,60)}, emoji="🏙", title="ГОНКОНГ, НОЧЬ", sub="двойная игра началась"},
            {bg={Color3.fromRGB(25,25,35), Color3.fromRGB(60,60,80)}, emoji="🕵", title="«Я полицейский», — сказал он", sub="смотря боссу в глаза"},
            {bg={Color3.fromRGB(35,35,45), Color3.fromRGB(80,80,100)}, emoji="🔫", title="«Я знаю», — ответил босс", sub="и улыбнулся"},
            {bg={Color3.fromRGB(45,45,55), Color3.fromRGB(100,100,120)}, emoji="💥", title="ПЕРЕСТРЕЛКА НАЧАЛАСЬ", sub="никто не выйдет живым"},
            {bg={Color3.fromRGB(55,55,65), Color3.fromRGB(120,120,140)}, emoji="🎬", title="ФИНАЛ В СЛЕДУЮЩЕЙ СЕРИИ", sub="..."},
        },
    },
    {
        user="@china_tech", desc="😂 МАМА УЗНАЛА ПРО VPN #смешно #китай #мем",
        likes="6.7M", comments="180K", shares="500K",
        music="funny drill",
        soundId="rbxassetid://904700482",
        frames = {
            {bg={Color3.fromRGB(40,30,20), Color3.fromRGB(80,60,40)}, emoji="🧑‍💻", title="СИЖУ В ИНТЕРНЕТЕ ЧЕРЕЗ VPN", sub="думал мама не узнает"},
            {bg={Color3.fromRGB(60,40,30), Color3.fromRGB(100,80,50)}, emoji="👩", title="МАМА: «А ЭТО ЧТО ЗА ПРИЛОЖЕНИЕ?»", sub="я в холодном поту"},
            {bg={Color3.fromRGB(80,50,40), Color3.fromRGB(120,100,60)}, emoji="😰", title="«Э-э-э... ЭТО ДЛЯ УЧЁБЫ»", sub="мама не верит"},
            {bg={Color3.fromRGB(100,60,50), Color3.fromRGB(140,120,70)}, emoji="📞", title="МАМА ЗВОНИТ В ПОЛИЦИЮ", sub="«алло, тут сын что-то делает»"},
            {bg={Color3.fromRGB(120,70,60), Color3.fromRGB(160,140,80)}, emoji="🚔", title="ФИНАЛ...", sub="продолжение в следующем видео 💀"},
        },
    },
}

local function makeTikTokVideo(vid)
    local videoFrame = Instance.new("Frame", tiktokFeed)
    videoFrame.Size = UDim2.new(1, 0, 0, videoHeight)
    videoFrame.BackgroundColor3 = vid.frames[1].bg[1]
    videoFrame.BorderSizePixel = 0
    videoFrame.ClipsDescendants = true
    
    local vgrad = Instance.new("UIGradient", videoFrame)
    vgrad.Rotation = 90
    vgrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, vid.frames[1].bg[1]),
        ColorSequenceKeypoint.new(1, vid.frames[1].bg[2]),
    }
    
    local bgDecor = Instance.new("Frame", videoFrame)
    bgDecor.Size = UDim2.new(1, 0, 1, 0)
    bgDecor.BackgroundTransparency = 1
    bgDecor.ClipsDescendants = true
    local bgDots = {}
    for d = 1, 20 do
        local dot = Instance.new("Frame", bgDecor)
        dot.Size = UDim2.new(0, 4, 0, 4)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BackgroundTransparency = 0.7
        dot.BorderSizePixel = 0
        dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        table.insert(bgDots, dot)
    end
    
    local centerEmoji = Instance.new("TextLabel", videoFrame)
    centerEmoji.AnchorPoint = Vector2.new(0.5, 0.5)
    centerEmoji.Position = UDim2.new(0.5, 0, 0.35, 0)
    centerEmoji.Size = UDim2.new(0, 200, 0, 200)
    centerEmoji.BackgroundTransparency = 1
    centerEmoji.Text = vid.frames[1].emoji
    centerEmoji.TextColor3 = Color3.fromRGB(255, 255, 255)
    centerEmoji.Font = Enum.Font.GothamBold
    centerEmoji.TextSize = 160
    centerEmoji.TextStrokeTransparency = 0.3
    centerEmoji.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local titleLbl = Instance.new("TextLabel", videoFrame)
    titleLbl.Position = UDim2.new(0, 30, 0, 60)
    titleLbl.Size = UDim2.new(1, -60, 0, 60)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = vid.frames[1].title
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 22
    titleLbl.TextWrapped = true
    titleLbl.TextStrokeTransparency = 0.3
    titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center
    
    local subLbl = Instance.new("TextLabel", videoFrame)
    subLbl.Position = UDim2.new(0, 40, 0.5, 30)
    subLbl.Size = UDim2.new(1, -80, 0, 40)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = vid.frames[1].sub
    subLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 16
    subLbl.TextWrapped = true
    subLbl.TextStrokeTransparency = 0.4
    subLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local liveLbl = Instance.new("TextLabel", videoFrame)
    liveLbl.Position = UDim2.new(0, 16, 0, 8)
    liveLbl.Size = UDim2.new(0, 60, 0, 24)
    liveLbl.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    liveLbl.Text = "LIVE"
    liveLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    liveLbl.Font = Enum.Font.GothamBold
    liveLbl.TextSize = 11
    liveLbl.BorderSizePixel = 0
    Instance.new("UICorner", liveLbl).CornerRadius = UDim.new(1, 0)
    
    local userLbl = Instance.new("TextLabel", videoFrame)
    userLbl.Position = UDim2.new(0, 20, 1, -160)
    userLbl.Size = UDim2.new(0.7, 0, 0, 26)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = vid.user
    userLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    userLbl.Font = Enum.Font.GothamBold
    userLbl.TextSize = 20
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.TextStrokeTransparency = 0.4
    
    local descLbl = Instance.new("TextLabel", videoFrame)
    descLbl.Position = UDim2.new(0, 20, 1, -130)
    descLbl.Size = UDim2.new(0.72, 0, 0, 50)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = vid.desc
    descLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 13
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.TextWrapped = true
    descLbl.TextStrokeTransparency = 0.5
    
    local musicLbl = Instance.new("TextLabel", videoFrame)
    musicLbl.Position = UDim2.new(0, 20, 1, -70)
    musicLbl.Size = UDim2.new(0.72, 0, 0, 20)
    musicLbl.BackgroundTransparency = 1
    musicLbl.Text = "🎵 " .. vid.music
    musicLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    musicLbl.Font = Enum.Font.Gotham
    musicLbl.TextSize = 12
    musicLbl.TextXAlignment = Enum.TextXAlignment.Left
    musicLbl.TextStrokeTransparency = 0.5
    
    local progressBg = Instance.new("Frame", videoFrame)
    progressBg.AnchorPoint = Vector2.new(0.5, 1)
    progressBg.Position = UDim2.new(0.5, 0, 1, -8)
    progressBg.Size = UDim2.new(1, -40, 0, 3)
    progressBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    progressBg.BorderSizePixel = 0
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)
    
    local progressFill = Instance.new("Frame", progressBg)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressFill.BorderSizePixel = 0
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    
    local rightPanel = Instance.new("Frame", videoFrame)
    rightPanel.AnchorPoint = Vector2.new(1, 1)
    rightPanel.Position = UDim2.new(1, -12, 1, -30)
    rightPanel.Size = UDim2.new(0, 70, 0, 300)
    rightPanel.BackgroundTransparency = 1
    
    local function makeActionButton(glyph, label, yPos, isLiked)
        local c = Instance.new("Frame", rightPanel)
        c.Position = UDim2.new(0, 0, 0, yPos)
        c.Size = UDim2.new(1, 0, 0, 62)
        c.BackgroundTransparency = 1
        
        local ic = Instance.new("TextLabel", c)
        ic.Size = UDim2.new(1, 0, 0, 44)
        ic.BackgroundTransparency = 1
        ic.Text = glyph
        ic.TextColor3 = isLiked and Color3.fromRGB(255, 60, 100) or Color3.fromRGB(255, 255, 255)
        ic.Font = Enum.Font.GothamBold
        ic.TextSize = 38
        ic.TextStrokeTransparency = 0.5
        
        local lb = Instance.new("TextLabel", c)
        lb.Position = UDim2.new(0, 0, 0, 44)
        lb.Size = UDim2.new(1, 0, 0, 18)
        lb.BackgroundTransparency = 1
        lb.Text = label
        lb.TextColor3 = Color3.fromRGB(255, 255, 255)
        lb.Font = Enum.Font.GothamBold
        lb.TextSize = 12
        lb.TextStrokeTransparency = 0.5
        
        return ic, lb
    end
    
    local likeIcon, likeLbl = makeActionButton("❤", vid.likes, 0, true)
    local cmtIcon, cmtLbl = makeActionButton("💬", vid.comments, 70, false)
    local shrIcon, shrLbl = makeActionButton("↗", vid.shares, 140, false)
    local _, musLbl = makeActionButton("🎵", "хор", 210, false)
    
    local disc = Instance.new("Frame", rightPanel)
    disc.AnchorPoint = Vector2.new(0.5, 0)
    disc.Position = UDim2.new(0.5, 0, 0, 272)
    disc.Size = UDim2.new(0, 44, 0, 44)
    disc.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    disc.BorderSizePixel = 0
    Instance.new("UICorner", disc).CornerRadius = UDim.new(1, 0)
    local discInner = Instance.new("TextLabel", disc)
    discInner.Size = UDim2.new(1, 0, 1, 0)
    discInner.BackgroundTransparency = 1
    discInner.Text = "🎵"
    discInner.TextColor3 = Color3.fromRGB(255, 255, 255)
    discInner.Font = Enum.Font.GothamBold
    discInner.TextSize = 20
    
    task.spawn(function()
        while disc.Parent do
            disc.Rotation = (disc.Rotation + 3) % 360
            task.wait(0.03)
        end
    end)
    
    local isPlaying = false
    local playThread = nil
    
    local function playScene(sceneIdx)
        if not videoFrame.Parent then return end
        local frameData = vid.frames[sceneIdx]
        if not frameData then return end
        
        Tween:Create(videoFrame, TweenInfo.new(0.6), {
            BackgroundColor3 = frameData.bg[1]
        }):Play()
        vgrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, frameData.bg[1]),
            ColorSequenceKeypoint.new(1, frameData.bg[2]),
        }
        
        centerEmoji.TextTransparency = 1
        Tween:Create(centerEmoji, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        centerEmoji.Text = frameData.emoji
        
        titleLbl.TextTransparency = 1
        Tween:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        titleLbl.Text = frameData.title
        
        subLbl.TextTransparency = 1
        Tween:Create(subLbl, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        subLbl.Text = frameData.sub
    end
    
    local function startPlayback()
        if isPlaying then return end
        isPlaying = true
        
        playThread = task.spawn(function()
            local sceneTime = 1.4
            local totalScenes = #vid.frames
            
            for i = 1, totalScenes do
                if not isPlaying or not videoFrame.Parent then break end
                playScene(i)
                local progress = i / totalScenes
                Tween:Create(progressFill, TweenInfo.new(sceneTime), {
                    Size = UDim2.new(progress, 0, 1, 0)
                }):Play()
                task.wait(sceneTime)
            end
            
            if videoFrame.Parent then
                task.wait(0.5)
                progressFill.Size = UDim2.new(0, 0, 1, 0)
                if isPlaying then
                    isPlaying = false
                    startPlayback()
                end
            end
        end)
    end
    
    local function stopPlayback()
        isPlaying = false
        if playThread then
            pcall(function() task.cancel(playThread) end)
            playThread = nil
        end
    end
    
    local tapArea = Instance.new("TextButton", videoFrame)
    tapArea.Size = UDim2.new(1, -90, 1, -100)
    tapArea.BackgroundTransparency = 1
    tapArea.Text = ""
    tapArea.ZIndex = 5
    
    local lastTap = 0
    tapArea.MouseButton1Click:Connect(function()
        playClick()
        local now = tick()
        if now - lastTap < 0.35 then
            local bigHeart = Instance.new("TextLabel", videoFrame)
            bigHeart.AnchorPoint = Vector2.new(0.5, 0.5)
            bigHeart.Position = UDim2.new(0.5, 0, 0.5, 0)
            bigHeart.Size = UDim2.new(0, 200, 0, 200)
            bigHeart.BackgroundTransparency = 1
            bigHeart.Text = "❤"
            bigHeart.TextColor3 = Color3.fromRGB(255, 60, 100)
            bigHeart.Font = Enum.Font.GothamBold
            bigHeart.TextSize = 160
            bigHeart.TextTransparency = 0.3
            Tween:Create(bigHeart, TweenInfo.new(0.7), {
                Size = UDim2.new(0, 320, 0, 320),
                TextTransparency = 1,
            }):Play()
            Debris:AddItem(bigHeart, 0.8)
        else
            if isPlaying then
                stopPlayback()
            else
                startPlayback()
            end
        end
        lastTap = now
    end)
    
    tapArea.MouseEnter:Connect(function()
        stopTikTokSound()
        currentTikTokSound = Instance.new("Sound")
        currentTikTokSound.SoundId = vid.soundId
        currentTikTokSound.Volume = 0.15
        currentTikTokSound.Looped = true
        currentTikTokSound.Parent = ScreenGui
        currentTikTokSound:Play()
    end)
    tapArea.MouseLeave:Connect(function()
        stopTikTokSound()
    end)
    
    local likeBtn = Instance.new("TextButton", likeIcon)
    likeBtn.Size = UDim2.new(1, 0, 1, 0)
    likeBtn.BackgroundTransparency = 1
    likeBtn.Text = ""
    local liked = true
    likeBtn.MouseButton1Click:Connect(function()
        liked = not liked
        playClick()
        likeIcon.TextColor3 = liked and Color3.fromRGB(255, 60, 100) or Color3.fromRGB(255, 255, 255)
    end)
    
    task.spawn(function()
        while videoFrame.Parent do
            local t = tick()
            for idx, dot in ipairs(bgDots) do
                local p = t * 0.4 + idx
                dot.Position = UDim2.new(
                    0.5 + math.sin(p) * 0.45, 0,
                    0.5 + math.cos(p * 0.9) * 0.45, 0
                )
            end
            centerEmoji.Rotation = math.sin(t * 1.5) * 5
            task.wait(0.03)
        end
    end)
end

for _, vid in ipairs(tiktokVideos) do
    makeTikTokVideo(vid)
end

TikTokWin:GetPropertyChangedSignal("Visible"):Connect(function()
    if not TikTokWin.Visible then
        stopTikTokSound()
    end
end)

-- ============================================
-- BING HACK
-- ============================================
do
    local order = 0
    local list = {"fly","speed","infjump","noclip","fullbright","god","antiafk","jump","esp","autofarm","aura","invisible","yield","flingaura","flingnormal","antifling"}
    for _, id in ipairs(list) do
        order = order + 1
        local entry = functionRegistry[id]
        local row = makeCard(bScroll, 80, order)
        local icon = Instance.new("TextLabel", row)
        icon.Position = UDim2.new(0,14,0,0)
        icon.Size = UDim2.new(0,40,1,0)
        icon.BackgroundTransparency = 1
        icon.Text = entry.icon
        icon.TextColor3 = accent()
        icon.Font = Enum.Font.GothamBold
        icon.TextSize = 26
        registerTheme(icon, "text")

        local n = Instance.new("TextLabel", row)
        n.Position = UDim2.new(0,62,0,12)
        n.Size = UDim2.new(0.4,0,0,20)
        n.BackgroundTransparency = 1
        n.Text = entry.name
        n.TextColor3 = Color3.fromRGB(230,255,240)
        n.Font = Enum.Font.GothamBold
        n.TextSize = 15
        n.TextXAlignment = Enum.TextXAlignment.Left

        local d = Instance.new("TextLabel", row)
        d.Position = UDim2.new(0,62,0,34)
        d.Size = UDim2.new(0.45,0,0,18)
        d.BackgroundTransparency = 1
        d.Text = entry.desc
        d.TextColor3 = Color3.fromRGB(150,170,160)
        d.Font = Enum.Font.Gotham
        d.TextSize = 11
        d.TextXAlignment = Enum.TextXAlignment.Left

        local toggle = Instance.new("TextButton", row)
        toggle.AnchorPoint = Vector2.new(1,0.5)
        toggle.Position = UDim2.new(1,-122,0.5,0)
        toggle.Size = UDim2.new(0,56,0,28)
        toggle.BackgroundColor3 = Color3.fromRGB(60,60,65)
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.fromRGB(255,255,255)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 12
        toggle.BorderSizePixel = 0
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)
        entry.toggleRef = toggle

        local bindBtn = Instance.new("TextButton", row)
        bindBtn.AnchorPoint = Vector2.new(1,0.5)
        bindBtn.Position = UDim2.new(1,-12,0.5,0)
        bindBtn.Size = UDim2.new(0,100,0,32)
        bindBtn.BackgroundColor3 = Color3.fromRGB(0,100,70)
        bindBtn.Text = entry.keybind and ("KEY: " .. entry.keybind.Name) or "BIND"
        bindBtn.TextColor3 = Color3.fromRGB(255,255,255)
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.TextSize = 12
        bindBtn.BorderSizePixel = 0
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0,10)
        entry.bindRef = bindBtn

        bindBtn.MouseButton1Click:Connect(function()
            playClick()
            awaitingBind = entry.id
            bindBtn.Text = "PRESS..."
        end)
        toggle.MouseButton1Click:Connect(function()
            playClick()
            entry.enabled = not entry.enabled
            entry.toggleFn(entry.enabled)
            toggle.Text = entry.enabled and "ON" or "OFF"
            toggle.BackgroundColor3 = entry.enabled and Color3.fromRGB(0,180,110) or Color3.fromRGB(60,60,65)
        end)
    end
end

-- HACK TOOLS
local tpHeader = Instance.new("Frame", hScroll)
tpHeader.Size = UDim2.new(1,-10,0,44)
tpHeader.BackgroundColor3 = Color3.fromRGB(15,22,18)
tpHeader.LayoutOrder = 1
tpHeader.Parent = hScroll
Instance.new("UICorner", tpHeader).CornerRadius = UDim.new(0,10)

local tpH = Instance.new("TextLabel", tpHeader)
tpH.Size = UDim2.new(1,0,1,0)
tpH.BackgroundTransparency = 1
tpH.Text = "  ▾  TELEPORT / FLING TO PLAYER"
tpH.TextColor3 = accent()
tpH.Font = Enum.Font.GothamBold
tpH.TextSize = 13
tpH.TextXAlignment = Enum.TextXAlignment.Left
registerTheme(tpH, "text")

local tpList = Instance.new("Frame", hScroll)
tpList.Size = UDim2.new(1,-10,0,0)
tpList.BackgroundTransparency = 1
tpList.LayoutOrder = 2
tpList.AutomaticSize = Enum.AutomaticSize.Y
local tpListL = Instance.new("UIListLayout", tpList)
tpListL.Padding = UDim.new(0,6)

local function refreshPlayers()
    for _, c in ipairs(tpList:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local row = makeCard(tpList, 52, 0)
            local av = Instance.new("ImageLabel", row)
            av.Position = UDim2.new(0,10,0.5,0)
            av.AnchorPoint = Vector2.new(0,0.5)
            av.Size = UDim2.new(0,34,0,34)
            av.BackgroundColor3 = Color3.fromRGB(40,40,40)
            av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
            av.BorderSizePixel = 0
            Instance.new("UICorner", av).CornerRadius = UDim.new(1,0)

            local n = Instance.new("TextLabel", row)
            n.Position = UDim2.new(0,54,0,0)
            n.Size = UDim2.new(0.4,0,1,0)
            n.BackgroundTransparency = 1
            n.Text = plr.DisplayName .. "  @" .. plr.Name
            n.TextColor3 = Color3.fromRGB(230,255,240)
            n.Font = Enum.Font.GothamMedium
            n.TextSize = 12
            n.TextXAlignment = Enum.TextXAlignment.Left

            local flingBtn = Instance.new("TextButton", row)
            flingBtn.AnchorPoint = Vector2.new(1,0.5)
            flingBtn.Position = UDim2.new(1,-94,0.5,0)
            flingBtn.Size = UDim2.new(0,76,0,32)
            flingBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
            flingBtn.Text = "FLING"
            flingBtn.TextColor3 = Color3.fromRGB(255,255,255)
            flingBtn.Font = Enum.Font.GothamBold
            flingBtn.TextSize = 12
            flingBtn.BorderSizePixel = 0
            Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0,10)
            flingBtn.MouseButton1Click:Connect(function()
                playClick()
                if plr.Character and plr.Character ~= LP.Character then
                    task.spawn(function() pcall(SkidFling, plr) end)
                end
            end)

            local tpB = Instance.new("TextButton", row)
            tpB.AnchorPoint = Vector2.new(1,0.5)
            tpB.Position = UDim2.new(1,-10,0.5,0)
            tpB.Size = UDim2.new(0,76,0,32)
            tpB.BackgroundColor3 = accent()
            tpB.Text = "TP"
            tpB.TextColor3 = Color3.fromRGB(0,0,0)
            tpB.Font = Enum.Font.GothamBold
            tpB.TextSize = 13
            tpB.BorderSizePixel = 0
            Instance.new("UICorner", tpB).CornerRadius = UDim.new(0,10)
            registerTheme(tpB, "bg")
            tpB.MouseButton1Click:Connect(function() playClick() teleport(plr) end)
        end
    end
end

local actionsHeader = Instance.new("Frame", hScroll)
actionsHeader.Size = UDim2.new(1,-10,0,44)
actionsHeader.BackgroundColor3 = Color3.fromRGB(15,22,18)
actionsHeader.LayoutOrder = 3
actionsHeader.Parent = hScroll
Instance.new("UICorner", actionsHeader).CornerRadius = UDim.new(0,10)

local aH = Instance.new("TextLabel", actionsHeader)
aH.Size = UDim2.new(1,0,1,0)
aH.BackgroundTransparency = 1
aH.Text = "  ▾  ACTIONS"
aH.TextColor3 = accent()
aH.Font = Enum.Font.GothamBold
aH.TextSize = 13
aH.TextXAlignment = Enum.TextXAlignment.Left
registerTheme(aH, "text")

local actionsFrame = Instance.new("Frame", hScroll)
actionsFrame.Size = UDim2.new(1,-10,0,230)
actionsFrame.BackgroundTransparency = 1
actionsFrame.LayoutOrder = 4
local actL = Instance.new("UIListLayout", actionsFrame)
actL.Padding = UDim.new(0,6)

local function makeActionBtn(text, cb)
    local b = Instance.new("TextButton", actionsFrame)
    b.Size = UDim2.new(1,0,0,44)
    b.BackgroundColor3 = Color3.fromRGB(20,26,22)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(230,255,240)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    b.MouseButton1Click:Connect(function() playClick() if cb then cb() end end)
end

makeActionBtn("📡  TP All To Me", teleportAllToMe)
makeActionBtn("🌀  FLING Nearest", flingNearest)
makeActionBtn("💥  FLING ALL", flingAll)
makeActionBtn("🌐  Rejoin Server", function()
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
    end)
end)
makeActionBtn("⚰  Reset Character", function()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

-- SETTINGS
do
    local setOrd = 0
    setOrd = setOrd + 1
    local accCard = makeCard(setScroll, 90, setOrd)
    local accLbl = Instance.new("TextLabel", accCard)
    accLbl.Position = UDim2.new(0,14,0,6)
    accLbl.Size = UDim2.new(1,0,0,20)
    accLbl.BackgroundTransparency = 1
    accLbl.Text = "Accent Color"
    accLbl.TextColor3 = Color3.fromRGB(230,255,240)
    accLbl.Font = Enum.Font.GothamBold
    accLbl.TextSize = 14
    accLbl.TextXAlignment = Enum.TextXAlignment.Left

    local PALETTE = {
        {0,255,150}, {0,180,255}, {255,80,180}, {255,180,0}, {180,80,255},
        {255,80,80}, {80,255,255}, {255,255,255}, {255,50,50}, {50,255,50},
    }
    local accRow = Instance.new("Frame", accCard)
    accRow.Position = UDim2.new(0,14,0,40)
    accRow.Size = UDim2.new(1,-28,0,32)
    accRow.BackgroundTransparency = 1
    local accRowL = Instance.new("UIListLayout", accRow)
    accRowL.FillDirection = Enum.FillDirection.Horizontal
    accRowL.Padding = UDim.new(0,6)

    for _, c in ipairs(PALETTE) do
        local sw = Instance.new("TextButton", accRow)
        sw.Size = UDim2.new(0,28,0,28)
        sw.BackgroundColor3 = Color3.fromRGB(c[1], c[2], c[3])
        sw.Text = ""
        sw.BorderSizePixel = 0
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1,0)
        sw.MouseButton1Click:Connect(function()
            playClick()
            _G.KaliAiPad.settings.accent = c
            applyTheme()
        end)
    end

    setOrd = setOrd + 1
    local wpCard = makeCard(setScroll, 80, setOrd)
    local wpLbl = Instance.new("TextLabel", wpCard)
    wpLbl.Position = UDim2.new(0,14,0,6)
    wpLbl.Size = UDim2.new(1,0,0,20)
    wpLbl.BackgroundTransparency = 1
    wpLbl.Text = "Wallpaper"
    wpLbl.TextColor3 = Color3.fromRGB(230,255,240)
    wpLbl.Font = Enum.Font.GothamBold
    wpLbl.TextSize = 14
    wpLbl.TextXAlignment = Enum.TextXAlignment.Left

    local wpRow = Instance.new("Frame", wpCard)
    wpRow.Position = UDim2.new(0,14,0,34)
    wpRow.Size = UDim2.new(1,-28,0,32)
    wpRow.BackgroundTransparency = 1
    local wpRowL = Instance.new("UIListLayout", wpRow)
    wpRowL.FillDirection = Enum.FillDirection.Horizontal
    wpRowL.Padding = UDim.new(0,6)

    for i, W in ipairs(WALLPAPERS) do
        local sw = Instance.new("TextButton", wpRow)
        sw.Size = UDim2.new(0,36,0,30)
        sw.Text = ""
        sw.BorderSizePixel = 0
        Instance.new("UICorner", sw).CornerRadius = UDim.new(0,6)
        local g = Instance.new("UIGradient", sw)
        g.Rotation = 135
        g.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(W[1][1], W[1][2], W[1][3])),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(W[3][1], W[3][2], W[3][3])),
        }
        sw.MouseButton1Click:Connect(function()
            playClick()
            _G.KaliAiPad.settings.wallpaper = i
            applyWallpaper()
        end)
    end

    setOrd = setOrd + 1
    local brCard = makeCard(setScroll, 66, setOrd)
    local brLbl = Instance.new("TextLabel", brCard)
    brLbl.Position = UDim2.new(0,14,0,6)
    brLbl.Size = UDim2.new(0.7,0,0,20)
    brLbl.BackgroundTransparency = 1
    brLbl.Text = "Яркость"
    brLbl.TextColor3 = Color3.fromRGB(230,255,240)
    brLbl.Font = Enum.Font.GothamBold
    brLbl.TextSize = 14
    brLbl.TextXAlignment = Enum.TextXAlignment.Left

    local brVal = Instance.new("TextLabel", brCard)
    brVal.AnchorPoint = Vector2.new(1,0)
    brVal.Position = UDim2.new(1,-14,0,6)
    brVal.Size = UDim2.new(0,60,0,20)
    brVal.BackgroundTransparency = 1
    brVal.Text = tostring(_G.KaliAiPad.settings.brightness)
    brVal.TextColor3 = accent()
    brVal.Font = Enum.Font.GothamBold
    brVal.TextSize = 14
    brVal.TextXAlignment = Enum.TextXAlignment.Right
    registerTheme(brVal, "text")

    local brTrack = Instance.new("Frame", brCard)
    brTrack.Position = UDim2.new(0,14,0,38)
    brTrack.Size = UDim2.new(1,-28,0,8)
    brTrack.BackgroundColor3 = Color3.fromRGB(40,45,42)
    brTrack.BorderSizePixel = 0
    Instance.new("UICorner", brTrack).CornerRadius = UDim.new(1,0)

    local brFill = Instance.new("Frame", brTrack)
    brFill.Size = UDim2.new(_G.KaliAiPad.settings.brightness / 100, 0, 1, 0)
    brFill.BackgroundColor3 = accent()
    brFill.BorderSizePixel = 0
    Instance.new("UICorner", brFill).CornerRadius = UDim.new(1,0)
    registerTheme(brFill, "bg")

    local brThumb = Instance.new("Frame", brTrack)
    brThumb.AnchorPoint = Vector2.new(0.5,0.5)
    brThumb.Position = UDim2.new(_G.KaliAiPad.settings.brightness / 100, 0, 0.5, 0)
    brThumb.Size = UDim2.new(0,18,0,18)
    brThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
    brThumb.BorderSizePixel = 0
    Instance.new("UICorner", brThumb).CornerRadius = UDim.new(1,0)

    local brDrag = false
    local function setBr(x)
        local rel = math.clamp((x - brTrack.AbsolutePosition.X) / brTrack.AbsoluteSize.X, 0, 1)
        local v = math.clamp(math.floor(rel * 100), 30, 100)
        brVal.Text = tostring(v)
        brFill.Size = UDim2.new(v/100, 0, 1, 0)
        brThumb.Position = UDim2.new(v/100, 0, 0.5, 0)
        _G.KaliAiPad.settings.brightness = v
        applyBrightness()
    end
    local brHit = Instance.new("TextButton", brTrack)
    brHit.Size = UDim2.new(1,20,0,20)
    brHit.Position = UDim2.new(0,-10,0.5,-10)
    brHit.BackgroundTransparency = 1
    brHit.Text = ""
    brHit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            brDrag = true
            setBr(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if brDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setBr(input.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            brDrag = false
        end
    end)

    setOrd = setOrd + 1
    local trCard = makeCard(setScroll, 66, setOrd)
    local trLbl = Instance.new("TextLabel", trCard)
    trLbl.Position = UDim2.new(0,14,0,6)
    trLbl.Size = UDim2.new(0.7,0,0,20)
    trLbl.BackgroundTransparency = 1
    trLbl.Text = "Прозрачность окон"
    trLbl.TextColor3 = Color3.fromRGB(230,255,240)
    trLbl.Font = Enum.Font.GothamBold
    trLbl.TextSize = 14
    trLbl.TextXAlignment = Enum.TextXAlignment.Left

    local trVal = Instance.new("TextLabel", trCard)
    trVal.AnchorPoint = Vector2.new(1,0)
    trVal.Position = UDim2.new(1,-14,0,6)
    trVal.Size = UDim2.new(0,60,0,20)
    trVal.BackgroundTransparency = 1
    trVal.Text = tostring(_G.KaliAiPad.settings.transparency)
    trVal.TextColor3 = accent()
    trVal.Font = Enum.Font.GothamBold
    trVal.TextSize = 14
    trVal.TextXAlignment = Enum.TextXAlignment.Right
    registerTheme(trVal, "text")

    local trTrack = Instance.new("Frame", trCard)
    trTrack.Position = UDim2.new(0,14,0,38)
    trTrack.Size = UDim2.new(1,-28,0,8)
    trTrack.BackgroundColor3 = Color3.fromRGB(40,45,42)
    trTrack.BorderSizePixel = 0
    Instance.new("UICorner", trTrack).CornerRadius = UDim.new(1,0)

    local trFill = Instance.new("Frame", trTrack)
    trFill.Size = UDim2.new(_G.KaliAiPad.settings.transparency / 100, 0, 1, 0)
    trFill.BackgroundColor3 = accent()
    trFill.BorderSizePixel = 0
    Instance.new("UICorner", trFill).CornerRadius = UDim.new(1,0)
    registerTheme(trFill, "bg")

    local trThumb = Instance.new("Frame", trTrack)
    trThumb.AnchorPoint = Vector2.new(0.5,0.5)
    trThumb.Position = UDim2.new(_G.KaliAiPad.settings.transparency / 100, 0, 0.5, 0)
    trThumb.Size = UDim2.new(0,18,0,18)
    trThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
    trThumb.BorderSizePixel = 0
    Instance.new("UICorner", trThumb).CornerRadius = UDim.new(1,0)

    local trDrag = false
    local function setTr(x)
        local rel = math.clamp((x - trTrack.AbsolutePosition.X) / trTrack.AbsoluteSize.X, 0, 1)
        local v = math.floor(rel * 80)
        trVal.Text = tostring(v)
        trFill.Size = UDim2.new(v/100, 0, 1, 0)
        trThumb.Position = UDim2.new(v/100, 0, 0.5, 0)
        _G.KaliAiPad.settings.transparency = v
        for _, w in ipairs(allWins) do
            w.BackgroundTransparency = v / 100
        end
    end
    local trHit = Instance.new("TextButton", trTrack)
    trHit.Size = UDim2.new(1,20,0,20)
    trHit.Position = UDim2.new(0,-10,0.5,-10)
    trHit.BackgroundTransparency = 1
    trHit.Text = ""
    trHit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            trDrag = true
            setTr(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if trDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setTr(input.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            trDrag = false
        end
    end)

    setOrd = setOrd + 1
    local sndCard = makeCard(setScroll, 58, setOrd)
    local sndLbl = Instance.new("TextLabel", sndCard)
    sndLbl.Position = UDim2.new(0,14,0,6)
    sndLbl.Size = UDim2.new(0.7,0,0,20)
    sndLbl.BackgroundTransparency = 1
    sndLbl.Text = "Звук клика"
    sndLbl.TextColor3 = Color3.fromRGB(230,255,240)
    sndLbl.Font = Enum.Font.GothamBold
    sndLbl.TextSize = 14
    sndLbl.TextXAlignment = Enum.TextXAlignment.Left

    local sndTr = Instance.new("Frame", sndCard)
    sndTr.AnchorPoint = Vector2.new(1,0.5)
    sndTr.Position = UDim2.new(1,-14,0.5,0)
    sndTr.Size = UDim2.new(0,46,0,26)
    sndTr.BackgroundColor3 = _G.KaliAiPad.settings.clickSound and Color3.fromRGB(0,180,110) or Color3.fromRGB(50,50,55)
    sndTr.BorderSizePixel = 0
    Instance.new("UICorner", sndTr).CornerRadius = UDim.new(1,0)

    local sndTh = Instance.new("Frame", sndTr)
    sndTh.AnchorPoint = Vector2.new(0,0.5)
    sndTh.Position = _G.KaliAiPad.settings.clickSound and UDim2.new(1,-23,0.5,0) or UDim2.new(0,3,0.5,0)
    sndTh.Size = UDim2.new(0,20,0,20)
    sndTh.BackgroundColor3 = Color3.fromRGB(255,255,255)
    sndTh.BorderSizePixel = 0
    Instance.new("UICorner", sndTh).CornerRadius = UDim.new(1,0)

    local sndBtn = Instance.new("TextButton", sndTr)
    sndBtn.Size = UDim2.new(1,0,1,0)
    sndBtn.BackgroundTransparency = 1
    sndBtn.Text = ""
    sndBtn.MouseButton1Click:Connect(function()
        _G.KaliAiPad.settings.clickSound = not _G.KaliAiPad.settings.clickSound
        playClick()
        if _G.KaliAiPad.settings.clickSound then
            sndTr.BackgroundColor3 = Color3.fromRGB(0,180,110)
            Tween:Create(sndTh, TweenInfo.new(0.2), {Position = UDim2.new(1,-23,0.5,0)}):Play()
        else
            sndTr.BackgroundColor3 = Color3.fromRGB(50,50,55)
            Tween:Create(sndTh, TweenInfo.new(0.2), {Position = UDim2.new(0,3,0.5,0)}):Play()
        end
    end)
end

-- PLAYER INFO
local function refreshPlayerInfo()
    for _, c in ipairs(piScroll:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    local o = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        o = o + 1
        local row = makeCard(piScroll, 90, o)
        local av = Instance.new("ImageLabel", row)
        av.Position = UDim2.new(0,12,0,12)
        av.Size = UDim2.new(0,54,0,54)
        av.BackgroundColor3 = Color3.fromRGB(40,40,40)
        av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
        av.BorderSizePixel = 0
        Instance.new("UICorner", av).CornerRadius = UDim.new(1,0)

        local nm = Instance.new("TextLabel", row)
        nm.Position = UDim2.new(0,76,0,10)
        nm.Size = UDim2.new(1,-90,0,20)
        nm.BackgroundTransparency = 1
        nm.Text = plr.DisplayName
        nm.TextColor3 = Color3.fromRGB(230,255,240)
        nm.Font = Enum.Font.GothamBold
        nm.TextSize = 15
        nm.TextXAlignment = Enum.TextXAlignment.Left

        local un = Instance.new("TextLabel", row)
        un.Position = UDim2.new(0,76,0,32)
        un.Size = UDim2.new(1,-90,0,16)
        un.BackgroundTransparency = 1
        un.Text = "@" .. plr.Name .. "  •  ID: " .. plr.UserId
        un.TextColor3 = Color3.fromRGB(150,170,160)
        un.Font = Enum.Font.Gotham
        un.TextSize = 11
        un.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- SERVER INFO
do
    local function mkRow(label, ord)
        local card = makeCard(siScroll, 40, ord)
        local l = Instance.new("TextLabel", card)
        l.Position = UDim2.new(0,14,0,0)
        l.Size = UDim2.new(0.5,0,1,0)
        l.BackgroundTransparency = 1
        l.Text = label
        l.TextColor3 = Color3.fromRGB(150,170,160)
        l.Font = Enum.Font.Gotham
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left

        local v = Instance.new("TextLabel", card)
        v.Position = UDim2.new(0.5,0,0,0)
        v.Size = UDim2.new(0.5,-14,1,0)
        v.BackgroundTransparency = 1
        v.Text = "—"
        v.TextColor3 = Color3.fromRGB(230,255,240)
        v.Font = Enum.Font.Code
        v.TextSize = 13
        v.TextXAlignment = Enum.TextXAlignment.Right
        return v
    end

    local vId = mkRow("Server ID", 1)
    local vPid = mkRow("Place ID", 2)
    local vPl = mkRow("Игроков", 3)
    local vMyId = mkRow("My UserId", 4)
    local vPing = mkRow("Ping", 5)

    task.spawn(function()
        while siScroll.Parent do
            pcall(function()
                vId.Text = (game.JobId ~= "" and game.JobId:sub(1,12)) or "studio"
                vPid.Text = tostring(game.PlaceId)
                vPl.Text = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
                vMyId.Text = tostring(LP.UserId)
                local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                vPing.Text = string.format("%.0f ms", ping or 0)
            end)
            task.wait(1)
        end
    end)
end

-- POSITIONS
local posInputRow = makeCard(posScroll, 56, 1)
local posInput = Instance.new("TextBox", posInputRow)
posInput.Position = UDim2.new(0,14,0.5,-16)
posInput.Size = UDim2.new(0.6,-20,0,32)
posInput.BackgroundColor3 = Color3.fromRGB(12,16,14)
posInput.BorderSizePixel = 0
posInput.Text = ""
posInput.PlaceholderText = "название..."
posInput.PlaceholderColor3 = Color3.fromRGB(120,140,130)
posInput.TextColor3 = Color3.fromRGB(230,255,240)
posInput.Font = Enum.Font.Gotham
posInput.TextSize = 13
posInput.ClearTextOnFocus = false
Instance.new("UICorner", posInput).CornerRadius = UDim.new(0,10)

local posSaveBtn = Instance.new("TextButton", posInputRow)
posSaveBtn.AnchorPoint = Vector2.new(1,0.5)
posSaveBtn.Position = UDim2.new(1,-14,0.5,0)
posSaveBtn.Size = UDim2.new(0,90,0,32)
posSaveBtn.BackgroundColor3 = accent()
posSaveBtn.Text = "SAVE"
posSaveBtn.TextColor3 = Color3.fromRGB(0,0,0)
posSaveBtn.Font = Enum.Font.GothamBold
posSaveBtn.TextSize = 12
posSaveBtn.BorderSizePixel = 0
Instance.new("UICorner", posSaveBtn).CornerRadius = UDim.new(0,10)
registerTheme(posSaveBtn, "bg")

local posList = Instance.new("Frame", posScroll)
posList.Size = UDim2.new(1,-10,0,0)
posList.BackgroundTransparency = 1
posList.LayoutOrder = 2
posList.AutomaticSize = Enum.AutomaticSize.Y
local posListL = Instance.new("UIListLayout", posList)
posListL.Padding = UDim.new(0,6)

local function refreshPositions()
    for _, c in ipairs(posList:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    local ord = 0
    for name, data in pairs(_G.KaliAiPad.positions) do
        ord = ord + 1
        local row = makeCard(posList, 52, ord)
        local l = Instance.new("TextLabel", row)
        l.Position = UDim2.new(0,14,0.5,-10)
        l.Size = UDim2.new(0.5,0,0,20)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(230,255,240)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left

        local goBtn = Instance.new("TextButton", row)
        goBtn.AnchorPoint = Vector2.new(1,0.5)
        goBtn.Position = UDim2.new(1,-68,0.5,0)
        goBtn.Size = UDim2.new(0,50,0,32)
        goBtn.BackgroundColor3 = Color3.fromRGB(0,150,90)
        goBtn.Text = "GO"
        goBtn.TextColor3 = Color3.fromRGB(255,255,255)
        goBtn.Font = Enum.Font.GothamBold
        goBtn.TextSize = 12
        goBtn.BorderSizePixel = 0
        Instance.new("UICorner", goBtn).CornerRadius = UDim.new(0,10)
        goBtn.MouseButton1Click:Connect(function()
            playClick()
            local c = LP.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(data[1], data[2], data[3]) end
            end
        end)

        local delBtn = Instance.new("TextButton", row)
        delBtn.AnchorPoint = Vector2.new(1,0.5)
        delBtn.Position = UDim2.new(1,-12,0.5,0)
        delBtn.Size = UDim2.new(0,50,0,32)
        delBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
        delBtn.Text = "DEL"
        delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.BorderSizePixel = 0
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0,10)
        delBtn.MouseButton1Click:Connect(function()
            playClick()
            _G.KaliAiPad.positions[name] = nil
            refreshPositions()
        end)
    end
end

posSaveBtn.MouseButton1Click:Connect(function()
    playClick()
    local n = posInput.Text
    if n == "" then n = "pos_" .. os.time() end
    local c = LP.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            _G.KaliAiPad.positions[n] = {hrp.Position.X, hrp.Position.Y, hrp.Position.Z}
            posInput.Text = ""
            refreshPositions()
        end
    end
end)

refreshPositions()

-- POWER
do
    local pB = Instance.new("Frame", PowWin)
    pB.Position = UDim2.new(0,30,0,120)
    pB.Size = UDim2.new(1,-60,0,320)
    pB.BackgroundTransparency = 1
    local pbL = Instance.new("UIListLayout", pB)
    pbL.Padding = UDim.new(0,14)
    pbL.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function mkBtn(text, icon, color, cb)
        local b = Instance.new("TextButton", pB)
        b.Size = UDim2.new(1,0,0,76)
        b.BackgroundColor3 = color
        b.Text = ""
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,16)

        local gl = Instance.new("TextLabel", b)
        gl.Position = UDim2.new(0,20,0,0)
        gl.Size = UDim2.new(0,50,1,0)
        gl.BackgroundTransparency = 1
        gl.Text = icon
        gl.TextColor3 = Color3.fromRGB(255,255,255)
        gl.Font = Enum.Font.GothamBold
        gl.TextSize = 30

        local t = Instance.new("TextLabel", b)
        t.Position = UDim2.new(0,80,0,0)
        t.Size = UDim2.new(1,-100,1,0)
        t.BackgroundTransparency = 1
        t.Text = text
        t.TextColor3 = Color3.fromRGB(255,255,255)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 18
        t.TextXAlignment = Enum.TextXAlignment.Left

        b.MouseButton1Click:Connect(function() playClick() if cb then cb() end end)
    end

    local function doBoot()
        Desktop.Visible = false
        OffLayer.Visible = false
        BootLayer.Visible = true
        bootBarFill.Size = UDim2.new(0,0,1,0)
        Tween:Create(bootBarFill, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Size = UDim2.new(1,0,1,0)}):Play()
        task.spawn(function()
            task.wait(1.6)
            BootLayer.Visible = false
            Desktop.Visible = true
        end)
        _G.KaliAiPad.powered = true
    end
    local function doPowerOff()
        Desktop.Visible = false
        BootLayer.Visible = false
        OffLayer.Visible = true
        _G.KaliAiPad.powered = false
    end

    mkBtn("Выключить", "⏻", Color3.fromRGB(180,40,40), doPowerOff)
    mkBtn("Перезагрузить", "↻", Color3.fromRGB(0,100,160), function()
        doPowerOff(); task.wait(0.5); doBoot()
    end)
    mkBtn("Закрыть меню", "✕", Color3.fromRGB(60,60,65), function() closeAllWins() end)

    physPower.MouseButton1Click:Connect(function()
        playClick()
        if _G.KaliAiPad.powered then doPowerOff() else doBoot() end
    end)
end

-- APPS
makeApp("TikTok", "📱", Color3.fromRGB(20,20,20), function() closeAllWins(TikTokWin); TikTokWin.Visible = true end)
makeApp("Bing Hack", "🎯", Color3.fromRGB(0,150,90), function() closeAllWins(BingWin); BingWin.Visible = true end)
makeApp("Hack Tools", "⚡", Color3.fromRGB(90,130,60), function() closeAllWins(HackWin); refreshPlayers(); HackWin.Visible = true end)
makeApp("Player Info", "👤", Color3.fromRGB(0,120,180), function() closeAllWins(PiWin); refreshPlayerInfo(); PiWin.Visible = true end)
makeApp("Server", "🌐", Color3.fromRGB(60,60,200), function() closeAllWins(SiWin); SiWin.Visible = true end)
makeApp("Positions", "📌", Color3.fromRGB(180,120,0), function() closeAllWins(PosWin); refreshPositions(); PosWin.Visible = true end)
makeApp("Settings", "⚙", Color3.fromRGB(90,90,100), function() closeAllWins(SetWin); SetWin.Visible = true end)
makeApp("Power", "⏻", Color3.fromRGB(180,40,40), function() closeAllWins(PowWin); PowWin.Visible = true end)

makeDockApp("📱", Color3.fromRGB(20,20,20), function() closeAllWins(TikTokWin) TikTokWin.Visible = true end)
makeDockApp("🎯", Color3.fromRGB(0,150,90), function() closeAllWins(BingWin) BingWin.Visible = true end)
makeDockApp("⚡", Color3.fromRGB(90,130,60), function() closeAllWins(HackWin) refreshPlayers() HackWin.Visible = true end)
makeDockApp("⚙", Color3.fromRGB(90,90,100), function() closeAllWins(SetWin) SetWin.Visible = true end)

local homeBar = Instance.new("TextButton", Desktop)
homeBar.AnchorPoint = Vector2.new(0.5,1)
homeBar.Position = UDim2.new(0.5,0,1,-6)
homeBar.Size = UDim2.new(0,160,0,5)
homeBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
homeBar.BackgroundTransparency = 0.5
homeBar.Text = ""
homeBar.BorderSizePixel = 0
Instance.new("UICorner", homeBar).CornerRadius = UDim.new(1,0)
homeBar.MouseButton1Click:Connect(function()
    playClick()
    ScreenGui.Enabled = false
    stopTikTokSound()
end)

local dragging, dragStart, startPos
StatusBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Body.Position
    end
end)
StatusBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Body.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if awaitingBind then
        local entry = functionRegistry[awaitingBind]
        if entry then
            if entry.keybind and keybinds[entry.keybind] then keybinds[entry.keybind] = nil end
            entry.keybind = input.KeyCode
            keybinds[input.KeyCode] = entry
            if entry.bindRef then entry.bindRef.Text = "KEY: " .. input.KeyCode.Name end
        end
        awaitingBind = nil
        return
    end

    local e = keybinds[input.KeyCode]
    if e then
        e.enabled = not e.enabled
        e.toggleFn(e.enabled)
        if e.toggleRef then
            e.toggleRef.Text = e.enabled and "ON" or "OFF"
            e.toggleRef.BackgroundColor3 = e.enabled and Color3.fromRGB(0,180,110) or Color3.fromRGB(60,60,65)
        end
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
        if not ScreenGui.Enabled then stopTikTokSound() end
    end
end)

Tool.Equipped:Connect(function()
    ScreenGui.Enabled = true
    playClick()
end)
Tool.Unequipped:Connect(function()
    ScreenGui.Enabled = false
    stopTikTokSound()
end)

applyTheme()

ScreenGui.Enabled = true
Desktop.Visible = true
OffLayer.Visible = false
BootLayer.Visible = false

print("[Kali] ✅ v5.9 DONE — TikTok с 8 мини-сериалами")
