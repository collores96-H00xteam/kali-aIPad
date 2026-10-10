-- // Kali AiPad OS // v6.0 // executor // TikTok PRO + fixed sounds
print("[Kali] start")

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Debris = game:GetService("Debris")

-- CLEANUP
local PG = LP:WaitForChild("PlayerGui")
for _, v in ipairs(PG:GetChildren()) do
    if v.Name == "KaliAiPadOS" or v.Name == "KaliAiPadUI" or v.Name == "KaliInventory" then v:Destroy() end
end
for _, v in ipairs(LP.Backpack:GetChildren()) do if v.Name == "Kali Ai Pad" then v:Destroy() end end
if LP.Character then for _, v in ipairs(LP.Character:GetChildren()) do if v.Name == "Kali Ai Pad" then v:Destroy() end end end

-- STATE
_G.KaliAiPad = _G.KaliAiPad or {}
_G.KaliAiPad.settings = _G.KaliAiPad.settings or { accent = {0,255,150}, wallpaper = 1, brightness = 100, transparency = 10, clickSound = true }
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
                elseif item.kind == "scroll" then item.element.ScrollBarImageColor3 = col end
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
Tool.Name = "Kali Ai Pad"
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
w1.Part0 = Handle
w1.Part1 = ScreenPart
Tool.Parent = LP.Backpack

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaliAiPadOS"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = true
ScreenGui.Parent = PG

-- ЗВУК КЛИКА (безопасно)
local CLICK_SOUND_ID = "rbxassetid://9125402735"
local VIDEO_SOUND_ID = "rbxassetid://131237243"

local function playClick()
    if not _G.KaliAiPad.settings.clickSound then return end
    local s = Instance.new("Sound")
    s.SoundId = CLICK_SOUND_ID
    s.Volume = 0.3
    s.Parent = ScreenGui
    pcall(function() s:Play() end)
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
bootSub.Text = "os v6.0 • by Bean & Jack"
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
SubHeader.Text = "os v6.0 • by Bean & Jack"
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
    t.Size = UDim2.new(1,-60,0,44)
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
-- FLING (SkidFling)
-- ============================================
local flinging = {}
local function SkidFling(TargetPlayer)
    if not TargetPlayer or TargetPlayer == LP then return end
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
    elseif THead then SFBasePart(THead) end
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
                if part:IsA("BasePart") then part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new() end
            end
            task.wait()
        until (RootPart.Position - OldPos.p).Magnitude < 25 or (tick() - sStart > 1.5)
    end
    pcall(function() workspace.FallenPartsDestroyHeight = prevFPDH end)
    task.wait(0.3)
    flinging[TargetPlayer] = nil
end

-- BOAT
local function spawnBoat()
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local basePos = hrp.CFrame * CFrame.new(0, 0, -20)
    local boatModel = Instance.new("Model")
    boatModel.Name = "KaliBoat"
    boatModel.Parent = workspace
    local hull = Instance.new("Part")
    hull.Size = Vector3.new(12, 3, 25)
    hull.Position = basePos.Position
    hull.Color = Color3.fromRGB(139, 69, 19)
    hull.Material = Enum.Material.Wood
    hull.Anchored = true
    hull.Parent = boatModel
    local deck = Instance.new("Part")
    deck.Size = Vector3.new(11, 0.5, 23)
    deck.Position = basePos.Position + Vector3.new(0, 2, 0)
    deck.Color = Color3.fromRGB(180, 140, 100)
    deck.Material = Enum.Material.WoodPlanks
    deck.Anchored = true
    deck.Parent = boatModel
    local mast = Instance.new("Part")
    mast.Size = Vector3.new(0.6, 15, 0.6)
    mast.Position = basePos.Position + Vector3.new(0, 9, 0)
    mast.Color = Color3.fromRGB(100, 60, 30)
    mast.Anchored = true
    mast.Parent = boatModel
    local sail = Instance.new("Part")
    sail.Size = Vector3.new(0.2, 10, 8)
    sail.Position = basePos.Position + Vector3.new(0, 10, 0)
    sail.Color = Color3.fromRGB(255, 255, 255)
    sail.Material = Enum.Material.Fabric
    sail.Anchored = true
    sail.Parent = boatModel
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum and hum.RootPart then hum.RootPart.CFrame = deck.CFrame + Vector3.new(0, 3, 0) end
end

-- STEAL BRAINROT
local function stealBrainrot()
    local stolen = 0
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("brainrot") or n:find("skibidi") or n:find("sigma") or n:find("rizz") then
                pcall(function()
                    if obj:IsA("Model") and obj.PrimaryPart then
                        obj:PivotTo(hrp.CFrame * CFrame.new(math.random(-5,5), 3, math.random(-5,5)))
                    elseif obj:IsA("BasePart") then
                        obj.CFrame = hrp.CFrame * CFrame.new(math.random(-5,5), 3, math.random(-5,5))
                    end
                    stolen = stolen + 1
                end)
            end
        end
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Brainrot",
            Text = "украдено: " .. stolen .. " шт.",
            Duration = 3,
        })
    end)
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
                    if tHum and tHRP and (tHRP.Position - hrp.Position).Magnitude < 8 then
                        tHum.Health = 0
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
            if p:IsA("BasePart") then p.Transparency = p.Name == "HumanoidRootPart" and 1 or 0 end
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
                if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyGyro") or v:IsA("BodyThrust") or v:IsA("BodyForce") or v:IsA("BodyPosition") then
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
                    if not (flyEntry and flyEntry.enabled) then hum.PlatformStand = false end
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
                    if tHRP and (tHRP.Position - hrp.Position).Magnitude < 4 then
                        task.spawn(function() pcall(SkidFling, plr) end)
                    end
                end
            end
        end)
    else
        if flingAuraConn then flingAuraConn:Disconnect() flingAuraConn=nil end
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
registerFn("antifling", "Anti-Fling", "защита", "🛡", applyAntiFling)

local function teleport(target)
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local tC = target.Character
    if not tC then return end
    local tHRP = tC:FindFirstChild("HumanoidRootPart")
    if hrp and tHRP then hrp.CFrame = tHRP.CFrame * CFrame.new(0,0,-3) end
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

-- ОКНА
local BingWin, bScroll = makeWin("🎯 Bing Hack Tools")
local HackWin, hScroll = makeWin("⚡ Hack Tools")
local SetWin, setScroll = makeWin("⚙ Settings")
local PiWin, piScroll = makeWin("👤 Player Info")
local SiWin, siScroll = makeWin("🌐 Server Info")
local PosWin, posScroll = makeWin("📌 Positions")
local PowWin = makeWin("⏻ Power")
local TikTokWin = makeWin("📱 TikTok")

-- ============================================
-- TIKTOK
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

local function tryPlayVideoSound()
    stopTikTokSound()
    pcall(function()
        currentTikTokSound = Instance.new("Sound")
        currentTikTokSound.SoundId = VIDEO_SOUND_ID
        currentTikTokSound.Volume = 0.15
        currentTikTokSound.Looped = true
        currentTikTokSound.Parent = ScreenGui
        currentTikTokSound:Play()
    end)
end

local videoHeight = 560

-- Комментарии
local commentsDB = {}
for i = 1, 20 do
    commentsDB[i] = {
        {user="Никто_не_узнает", text="это лучшее что я видел 😭", likes=234},
        {user="кот_миллионер", text="я тут главный 🐱", likes=89},
        {user="jack.femboy", text="бин, ты лучший 💅", likes=420},
        {user="скептик_5000", text="фейк но смешно", likes=12},
        {user="тикток_фанат", text="серия 2 когда??", likes=156},
    }
end

local profilesDB = {
    ["@c_drama_king"] = {name="C-Drama King", followers="12.4M", following="234", likes="88.2M", verified=true, desc="китайские сериалы 24/7"},
    ["@shaolin_master"] = {name="Shaolin Master", followers="4.1M", following="12", likes="34.5M", verified=true, desc="школа кунг-фу"},
    ["@china_history"] = {name="China History", followers="8.8M", following="87", likes="120M", verified=true, desc="история Поднебесной"},
    ["@cat_money"] = {name="Cat Money", followers="15.2M", following="1", likes="230M", verified=true, desc="самый богатый кот 🐱"},
    ["@c_horror"] = {name="C-Horror", followers="2.9M", following="45", likes="21.4M", verified=false, desc="ужасы из Китая"},
    ["@metro_love"] = {name="Metro Love", followers="1.8M", following="203", likes="18.9M", verified=false, desc="романтика в метро"},
    ["@hk_action"] = {name="HK Action", followers="3.3M", following="56", likes="42.1M", verified=true, desc="гонконг боевики"},
    ["@china_tech"] = {name="China Tech", followers="22.1M", following="234", likes="420M", verified=true, desc="мемы про технологии"},
}

local function openProfile(username, parentWin)
    local prof = profilesDB[username] or {name=username:gsub("@",""), followers="123", following="45", likes="6.7K", verified=false, desc="ноунейм"}
    local ProfileWin = Instance.new("Frame", parentWin)
    ProfileWin.Size = UDim2.new(1, 0, 1, 0)
    ProfileWin.BackgroundColor3 = Color3.fromRGB(10, 14, 12)
    ProfileWin.BackgroundTransparency = 0.05
    ProfileWin.BorderSizePixel = 0
    ProfileWin.ZIndex = 100
    ProfileWin.Parent = parentWin
    Instance.new("UICorner", ProfileWin).CornerRadius = UDim.new(0, 22)
    local backBtn = Instance.new("TextButton", ProfileWin)
    backBtn.Position = UDim2.new(0, 16, 0, 16)
    backBtn.Size = UDim2.new(0, 40, 0, 40)
    backBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    backBtn.Text = "←"
    backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    backBtn.Font = Enum.Font.GothamBold
    backBtn.TextSize = 22
    backBtn.BorderSizePixel = 0
    Instance.new("UICorner", backBtn).CornerRadius = UDim.new(1, 0)
    backBtn.MouseButton1Click:Connect(function() playClick() ProfileWin:Destroy() end)
    local avatar = Instance.new("Frame", ProfileWin)
    avatar.AnchorPoint = Vector2.new(0.5, 0)
    avatar.Position = UDim2.new(0.5, 0, 0, 80)
    avatar.Size = UDim2.new(0, 120, 0, 120)
    avatar.BackgroundColor3 = Color3.fromRGB(math.random(50,200), math.random(50,200), math.random(50,200))
    avatar.BorderSizePixel = 0
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    local letter = Instance.new("TextLabel", avatar)
    letter.Size = UDim2.new(1, 0, 1, 0)
    letter.BackgroundTransparency = 1
    letter.Text = (prof.name:sub(1,1)):upper()
    letter.TextColor3 = Color3.fromRGB(255, 255, 255)
    letter.Font = Enum.Font.GothamBold
    letter.TextSize = 60
    local uname = Instance.new("TextLabel", ProfileWin)
    uname.Position = UDim2.new(0, 0, 0, 210)
    uname.Size = UDim2.new(1, 0, 0, 30)
    uname.BackgroundTransparency = 1
    uname.Text = username .. (prof.verified and " ✓" or "")
    uname.TextColor3 = prof.verified and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 255, 255)
    uname.Font = Enum.Font.GothamBold
    uname.TextSize = 22
    local statsRow = Instance.new("Frame", ProfileWin)
    statsRow.Position = UDim2.new(0, 40, 0, 260)
    statsRow.Size = UDim2.new(1, -80, 0, 60)
    statsRow.BackgroundTransparency = 1
    local statsL = Instance.new("UIListLayout", statsRow)
    statsL.FillDirection = Enum.FillDirection.Horizontal
    statsL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    statsL.Padding = UDim.new(0, 30)
    local function mkStat(val, lbl)
        local c = Instance.new("Frame", statsRow)
        c.Size = UDim2.new(0, 100, 1, 0)
        c.BackgroundTransparency = 1
        local v = Instance.new("TextLabel", c)
        v.Size = UDim2.new(1, 0, 0.6, 0)
        v.BackgroundTransparency = 1
        v.Text = val
        v.TextColor3 = Color3.fromRGB(255, 255, 255)
        v.Font = Enum.Font.GothamBold
        v.TextSize = 20
        local l = Instance.new("TextLabel", c)
        l.Position = UDim2.new(0, 0, 0.6, 0)
        l.Size = UDim2.new(1, 0, 0.4, 0)
        l.BackgroundTransparency = 1
        l.Text = lbl
        l.TextColor3 = Color3.fromRGB(150, 170, 160)
        l.Font = Enum.Font.Gotham
        l.TextSize = 12
    end
    mkStat(prof.followers, "подписчики")
    mkStat(prof.following, "подписки")
    mkStat(prof.likes, "лайки")
    local descLbl = Instance.new("TextLabel", ProfileWin)
    descLbl.Position = UDim2.new(0, 40, 0, 340)
    descLbl.Size = UDim2.new(1, -80, 0, 60)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = prof.desc
    descLbl.TextColor3 = Color3.fromRGB(220, 230, 225)
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 14
    descLbl.TextWrapped = true
    local followBtn = Instance.new("TextButton", ProfileWin)
    followBtn.AnchorPoint = Vector2.new(0.5, 0)
    followBtn.Position = UDim2.new(0.5, 0, 0, 420)
    followBtn.Size = UDim2.new(0, 200, 0, 44)
    followBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 80)
    followBtn.Text = "Подписаться"
    followBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    followBtn.Font = Enum.Font.GothamBold
    followBtn.TextSize = 15
    followBtn.BorderSizePixel = 0
    Instance.new("UICorner", followBtn).CornerRadius = UDim.new(0, 10)
    local following = false
    followBtn.MouseButton1Click:Connect(function()
        playClick()
        following = not following
        followBtn.Text = following and "✓ Подписан" or "Подписаться"
        followBtn.BackgroundColor3 = following and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(255, 40, 80)
    end)
end

-- Видео
local tiktokVideos = {
    {user="@c_drama_king", desc="💰 МИЛЛИАРДЕР ПОЛЮБИЛ УБОРЩИЦУ | Серия 1", likes="4.2M", comments="88K", shares="210K", music="китайская драма", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(60,10,20), Color3.fromRGB(120,20,40)}, emoji="🏢", title="КИТАЙСКИЙ МИЛЛИАРДЕР", sub="Серия 1: случайная встреча"},
        {bg={Color3.fromRGB(80,20,30), Color3.fromRGB(140,40,60)}, emoji="🧹", title="Она — простая уборщица", sub="работает в его офисе"},
        {bg={Color3.fromRGB(100,30,40), Color3.fromRGB(160,50,80)}, emoji="💼", title="Он — владелец корпорации", sub="¥ 8,000,000,000 на счету"},
        {bg={Color3.fromRGB(120,40,60), Color3.fromRGB(180,60,100)}, emoji="👁", title="Их взгляды встретились...", sub="«кто это?» — подумал он"},
        {bg={Color3.fromRGB(140,50,70), Color3.fromRGB(200,80,120)}, emoji="💗", title="Он влюбился", sub="продолжение в серии 2..."},
    }},
    {user="@shaolin_master", desc="🐉 УЧЕНИК ПОБЕДИЛ МАСТЕРА КУНГ-ФУ", likes="2.8M", comments="42K", shares="120K", music="восточный барабан", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(20,30,10), Color3.fromRGB(50,80,20)}, emoji="⛩", title="ШАОЛИНЬ", sub="3-й день обучения"},
        {bg={Color3.fromRGB(30,40,15), Color3.fromRGB(70,100,30)}, emoji="🥋", title="«ВСТАВАЙ!»", sub="удары со всех сторон"},
        {bg={Color3.fromRGB(40,50,20), Color3.fromRGB(90,120,40)}, emoji="👊", title="Ученик собрал силы", sub="«х-х-а-а!»"},
        {bg={Color3.fromRGB(60,70,30), Color3.fromRGB(120,150,50)}, emoji="💥", title="МАСТЕР ПАЛ", sub="«ты... стал сильнее...»"},
        {bg={Color3.fromRGB(80,90,40), Color3.fromRGB(150,180,60)}, emoji="🐲", title="НОВАЯ ЛЕГЕНДА", sub="серия 2 скоро..."},
    }},
    {user="@china_history", desc="👑 ИМПЕРАТОР ПРИЗВАЛ ДРАКОНА", likes="3.1M", comments="56K", shares="180K", music="гуцинь", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(80,40,10), Color3.fromRGB(160,80,20)}, emoji="🏯", title="ЗАПРЕТНЫЙ ГОРОД, 1420", sub="император молил о помощи"},
        {bg={Color3.fromRGB(100,50,15), Color3.fromRGB(180,100,30)}, emoji="👑", title="«О ДРАКОН, УСЛЫШЬ!»", sub="— сказал император"},
        {bg={Color3.fromRGB(120,60,20), Color3.fromRGB(200,120,40)}, emoji="🐲", title="НЕБО РАЗВЕРЗЛОСЬ", sub="гигантский дракон спускался"},
        {bg={Color3.fromRGB(140,70,25), Color3.fromRGB(220,140,50)}, emoji="⚡", title="«ЧЕГО ТЫ ХОЧЕШЬ?»", sub="голос сотрясал землю"},
        {bg={Color3.fromRGB(160,80,30), Color3.fromRGB(240,160,60)}, emoji="🗡", title="«МИР. ИЛИ...»", sub="окончание в финале"},
    }},
    {user="@cat_money", desc="😹 КОТ-МИЛЛИОНЕР И ЕГО РАБ", likes="5.6M", comments="120K", shares="340K", music="смешная музыка", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(50,50,50), Color3.fromRGB(100,100,100)}, emoji="🐱", title="КОТ-МИЛЛИОНЕР", sub="у него 3000 работников"},
        {bg={Color3.fromRGB(60,60,60), Color3.fromRGB(120,120,120)}, emoji="🧑‍💼", title="«БОСС, я готов!»", sub="новый работник"},
        {bg={Color3.fromRGB(70,70,70), Color3.fromRGB(140,140,140)}, emoji="🐾", title="Кот поднял лапу...", sub="«Мяу» — «Что?»"},
        {bg={Color3.fromRGB(80,80,80), Color3.fromRGB(160,160,160)}, emoji="💰", title="«Зарплата — 5 рыб»", sub="работник в шоке"},
        {bg={Color3.fromRGB(90,90,90), Color3.fromRGB(180,180,180)}, emoji="😂", title="ОН СОГЛАСИЛСЯ", sub="работа — мечта"},
    }},
    {user="@c_horror", desc="👻 ОНА ВЕРНУЛАСЬ ЧЕРЕЗ 1000 ЛЕТ", likes="3.4M", comments="72K", shares="150K", music="страшная музыка", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(10,0,20), Color3.fromRGB(30,5,50)}, emoji="🌑", title="1000 ЛЕТ НАЗАД", sub="она умерла..."},
        {bg={Color3.fromRGB(15,5,25), Color3.fromRGB(40,10,60)}, emoji="🕯", title="МОНАХ ЗАЖЁГ СВЕЧУ", sub="«что-то не так...»"},
        {bg={Color3.fromRGB(20,10,30), Color3.fromRGB(50,15,70)}, emoji="👤", title="В ДВЕРЯХ — ТЕНЬ", sub="без ног"},
        {bg={Color3.fromRGB(25,15,35), Color3.fromRGB(60,20,80)}, emoji="👻", title="«Я ВЕРНУЛАСЬ...»", sub="прошептала она"},
        {bg={Color3.fromRGB(30,20,40), Color3.fromRGB(70,25,90)}, emoji="💀", title="СТРАХ НАЧАЛСЯ", sub="серия 2 скоро..."},
    }},
    {user="@metro_love", desc="🚇 СУДЬБА В МЕТРО", likes="1.9M", comments="28K", shares="72K", music="романтическая скрипка", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(40,20,60), Color3.fromRGB(80,40,120)}, emoji="🚇", title="ПЕКИН, ЧАС ПИК", sub="два незнакомца"},
        {bg={Color3.fromRGB(60,30,80), Color3.fromRGB(100,50,140)}, emoji="📱", title="Уронила телефон", sub="он поймал"},
        {bg={Color3.fromRGB(80,40,100), Color3.fromRGB(120,60,160)}, emoji="👀", title="«Спасибо...»", sub="глаза встретились"},
        {bg={Color3.fromRGB(100,50,120), Color3.fromRGB(140,70,180)}, emoji="💞", title="«Кофе?»", sub="она улыбнулась"},
        {bg={Color3.fromRGB(120,60,140), Color3.fromRGB(160,80,200)}, emoji="☕", title="ГОД СПУСТЯ — СВАДЬБА", sub="тот день изменил всё"},
    }},
    {user="@hk_action", desc="🔫 ОН БЫЛ И ТО И ТО", likes="2.2M", comments="34K", shares="88K", music="китайский рэп", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(15,15,25), Color3.fromRGB(40,40,60)}, emoji="🏙", title="ГОНКОНГ, НОЧЬ", sub="двойная игра"},
        {bg={Color3.fromRGB(25,25,35), Color3.fromRGB(60,60,80)}, emoji="🕵", title="«Я полицейский»", sub="смотря боссу в глаза"},
        {bg={Color3.fromRGB(35,35,45), Color3.fromRGB(80,80,100)}, emoji="🔫", title="«Я знаю»", sub="и улыбнулся босс"},
        {bg={Color3.fromRGB(45,45,55), Color3.fromRGB(100,100,120)}, emoji="💥", title="ПЕРЕСТРЕЛКА", sub="никто не выйдет"},
        {bg={Color3.fromRGB(55,55,65), Color3.fromRGB(120,120,140)}, emoji="🎬", title="ФИНАЛ В СЛЕДУЮЩЕЙ", sub="..."},
    }},
    {user="@china_tech", desc="😂 МАМА УЗНАЛА ПРО VPN", likes="6.7M", comments="180K", shares="500K", music="funny drill", soundId=VIDEO_SOUND_ID,
     frames = {
        {bg={Color3.fromRGB(40,30,20), Color3.fromRGB(80,60,40)}, emoji="🧑‍💻", title="СИЖУ ЧЕРЕЗ VPN", sub="думал не узнают"},
        {bg={Color3.fromRGB(60,40,30), Color3.fromRGB(100,80,50)}, emoji="👩", title="МАМА: «ЧТО ЭТО?»", sub="я в холодном поту"},
        {bg={Color3.fromRGB(80,50,40), Color3.fromRGB(120,100,60)}, emoji="😰", title="«Э... ДЛЯ УЧЁБЫ»", sub="мама не верит"},
        {bg={Color3.fromRGB(100,60,50), Color3.fromRGB(140,120,70)}, emoji="📞", title="ЗВОНИТ В ПОЛИЦИЮ", sub="«алло, тут сын...»"},
        {bg={Color3.fromRGB(120,70,60), Color3.fromRGB(160,140,80)}, emoji="🚔", title="ФИНАЛ...", sub="продолжение 💀"},
    }},
}

local function makeTikTokVideo(vid, idx)
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
    
    local centerEmoji = Instance.new("TextLabel", videoFrame)
    centerEmoji.AnchorPoint = Vector2.new(0.5, 0.5)
    centerEmoji.Position = UDim2.new(0.5, 0, 0.32, 0)
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
    
    local userBtn = Instance.new("TextButton", videoFrame)
    userBtn.Position = UDim2.new(0, 20, 1, -160)
    userBtn.Size = UDim2.new(0.5, 0, 0, 26)
    userBtn.BackgroundTransparency = 1
    userBtn.Text = vid.user
    userBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    userBtn.Font = Enum.Font.GothamBold
    userBtn.TextSize = 20
    userBtn.TextXAlignment = Enum.TextXAlignment.Left
    userBtn.TextStrokeTransparency = 0.4
    userBtn.MouseButton1Click:Connect(function()
        playClick()
        openProfile(vid.user, TikTokWin)
    end)
    
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
    
    local likeContainer = Instance.new("Frame", rightPanel)
    likeContainer.Position = UDim2.new(0, 0, 0, 0)
    likeContainer.Size = UDim2.new(1, 0, 0, 62)
    likeContainer.BackgroundTransparency = 1
    local likeIcon = Instance.new("TextLabel", likeContainer)
    likeIcon.Size = UDim2.new(1, 0, 0, 44)
    likeIcon.BackgroundTransparency = 1
    likeIcon.Text = "🤍"
    likeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    likeIcon.Font = Enum.Font.GothamBold
    likeIcon.TextSize = 38
    likeIcon.TextStrokeTransparency = 0.5
    local likeLbl = Instance.new("TextLabel", likeContainer)
    likeLbl.Position = UDim2.new(0, 0, 0, 44)
    likeLbl.Size = UDim2.new(1, 0, 0, 18)
    likeLbl.BackgroundTransparency = 1
    likeLbl.Text = vid.likes
    likeLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    likeLbl.Font = Enum.Font.GothamBold
    likeLbl.TextSize = 12
    likeLbl.TextStrokeTransparency = 0.5
    local likeBtn = Instance.new("TextButton", likeIcon)
    likeBtn.Size = UDim2.new(1, 0, 1, 0)
    likeBtn.BackgroundTransparency = 1
    likeBtn.Text = ""
    local liked = false
    likeBtn.MouseButton1Click:Connect(function()
        liked = not liked
        playClick()
        likeIcon.Text = liked and "❤" or "🤍"
        likeIcon.TextColor3 = liked and Color3.fromRGB(255, 60, 100) or Color3.fromRGB(255, 255, 255)
    end)
    
    local cmtContainer = Instance.new("Frame", rightPanel)
    cmtContainer.Position = UDim2.new(0, 0, 0, 70)
    cmtContainer.Size = UDim2.new(1, 0, 0, 62)
    cmtContainer.BackgroundTransparency = 1
    local cmtIcon = Instance.new("TextLabel", cmtContainer)
    cmtIcon.Size = UDim2.new(1, 0, 0, 44)
    cmtIcon.BackgroundTransparency = 1
    cmtIcon.Text = "💬"
    cmtIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    cmtIcon.Font = Enum.Font.GothamBold
    cmtIcon.TextSize = 34
    cmtIcon.TextStrokeTransparency = 0.5
    local cmtLbl = Instance.new("TextLabel", cmtContainer)
    cmtLbl.Position = UDim2.new(0, 0, 0, 44)
    cmtLbl.Size = UDim2.new(1, 0, 0, 18)
    cmtLbl.BackgroundTransparency = 1
    cmtLbl.Text = vid.comments
    cmtLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    cmtLbl.Font = Enum.Font.GothamBold
    cmtLbl.TextSize = 12
    cmtLbl.TextStrokeTransparency = 0.5
    local cmtBtn = Instance.new("TextButton", cmtIcon)
    cmtBtn.Size = UDim2.new(1, 0, 1, 0)
    cmtBtn.BackgroundTransparency = 1
    cmtBtn.Text = ""
    
    local shrContainer = Instance.new("Frame", rightPanel)
    shrContainer.Position = UDim2.new(0, 0, 0, 140)
    shrContainer.Size = UDim2.new(1, 0, 0, 62)
    shrContainer.BackgroundTransparency = 1
    local shrIcon = Instance.new("TextLabel", shrContainer)
    shrIcon.Size = UDim2.new(1, 0, 0, 44)
    shrIcon.BackgroundTransparency = 1
    shrIcon.Text = "↗"
    shrIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    shrIcon.Font = Enum.Font.GothamBold
    shrIcon.TextSize = 34
    shrIcon.TextStrokeTransparency = 0.5
    local shrLbl = Instance.new("TextLabel", shrContainer)
    shrLbl.Position = UDim2.new(0, 0, 0, 44)
    shrLbl.Size = UDim2.new(1, 0, 0, 18)
    shrLbl.BackgroundTransparency = 1
    shrLbl.Text = vid.shares
    shrLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    shrLbl.Font = Enum.Font.GothamBold
    shrLbl.TextSize = 12
    shrLbl.TextStrokeTransparency = 0.5
    
    local disc = Instance.new("Frame", rightPanel)
    disc.AnchorPoint = Vector2.new(0.5, 0)
    disc.Position = UDim2.new(0.5, 0, 0, 220)
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
        Tween:Create(videoFrame, TweenInfo.new(0.6), {BackgroundColor3 = frameData.bg[1]}):Play()
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
        tryPlayVideoSound()
        playThread = task.spawn(function()
            local sceneTime = 1.4
            local totalScenes = #vid.frames
            for i = 1, totalScenes do
                if not isPlaying or not videoFrame.Parent then break end
                playScene(i)
                local progress = i / totalScenes
                Tween:Create(progressFill, TweenInfo.new(sceneTime), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
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
        stopTikTokSound()
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
            liked = true
            likeIcon.Text = "❤"
            likeIcon.TextColor3 = Color3.fromRGB(255, 60, 100)
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
            if isPlaying then stopPlayback() else startPlayback() end
        end
        lastTap = now
    end)
    
    -- КОММЕНТЫ
    cmtBtn.MouseButton1Click:Connect(function()
        playClick()
        local CommentsWin = Instance.new("Frame", TikTokWin)
        CommentsWin.Size = UDim2.new(1, 0, 1, 0)
        CommentsWin.BackgroundColor3 = Color3.fromRGB(15, 18, 16)
        CommentsWin.BackgroundTransparency = 0.05
        CommentsWin.BorderSizePixel = 0
        CommentsWin.ZIndex = 100
        CommentsWin.Parent = TikTokWin
        Instance.new("UICorner", CommentsWin).CornerRadius = UDim.new(0, 22)
        
        local cHeader = Instance.new("Frame", CommentsWin)
        cHeader.Size = UDim2.new(1, 0, 0, 50)
        cHeader.BackgroundColor3 = Color3.fromRGB(20, 25, 22)
        cHeader.BorderSizePixel = 0
        Instance.new("UICorner", cHeader).CornerRadius = UDim.new(0, 22)
        
        local cTitle = Instance.new("TextLabel", cHeader)
        cTitle.Position = UDim2.new(0, 16, 0, 0)
        cTitle.Size = UDim2.new(1, -100, 1, 0)
        cTitle.BackgroundTransparency = 1
        cTitle.Text = "Комментарии (" .. vid.comments .. ")"
        cTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        cTitle.Font = Enum.Font.GothamBold
        cTitle.TextSize = 16
        cTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local cClose = Instance.new("TextButton", cHeader)
        cClose.AnchorPoint = Vector2.new(1, 0.5)
        cClose.Position = UDim2.new(1, -16, 0.5, 0)
        cClose.Size = UDim2.new(0, 30, 0, 30)
        cClose.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        cClose.Text = "×"
        cClose.TextColor3 = Color3.fromRGB(255, 255, 255)
        cClose.Font = Enum.Font.GothamBold
        cClose.TextSize = 18
        cClose.BorderSizePixel = 0
        Instance.new("UICorner", cClose).CornerRadius = UDim.new(1, 0)
        cClose.MouseButton1Click:Connect(function() playClick() CommentsWin:Destroy() end)
        
        local cList = Instance.new("ScrollingFrame", CommentsWin)
        cList.Position = UDim2.new(0, 12, 0, 60)
        cList.Size = UDim2.new(1, -24, 1, -130)
        cList.BackgroundTransparency = 1
        cList.BorderSizePixel = 0
        cList.ScrollBarThickness = 4
        cList.ScrollBarImageColor3 = accent()
        cList.CanvasSize = UDim2.new(0, 0, 0, 0)
        cList.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local cLL = Instance.new("UIListLayout", cList)
        cLL.Padding = UDim.new(0, 8)
        cLL.SortOrder = Enum.SortOrder.LayoutOrder
        
        local function refreshComments()
            for _, ch in ipairs(cList:GetChildren()) do
                if not ch:IsA("UIListLayout") then ch:Destroy() end
            end
            for i, cm in ipairs(commentsDB[idx] or {}) do
                local row = Instance.new("Frame", cList)
                row.Size = UDim2.new(1, -10, 0, 70)
                row.BackgroundColor3 = Color3.fromRGB(20, 26, 22)
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
                local uname = Instance.new("TextButton", row)
                uname.Position = UDim2.new(0, 12, 0, 8)
                uname.Size = UDim2.new(0.5, 0, 0, 18)
                uname.BackgroundTransparency = 1
                uname.Text = cm.user
                uname.TextColor3 = Color3.fromRGB(150, 200, 255)
                uname.Font = Enum.Font.GothamBold
                uname.TextSize = 13
                uname.TextXAlignment = Enum.TextXAlignment.Left
                uname.MouseButton1Click:Connect(function()
                    playClick()
                    openProfile("@" .. cm.user, TikTokWin)
                end)
                local txt = Instance.new("TextLabel", row)
                txt.Position = UDim2.new(0, 12, 0, 28)
                txt.Size = UDim2.new(1, -80, 0, 34)
                txt.BackgroundTransparency = 1
                txt.Text = cm.text
                txt.TextColor3 = Color3.fromRGB(230, 240, 235)
                txt.Font = Enum.Font.Gotham
                txt.TextSize = 13
                txt.TextXAlignment = Enum.TextXAlignment.Left
                txt.TextYAlignment = Enum.TextYAlignment.Top
                txt.TextWrapped = true
                local lk = Instance.new("TextButton", row)
                lk.AnchorPoint = Vector2.new(1, 0.5)
                lk.Position = UDim2.new(1, -12, 0.5, 0)
                lk.Size = UDim2.new(0, 44, 0, 44)
                lk.BackgroundTransparency = 1
                lk.Text = "🤍\n" .. tostring(cm.likes)
                lk.TextColor3 = Color3.fromRGB(255, 255, 255)
                lk.Font = Enum.Font.GothamBold
                lk.TextSize = 11
                local cmLiked = false
                lk.MouseButton1Click:Connect(function()
                    playClick()
                    cmLiked = not cmLiked
                    cm.likes = cm.likes + (cmLiked and 1 or -1)
                    lk.Text = (cmLiked and "❤\n" or "🤍\n") .. tostring(cm.likes)
                end)
            end
        end
        refreshComments()
        
        local inputBg = Instance.new("Frame", CommentsWin)
        inputBg.AnchorPoint = Vector2.new(0.5, 1)
        inputBg.Position = UDim2.new(0.5, 0, 1, -14)
        inputBg.Size = UDim2.new(1, -24, 0, 50)
        inputBg.BackgroundColor3 = Color3.fromRGB(20, 25, 22)
        inputBg.BorderSizePixel = 0
        Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 12)
        local cInput = Instance.new("TextBox", inputBg)
        cInput.Position = UDim2.new(0, 12, 0, 0)
        cInput.Size = UDim2.new(1, -110, 1, 0)
        cInput.BackgroundTransparency = 1
        cInput.Text = ""
        cInput.PlaceholderText = "напиши комментарий..."
        cInput.PlaceholderColor3 = Color3.fromRGB(120, 140, 130)
        cInput.TextColor3 = Color3.fromRGB(230, 240, 235)
        cInput.Font = Enum.Font.Gotham
        cInput.TextSize = 14
        cInput.TextXAlignment = Enum.TextXAlignment.Left
        cInput.ClearTextOnFocus = false
        
        local sendBtn = Instance.new("TextButton", inputBg)
        sendBtn.AnchorPoint = Vector2.new(1, 0.5)
        sendBtn.Position = UDim2.new(1, -10, 0.5, 0)
        sendBtn.Size = UDim2.new(0, 80, 0, 36)
        sendBtn.BackgroundColor3 = accent()
        sendBtn.Text = "Send"
        sendBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        sendBtn.Font = Enum.Font.GothamBold
        sendBtn.TextSize = 13
        sendBtn.BorderSizePixel = 0
        Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 10)
        sendBtn.MouseButton1Click:Connect(function()
            local t = cInput.Text
            if t == "" then return end
            playClick()
            table.insert(commentsDB[idx], 1, {user = LP.Name, text = t, likes = 0})
            cInput.Text = ""
            refreshComments()
        end)
    end)
    
    -- анимация диска и эмодзи
    task.spawn(function()
        while videoFrame.Parent do
            local t = tick()
            centerEmoji.Rotation = math.sin(t * 1.5) * 5
            task.wait(0.03)
        end
    end)
end

for i, vid in ipairs(tiktokVideos) do
    makeTikTokVideo(vid, i)
end

TikTokWin:GetPropertyChangedSignal("Visible"):Connect(function()
    if not TikTokWin.Visible then stopTikTokSound() end
end)

-- BING HACK
do
    local order = 0
    local list = {"fly","speed","infjump","noclip","fullbright","god","antiafk","jump","esp","autofarm","aura","invisible","yield","flingaura","antifling"}
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
tpH.Text = "  ▾  TP / FLING"
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
            n.Text = plr.DisplayName
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
                if plr.Character then task.spawn(function() pcall(SkidFling, plr) end) end
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
actionsFrame.Size = UDim2.new(1,-10,0,300)
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
makeActionBtn("🚤  Спавн лодки", spawnBoat)
makeActionBtn("🧠  Steal Brainrot", stealBrainrot)
makeActionBtn("🌐  Rejoin Server", function()
    pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
end)
makeActionBtn("⚰  Reset Character", function()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

-- SETTINGS (accent + wallpaper)
do
    local setOrd = 1
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

    setOrd = 2
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
end

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
makeApp("Player Info", "👤", Color3.fromRGB(0,120,180), function() closeAllWins(PiWin); PiWin.Visible = true end)
makeApp("Server", "🌐", Color3.fromRGB(60,60,200), function() closeAllWins(SiWin); SiWin.Visible = true end)
makeApp("Positions", "📌", Color3.fromRGB(180,120,0), function() closeAllWins(PosWin); PosWin.Visible = true end)
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

print("[Kali] ✅ v6.0 DONE — звуки пофикшены через pcall")
