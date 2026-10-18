--[[
    ═══════════════════════════════════════════════════════
    VzNam Hub-Main - Steal an Egg Edition
    FULL CODE - FULL UI + Logic Chạy Bộ (Bản chuẩn 100%)
    ═══════════════════════════════════════════════════════
]]

local CoreGui         = game:GetService("CoreGui")
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local SoundService    = game:GetService("SoundService")
local HttpService     = game:GetService("HttpService")
local RunService      = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end
if PlayerGui:FindFirstChild("VzNamHubLoading") then PlayerGui.VzNamHubLoading:Destroy() end
if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end

-- ═════════════════ CONNECTION TRACKING ═════════════════
local Connections = {}
local function Track(c) if c then table.insert(Connections, c) end return c end

-- ═════════════════ STATE ═════════════════
local State = {
    ThemeBase   = Color3.fromRGB(15, 16, 22),
    StrokeMode  = "Solid",
    StrokeColor = Color3.fromRGB(0, 191, 255),
    Volume      = 0.5,
    SoundId     = "1837879082",
    CurrentConfig = "Default",
    Transparent = 0,
}

local FarmState = {
    AutoSteal     = false,
    SafeZonePos   = nil,
    SpeedBack     = 1500,
    -- Các biến cũ giữ nguyên cho UI
    SuperSpeed    = false,
    Steps         = 2,
    FastDelivery  = false,
    SpeedV2       = false,
    FlySpeed      = 150,
    SellAfterDrop = true,
    AvoidGuards   = true,
    GuardRadius   = 40,
    MinRarity     = "Tất cả",
    StealPriority = "Gần nhất",
}

-- ═════════════════ UI HELPERS ═════════════════
local function Corner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = r or UDim.new(0, 5); return c end
local AllUIStrokes = {}
local function Stroke(p, color, thick)
    local s = Instance.new("UIStroke", p)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color or State.StrokeColor; s.Thickness = thick or 1
    table.insert(AllUIStrokes, s); return s
end
local ThemedElements = {}
local function RegTheme(el, t) table.insert(ThemedElements, {Element = el, Type = t}); return el end

-- ═════════════════ ROOT UI ═════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.DisplayOrder = 99999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 300)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Corner(MainFrame, UDim.new(0, 8)); Stroke(MainFrame, Color3.fromRGB(0, 191, 255), 2)

-- ═════════════════ LOADING ═════════════════
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "VzNamHubLoading"
LoadingGui.DisplayOrder = 100000
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = PlayerGui

local LoadFrame = Instance.new("Frame", LoadingGui)
LoadFrame.Size = UDim2.new(0, 340, 0, 220)
LoadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
LoadFrame.BorderSizePixel = 0
Corner(LoadFrame, UDim.new(0, 8)); Stroke(LoadFrame, Color3.fromRGB(0, 191, 255), 2)

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0, 35); LoadTitle.Position = UDim2.new(0, 0, 0, 8)
LoadTitle.BackgroundTransparency = 1; LoadTitle.Text = "🌸 VzNam Hub-Main 🌸"
LoadTitle.TextColor3 = Color3.fromRGB(0, 191, 255); LoadTitle.TextSize = 13; LoadTitle.Font = Enum.Font.GothamBold

local LoadInfoHolder = Instance.new("Frame", LoadFrame)
LoadInfoHolder.Size = UDim2.new(1, -20, 0, 95); LoadInfoHolder.Position = UDim2.new(0, 10, 0, 45)
LoadInfoHolder.BackgroundTransparency = 1
local LIL = Instance.new("UIListLayout", LoadInfoHolder)
LIL.SortOrder = Enum.SortOrder.LayoutOrder; LIL.Padding = UDim.new(0, 4); LIL.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateLoadCard(parent, order, bgColor, titleText, mainText, borderColor, iconSymbol)
    local card = Instance.new("Frame", parent)
    card.LayoutOrder = order; card.Size = UDim2.new(1, 0, 0, 27); card.BackgroundColor3 = bgColor; card.BorderSizePixel = 0
    Corner(card); Stroke(card, borderColor, 1)
    local ic = Instance.new("Frame", card)
    ic.Size = UDim2.new(0, 16, 0, 16); ic.Position = UDim2.new(0, 4, 0.5, -8); ic.BackgroundColor3 = borderColor; ic.BorderSizePixel = 0
    Corner(ic, UDim.new(1, 0)); Stroke(ic, borderColor)
    local il = Instance.new("TextLabel", ic)
    il.Size = UDim2.new(1,0,1,0); il.BackgroundTransparency = 1; il.Text = iconSymbol; il.TextColor3 = Color3.fromRGB(255,255,255); il.TextSize = 7; il.Font = Enum.Font.GothamBold
    local tLbl = Instance.new("TextLabel", card)
    tLbl.Size = UDim2.new(1, -30, 0, 10); tLbl.Position = UDim2.new(0, 24, 0, 1); tLbl.BackgroundTransparency = 1; tLbl.Text = titleText; tLbl.TextColor3 = Color3.fromRGB(255,150,100); tLbl.TextSize = 7; tLbl.Font = Enum.Font.GothamBold; tLbl.TextXAlignment = Enum.TextXAlignment.Left
    local mLbl = Instance.new("TextLabel", card)
    mLbl.Size = UDim2.new(1, -30, 0, 12); mLbl.Position = UDim2.new(0, 24, 0, 12); mLbl.BackgroundTransparency = 1; mLbl.Text = mainText; mLbl.TextColor3 = Color3.fromRGB(220,220,230); mLbl.TextSize = 7; mLbl.Font = Enum.Font.Gotham; mLbl.TextXAlignment = Enum.TextXAlignment.Left
end

CreateLoadCard(LoadInfoHolder, 1, Color3.fromRGB(70,20,45), "ĐƯỢC TẠO BỞI", "VzNam ROBLOX", Color3.fromRGB(180,50,50), "👤")
CreateLoadCard(LoadInfoHolder, 2, Color3.fromRGB(30,40,70), "DISCORD", "https://discord.gg/6TG7krbsU", Color3.fromRGB(60,100,200), "💬")
CreateLoadCard(LoadInfoHolder, 3, Color3.fromRGB(45,45,65), "TIKTOK", "https://www.tiktok.com/@uttop1gl.ovo", Color3.fromRGB(100,100,120), "🎵")

local BarBg = Instance.new("Frame", LoadFrame)
BarBg.Size = UDim2.new(1, -20, 0, 10); BarBg.Position = UDim2.new(0, 10, 1, -40); BarBg.BackgroundColor3 = Color3.fromRGB(25,26,35)
Corner(BarBg, UDim.new(1, 0)); Stroke(BarBg, Color3.fromRGB(0, 191, 255), 1)
local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromRGB(0, 191, 255); Corner(BarFill, UDim.new(1, 0))
local PercentLbl = Instance.new("TextLabel", LoadFrame)
PercentLbl.Size = UDim2.new(1, 0, 0, 18); PercentLbl.Position = UDim2.new(0, 0, 1, -24); PercentLbl.BackgroundTransparency = 1; PercentLbl.Text = "Đang tải: 0/10"; PercentLbl.TextColor3 = Color3.fromRGB(200,205,215); PercentLbl.TextSize = 8; PercentLbl.Font = Enum.Font.GothamBold

-- ═════════════════ NÚT BÔNG HOA 🌸 ═════════════════
local flowerBtn = Instance.new("TextButton", ScreenGui)
flowerBtn.Name = "FlowerToggle"
flowerBtn.Size = UDim2.new(0, 50, 0, 50); flowerBtn.Position = UDim2.new(0, 20, 0.4, 0)
flowerBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); flowerBtn.BackgroundTransparency = 0.1
flowerBtn.Text = "🌸"; flowerBtn.TextSize = 26; flowerBtn.TextColor3 = Color3.fromRGB(255, 255, 255); flowerBtn.Font = Enum.Font.GothamBold
flowerBtn.Active = true; flowerBtn.Draggable = true; flowerBtn.Visible = false
Corner(flowerBtn, UDim.new(1, 0))
local fStroke = Instance.new("UIStroke", flowerBtn); fStroke.Thickness = 2.5; fStroke.Color = Color3.fromRGB(255, 105, 180)
table.insert(AllUIStrokes, fStroke)

local glow = Instance.new("Frame", flowerBtn)
glow.Size = UDim2.new(1, 8, 1, 8); glow.Position = UDim2.new(0, -4, 0, -4); glow.BackgroundColor3 = Color3.fromRGB(255, 105, 180); glow.BackgroundTransparency = 0.85; glow.BorderSizePixel = 0; glow.ZIndex = 0
Corner(glow, UDim.new(1, 0))

task.spawn(function()
    while flowerBtn.Parent do
        local tw = TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 14, 1, 14), Position = UDim2.new(0, -7, 0, -7), BackgroundTransparency = 0.7})
        tw:Play(); task.wait(1.2)
        if not flowerBtn.Parent then break end
        local tw2 = TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 8, 1, 8), Position = UDim2.new(0, -4, 0, -4), BackgroundTransparency = 0.85})
        tw2:Play(); task.wait(1.2)
    end
end)

local function UpdateFlowerIcon()
    if MainFrame.Visible then
        flowerBtn.Text = "✕"; fStroke.Color = Color3.fromRGB(255, 80, 80); glow.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    else
        flowerBtn.Text = "🌸"; fStroke.Color = Color3.fromRGB(255, 105, 180); glow.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    end
end

task.spawn(function()
    for i = 1, 10 do task.wait(0.2); BarFill.Size = UDim2.new(i / 10, 0, 1, 0); PercentLbl.Text = "Đang tải: " .. i .. "/10" end
    task.wait(0.3); LoadingGui:Destroy(); MainFrame.Visible = true; flowerBtn.Visible = true; UpdateFlowerIcon()
end)

-- ═════════════════ RESIZE ═════════════════
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size, ResizeBtn.Position = UDim2.new(0, 18, 0, 18), UDim2.new(1, -18, 1, -18)
ResizeBtn.BackgroundTransparency, ResizeBtn.Text = 1, "◢"
ResizeBtn.TextColor3, ResizeBtn.TextSize, ResizeBtn.ZIndex = Color3.fromRGB(0, 191, 255), 12, 10
local resizing, resizeStart, startSize = false, nil, nil
Track(ResizeBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; resizeStart = input.Position; startSize = MainFrame.AbsoluteSize end end))
Track(UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end))
Track(UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local d = input.Position - resizeStart; MainFrame.Size = UDim2.new(0, math.clamp(startSize.X + d.X, 320, 500), 0, math.clamp(startSize.Y + d.Y, 230, 450)) end end))

-- ═════════════════ TOP BAR ═════════════════
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1
local Logo = Instance.new("Frame", TopBar)
Logo.Size, Logo.Position = UDim2.new(0, 18, 0, 18), UDim2.new(0, 6, 0.5, -9); Logo.BackgroundColor3, Logo.BorderSizePixel = Color3.fromRGB(0, 191, 255), 0
Corner(Logo, UDim.new(0, 4)); Stroke(Logo, Color3.fromRGB(0, 191, 255))
local LogoIcon = Instance.new("TextLabel", Logo)
LogoIcon.Size, LogoIcon.BackgroundTransparency = UDim2.new(1,0,1,0), 1; LogoIcon.Text, LogoIcon.TextColor3 = "🌸", Color3.fromRGB(255,255,255); LogoIcon.TextSize, LogoIcon.Font = 10, Enum.Font.GothamBold
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position = UDim2.new(1, -60, 1, 0), UDim2.new(0, 28, 0, 0); Title.BackgroundTransparency, Title.Text = 1, "🌸 VzNam Hub-Main 🌸"
Title.TextColor3, Title.TextSize = Color3.fromRGB(0, 191, 255), 10; Title.Font, Title.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 24, 0, 24), UDim2.new(1, -26, 0.5, -12); CloseBtn.BackgroundTransparency, CloseBtn.Text = 1, "✕"
CloseBtn.TextColor3, CloseBtn.TextSize = Color3.fromRGB(200, 200, 210), 10; CloseBtn.Font = Enum.Font.GothamBold
Track(CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; UpdateFlowerIcon() end))

-- ═════════════════ SIDEBAR & CONTENT ═════════════════
local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Size, SidebarPanel.Position = UDim2.new(0.3, -4, 1, -34), UDim2.new(0, 6, 0, 28); SidebarPanel.BackgroundColor3, SidebarPanel.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Corner(SidebarPanel, UDim.new(0, 6)); Stroke(SidebarPanel, Color3.fromRGB(0,191,255), 1)

local SearchBoxTab = Instance.new("TextBox", SidebarPanel)
SearchBoxTab.Size, SearchBoxTab.Position = UDim2.new(1, -8, 0, 18), UDim2.new(0, 4, 0, 4); SearchBoxTab.BackgroundColor3 = Color3.fromRGB(12,12,17)
SearchBoxTab.Text, SearchBoxTab.PlaceholderText = "", "🔍 Search..."; SearchBoxTab.PlaceholderColor3, SearchBoxTab.TextColor3 = Color3.fromRGB(150,155,165), Color3.fromRGB(255,255,255)
SearchBoxTab.TextSize, SearchBoxTab.Font = 8, Enum.Font.Gotham; Corner(SearchBoxTab, UDim.new(0, 4)); Stroke(SearchBoxTab); RegTheme(SearchBoxTab, "Input")

local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
SidebarScroll.Size, SidebarScroll.Position = UDim2.new(1, -4, 1, -26), UDim2.new(0, 2, 0, 25); SidebarScroll.BackgroundTransparency, SidebarScroll.BorderSizePixel = 1, 0
SidebarScroll.ScrollBarThickness, SidebarScroll.ClipsDescendants = 2, true
local SidebarLayout = Instance.new("UIListLayout", SidebarScroll)
SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 3)
local SidebarPad = Instance.new("UIPadding", SidebarScroll)
SidebarPad.PaddingLeft, SidebarPad.PaddingRight = UDim.new(0, 2), UDim.new(0, 6)
Track(SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 10) end))

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position = UDim2.new(0.68, -4, 1, -34), UDim2.new(0.315, 0, 0, 28); ContentContainer.BackgroundColor3, ContentContainer.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Corner(ContentContainer, UDim.new(0, 6)); Stroke(ContentContainer, Color3.fromRGB(0,191,255), 1)

local ContentHeader = Instance.new("Frame", ContentContainer)
ContentHeader.Size, ContentHeader.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1
local ActiveTabTitle = Instance.new("TextLabel", ContentHeader)
ActiveTabTitle.Size, ActiveTabTitle.Position = UDim2.new(1, -30, 1, 0), UDim2.new(0, 6, 0, 0); ActiveTabTitle.BackgroundTransparency, ActiveTabTitle.Text = 1, ""
ActiveTabTitle.TextColor3, ActiveTabTitle.TextSize = Color3.fromRGB(255,255,255), 10; ActiveTabTitle.Font, ActiveTabTitle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
local HeaderDivider = Instance.new("Frame", ContentContainer)
HeaderDivider.Size, HeaderDivider.Position = UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 26); HeaderDivider.BackgroundColor3, HeaderDivider.BorderSizePixel = Color3.fromRGB(0,191,255), 0
local Tabs = {}

-- ═════════════════ TAB HOME ═════════════════
local tabHomeBtn = Instance.new("TextButton", SidebarScroll)
tabHomeBtn.LayoutOrder = 0; tabHomeBtn.Size, tabHomeBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabHomeBtn.BackgroundTransparency, tabHomeBtn.Text = 0, " 🏠 Trang Chủ"; tabHomeBtn.TextColor3, tabHomeBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabHomeBtn.Font, tabHomeBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Corner(tabHomeBtn); RegTheme(tabHomeBtn, "Primary")

local homeInd = Instance.new("Frame", tabHomeBtn)
homeInd.Size, homeInd.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6); homeInd.BackgroundColor3, homeInd.BorderSizePixel = Color3.fromRGB(255,105,180), 0; homeInd.Visible = false
Corner(homeInd, UDim.new(0, 2))

local homeScroll = Instance.new("ScrollingFrame", ContentContainer)
homeScroll.Size, homeScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28); homeScroll.BackgroundTransparency, homeScroll.BorderSizePixel = 1, 0
homeScroll.ScrollBarThickness, homeScroll.Visible, homeScroll.ClipsDescendants = 3, false, true
local homeLayout = Instance.new("UIListLayout", homeScroll)
homeLayout.SortOrder, homeLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); homeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local homePad = Instance.new("UIPadding", homeScroll)
homePad.PaddingLeft, homePad.PaddingRight = UDim.new(0, 4), UDim.new(0, 10); homePad.PaddingTop, homePad.PaddingBottom = UDim.new(0, 4), UDim.new(0, 4)
Track(homeLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() homeScroll.CanvasSize = UDim2.new(0, 0, 0, homeLayout.AbsoluteContentSize.Y + 15) end))

Track(tabHomeBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false; if t.Indicator then t.Indicator.Visible = false end end
    homeScroll.Visible, homeInd.Visible = true, true; ActiveTabTitle.Text = "🏠 Trang Chủ"
end))
table.insert(Tabs, {Container = homeScroll, Indicator = homeInd}); homeScroll.Visible, homeInd.Visible = true, true; ActiveTabTitle.Text = "🏠 Trang Chủ"

local infoToggleBtn = Instance.new("TextButton", homeScroll)
infoToggleBtn.LayoutOrder = 1; infoToggleBtn.Size, infoToggleBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 32), Color3.fromRGB(55,12,40)
infoToggleBtn.BackgroundTransparency, infoToggleBtn.Text = 0, " → thông tin"; infoToggleBtn.TextColor3, infoToggleBtn.TextSize = Color3.fromRGB(255,255,255), 10
infoToggleBtn.Font, infoToggleBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Corner(infoToggleBtn); Stroke(infoToggleBtn); RegTheme(infoToggleBtn, "Secondary")

local infoSub = Instance.new("TextLabel", infoToggleBtn)
infoSub.Size, infoSub.Position = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14); infoSub.BackgroundTransparency, infoSub.Text = 1, "Xem các thông tin Hub"
infoSub.TextColor3, infoSub.TextSize = Color3.fromRGB(140,140,150), 7; infoSub.Font, infoSub.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Center

local infoContainer = Instance.new("Frame", homeScroll)
infoContainer.LayoutOrder = 2; infoContainer.Size, infoContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
infoContainer.BackgroundTransparency = 1; infoContainer.Visible = false
local infoLayout = Instance.new("UIListLayout", infoContainer)
infoLayout.SortOrder, infoLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4); infoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Track(infoToggleBtn.MouseButton1Click:Connect(function() infoContainer.Visible = not infoContainer.Visible; infoToggleBtn.Text = infoContainer.Visible and " ↓ thông tin" or " → thông tin" end))

local function CreateHomeCard(parent, order, bgColor, titleText, mainText, copyText, borderColor, iconSymbol)
    local card = Instance.new("Frame", parent)
    card.LayoutOrder, card.Size = order, UDim2.new(1, 0, 0, 26); card.BackgroundColor3, card.BorderSizePixel = bgColor, 0
    Corner(card); Stroke(card, borderColor, 1)
    local ic = Instance.new("Frame", card)
    ic.Size, ic.Position = UDim2.new(0, 16, 0, 16), UDim2.new(0, 4, 0.5, -8); ic.BackgroundColor3, ic.BorderSizePixel = borderColor, 0
    Corner(ic, UDim.new(1, 0)); Stroke(ic, borderColor)
    local il = Instance.new("TextLabel", ic)
    il.Size, il.BackgroundTransparency = UDim2.new(1,0,1,0), 1; il.Text, il.TextColor3 = iconSymbol, Color3.fromRGB(255,255,255); il.TextSize, il.Font = 7, Enum.Font.GothamBold
    local tLbl = Instance.new("TextLabel", card)
    tLbl.Size, tLbl.Position = UDim2.new(1, -70, 0, 10), UDim2.new(0, 24, 0, 1); tLbl.BackgroundTransparency, tLbl.Text = 1, titleText
    tLbl.TextColor3, tLbl.TextSize = Color3.fromRGB(255,150,100), 7; tLbl.Font, tLbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
    local mLbl = Instance.new("TextLabel", card)
    mLbl.Size, mLbl.Position = UDim2.new(1, -70, 0, 12), UDim2.new(0, 24, 0, 12); mLbl.BackgroundTransparency, mLbl.Text = 1, mainText
    mLbl.TextColor3, mLbl.TextSize = Color3.fromRGB(220,220,230), 7; mLbl.Font, mLbl.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
    if copyText ~= "" then
        local cBtn = Instance.new("TextButton", card)
        cBtn.Size, cBtn.Position = UDim2.new(0, 42, 0, 16), UDim2.new(1, -44, 0.5, -8); cBtn.BackgroundTransparency, cBtn.Text = 1, "📋 COPY"
        cBtn.TextColor3, cBtn.TextSize = Color3.fromRGB(200,200,210), 7; cBtn.Font = Enum.Font.GothamBold
        Track(cBtn.MouseButton1Click:Connect(function() if typeof(setclipboard) == "function" then pcall(setclipboard, copyText); cBtn.Text = "✓ COPIED"; task.delay(1.5, function() if cBtn.Parent then cBtn.Text = "📋 COPY" end end) end end))
    end
end

CreateHomeCard(infoContainer, 1, Color3.fromRGB(70,20,45), "ĐƯỢC TẠO BỞI", "VzNam ROBLOX", "", Color3.fromRGB(180,50,50), "👤")
CreateHomeCard(infoContainer, 2, Color3.fromRGB(30,40,70), "DISCORD", "https://discord.gg/6TG7krbsU", "https://discord.gg/6TG7krbsU", Color3.fromRGB(60,100,200), "💬")
CreateHomeCard(infoContainer, 3, Color3.fromRGB(45,45,65), "TIKTOK", "https://www.tiktok.com/@uttop1gl.ovo", "https://www.tiktok.com/@uttop1gl.ovo?_r=1&_t=ZS-9AWatTQR08y", Color3.fromRGB(100,100,120), "🎵")

-- ═════════════════ LOGIC STEAL AN EGG ═════════════════
local function GetChar()
    local c = localPlayer.Character
    if not c then return nil, nil, nil end
    return c, c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

-- Hàm CHẠY BỘ (Dùng tốc độ thực tế của nhân vật)
local function WalkTo(hrp, humanoid, targetPos)
    if not humanoid or humanoid.Health <= 0 then return end
    humanoid:MoveTo(targetPos)
    -- Chờ tối đa 5s cho đến khi tới gần trứng
    local timeout = tick() + 5
    while (hrp.Position - targetPos).Magnitude > 5 and tick() < timeout do
        task.wait(0.1)
    end
    humanoid:MoveTo(hrp.Position)
end

-- Hàm TWEEN SIÊU TỐC (Chỉ dùng để bay về)
local function FastTween(hrp, targetPos, speed)
    local dist = (hrp.Position - targetPos).Magnitude
    if dist < 3 then return end
    local t = dist / speed
    local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
    tw:Play()
    pcall(function() tw.Completed:Wait() end)
end

local function FindNearestEgg()
    local _, hrp = GetChar()
    if not hrp then return nil end
    local bestPrompt, bestDist = nil, math.huge
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "SmartPromptPart" then
            local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt and string.lower(prompt.ActionText) == "steal" then
                if FarmState.SafeZonePos and (v.Position - FarmState.SafeZonePos).Magnitude < 60 then continue end
                local dist = (hrp.Position - v.Position).Magnitude
                if dist < bestDist then bestDist = dist; bestPrompt = prompt end
            end
        end
    end
    return bestPrompt
end

local function FindEggNear(pos, radius)
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "SmartPromptPart" then
            local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt and string.lower(prompt.ActionText) == "steal" and (pos - v.Position).Magnitude <= radius then return prompt end
        end
    end
    return nil
end

local function GrabEgg(prompt)
    if not prompt then return end
    pcall(function()
        prompt.MaxActivationDistance = 500
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        fireproximityprompt(prompt)
    end)
end

local function DropEgg()
    local rs = game:GetService("ReplicatedStorage")
    local dropRF = rs:FindFirstChild("Packages", true) and rs.Packages:FindFirstChild("Networking", true) and rs.Packages.Networking:FindFirstChild("RF/EggWorld/AskFieldEggDrop", true)
    if dropRF then pcall(function() dropRF:InvokeServer() end) else
        local pg = localPlayer:FindFirstChild("PlayerGui")
        local gui = pg and pg:FindFirstChild("DropHeldEgg")
        if gui then for _, obj in ipairs(gui:GetDescendants()) do if obj:IsA("TextButton") or obj:IsA("ImageButton") then pcall(function() obj:Activate() end) end end end
    end
end

local running = false
local function StartFarmLoop()
    if running then return end
    running = true
    task.spawn(function()
        while running and FarmState.AutoSteal do
            pcall(function()
                local char, hrp, humanoid = GetChar()
                if not hrp or not humanoid or not FarmState.SafeZonePos then return end
                
                -- 1. CHẠY BỘ ra lấy trứng
                local prompt = FindNearestEgg()
                if prompt and prompt.Parent then
                    WalkTo(hrp, humanoid, prompt.Parent.Position)
                    task.wait(0.05)
                    GrabEgg(prompt)
                    task.wait(0.15)
                end
                
                -- 2. TWEEN SIÊU TỐC về Safe Zone
                FastTween(hrp, FarmState.SafeZonePos, FarmState.SpeedBack)
                task.wait(0.05)
                
                -- 3. Thả & Lượm lại (Reset Anti-Cheat)
                DropEgg()
                task.wait(0.15)
                local newPrompt = FindEggNear(FarmState.SafeZonePos, 20)
                if newPrompt then
                    GrabEgg(newPrompt)
                    task.wait(0.15)
                    DropEgg()
                end
                task.wait(0.2)
            end)
            task.wait(0.1)
        end
        running = false
    end)
end

-- ═════════════════ TAB FARM (UI) ═════════════════
local tabFarmBtn = Instance.new("TextButton", SidebarScroll)
tabFarmBtn.LayoutOrder = 1; tabFarmBtn.Size, tabFarmBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabFarmBtn.BackgroundTransparency, tabFarmBtn.Text = 0, " 🌾 Farm"; tabFarmBtn.TextColor3, tabFarmBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabFarmBtn.Font, tabFarmBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Corner(tabFarmBtn); RegTheme(tabFarmBtn, "Primary")

local farmInd = Instance.new("Frame", tabFarmBtn)
farmInd.Size, farmInd.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6); farmInd.BackgroundColor3, farmInd.BorderSizePixel = Color3.fromRGB(255,105,180), 0; farmInd.Visible = false
Corner(farmInd, UDim.new(0, 2))

local farmScroll = Instance.new("ScrollingFrame", ContentContainer)
farmScroll.Size, farmScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28); farmScroll.BackgroundTransparency, farmScroll.BorderSizePixel = 1, 0
farmScroll.ScrollBarThickness, farmScroll.Visible, farmScroll.ClipsDescendants = 3, false, true
local farmLayout = Instance.new("UIListLayout", farmScroll)
farmLayout.SortOrder, farmLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); farmLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local farmPad = Instance.new("UIPadding", farmScroll)
farmPad.PaddingLeft, farmPad.PaddingRight = UDim.new(0,4), UDim.new(0,10); farmPad.PaddingTop, farmPad.PaddingBottom = UDim.new(0,4), UDim.new(0,4)
Track(farmLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() farmScroll.CanvasSize = UDim2.new(0, 0, 0, farmLayout.AbsoluteContentSize.Y + 20) end))
Track(tabFarmBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false; if t.Indicator then t.Indicator.Visible = false end end
    farmScroll.Visible, farmInd.Visible = true, true; ActiveTabTitle.Text = "🌾 Farm"
end))
table.insert(Tabs, {Container = farmScroll, Indicator = farmInd})

-- Hàm tạo Toggle, Slider, Dropdown
local function CreateToggle(parent, order, label, getter, setter, onChange)
    local f = Instance.new("Frame", parent)
    f.LayoutOrder, f.Size = order, UDim2.new(1, 0, 0, 30); f.BackgroundColor3, f.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
    Corner(f); Stroke(f); RegTheme(f, "Primary")
    local lbl = Instance.new("TextLabel", f)
    lbl.Size, lbl.Position = UDim2.new(1, -50, 1, 0), UDim2.new(0, 6, 0, 0); lbl.BackgroundTransparency, lbl.Text = 1, label
    lbl.TextColor3, lbl.TextSize = Color3.fromRGB(255,255,255), 8; lbl.Font, lbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f)
    btn.Size, btn.Position = UDim2.new(0, 34, 0, 16), UDim2.new(1, -40, 0.5, -8); btn.BackgroundColor3, btn.Text = Color3.fromRGB(60,65,75), ""
    Corner(btn, UDim.new(1, 0)); Stroke(btn)
    local dot = Instance.new("Frame", btn)
    dot.Size, dot.Position = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6); dot.BackgroundColor3 = Color3.fromRGB(255,255,255); Corner(dot, UDim.new(1, 0))
    local function upd(s) if s then btn.BackgroundColor3 = Color3.fromRGB(50,200,50); dot.Position = UDim2.new(1, -14, 0.5, -6) else btn.BackgroundColor3 = Color3.fromRGB(60,65,75); dot.Position = UDim2.new(0, 2, 0.5, -6) end end
    upd(getter())
    Track(btn.MouseButton1Click:Connect(function() local n = not getter(); setter(n); upd(n); if onChange then onChange(n) end end))
    return f
end

local function CreateSlider(parent, order, label, minV, maxV, getter, setter)
    local f = Instance.new("Frame", parent)
    f.LayoutOrder, f.Size = order, UDim2.new(1, 0, 0, 34); f.BackgroundColor3, f.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
    Corner(f); Stroke(f); RegTheme(f, "Primary")
    local lbl = Instance.new("TextLabel", f)
    lbl.Size, lbl.Position = UDim2.new(1, -10, 0, 12), UDim2.new(0, 6, 0, 2); lbl.BackgroundTransparency, lbl.Text = 1, label
    lbl.TextColor3, lbl.TextSize = Color3.fromRGB(255,255,255), 8; lbl.Font, lbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
    local valLbl = Instance.new("TextLabel", f)
    valLbl.Size, valLbl.Position = UDim2.new(0, 50, 0, 12), UDim2.new(1, -56, 0, 2); valLbl.BackgroundTransparency, valLbl.Text = 1, tostring(getter())
    valLbl.TextColor3, valLbl.TextSize = Color3.fromRGB(0,200,255), 8; valLbl.Font, valLbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Right
    local barBg = Instance.new("Frame", f)
    barBg.Size, barBg.Position = UDim2.new(1, -12, 0, 8), UDim2.new(0, 6, 1, -13); barBg.BackgroundColor3 = Color3.fromRGB(90,25,65)
    Corner(barBg, UDim.new(1, 0)); Stroke(barBg); RegTheme(barBg, "DropItem")
    local barFill = Instance.new("Frame", barBg)
    barFill.BackgroundColor3 = Color3.fromRGB(0,180,255); Corner(barFill, UDim.new(1, 0))
    local pct = (getter() - minV) / (maxV - minV); barFill.Size = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0)
    local drag = Instance.new("TextButton", barBg)
    drag.Size, drag.BackgroundTransparency, drag.Text = UDim2.new(1, 10, 1, 10), 1, ""
    local dragging = false
    Track(drag.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end))
    Track(UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end))
    Track(UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local ap, as = barBg.AbsolutePosition.X, barBg.AbsoluteSize.X
            local p = math.clamp((i.Position.X - ap) / as, 0, 1)
            local v = math.floor(minV + p * (maxV - minV))
            barFill.Size = UDim2.new(p, 0, 1, 0); valLbl.Text = tostring(v); setter(v)
        end
    end))
    return f
end

local function CreateDropdown(parent, order, prefix, options, getter, setter)
    local f = Instance.new("Frame", parent)
    f.LayoutOrder = order; f.Size, f.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y; f.BackgroundTransparency = 1
    local fl = Instance.new("UIListLayout", f)
    fl.SortOrder, fl.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 3); fl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local mainBtn = Instance.new("TextButton", f)
    mainBtn.LayoutOrder, mainBtn.Size = 1, UDim2.new(1, 0, 0, 26); mainBtn.BackgroundColor3, mainBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
    mainBtn.Text = " " .. prefix .. ": " .. tostring(getter()) .. " ✓"; mainBtn.TextColor3, mainBtn.TextSize = Color3.fromRGB(255,255,255), 8
    mainBtn.Font, mainBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
    Corner(mainBtn); Stroke(mainBtn); RegTheme(mainBtn, "Primary")
    local dropFrame = Instance.new("ScrollingFrame", f)
    dropFrame.LayoutOrder, dropFrame.Size = 2, UDim2.new(1, 0, 0, math.min(#options * 22 + 6, 105)); dropFrame.BackgroundColor3, dropFrame.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
    dropFrame.CanvasSize = UDim2.new(0,0,0,#options*22+6); dropFrame.ScrollBarThickness, dropFrame.Visible = 3, false
    Corner(dropFrame); Stroke(dropFrame); RegTheme(dropFrame, "DropFrame")
    local dl = Instance.new("UIListLayout", dropFrame); dl.Padding = UDim.new(0, 3)
    Instance.new("UIPadding", dropFrame).PaddingRight = UDim.new(0, 8)
    for i, opt in ipairs(options) do
        local ob = Instance.new("TextButton", dropFrame)
        ob.LayoutOrder, ob.Size = i, UDim2.new(1, 0, 0, 20); ob.BackgroundColor3, ob.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
        ob.Text, ob.TextColor3, ob.TextSize = " " .. opt, Color3.fromRGB(255,255,255), 8
        ob.Font, ob.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
        Corner(ob, UDim.new(0, 4)); Stroke(ob); RegTheme(ob, "DropItem")
        Track(ob.MouseButton1Click:Connect(function() setter(opt); mainBtn.Text = " " .. prefix .. ": " .. opt .. " ✓"; dropFrame.Visible = false end))
    end
    Track(mainBtn.MouseButton1Click:Connect(function() dropFrame.Visible = not dropFrame.Visible end))
    return f
end

-- NÚT MỞ RỘNG FARM CỦA MÀY
local autoStealBtn = Instance.new("TextButton", farmScroll)
autoStealBtn.LayoutOrder = 1; autoStealBtn.Size, autoStealBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(55,12,40)
autoStealBtn.BackgroundTransparency, autoStealBtn.Text = 0, " → Tự Động Trộm Trứng"; autoStealBtn.TextColor3, autoStealBtn.TextSize = Color3.fromRGB(255,255,255), 10
autoStealBtn.Font, autoStealBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Corner(autoStealBtn); Stroke(autoStealBtn); RegTheme(autoStealBtn, "Secondary")

local asSub = Instance.new("TextLabel", autoStealBtn)
asSub.Size, asSub.Position = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14); asSub.BackgroundTransparency, asSub.Text = 1, "Bật/tắt các chức năng auto trộm trứng"
asSub.TextColor3, asSub.TextSize = Color3.fromRGB(140,140,150), 7; asSub.Font, asSub.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Center

local autoStealContainer = Instance.new("Frame", farmScroll)
autoStealContainer.LayoutOrder = 2; autoStealContainer.Size, autoStealContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
autoStealContainer.BackgroundTransparency = 1; autoStealContainer.Visible = false
local ascL = Instance.new("UIListLayout", autoStealContainer)
ascL.SortOrder, ascL.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); ascL.HorizontalAlignment = Enum.HorizontalAlignment.Center
Track(autoStealBtn.MouseButton1Click:Connect(function()
    autoStealContainer.Visible = not autoStealContainer.Visible
    autoStealBtn.Text = autoStealContainer.Visible and " ↓ Tự Động Trộm Trứng" or " → Tự Động Trộm Trứng"
end))

-- CÁC CHỨC NĂNG CON
CreateToggle(autoStealContainer, 1, "⚡ Tự Động Cướp Trứng",
    function() return FarmState.AutoSteal end, function(v) FarmState.AutoSteal = v end, function(v) if v then StartFarmLoop() else running = false end end)

local setSafeZoneBtn = Instance.new("TextButton", autoStealContainer)
setSafeZoneBtn.LayoutOrder = 2; setSafeZoneBtn.Size = UDim2.new(1, 0, 0, 30)
setSafeZoneBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200); setSafeZoneBtn.Text = "📍 Đặt Vùng An Toàn (Bìa Rừng)"
setSafeZoneBtn.TextColor3 = Color3.fromRGB(255, 255, 255); setSafeZoneBtn.Font = Enum.Font.GothamBold; setSafeZoneBtn.TextSize = 9
Corner(setSafeZoneBtn); Stroke(setSafeZoneBtn); RegTheme(setSafeZoneBtn, "Secondary")
setSafeZoneBtn.MouseButton1Click:Connect(function()
    local _, hrp = GetChar()
    if hrp then
        FarmState.SafeZonePos = hrp.Position
        setSafeZoneBtn.Text = "✅ Đã Lưu Vùng An Toàn!"
        task.wait(2)
        setSafeZoneBtn.Text = "📍 Đặt Vùng An Toàn (Bìa Rừng)"
    end
end)

CreateSlider(autoStealContainer, 3, "⚡ Tốc độ bay về (Tween)", 500, 3000, function() return FarmState.SpeedBack end, function(v) FarmState.SpeedBack = v end)

CreateToggle(autoStealContainer, 4, "🚀 Cướp Siêu Tốc (Cũ)", function() return FarmState.SuperSpeed end, function(v) FarmState.SuperSpeed = v end)
CreateSlider(autoStealContainer, 5, "👣 Số Bước Cướp (Cũ)", 1, 10, function() return FarmState.Steps end, function(v) FarmState.Steps = v end)
CreateToggle(autoStealContainer, 6, "📦 Fast Delivery (Cũ)", function() return FarmState.FastDelivery end, function(v) FarmState.FastDelivery = v end)
CreateToggle(autoStealContainer, 7, "⚡ Cướp Siêu Tốc V2 (Cũ)", function() return FarmState.SpeedV2 end, function(v) FarmState.SpeedV2 = v end)
CreateToggle(autoStealContainer, 8, "💰 Auto Sell (Cũ)", function() return FarmState.SellAfterDrop end, function(v) FarmState.SellAfterDrop = v end)
CreateToggle(autoStealContainer, 9, "🛡️ Né Vệ Sĩ (Cũ)", function() return FarmState.AvoidGuards end, function(v) FarmState.AvoidGuards = v end)
CreateSlider(autoStealContainer, 10, "📏 Bán Kính Né Guard (Cũ)", 20, 100, function() return FarmState.GuardRadius end, function(v) FarmState.GuardRadius = v end)
CreateSlider(autoStealContainer, 11, "🕊️ Tốc Độ Bay (Cũ)", 50, 300, function() return FarmState.FlySpeed end, function(v) FarmState.FlySpeed = v end)
CreateDropdown(autoStealContainer, 12, "⭐ Ưu Tiên Cướp (Cũ)", {"Gần nhất", "Giá trị cao nhất", "Rarity cao nhất"}, function() return FarmState.StealPriority end, function(v) FarmState.StealPriority = v end)

-- ═════════════════ TAB MISC ═════════════════
local tabMiscBtn = Instance.new("TextButton", SidebarScroll)
tabMiscBtn.LayoutOrder = 2; tabMiscBtn.Size, tabMiscBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabMiscBtn.BackgroundTransparency, tabMiscBtn.Text = 0, " ⚙️ MISC"; tabMiscBtn.TextColor3, tabMiscBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabMiscBtn.Font, tabMiscBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Corner(tabMiscBtn); RegTheme(tabMiscBtn, "Primary")

local miscInd = Instance.new("Frame", tabMiscBtn)
miscInd.Size, miscInd.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6); miscInd.BackgroundColor3, miscInd.BorderSizePixel = Color3.fromRGB(255,105,180), 0; miscInd.Visible = false
Corner(miscInd, UDim.new(0, 2))

local miscScroll = Instance.new("ScrollingFrame", ContentContainer)
miscScroll.Size, miscScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28); miscScroll.BackgroundTransparency, miscScroll.BorderSizePixel = 1, 0
miscScroll.ScrollBarThickness, miscScroll.Visible, miscScroll.ClipsDescendants = 3, false, true
local miscLayout = Instance.new("UIListLayout", miscScroll)
miscLayout.SortOrder, miscLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); miscLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local miscPad = Instance.new("UIPadding", miscScroll)
miscPad.PaddingLeft, miscPad.PaddingRight, miscPad.PaddingTop = UDim.new(0,4), UDim.new(0,10), UDim.new(0,4)
Track(miscLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() miscScroll.CanvasSize = UDim2.new(0, 0, 0, miscLayout.AbsoluteContentSize.Y + 15) end))
Track(tabMiscBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false; if t.Indicator then t.Indicator.Visible = false end end
    miscScroll.Visible, miscInd.Visible = true, true; ActiveTabTitle.Text = "⚙️ MISC"
end))
table.insert(Tabs, {Container = miscScroll, Indicator = miscInd})

-- Nhạc
local musicBtn = Instance.new("TextButton", miscScroll)
musicBtn.LayoutOrder = 1; musicBtn.Size, musicBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(55,12,40)
musicBtn.BackgroundTransparency, musicBtn.Text = 0, " ↓ âm nhạc"; musicBtn.TextColor3, musicBtn.TextSize = Color3.fromRGB(255,255,255), 10
musicBtn.Font, musicBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Corner(musicBtn); Stroke(musicBtn); RegTheme(musicBtn, "Secondary")

local musicContainer = Instance.new("Frame", miscScroll)
musicContainer.LayoutOrder, musicContainer.Size = 2, UDim2.new(1, 0, 0, 0); musicContainer.AutomaticSize, musicContainer.BackgroundTransparency = Enum.AutomaticSize.Y, 1
musicContainer.Visible = true
local mL = Instance.new("UIListLayout", musicContainer)
mL.SortOrder, mL.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4); mL.HorizontalAlignment = Enum.HorizontalAlignment.Center
Track(musicBtn.MouseButton1Click:Connect(function() musicContainer.Visible = not musicContainer.Visible; musicBtn.Text = musicContainer.Visible and " ↓ âm nhạc" or " → âm nhạc" end))

local HubSound = Instance.new("Sound", SoundService)
HubSound.Name, HubSound.Looped, HubSound.Volume = "VzNamHubSound", true, State.Volume
HubSound.SoundId = "rbxassetid://" .. State.SoundId

local musicToggle = Instance.new("Frame", musicContainer)
musicToggle.LayoutOrder, musicToggle.Size = 1, UDim2.new(1, 0, 0, 30); musicToggle.BackgroundColor3, musicToggle.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Corner(musicToggle); Stroke(musicToggle); RegTheme(musicToggle, "Primary")
local mtl = Instance.new("TextLabel", musicToggle)
mtl.Size, mtl.Position = UDim2.new(1, -40, 1, 0), UDim2.new(0, 5, 0, 0); mtl.BackgroundTransparency, mtl.Text = 1, "🎵 Phát Nhạc Nền"
mtl.TextColor3, mtl.TextSize = Color3.fromRGB(255,255,255), 9; mtl.Font, mtl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local tMusic = Instance.new("TextButton", musicToggle)
tMusic.Size, tMusic.Position = UDim2.new(0, 30, 0, 15), UDim2.new(1, -34, 0.5, -7.5); tMusic.BackgroundColor3, tMusic.Text = Color3.fromRGB(60,65,75), ""
Corner(tMusic, UDim.new(1, 0)); Stroke(tMusic)
local mDot = Instance.new("Frame", tMusic)
mDot.Size, mDot.Position = UDim2.new(0, 11, 0, 11), UDim2.new(0, 2, 0.5, -5.5); mDot.BackgroundColor3 = Color3.fromRGB(255,255,255); Corner(mDot, UDim.new(1, 0))
local playing = false
Track(tMusic.MouseButton1Click:Connect(function()
    playing = not playing
    if playing then tMusic.BackgroundColor3 = Color3.fromRGB(50, 200, 50); mDot.Position = UDim2.new(1, -13, 0.5, -5.5); HubSound:Play()
    else tMusic.BackgroundColor3 = Color3.fromRGB(60, 65, 75); mDot.Position = UDim2.new(0, 2, 0.5, -5.5); HubSound:Stop() end
end))

-- Màu menu
local colorToggle = Instance.new("TextButton", miscScroll)
colorToggle.LayoutOrder = 3; colorToggle.Size, colorToggle.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(55,12,40)
colorToggle.BackgroundTransparency, colorToggle.Text = 0, " ↓ màu menu"; colorToggle.TextColor3, colorToggle.TextSize = Color3.fromRGB(255,255,255), 10
colorToggle.Font, colorToggle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Corner(colorToggle); Stroke(colorToggle); RegTheme(colorToggle, "Secondary")

local colorContainer = Instance.new("Frame", miscScroll)
colorContainer.LayoutOrder, colorContainer.Size = 4, UDim2.new(1, 0, 0, 0); colorContainer.AutomaticSize, colorContainer.BackgroundTransparency = Enum.AutomaticSize.Y, 1
colorContainer.Visible = true
local cL = Instance.new("UIListLayout", colorContainer)
cL.SortOrder, cL.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4); cL.HorizontalAlignment = Enum.HorizontalAlignment.Center
Track(colorToggle.MouseButton1Click:Connect(function() colorContainer.Visible = not colorContainer.Visible; colorToggle.Text = colorContainer.Visible and " ↓ màu menu" or " → màu menu" end))

local menuThemes = {
    {Name = "🌸 Hồng Pastel",    Bg = Color3.fromRGB(70, 15, 50)},
    {Name = "🌙 Đêm Đen Sâu",   Bg = Color3.fromRGB(15, 16, 22)},
    {Name = "🔥 Đỏ Lửa",         Bg = Color3.fromRGB(70, 10, 15)},
    {Name = "🌊 Xanh Đại Dương", Bg = Color3.fromRGB(10, 22, 50)},
}

local function ApplyTheme(newBase)
    State.ThemeBase = newBase
    local primary   = newBase:Lerp(Color3.new(1,1,1), 0.08)
    local secondary = newBase:Lerp(Color3.new(1,1,1), 0.15)
    local dropFrame = newBase:Lerp(Color3.new(1,1,1), 0.2)
    local dropItem  = newBase:Lerp(Color3.new(1,1,1), 0.3)
    local input     = newBase:Lerp(Color3.new(0,0,0), 0.4)
    SidebarPanel.BackgroundColor3 = newBase; ContentContainer.BackgroundColor3 = newBase
    for _, item in ipairs(ThemedElements) do
        local el = item.Element
        if el and el.Parent then
            if item.Type == "Primary" then el.BackgroundColor3 = primary
            elseif item.Type == "Secondary" then el.BackgroundColor3 = secondary
            elseif item.Type == "DropFrame" then el.BackgroundColor3 = dropFrame
            elseif item.Type == "DropItem" then el.BackgroundColor3 = dropItem
            elseif item.Type == "Input" then el.BackgroundColor3 = input end
        end
    end
end

local themeBtn = Instance.new("TextButton", colorContainer)
themeBtn.LayoutOrder, themeBtn.Size = 1, UDim2.new(1, 0, 0, 26); themeBtn.BackgroundColor3, themeBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
themeBtn.Text, themeBtn.TextColor3 = " 🎨 Theme: 🌙 Đêm Đen Sâu", Color3.fromRGB(255,255,255); themeBtn.TextSize, themeBtn.Font = 9, Enum.Font.Gotham
themeBtn.TextXAlignment = Enum.TextXAlignment.Left
Corner(themeBtn); Stroke(themeBtn); RegTheme(themeBtn, "Primary")

local themeDrop = Instance.new("ScrollingFrame", colorContainer)
themeDrop.LayoutOrder, themeDrop.Size = 2, UDim2.new(1, 0, 0, 95); themeDrop.BackgroundColor3, themeDrop.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
themeDrop.CanvasSize = UDim2.new(0,0,0,#menuThemes*25); themeDrop.ScrollBarThickness, themeDrop.Visible = 3, false
Corner(themeDrop); Stroke(themeDrop); RegTheme(themeDrop, "DropFrame")
local tDL = Instance.new("UIListLayout", themeDrop); tDL.Padding = UDim.new(0, 3)
Instance.new("UIPadding", themeDrop).PaddingRight = UDim.new(0, 8)
for i, th in ipairs(menuThemes) do
    local tb = Instance.new("TextButton", themeDrop)
    tb.LayoutOrder, tb.Size = i, UDim2.new(1, 0, 0, 22); tb.BackgroundColor3, tb.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
    tb.Text, tb.TextColor3, tb.TextSize = " " .. th.Name, Color3.fromRGB(255,255,255), 9
    tb.Font, tb.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
    Corner(tb, UDim.new(0, 4)); Stroke(tb); RegTheme(tb, "DropItem")
    Track(tb.MouseButton1Click:Connect(function() themeBtn.Text = " 🎨 Theme: " .. th.Name; themeDrop.Visible = false; ApplyTheme(th.Bg) end))
end
Track(themeBtn.MouseButton1Click:Connect(function() themeDrop.Visible = not themeDrop.Visible end))

-- Viền
local strokeList = {
    {Name = "🔵 Xanh Dương",        Color = Color3.fromRGB(0, 191, 255)},
    {Name = "🌈 Cầu Vồng",          Color = "Rainbow"},
    {Name = "🌸 Hồng Kẹo",          Color = Color3.fromRGB(255, 105, 180)},
    {Name = "❌ Không Viền",        Color = "None"},
}

local strokeBtn = Instance.new("TextButton", colorContainer)
strokeBtn.LayoutOrder, strokeBtn.Size = 3, UDim2.new(1, 0, 0, 26); strokeBtn.BackgroundColor3, strokeBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
strokeBtn.Text, strokeBtn.TextColor3 = " 🎨 Viền: 🔵 Xanh Dương", Color3.fromRGB(255,255,255); strokeBtn.TextSize, strokeBtn.Font = 9, Enum.Font.Gotham
strokeBtn.TextXAlignment = Enum.TextXAlignment.Left
Corner(strokeBtn); Stroke(strokeBtn); RegTheme(strokeBtn, "Primary")

local strokeDrop = Instance.new("ScrollingFrame", colorContainer)
strokeDrop.LayoutOrder, strokeDrop.Size = 4, UDim2.new(1, 0, 0, 95); strokeDrop.BackgroundColor3, strokeDrop.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
strokeDrop.CanvasSize = UDim2.new(0,0,0,#strokeList*25); strokeDrop.ScrollBarThickness, strokeDrop.Visible = 3, false
Corner(strokeDrop); Stroke(strokeDrop); RegTheme(strokeDrop, "DropFrame")
local sDL = Instance.new("UIListLayout", strokeDrop); sDL.Padding = UDim.new(0, 3)
Instance.new("UIPadding", strokeDrop).PaddingRight = UDim.new(0, 8)

local function UpdateAllStrokes(target)
    if target == "None" then for _, s in ipairs(AllUIStrokes) do if s then s.Transparency = 1 end end
    elseif target == "Rainbow" then for _, s in ipairs(AllUIStrokes) do if s then s.Transparency = 0 end end
    else State.StrokeColor = target; for _, s in ipairs(AllUIStrokes) do if s then s.Transparency = 0; s.Color = target end end end
end

for i, cItem in ipairs(strokeList) do
    local cb = Instance.new("TextButton", strokeDrop)
    cb.LayoutOrder, cb.Size = i, UDim2.new(1, 0, 0, 22); cb.BackgroundColor3, cb.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
    cb.Text, cb.TextColor3, cb.TextSize = " " .. cItem.Name, Color3.fromRGB(255,255,255), 9
    cb.Font, cb.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
    Corner(cb, UDim.new(0, 4)); Stroke(cb); RegTheme(cb, "DropItem")
    Track(cb.MouseButton1Click:Connect(function()
        strokeBtn.Text = " 🎨 Viền: " .. cItem.Name; strokeDrop.Visible = false
        if cItem.Color == "Rainbow" then State.StrokeMode = "Rainbow"; UpdateAllStrokes("Rainbow")
        elseif cItem.Color == "None" then State.StrokeMode = "None"; UpdateAllStrokes("None")
        else State.StrokeMode = "Solid"; UpdateAllStrokes(cItem.Color) end
    end))
end
Track(strokeBtn.MouseButton1Click:Connect(function() strokeDrop.Visible = not strokeDrop.Visible end))
Track(RunService.RenderStepped:Connect(function()
    if State.StrokeMode ~= "Rainbow" then return end
    local rainbow = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    for _, s in ipairs(AllUIStrokes) do if s then s.Transparency = 0; s.Color = rainbow end end
end))

-- ═════════════════ TAB CONFIG ═════════════════
local tabCfgBtn = Instance.new("TextButton", SidebarScroll)
tabCfgBtn.LayoutOrder = 3; tabCfgBtn.Size, tabCfgBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabCfgBtn.BackgroundTransparency, tabCfgBtn.Text = 0, " 📦 CẤU HÌNH"; tabCfgBtn.TextColor3, tabCfgBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabCfgBtn.Font, tabCfgBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Corner(tabCfgBtn); RegTheme(tabCfgBtn, "Primary")

local cfgInd = Instance.new("Frame", tabCfgBtn)
cfgInd.Size, cfgInd.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6); cfgInd.BackgroundColor3, cfgInd.BorderSizePixel = Color3.fromRGB(255,105,180), 0; cfgInd.Visible = false
Corner(cfgInd, UDim.new(0, 2))

local cfgScroll = Instance.new("ScrollingFrame", ContentContainer)
cfgScroll.Size, cfgScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
cfgScroll.BackgroundTransparency, cfgScroll.BorderSizePixel = 1, 0; cfgScroll.ScrollBarThickness, cfgScroll.Visible, cfgScroll.ClipsDescendants = 3, false, true
local cfgLayout = Instance.new("UIListLayout", cfgScroll)
cfgLayout.SortOrder, cfgLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); cfgLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", cfgScroll).PaddingTop = UDim.new(0, 4)
Track(tabCfgBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false; if t.Indicator then t.Indicator.Visible = false end end
    cfgScroll.Visible, cfgInd.Visible = true, true; ActiveTabTitle.Text = "📦 CẤU HÌNH"
end))
table.insert(Tabs, {Container = cfgScroll, Indicator = cfgInd})

Track(flowerBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible; UpdateFlowerIcon() end))
ApplyTheme(Color3.fromRGB(15, 16, 22)); UpdateAllStrokes(Color3.fromRGB(0, 191, 255))
print("[VzNam Hub-Main] ✅ FULL LOADED - Đã có đầy đủ chức năng!")
