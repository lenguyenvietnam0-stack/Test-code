--[[
    ═══════════════════════════════════════════════════════
    VzNam Hub v4 — ẢNH NỀN ANIME FIX CHUẨN 100%
    ═══════════════════════════════════════════════════════
]]

local CoreGui   = game:GetService("CoreGui")
local Players   = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local SoundService    = game:GetService("SoundService")
local HttpService     = game:GetService("HttpService")
local RunService      = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end
if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end

local Connections = {}
local function Track(conn)
    if conn then table.insert(Connections, conn) end
    return conn
end
local function DisconnectAll()
    for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
    Connections = {}
end

local State = {
    ThemeBase      = Color3.fromRGB(15, 16, 22),
    StrokeMode     = "Solid",
    StrokeColor    = Color3.fromRGB(0, 191, 255),
    Volume         = 0.5,
    SoundId        = "1837879082",
    SelectedScript = nil,
    IsAutoLoad     = false,
    CurrentConfig  = "Default",
    AutoSave       = true,
    AutoLoadConfig = true,
    Transparent    = 0,
    Initialized    = false,
}

local AutoSaveHook        = function() end
local RefreshStartupLabel = function() end

local function Corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = radius or UDim.new(0, 5)
    return c
end

local AllUIStrokes = {}
local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke", parent)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color or State.StrokeColor
    s.Thickness = thickness or 1
    table.insert(AllUIStrokes, s)
    return s
end

local ThemedElements = {}
local function RegTheme(el, t)
    table.insert(ThemedElements, {Element = el, Type = t})
    return el
end

local ALLOWED_HOSTS = {
    "raw.githubusercontent.com",
    "gist.githubusercontent.com",
    "github.com",
    "api.luarmor.net",
    "fyycommunity.my.id",
    "id.tomroblox.com",
}
local function IsUrlAllowed(url)
    if typeof(url) ~= "string" then return false end
    local host = string.match(url, "^https?://([^/]+)")
    if not host then return false end
    host = host:lower()
    for _, h in ipairs(ALLOWED_HOSTS) do
        if host == h or host:sub(-(#h + 1)) == "." .. h then return true end
    end
    return false
end

local function SafeLoad(url)
    if not IsUrlAllowed(url) then return false end
    local ok, source = pcall(function() return game:HttpGet(url, true) end)
    if not ok or not source then return false end
    local ok2, fn = pcall(loadstring, source)
    if not ok2 or not fn then return false end
    local ok3, err = pcall(fn)
    return ok3
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.DisplayOrder = 99999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 280)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Corner(MainFrame, UDim.new(0, 8))
Stroke(MainFrame, Color3.fromRGB(0, 191, 255), 2)

-- 🌸 [ẢNH NỀN HIỂN THỊ CHUẨN 100%] 🌸
local CustomBg = Instance.new("ImageLabel", MainFrame)
CustomBg.Name = "CustomStaticBg"
CustomBg.Size = UDim2.new(1, 0, 1, 0)
CustomBg.Position = UDim2.new(0, 0, 0, 0)
CustomBg.BackgroundTransparency = 1
CustomBg.ZIndex = 0
CustomBg.Image = "rbxassetid://5252447904" -- ID chuẩn không bị lỗi chặn
CustomBg.ImageTransparency = 0.35
Corner(CustomBg, UDim.new(0, 8))

local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size, ResizeBtn.Position = UDim2.new(0, 18, 0, 18), UDim2.new(1, -18, 1, -18)
ResizeBtn.BackgroundTransparency, ResizeBtn.Text = 1, "◢"
ResizeBtn.TextColor3, ResizeBtn.TextSize, ResizeBtn.ZIndex = Color3.fromRGB(0, 191, 255), 12, 10

local resizing, resizeStart, startSize = false, nil, nil
Track(ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = MainFrame.AbsoluteSize
    end
end))
Track(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end))
Track(UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - resizeStart
        MainFrame.Size = UDim2.new(0, math.clamp(startSize.X + d.X, 320, 500), 0, math.clamp(startSize.Y + d.Y, 230, 450))
    end
end))

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1

local Logo = Instance.new("Frame", TopBar)
Logo.Size, Logo.Position = UDim2.new(0, 18, 0, 18), UDim2.new(0, 6, 0.5, -9)
Logo.BackgroundColor3, Logo.BorderSizePixel = Color3.fromRGB(0, 191, 255), 0
Corner(Logo, UDim.new(0, 4))
Stroke(Logo, Color3.fromRGB(0, 191, 255))

local LogoIcon = Instance.new("TextLabel", Logo)
LogoIcon.Size, LogoIcon.BackgroundTransparency = UDim2.new(1,0,1,0), 1
LogoIcon.Text, LogoIcon.TextColor3 = "🌸", Color3.fromRGB(255,255,255)
LogoIcon.TextSize, LogoIcon.Font = 10, Enum.Font.GothamBold

local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position = UDim2.new(1, -60, 1, 0), UDim2.new(0, 28, 0, 0)
Title.BackgroundTransparency, Title.Text = 1, "🌸 VzNam Hub v4 🌸"
Title.TextColor3, Title.TextSize = Color3.fromRGB(0, 191, 255), 11
Title.Font, Title.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 24, 0, 24), UDim2.new(1, -26, 0.5, -12)
CloseBtn.BackgroundTransparency, CloseBtn.Text = 1, "✕"
CloseBtn.TextColor3, CloseBtn.TextSize = Color3.fromRGB(200, 200, 210), 10
CloseBtn.Font = Enum.Font.GothamBold

Track(CloseBtn.MouseButton1Click:Connect(function()
    DisconnectAll()
    if SoundService:FindFirstChild("VzNamHubSound") then
        SoundService.VzNamHubSound:Stop()
        SoundService.VzNamHubSound:Destroy()
    end
    ScreenGui:Destroy()
end))

local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Size, SidebarPanel.Position = UDim2.new(0.3, -4, 1, -34), UDim2.new(0, 6, 0, 28)
SidebarPanel.BackgroundColor3, SidebarPanel.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Corner(SidebarPanel, UDim.new(0, 6))
Stroke(SidebarPanel, Color3.fromRGB(0,191,255), 1)

local SearchBoxTab = Instance.new("TextBox", SidebarPanel)
SearchBoxTab.Size, SearchBoxTab.Position = UDim2.new(1, -8, 0, 18), UDim2.new(0, 4, 0, 4)
SearchBoxTab.BackgroundColor3 = Color3.fromRGB(12,12,17)
SearchBoxTab.Text, SearchBoxTab.PlaceholderText = "", "🔍 Search..."
SearchBoxTab.PlaceholderColor3, SearchBoxTab.TextColor3 = Color3.fromRGB(150,155,165), Color3.fromRGB(255,255,255)
SearchBoxTab.TextSize, SearchBoxTab.Font = 8, Enum.Font.Gotham
Corner(SearchBoxTab, UDim.new(0, 4))
Stroke(SearchBoxTab)
RegTheme(SearchBoxTab, "Input")

local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
SidebarScroll.Size, SidebarScroll.Position = UDim2.new(1, -4, 1, -26), UDim2.new(0, 2, 0, 25)
SidebarScroll.BackgroundTransparency, SidebarScroll.BorderSizePixel = 1, 0
SidebarScroll.ScrollBarThickness, SidebarScroll.ClipsDescendants = 2, true
local SidebarLayout = Instance.new("UIListLayout", SidebarScroll)
SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 3)
local SidebarPadding = Instance.new("UIPadding", SidebarScroll)
SidebarPadding.PaddingLeft, SidebarPadding.PaddingRight = UDim.new(0, 2), UDim.new(0, 6)

Track(SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 10)
end))

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position = UDim2.new(0.68, -4, 1, -34), UDim2.new(0.315, 0, 0, 28)
ContentContainer.BackgroundColor3, ContentContainer.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Corner(ContentContainer, UDim.new(0, 6))
Stroke(ContentContainer, Color3.fromRGB(0,191,255), 1)

local ContentHeader = Instance.new("Frame", ContentContainer)
ContentHeader.Size, ContentHeader.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1

local ActiveTabTitle = Instance.new("TextLabel", ContentHeader)
ActiveTabTitle.Size, ActiveTabTitle.Position = UDim2.new(1, -30, 1, 0), UDim2.new(0, 6, 0, 0)
ActiveTabTitle.BackgroundTransparency, ActiveTabTitle.Text = 1, "🏠 Trang Chủ"
ActiveTabTitle.TextColor3, ActiveTabTitle.TextSize = Color3.fromRGB(255,255,255), 10
ActiveTabTitle.Font, ActiveTabTitle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

-- Nút mở hub thu gọn
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size, OpenButton.Position = UDim2.new(0, 40, 0, 40), UDim2.new(0, 15, 0.25, 0)
OpenButton.BackgroundColor3, OpenButton.BackgroundTransparency = Color3.fromRGB(20,22,28), 0
OpenButton.Text, OpenButton.TextSize = "🌸", 20
OpenButton.Active, OpenButton.Draggable = true, true
Corner(OpenButton, UDim.new(1, 0))
local OpenStroke = Instance.new("UIStroke", OpenButton)
OpenStroke.Thickness, OpenStroke.Color = 3, Color3.fromRGB(0,191,255)
table.insert(AllUIStrokes, OpenStroke)

Track(OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end))

print("[VzNam Hub v4] ✅ Loaded với ảnh nền chuẩn!")
