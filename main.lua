local CoreGui, Players, TweenService, UserInputService, SoundService, HttpService, RunService =
    game:GetService("CoreGui"), game:GetService("Players"), game:GetService("TweenService"),
    game:GetService("UserInputService"), game:GetService("SoundService"),
    game:GetService("HttpService"), game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end

--------------------------------------------------------------------------------
-- HELPERS
--------------------------------------------------------------------------------
local LastSelectedScriptStroke = nil
local RegisteredScripts = {}
local AllUIStrokes = {}
local ThemedElements = {}
local Connections = {}
local CurrentStrokeMode = "Rainbow"
local CurrentStrokeColor = Color3.fromRGB(255, 105, 180)
local SubTabPairs = {}

local function Connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(Connections, c)
    return c
end

local function TrackStroke(stroke)
    if stroke and not table.find(AllUIStrokes, stroke) then
        table.insert(AllUIStrokes, stroke)
    end
    return stroke
end

local function RegisterTheme(element, t)
    for _, v in ipairs(ThemedElements) do
        if v.Element == element then return element end
    end
    table.insert(ThemedElements, {Element = element, Type = t})
    return element
end

local function SafeLoad(url)
    local ok, err = pcall(function()
        local code = game:HttpGet(url, true)
        local fn, compileErr = loadstring(code)
        if not fn then error(compileErr) end
        fn()
    end)
    if not ok then warn("[VzNam Hub] Load lỗi: " .. tostring(err)) end
end

local function ResetStrokeStyle(stroke, isActive)
    if not stroke or not stroke.Parent then return end
    if CurrentStrokeMode == "None" then
        stroke.Transparency = 1
    else
        stroke.Transparency = isActive and 0 or 0.4
        if CurrentStrokeMode == "Color" then stroke.Color = CurrentStrokeColor end
    end
    stroke.Thickness = isActive and 2.5 or 1.5
end

local function ApplyStrokeColor(newColor)
    if newColor == "None" then
        CurrentStrokeMode = "None"
        for _, s in ipairs(AllUIStrokes) do
            if s and s.Parent then s.Transparency = 1 end
        end
    elseif newColor == "Rainbow" then
        CurrentStrokeMode = "Rainbow"
        for _, s in ipairs(AllUIStrokes) do
            if s and s.Parent then s.Transparency = 0 end
        end
    else
        CurrentStrokeMode = "Color"
        CurrentStrokeColor = newColor
        for _, s in ipairs(AllUIStrokes) do
            if s and s.Parent then
                s.Transparency = 0
                s.Color = newColor
            end
        end
    end
    for _, p in ipairs(SubTabPairs) do
        ResetStrokeStyle(p.nkStroke, p.activeIsNoKey)
        ResetStrokeStyle(p.hkStroke, not p.activeIsNoKey)
    end
    if LastSelectedScriptStroke and LastSelectedScriptStroke.Parent then
        LastSelectedScriptStroke.Transparency = (CurrentStrokeMode == "None") and 1 or 0
        LastSelectedScriptStroke.Thickness = 2.5
        if CurrentStrokeMode == "Color" then
            LastSelectedScriptStroke.Color = CurrentStrokeColor
        end
    end
end

--------------------------------------------------------------------------------
-- SCREEN GUI
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.DisplayOrder = 99999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 280)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local OuterStroke = TrackStroke(Instance.new("UIStroke", MainFrame))
OuterStroke.Color, OuterStroke.Thickness = Color3.fromRGB(255, 105, 180), 2

local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size = UDim2.new(0, 18, 0, 18)
ResizeBtn.Position = UDim2.new(1, -18, 1, -18)
ResizeBtn.BackgroundTransparency = 1
ResizeBtn.Text = "◢"
ResizeBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ResizeBtn.TextSize = 12
ResizeBtn.ZIndex = 10

local resizing = false
local resizeStart, startSize
Connect(ResizeBtn.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = MainFrame.AbsoluteSize
    end
end)
Connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)
Connect(UserInputService.InputChanged, function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local nw = math.clamp(startSize.X + delta.X, 320, 500)
        local nh = math.clamp(startSize.Y + delta.Y, 230, 450)
        MainFrame.Size = UDim2.new(0, nw, 0, nh)
    end
end)

--------------------------------------------------------------------------------
-- TOP BAR
--------------------------------------------------------------------------------
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1

local Logo = Instance.new("Frame", TopBar)
Logo.Size, Logo.Position = UDim2.new(0, 18, 0, 18), UDim2.new(0, 6, 0.5, -9)
Logo.BackgroundColor3, Logo.BackgroundTransparency, Logo.BorderSizePixel = Color3.fromRGB(255, 105, 180), 0, 0
Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", Logo)).Color = Color3.fromRGB(255, 105, 180)

local LogoIcon = Instance.new("TextLabel", Logo)
LogoIcon.Size, LogoIcon.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
LogoIcon.Text, LogoIcon.TextColor3, LogoIcon.TextSize, LogoIcon.Font = "🌸", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold

local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -60, 1, 0), UDim2.new(0, 28, 0, 0), 1
Title.Text, Title.TextColor3, Title.TextSize, Title.Font, Title.TextXAlignment = "🌸 VzNam Hub v4 🌸", Color3.fromRGB(255, 105, 180), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundTransparency = UDim2.new(0, 24, 0, 24), UDim2.new(1, -26, 0.5, -12), 1
CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize, CloseBtn.Font = "✕", Color3.fromRGB(200, 200, 210), 10, Enum.Font.GothamBold

Connect(CloseBtn.MouseButton1Click, function()
    if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end
    for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
    AllUIStrokes, ThemedElements, Connections, SubTabPairs = {}, {}, {}, {}
    ScreenGui:Destroy()
end)

--------------------------------------------------------------------------------
-- SIDEBAR
--------------------------------------------------------------------------------
local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Name = "SidebarPanel"
SidebarPanel.Size, SidebarPanel.Position = UDim2.new(0.3, -4, 1, -34), UDim2.new(0, 6, 0, 28)
SidebarPanel.BackgroundColor3, SidebarPanel.BackgroundTransparency, SidebarPanel.BorderSizePixel = Color3.fromRGB(15, 16, 22), 0, 0
Instance.new("UICorner", SidebarPanel).CornerRadius = UDim.new(0, 6)
local SidebarStroke = TrackStroke(Instance.new("UIStroke", SidebarPanel))
SidebarStroke.Color, SidebarStroke.Thickness = Color3.fromRGB(40, 43, 52), 1

local SearchBoxTab = Instance.new("TextBox", SidebarPanel)
SearchBoxTab.Size, SearchBoxTab.Position = UDim2.new(1, -8, 0, 18), UDim2.new(0, 4, 0, 4)
SearchBoxTab.BackgroundColor3, SearchBoxTab.BackgroundTransparency = Color3.fromRGB(12, 12, 17), 0
SearchBoxTab.Text, SearchBoxTab.PlaceholderText, SearchBoxTab.PlaceholderColor3 = "", "🔍 Search...", Color3.fromRGB(150, 155, 165)
SearchBoxTab.TextColor3, SearchBoxTab.TextSize, SearchBoxTab.Font = Color3.fromRGB(255, 255, 255), 8, Enum.Font.Gotham
Instance.new("UICorner", SearchBoxTab).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", SearchBoxTab)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(SearchBoxTab, "Input")

local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
SidebarScroll.Size, SidebarScroll.Position = UDim2.new(1, -4, 1, -26), UDim2.new(0, 2, 0, 25)
SidebarScroll.BackgroundTransparency, SidebarScroll.BorderSizePixel = 1, 0
SidebarScroll.ScrollBarThickness, SidebarScroll.ClipsDescendants = 2, true
local SidebarLayout = Instance.new("UIListLayout", SidebarScroll)
SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
local SidebarPadding = Instance.new("UIPadding", SidebarScroll)
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.PaddingTop = UDim.new(0, 3)
SidebarPadding.PaddingBottom = UDim.new(0, 3)

Connect(SearchBoxTab:GetPropertyChangedSignal("Text"), function()
    local query = string.lower(SearchBoxTab.Text)
    for _, item in ipairs(SidebarScroll:GetChildren()) do
        if item:IsA("TextButton") then
            item.Visible = (query == "" or string.find(string.lower(item.Text), query)) and true or false
        end
    end
end)

--------------------------------------------------------------------------------
-- CONTENT CONTAINER
--------------------------------------------------------------------------------
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size, ContentContainer.Position = UDim2.new(0.68, -4, 1, -34), UDim2.new(0.315, 0, 0, 28)
ContentContainer.BackgroundColor3, ContentContainer.BackgroundTransparency, ContentContainer.BorderSizePixel = Color3.fromRGB(15, 16, 22), 0, 0
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 6)
local ContentStroke = TrackStroke(Instance.new("UIStroke", ContentContainer))
ContentStroke.Color, ContentStroke.Thickness = Color3.fromRGB(40, 43, 52), 1

local ContentHeader = Instance.new("Frame", ContentContainer)
ContentHeader.Size, ContentHeader.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1

local ActiveTabTitle = Instance.new("TextLabel", ContentHeader)
ActiveTabTitle.Size, ActiveTabTitle.Position, ActiveTabTitle.BackgroundTransparency = UDim2.new(1, -30, 1, 0), UDim2.new(0, 6, 0, 0), 1
ActiveTabTitle.Text, ActiveTabTitle.TextColor3, ActiveTabTitle.TextSize, ActiveTabTitle.Font, ActiveTabTitle.TextXAlignment = "", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local SearchInputContent = Instance.new("TextBox", ContentHeader)
SearchInputContent.Size, SearchInputContent.Position = UDim2.new(1, -34, 0, 18), UDim2.new(0, 6, 0.5, -9)
SearchInputContent.BackgroundColor3, SearchInputContent.BackgroundTransparency = Color3.fromRGB(12, 12, 17), 0
SearchInputContent.TextColor3, SearchInputContent.PlaceholderText, SearchInputContent.PlaceholderColor3 = Color3.fromRGB(255, 255, 255), "Search features...", Color3.fromRGB(150, 155, 165)
SearchInputContent.TextSize, SearchInputContent.Font, SearchInputContent.Visible = 8, Enum.Font.Gotham, false
Instance.new("UICorner", SearchInputContent).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", SearchInputContent)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(SearchInputContent, "Input")

local SearchContentIcon = Instance.new("TextButton", ContentHeader)
SearchContentIcon.Size, SearchContentIcon.Position, SearchContentIcon.BackgroundTransparency = UDim2.new(0, 20, 0, 20), UDim2.new(1, -24, 0.5, -10), 1
SearchContentIcon.Text, SearchContentIcon.TextSize, SearchContentIcon.TextColor3 = "🔍", 9, Color3.fromRGB(200, 205, 215)

local searching = false
Connect(SearchContentIcon.MouseButton1Click, function()
    searching = not searching
    SearchInputContent.Visible = searching
    ActiveTabTitle.Visible = not searching
    if searching then SearchInputContent:CaptureFocus() else SearchInputContent.Text = "" end
end)

local HeaderDivider = Instance.new("Frame", ContentContainer)
HeaderDivider.Size, HeaderDivider.Position = UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 26)
HeaderDivider.BackgroundColor3, HeaderDivider.BorderSizePixel = Color3.fromRGB(40, 43, 52), 0

local Tabs = {}
local FirstTab = nil

--------------------------------------------------------------------------------
-- TAB TRANG CHỦ
--------------------------------------------------------------------------------
local tabHomeBtn = Instance.new("TextButton", SidebarScroll)
tabHomeBtn.LayoutOrder = 0
tabHomeBtn.Size = UDim2.new(1, -2, 0, 28)
tabHomeBtn.BackgroundColor3, tabHomeBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
tabHomeBtn.Text, tabHomeBtn.TextColor3, tabHomeBtn.TextSize, tabHomeBtn.Font, tabHomeBtn.TextXAlignment =
    " 🏠 Trang Chủ", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", tabHomeBtn).CornerRadius = UDim.new(0, 5)
local tabHomeStroke = TrackStroke(Instance.new("UIStroke", tabHomeBtn))
tabHomeStroke.Color, tabHomeStroke.Thickness = Color3.fromRGB(255, 255, 255), 3
tabHomeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RegisterTheme(tabHomeBtn, "Primary")

local homeIndicator = Instance.new("Frame", tabHomeBtn)
homeIndicator.Size, homeIndicator.Position, homeIndicator.BackgroundColor3, homeIndicator.BorderSizePixel, homeIndicator.Visible =
    UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6), Color3.fromRGB(255, 105, 180), 0, false
Instance.new("UICorner", homeIndicator).CornerRadius = UDim.new(0, 2)

local homeScroll = Instance.new("ScrollingFrame", ContentContainer)
homeScroll.Name = "Container_HOME"
homeScroll.Size, homeScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
homeScroll.BackgroundTransparency, homeScroll.BorderSizePixel, homeScroll.ScrollBarThickness = 1, 0, 3
homeScroll.Visible, homeScroll.ClipsDescendants = false, true
local homeLayout = Instance.new("UIListLayout", homeScroll)
homeLayout.SortOrder, homeLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5)
homeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local homePad = Instance.new("UIPadding", homeScroll)
homePad.PaddingLeft, homePad.PaddingRight, homePad.PaddingTop, homePad.PaddingBottom =
    UDim.new(0, 4), UDim.new(0, 10), UDim.new(0, 4), UDim.new(0, 4)

Connect(tabHomeBtn.MouseButton1Click, function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    homeScroll.Visible = true
    homeIndicator.Visible = true
    ActiveTabTitle.Text = "🏠 Trang Chủ"
    SearchInputContent.Text = ""
end)

table.insert(Tabs, { Container = homeScroll, Indicator = homeIndicator })
homeScroll.Visible, homeIndicator.Visible = true, true
ActiveTabTitle.Text = "🏠 Trang Chủ"

local infoToggleBtn = Instance.new("TextButton", homeScroll)
infoToggleBtn.LayoutOrder = 1
infoToggleBtn.Size = UDim2.new(1, 0, 0, 32)
infoToggleBtn.BackgroundColor3, infoToggleBtn.BackgroundTransparency = Color3.fromRGB(55, 12, 40), 0
infoToggleBtn.Text, infoToggleBtn.TextColor3, infoToggleBtn.TextSize, infoToggleBtn.Font, infoToggleBtn.TextXAlignment =
    " ↓ thông tin", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", infoToggleBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", infoToggleBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(infoToggleBtn, "Secondary")

local infoSubLabel = Instance.new("TextLabel", infoToggleBtn)
infoSubLabel.Size, infoSubLabel.Position, infoSubLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14), 1
infoSubLabel.Text, infoSubLabel.TextColor3, infoSubLabel.TextSize, infoSubLabel.Font, infoSubLabel.TextXAlignment =
    "Xem các thông tin Hub", Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Center

local infoContainer = Instance.new("Frame", homeScroll)
infoContainer.LayoutOrder = 2
infoContainer.Size, infoContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
infoContainer.BackgroundTransparency, infoContainer.Visible = 1, true
local infoLayout = Instance.new("UIListLayout", infoContainer)
infoLayout.SortOrder, infoLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
infoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Connect(infoToggleBtn.MouseButton1Click, function()
    infoContainer.Visible = not infoContainer.Visible
    infoToggleBtn.Text = infoContainer.Visible and " ↓ thông tin" or " → thông tin"
    infoSubLabel.Visible = infoContainer.Visible
end)

local function CreateHomeCardWithIcon(parent, order, bgColor, titleText, mainText, copyText, borderColor, iconSymbol)
    local card = Instance.new("Frame", parent)
    card.LayoutOrder = order
    card.Size, card.BackgroundColor3, card.BackgroundTransparency, card.BorderSizePixel =
        UDim2.new(1, 0, 0, 26), bgColor, 0, 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 5)
    local stroke = TrackStroke(Instance.new("UIStroke", card))
    stroke.Color, stroke.Thickness = borderColor, 1.5

    local iconCircle = Instance.new("Frame", card)
    iconCircle.Size, iconCircle.Position, iconCircle.BackgroundColor3, iconCircle.BorderSizePixel =
        UDim2.new(0, 16, 0, 16), UDim2.new(0, 4, 0.5, -8), borderColor, 0
    Instance.new("UICorner", iconCircle).CornerRadius = UDim.new(1, 0)
    TrackStroke(Instance.new("UIStroke", iconCircle)).Color = borderColor
    local iconLbl = Instance.new("TextLabel", iconCircle)
    iconLbl.Size, iconLbl.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    iconLbl.Text, iconLbl.TextColor3, iconLbl.TextSize, iconLbl.Font = iconSymbol, Color3.fromRGB(255, 255, 255), 7, Enum.Font.GothamBold

    local tLbl = Instance.new("TextLabel", card)
    tLbl.Size, tLbl.Position, tLbl.BackgroundTransparency = UDim2.new(1, -70, 0, 10), UDim2.new(0, 24, 0, 1), 1
    tLbl.Text, tLbl.TextColor3, tLbl.TextSize, tLbl.Font, tLbl.TextXAlignment = titleText, Color3.fromRGB(255, 150, 100), 7, Enum.Font.GothamBold, Enum.TextXAlignment.Left

    local mLbl = Instance.new("TextLabel", card)
    mLbl.Size, mLbl.Position, mLbl.BackgroundTransparency = UDim2.new(1, -70, 0, 12), UDim2.new(0, 24, 0, 12), 1
    mLbl.Text, mLbl.TextColor3, mLbl.TextSize, mLbl.Font, mLbl.TextXAlignment = mainText, Color3.fromRGB(220, 220, 230), 7, Enum.Font.Gotham, Enum.TextXAlignment.Left

    if copyText ~= "" then
        local copyBtn = Instance.new("TextButton", card)
        copyBtn.Size, copyBtn.Position, copyBtn.BackgroundTransparency = UDim2.new(0, 42, 0, 16), UDim2.new(1, -44, 0.5, -8), 1
        copyBtn.Text, copyBtn.TextColor3, copyBtn.TextSize, copyBtn.Font = "📋 COPY", Color3.fromRGB(200, 200, 210), 7, Enum.Font.GothamBold
        local function doCopy()
            if typeof(setclipboard) == "function" then
                pcall(setclipboard, copyText)
                copyBtn.Text = "✓ COPIED"
                task.delay(1.5, function() copyBtn.Text = "📋 COPY" end)
            end
        end
        Connect(copyBtn.MouseButton1Click, doCopy)
        Connect(card.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                doCopy()
            end
        end)
    end
end

CreateHomeCardWithIcon(infoContainer, 1, Color3.fromRGB(70, 20, 45), "ĐƯỢC TẠO BỞI", "VzNam ROBLOX", "", Color3.fromRGB(180, 50, 50), "👤")
CreateHomeCardWithIcon(infoContainer, 2, Color3.fromRGB(30, 40, 70), "DISCORD SERVER", "https://discord.gg/6TG7krbsU", "https://discord.gg/6TG7krbsU", Color3.fromRGB(60, 100, 200), "💬")
CreateHomeCardWithIcon(infoContainer, 3, Color3.fromRGB(45, 45, 65), "TIKTOK CHANNEL", "https://www.tiktok.com/@uttop1gl.ovo", "https://www.tiktok.com/@uttop1gl.ovo", Color3.fromRGB(100, 100, 120), "🎵")

homeScroll.CanvasSize = UDim2.new(0, 0, 0, 120)

--------------------------------------------------------------------------------
-- CATEGORY TAB BUILDER
--------------------------------------------------------------------------------
local function CreateCategoryTab(tabName)
    local tabBtn = Instance.new("TextButton", SidebarScroll)
    tabBtn.Size = UDim2.new(1, -2, 0, 28)
    tabBtn.BackgroundColor3, tabBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
    tabBtn.Text, tabBtn.TextColor3, tabBtn.TextSize, tabBtn.Font, tabBtn.TextXAlignment =
        " " .. tabName, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
    local tabStroke = TrackStroke(Instance.new("UIStroke", tabBtn))
    tabStroke.Color, tabStroke.Thickness = Color3.fromRGB(255, 255, 255), 3
    tabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    RegisterTheme(tabBtn, "Primary")

    local indicator = Instance.new("Frame", tabBtn)
    indicator.Size, indicator.Position, indicator.BackgroundColor3, indicator.BorderSizePixel, indicator.Visible =
        UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6), Color3.fromRGB(255, 105, 180), 0, false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local containerFrame = Instance.new("Frame", ContentContainer)
    containerFrame.Name = "Container_" .. tabName
    containerFrame.Size = UDim2.new(1, 0, 1, -27)
    containerFrame.Position = UDim2.new(0, 0, 0, 27)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Visible = false
    containerFrame.ClipsDescendants = true

    local subBar = Instance.new("Frame", containerFrame)
    subBar.Size, subBar.Position, subBar.BackgroundTransparency, subBar.ZIndex = UDim2.new(1, -12, 0, 22), UDim2.new(0, 6, 0, 0), 1, 5
    local subLayout = Instance.new("UIListLayout", subBar)
    subLayout.FillDirection, subLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 4)

    local noKeyBtn = Instance.new("TextButton", subBar)
    noKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    noKeyBtn.BackgroundColor3, noKeyBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
    noKeyBtn.Text, noKeyBtn.TextColor3, noKeyBtn.TextSize, noKeyBtn.Font = "no key", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold
    noKeyBtn.ZIndex = 6
    Instance.new("UICorner", noKeyBtn).CornerRadius = UDim.new(0, 5)
    local nkStroke = TrackStroke(Instance.new("UIStroke", noKeyBtn))
    nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
    RegisterTheme(noKeyBtn, "Primary")

    local hasKeyBtn = Instance.new("TextButton", subBar)
    hasKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    hasKeyBtn.BackgroundColor3, hasKeyBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
    hasKeyBtn.Text, hasKeyBtn.TextColor3, hasKeyBtn.TextSize, hasKeyBtn.Font = "có key", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold
    hasKeyBtn.ZIndex = 6
    Instance.new("UICorner", hasKeyBtn).CornerRadius = UDim.new(0, 5)
    local hkStroke = TrackStroke(Instance.new("UIStroke", hasKeyBtn))
    hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
    RegisterTheme(hasKeyBtn, "Primary")

    local scrollNoKey = Instance.new("ScrollingFrame", containerFrame)
    scrollNoKey.Position, scrollNoKey.Size = UDim2.new(0, 6, 0, 26), UDim2.new(1, -12, 1, -26)
    scrollNoKey.BackgroundTransparency, scrollNoKey.BorderSizePixel = 1, 0
    scrollNoKey.ScrollBarThickness, scrollNoKey.Visible, scrollNoKey.ClipsDescendants = 3, true, true
    scrollNoKey.ZIndex = 1
    local snkPad = Instance.new("UIPadding", scrollNoKey)
    snkPad.PaddingLeft, snkPad.PaddingRight, snkPad.PaddingTop = UDim.new(0, 4), UDim.new(0, 10), UDim.new(0, 4)
    local l1 = Instance.new("UIListLayout", scrollNoKey)
    l1.Padding, l1.HorizontalAlignment = UDim.new(0, 3), Enum.HorizontalAlignment.Center

    local scrollHasKey = Instance.new("ScrollingFrame", containerFrame)
    scrollHasKey.Position, scrollHasKey.Size = UDim2.new(0, 6, 0, 26), UDim2.new(1, -12, 1, -26)
    scrollHasKey.BackgroundTransparency, scrollHasKey.BorderSizePixel = 1, 0
    scrollHasKey.ScrollBarThickness, scrollHasKey.Visible, scrollHasKey.ClipsDescendants = 3, false, true
    scrollHasKey.ZIndex = 1
    local shkPad = Instance.new("UIPadding", scrollHasKey)
    shkPad.PaddingLeft, shkPad.PaddingRight, shkPad.PaddingTop = UDim.new(0, 4), UDim.new(0, 10), UDim.new(0, 4)
    local l2 = Instance.new("UIListLayout", scrollHasKey)
    l2.Padding, l2.HorizontalAlignment = UDim.new(0, 3), Enum.HorizontalAlignment.Center

    Connect(SearchInputContent:GetPropertyChangedSignal("Text"), function()
        if containerFrame.Visible then
            local query = string.lower(SearchInputContent.Text)
            local target = scrollNoKey.Visible and scrollNoKey or scrollHasKey
            for _, item in ipairs(target:GetChildren()) do
                if item:IsA("TextButton") then
                    item.Visible = (query == "" or string.find(string.lower(item.Text), query)) and true or false
                end
            end
        end
    end)

    local pair = { nkStroke = nkStroke, hkStroke = hkStroke, activeIsNoKey = true }
    table.insert(SubTabPairs, pair)

    Connect(noKeyBtn.MouseButton1Click, function()
        scrollNoKey.Visible, scrollHasKey.Visible = true, false
        pair.activeIsNoKey = true
        ResetStrokeStyle(nkStroke, true)
        ResetStrokeStyle(hkStroke, false)
    end)
    Connect(hasKeyBtn.MouseButton1Click, function()
        scrollNoKey.Visible, scrollHasKey.Visible = false, true
        pair.activeIsNoKey = false
        ResetStrokeStyle(hkStroke, true)
        ResetStrokeStyle(nkStroke, false)
    end)

    Connect(tabBtn.MouseButton1Click, function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            if t.Indicator then t.Indicator.Visible = false end
        end
        containerFrame.Visible = true
        indicator.Visible = true
        ActiveTabTitle.Text = tabName
        SearchInputContent.Text = ""
    end)

    table.insert(Tabs, { Container = containerFrame, Indicator = indicator })

    local Elements = {}
    local function AddBtnTo(parent, name, callback)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, 0, 0, 26)
        Btn.BackgroundColor3, Btn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
        Btn.Text, Btn.TextColor3, Btn.TextSize, Btn.Font, Btn.TextXAlignment = " ▶ " .. name, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        local btnStroke = TrackStroke(Instance.new("UIStroke", Btn))
        btnStroke.Color, btnStroke.Thickness = Color3.fromRGB(255, 105, 180), 2
        RegisterTheme(Btn, "Primary")

        Connect(Btn.MouseButton1Click, function()
            if LastSelectedScriptStroke and LastSelectedScriptStroke.Parent then
                if CurrentStrokeMode == "None" then
                    LastSelectedScriptStroke.Transparency = 1
                else
                    LastSelectedScriptStroke.Transparency = 0
                    LastSelectedScriptStroke.Thickness = 2
                    if CurrentStrokeMode == "Color" then LastSelectedScriptStroke.Color = CurrentStrokeColor end
                end
            end
            btnStroke.Thickness = 2.5
            btnStroke.Transparency = (CurrentStrokeMode == "None") and 1 or 0
            LastSelectedScriptStroke = btnStroke
            callback()
        end)
        table.insert(RegisteredScripts, {Name = name, Callback = callback})
    end

    function Elements:AddNoKey(name, callback) AddBtnTo(scrollNoKey, name, callback) end
    function Elements:AddHasKey(name, callback) AddBtnTo(scrollHasKey, name, callback) end
    return Elements
end

--------------------------------------------------------------------------------
-- CÁC TAB SCRIPT
--------------------------------------------------------------------------------
local tab1 = CreateCategoryTab("🌸STEAL AN EGG🌸")
tab1:AddNoKey("1. Hop sv1 người(nokey)", function() SafeLoad('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source') end)
tab1:AddNoKey("2. FyyCommunity(lúc có key lúc no key)", function() SafeLoad("https://FyyCommunity.my.id") end)
tab1:AddNoKey("3. Chilli Hub V4(nokey)", function() SafeLoad("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4") end)
tab1:AddNoKey("4. Night hub(nokey)", function() SafeLoad("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau") end)
tab1:AddHasKey("1. Lemon Hub v4(có key)", function() SafeLoad("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt") end)
tab1:AddHasKey("2. Hoshi hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua") end)
tab1:AddHasKey("3. Bigfroot(có key)", function() SafeLoad("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua") end)
tab1:AddHasKey("4. Chữ A(ajjans)|(có key)", function() SafeLoad("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua") end)
tab1:AddHasKey("5. Speed hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end)
tab1:AddHasKey("6. Neohub(có key)", function() SafeLoad("https://raw.githubusercontent.com/neohubdev/script/main/script") end)
tab1:AddHasKey("7. Real kid(có key)", function() SafeLoad("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua") end)
tab1:AddHasKey("8. Chilli v2(có key)", function() SafeLoad("https://gist.githubusercontent.com/ronnei/1fa67c56dd9af203b192d15e752928e5/raw/4e2d5105640e09a008b4ae6df23f9708cadfef06/chilliv2-stealanegg") end)

local tab2 = CreateCategoryTab("🌸BLOX FRUIT🌸")
tab2:AddNoKey("1. RedzHub v2 (no key)", function() SafeLoad("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2") end)
tab2:AddNoKey("2. Quantumx Hub(nokey)", function() SafeLoad("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua") end)
tab2:AddHasKey("1. Speed Hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end)
tab2:AddHasKey("2. Omg Hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua") end)
tab2:AddHasKey("3. TeddyHub(có key)", function()
    repeat task.wait() until game:IsLoaded() and Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
    SafeLoad("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua")
end)
tab2:AddHasKey("4. Gravity Hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua") end)
tab2:AddHasKey("5. Realkid hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua") end)
tab2:AddHasKey("6. BananaHub(có key)", function()
    repeat task.wait() until game:IsLoaded() and Players.LocalPlayer
    getgenv().Team = "Marines"
    SafeLoad("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua")
end)

local tab3 = CreateCategoryTab("🌸BREAK AN STEAL🌸")
tab3:AddNoKey("1. break and steal an egg", function() SafeLoad("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua") end)

local tab4 = CreateCategoryTab("Tab 4")
local tab5 = CreateCategoryTab("Tab 5")

--------------------------------------------------------------------------------
-- TAB MISC
--------------------------------------------------------------------------------
local tabMiscBtn = Instance.new("TextButton", SidebarScroll)
tabMiscBtn.Size = UDim2.new(1, -2, 0, 28)
tabMiscBtn.BackgroundColor3, tabMiscBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
tabMiscBtn.Text, tabMiscBtn.TextColor3, tabMiscBtn.TextSize, tabMiscBtn.Font, tabMiscBtn.TextXAlignment = " ⚙️ MISC", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", tabMiscBtn).CornerRadius = UDim.new(0, 5)
local tabMiscStroke = TrackStroke(Instance.new("UIStroke", tabMiscBtn))
tabMiscStroke.Color, tabMiscStroke.Thickness = Color3.fromRGB(255, 255, 255), 3
tabMiscStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RegisterTheme(tabMiscBtn, "Primary")

local miscIndicator = Instance.new("Frame", tabMiscBtn)
miscIndicator.Size, miscIndicator.Position, miscIndicator.BackgroundColor3, miscIndicator.BorderSizePixel, miscIndicator.Visible =
    UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6), Color3.fromRGB(255, 105, 180), 0, false
Instance.new("UICorner", miscIndicator).CornerRadius = UDim.new(0, 2)

local miscScroll = Instance.new("ScrollingFrame", ContentContainer)
miscScroll.Name = "Container_MISC"
miscScroll.Size, miscScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
miscScroll.BackgroundTransparency, miscScroll.BorderSizePixel, miscScroll.ScrollBarThickness = 1, 0, 3
miscScroll.Visible, miscScroll.ClipsDescendants = false, true
local miscLayout = Instance.new("UIListLayout", miscScroll)
miscLayout.SortOrder, miscLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5)
miscLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local miscPad = Instance.new("UIPadding", miscScroll)
miscPad.PaddingLeft, miscPad.PaddingRight, miscPad.PaddingTop = UDim.new(0, 4), UDim.new(0, 10), UDim.new(0, 4)

Connect(tabMiscBtn.MouseButton1Click, function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    miscScroll.Visible = true
    miscIndicator.Visible = true
    ActiveTabTitle.Text = "⚙️ MISC"
end)
table.insert(Tabs, {Container = miscScroll, Indicator = miscIndicator})

local autoLoadToggleBtn = Instance.new("TextButton", miscScroll)
autoLoadToggleBtn.LayoutOrder = 1
autoLoadToggleBtn.Size = UDim2.new(1, 0, 0, 34)
autoLoadToggleBtn.BackgroundColor3, autoLoadToggleBtn.BackgroundTransparency = Color3.fromRGB(55, 12, 40), 0
autoLoadToggleBtn.Text, autoLoadToggleBtn.TextColor3, autoLoadToggleBtn.TextSize, autoLoadToggleBtn.Font, autoLoadToggleBtn.TextXAlignment =
    " ↓ auto load script", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", autoLoadToggleBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", autoLoadToggleBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(autoLoadToggleBtn, "Secondary")

local alSubLabel = Instance.new("TextLabel", autoLoadToggleBtn)
alSubLabel.Size, alSubLabel.Position, alSubLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14), 1
alSubLabel.Text, alSubLabel.TextColor3, alSubLabel.TextSize, alSubLabel.Font, alSubLabel.TextXAlignment =
    "Quản lý auto load script", Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Center

local autoLoadContainer = Instance.new("Frame", miscScroll)
autoLoadContainer.LayoutOrder = 2
autoLoadContainer.Size, autoLoadContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
autoLoadContainer.BackgroundTransparency, autoLoadContainer.Visible = 1, true
local alLayout = Instance.new("UIListLayout", autoLoadContainer)
alLayout.SortOrder, alLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
alLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Connect(autoLoadToggleBtn.MouseButton1Click, function()
    autoLoadContainer.Visible = not autoLoadContainer.Visible
    autoLoadToggleBtn.Text = autoLoadContainer.Visible and " ↓ auto load script" or " → auto load script"
    alSubLabel.Visible = autoLoadContainer.Visible
end)

local selScript, isAuto = nil, false
local dropBtn = Instance.new("TextButton", autoLoadContainer)
dropBtn.LayoutOrder = 1
dropBtn.Size = UDim2.new(1, 0, 0, 26)
dropBtn.BackgroundColor3, dropBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
dropBtn.Text, dropBtn.TextColor3, dropBtn.TextSize, dropBtn.Font, dropBtn.TextXAlignment =
    " 📜 Chọn Script Auto Load...", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", dropBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(dropBtn, "Primary")

local dropFrame = Instance.new("ScrollingFrame", autoLoadContainer)
dropFrame.LayoutOrder = 2
dropFrame.Size, dropFrame.BackgroundColor3, dropFrame.BackgroundTransparency = UDim2.new(1, 0, 0, 90), Color3.fromRGB(80, 20, 60), 0
dropFrame.CanvasSize, dropFrame.ScrollBarThickness, dropFrame.Visible = UDim2.new(0, 0, 0, 0), 3, false
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", dropFrame)).Color = Color3.fromRGB(40, 43, 52)
local dropLayout = Instance.new("UIListLayout", dropFrame)
dropLayout.Padding = UDim.new(0, 3)
RegisterTheme(dropFrame, "DropFrame")
local dropPad = Instance.new("UIPadding", dropFrame)
dropPad.PaddingRight = UDim.new(0, 8)
Connect(dropBtn.MouseButton1Click, function() dropFrame.Visible = not dropFrame.Visible end)

local autoLoadScriptFrame = Instance.new("Frame", autoLoadContainer)
autoLoadScriptFrame.LayoutOrder = 3
autoLoadScriptFrame.Size = UDim2.new(1, 0, 0, 30)
autoLoadScriptFrame.BackgroundColor3, autoLoadScriptFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", autoLoadScriptFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", autoLoadScriptFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(autoLoadScriptFrame, "Primary")

local alsTitle = Instance.new("TextLabel", autoLoadScriptFrame)
alsTitle.Size, alsTitle.Position, alsTitle.BackgroundTransparency = UDim2.new(1, -40, 1, 0), UDim2.new(0, 5, 0, 0), 1
alsTitle.Text, alsTitle.TextColor3, alsTitle.TextSize, alsTitle.Font, alsTitle.TextXAlignment =
    "Auto Load Script Chạy", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local toggleAutoBtn = Instance.new("TextButton", autoLoadScriptFrame)
toggleAutoBtn.Size, toggleAutoBtn.Position = UDim2.new(0, 30, 0, 15), UDim2.new(1, -34, 0.5, -7.5)
toggleAutoBtn.BackgroundColor3, toggleAutoBtn.Text = Color3.fromRGB(60, 65, 75), ""
Instance.new("UICorner", toggleAutoBtn).CornerRadius = UDim.new(1, 0)
TrackStroke(Instance.new("UIStroke", toggleAutoBtn)).Color = Color3.fromRGB(40, 43, 52)
local autoDot = Instance.new("Frame", toggleAutoBtn)
autoDot.Size, autoDot.Position, autoDot.BackgroundColor3 = UDim2.new(0, 11, 0, 11), UDim2.new(0, 2, 0.5, -5.5), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", autoDot).CornerRadius = UDim.new(1, 0)

Connect(toggleAutoBtn.MouseButton1Click, function()
    if not selScript then return end
    isAuto = not isAuto
    if isAuto then
        toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        autoDot.Position = UDim2.new(1, -13, 0.5, -5.5)
        pcall(selScript.Callback)
    else
        toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
        autoDot.Position = UDim2.new(0, 2, 0.5, -5.5)
    end
end)

local musicToggleBtn = Instance.new("TextButton", miscScroll)
musicToggleBtn.LayoutOrder = 3
musicToggleBtn.Size = UDim2.new(1, 0, 0, 34)
musicToggleBtn.BackgroundColor3, musicToggleBtn.BackgroundTransparency = Color3.fromRGB(55, 12, 40), 0
musicToggleBtn.Text, musicToggleBtn.TextColor3, musicToggleBtn.TextSize, musicToggleBtn.Font, musicToggleBtn.TextXAlignment =
    " ↓ âm nhạc", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", musicToggleBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", musicToggleBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(musicToggleBtn, "Secondary")

local muSubLabel = Instance.new("TextLabel", musicToggleBtn)
muSubLabel.Size, muSubLabel.Position, muSubLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14), 1
muSubLabel.Text, muSubLabel.TextColor3, muSubLabel.TextSize, muSubLabel.Font, muSubLabel.TextXAlignment =
    "Cài đặt âm nhạc nền", Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Center

local musicContainer = Instance.new("Frame", miscScroll)
musicContainer.LayoutOrder = 4
musicContainer.Size, musicContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
musicContainer.BackgroundTransparency, musicContainer.Visible = 1, true
local muLayout = Instance.new("UIListLayout", musicContainer)
muLayout.SortOrder, muLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
muLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Connect(musicToggleBtn.MouseButton1Click, function()
    musicContainer.Visible = not musicContainer.Visible
    musicToggleBtn.Text = musicContainer.Visible and " ↓ âm nhạc" or " → âm nhạc"
    muSubLabel.Visible = musicContainer.Visible
end)

local HubSound = SoundService:FindFirstChild("VzNamHubSound") or Instance.new("Sound", SoundService)
HubSound.Name, HubSound.Looped, HubSound.Volume = "VzNamHubSound", true, 0.5
local currentSoundId = "1837879082"

local customIdBox = Instance.new("TextBox", musicContainer)
customIdBox.LayoutOrder = 1
customIdBox.Size = UDim2.new(1, 0, 0, 26)
customIdBox.BackgroundColor3, customIdBox.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
customIdBox.PlaceholderText, customIdBox.Text = "🎶 Nhập Sound ID...", ""
customIdBox.TextColor3, customIdBox.TextSize, customIdBox.Font = Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham
Instance.new("UICorner", customIdBox).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", customIdBox)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(customIdBox, "Input")

local musicDropBtn = Instance.new("TextButton", musicContainer)
musicDropBtn.LayoutOrder = 2
musicDropBtn.Size = UDim2.new(1, 0, 0, 26)
musicDropBtn.BackgroundColor3, musicDropBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
musicDropBtn.Text, musicDropBtn.TextColor3, musicDropBtn.TextSize, musicDropBtn.Font, musicDropBtn.TextXAlignment =
    " 🎵 Chọn Nhạc...", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", musicDropBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", musicDropBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(musicDropBtn, "Primary")

local musicDropFrame = Instance.new("ScrollingFrame", musicContainer)
musicDropFrame.LayoutOrder = 3
musicDropFrame.Size, musicDropFrame.BackgroundColor3, musicDropFrame.BackgroundTransparency = UDim2.new(1, 0, 0, 95), Color3.fromRGB(80, 20, 60), 0
musicDropFrame.CanvasSize, musicDropFrame.ScrollBarThickness, musicDropFrame.Visible = UDim2.new(0, 0, 0, 0), 3, false
Instance.new("UICorner", musicDropFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", musicDropFrame)).Color = Color3.fromRGB(40, 43, 52)
local musicListLayout = Instance.new("UIListLayout", musicDropFrame)
musicListLayout.Padding = UDim.new(0, 3)
RegisterTheme(musicDropFrame, "DropFrame")
local musicPad = Instance.new("UIPadding", musicDropFrame)
musicPad.PaddingRight = UDim.new(0, 8)

local presetMusics = {
    {Name = "🎵 Chill Lofi", Id = "1837879082"},
    {Name = "🎶 Phonk Beat", Id = "1843404008"},
    {Name = "🎵 Anime Relax", Id = "9043887091"},
    {Name = "🎶 EDM Hype", Id = "1837871000"},
    {Name = "🎶 Như Một Người Dưng", Id = "91897652967267"}
}
for i, m in ipairs(presetMusics) do
    local mBtn = Instance.new("TextButton", musicDropFrame)
    mBtn.LayoutOrder = i
    mBtn.Size = UDim2.new(1, 0, 0, 22)
    mBtn.BackgroundColor3, mBtn.BackgroundTransparency = Color3.fromRGB(90, 25, 65), 0
    mBtn.Text, mBtn.TextColor3, mBtn.TextSize, mBtn.Font, mBtn.TextXAlignment = " " .. m.Name, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 4)
    TrackStroke(Instance.new("UIStroke", mBtn)).Color = Color3.fromRGB(40, 43, 52)
    RegisterTheme(mBtn, "DropItem")
    Connect(mBtn.MouseButton1Click, function()
        currentSoundId = m.Id
        musicDropBtn.Text = " 🎵 " .. m.Name
        musicDropFrame.Visible = false
        if HubSound.IsPlaying then
            HubSound.SoundId = "rbxassetid://" .. currentSoundId
            HubSound:Play()
        end
    end)
end
musicDropFrame.CanvasSize = UDim2.new(0, 0, 0, #presetMusics * 25)
Connect(musicDropBtn.MouseButton1Click, function() musicDropFrame.Visible = not musicDropFrame.Visible end)

local volumeFrame = Instance.new("Frame", musicContainer)
volumeFrame.LayoutOrder = 4
volumeFrame.Size = UDim2.new(1, 0, 0, 26)
volumeFrame.BackgroundColor3, volumeFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", volumeFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", volumeFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(volumeFrame, "Primary")

local volumeLabel = Instance.new("TextLabel", volumeFrame)
volumeLabel.Size, volumeLabel.Position, volumeLabel.BackgroundTransparency = UDim2.new(1, -8, 1, 0), UDim2.new(0, 5, 0, 0), 1
volumeLabel.Text, volumeLabel.TextColor3, volumeLabel.TextSize, volumeLabel.Font, volumeLabel.TextXAlignment =
    "🔊 Vol: 50%", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local volumeBarBg = Instance.new("Frame", volumeFrame)
volumeBarBg.Size, volumeBarBg.Position, volumeBarBg.BackgroundColor3 = UDim2.new(0, 80, 0, 8), UDim2.new(1, -86, 0.5, -4), Color3.fromRGB(90, 25, 65)
Instance.new("UICorner", volumeBarBg).CornerRadius = UDim.new(1, 0)
TrackStroke(Instance.new("UIStroke", volumeBarBg)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(volumeBarBg, "DropItem")
local volumeBarFill = Instance.new("Frame", volumeBarBg)
volumeBarFill.Size, volumeBarFill.BackgroundColor3 = UDim2.new(0.5, 0, 1, 0), Color3.fromRGB(0, 180, 255)
Instance.new("UICorner", volumeBarFill).CornerRadius = UDim.new(1, 0)
local volumeBtn = Instance.new("TextButton", volumeBarBg)
volumeBtn.Size, volumeBtn.BackgroundTransparency, volumeBtn.Text = UDim2.new(1, 10, 1, 10), 1, ""

local adjustingVol = false
Connect(volumeBtn.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then adjustingVol = true end
end)
Connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then adjustingVol = false end
end)
Connect(UserInputService.InputChanged, function(input)
    if adjustingVol and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percent = math.clamp((input.Position.X - volumeBarBg.AbsolutePosition.X) / volumeBarBg.AbsoluteSize.X, 0, 1)
        volumeBarFill.Size = UDim2.new(percent, 0, 1, 0)
        HubSound.Volume = percent
        volumeLabel.Text = "🔊 Vol: " .. math.floor(percent * 100) .. "%"
    end
end)

local musicToggleFrame = Instance.new("Frame", musicContainer)
musicToggleFrame.LayoutOrder = 5
musicToggleFrame.Size = UDim2.new(1, 0, 0, 30)
musicToggleFrame.BackgroundColor3, musicToggleFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", musicToggleFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", musicToggleFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(musicToggleFrame, "Primary")

local musicTitle = Instance.new("TextLabel", musicToggleFrame)
musicTitle.Size, musicTitle.Position, musicTitle.BackgroundTransparency = UDim2.new(1, -40, 1, 0), UDim2.new(0, 5, 0, 0), 1
musicTitle.Text, musicTitle.TextColor3, musicTitle.TextSize, musicTitle.Font, musicTitle.TextXAlignment =
    "Phát Nhạc Nền", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local toggleMusicBtn = Instance.new("TextButton", musicToggleFrame)
toggleMusicBtn.Size, toggleMusicBtn.Position = UDim2.new(0, 30, 0, 15), UDim2.new(1, -34, 0.5, -7.5)
toggleMusicBtn.BackgroundColor3, toggleMusicBtn.Text = Color3.fromRGB(60, 65, 75), ""
Instance.new("UICorner", toggleMusicBtn).CornerRadius = UDim.new(1, 0)
TrackStroke(Instance.new("UIStroke", toggleMusicBtn)).Color = Color3.fromRGB(40, 43, 52)
local musicDot = Instance.new("Frame", toggleMusicBtn)
musicDot.Size, musicDot.Position, musicDot.BackgroundColor3 = UDim2.new(0, 11, 0, 11), UDim2.new(0, 2, 0.5, -5.5), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", musicDot).CornerRadius = UDim.new(1, 0)

local isMusicPlaying = false
Connect(toggleMusicBtn.MouseButton1Click, function()
    isMusicPlaying = not isMusicPlaying
    if isMusicPlaying then
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        musicDot.Position = UDim2.new(1, -13, 0.5, -5.5)
        local customId = tonumber(customIdBox.Text) or tonumber(string.match(customIdBox.Text, "%d+"))
        HubSound.SoundId = "rbxassetid://" .. (customId and tostring(customId) or currentSoundId)
        HubSound:Play()
    else
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
        musicDot.Position = UDim2.new(0, 2, 0.5, -5.5)
        HubSound:Stop()
    end
end)

local menuColorToggleBtn = Instance.new("TextButton", miscScroll)
menuColorToggleBtn.LayoutOrder = 5
menuColorToggleBtn.Size = UDim2.new(1, 0, 0, 34)
menuColorToggleBtn.BackgroundColor3, menuColorToggleBtn.BackgroundTransparency = Color3.fromRGB(55, 12, 40), 0
menuColorToggleBtn.Text, menuColorToggleBtn.TextColor3, menuColorToggleBtn.TextSize, menuColorToggleBtn.Font, menuColorToggleBtn.TextXAlignment =
    " ↓ màu menu", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", menuColorToggleBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", menuColorToggleBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(menuColorToggleBtn, "Secondary")

local mcSubLabel = Instance.new("TextLabel", menuColorToggleBtn)
mcSubLabel.Size, mcSubLabel.Position, mcSubLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14), 1
mcSubLabel.Text, mcSubLabel.TextColor3, mcSubLabel.TextSize, mcSubLabel.Font, mcSubLabel.TextXAlignment =
    "Tùy chỉnh màu sắc & độ trong suốt", Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Center

local menuColorContainer = Instance.new("Frame", miscScroll)
menuColorContainer.LayoutOrder = 6
menuColorContainer.Size, menuColorContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
menuColorContainer.BackgroundTransparency, menuColorContainer.Visible = 1, true
local mcLayout = Instance.new("UIListLayout", menuColorContainer)
mcLayout.SortOrder, mcLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
mcLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Connect(menuColorToggleBtn.MouseButton1Click, function()
    menuColorContainer.Visible = not menuColorContainer.Visible
    menuColorToggleBtn.Text = menuColorContainer.Visible and " ↓ màu menu" or " → màu menu"
    mcSubLabel.Visible = menuColorContainer.Visible
end)

local menuThemeList = {
    {Name = "🌸 Hồng Pastel", Bg = Color3.fromRGB(70, 15, 50)},
    {Name = "🌙 Đêm Đen Sâu", Bg = Color3.fromRGB(15, 16, 22)},
    {Name = "🔥 Đỏ Lửa", Bg = Color3.fromRGB(70, 10, 15)},
    {Name = "🌊 Xanh Đại Dương", Bg = Color3.fromRGB(10, 22, 50)}
}
local themeDropBtn = Instance.new("TextButton", menuColorContainer)
themeDropBtn.LayoutOrder = 1
themeDropBtn.Size = UDim2.new(1, 0, 0, 26)
themeDropBtn.BackgroundColor3, themeDropBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
themeDropBtn.Text, themeDropBtn.TextColor3, themeDropBtn.TextSize, themeDropBtn.Font, themeDropBtn.TextXAlignment =
    " 🎨 Theme: 🌙 Đêm Đen Sâu", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", themeDropBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", themeDropBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(themeDropBtn, "Primary")

local themeDropFrame = Instance.new("ScrollingFrame", menuColorContainer)
themeDropFrame.LayoutOrder = 2
themeDropFrame.Size, themeDropFrame.BackgroundColor3, themeDropFrame.BackgroundTransparency = UDim2.new(1, 0, 0, 95), Color3.fromRGB(80, 20, 60), 0
themeDropFrame.CanvasSize, themeDropFrame.ScrollBarThickness, themeDropFrame.Visible = UDim2.new(0, 0, 0, 0), 3, false
Instance.new("UICorner", themeDropFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", themeDropFrame)).Color = Color3.fromRGB(40, 43, 52)
local themeListLayout = Instance.new("UIListLayout", themeDropFrame)
themeListLayout.Padding = UDim.new(0, 3)
RegisterTheme(themeDropFrame, "DropFrame")
local themePad = Instance.new("UIPadding", themeDropFrame)
themePad.PaddingRight = UDim.new(0, 8)

local function ApplyTheme(newBaseColor)
    local primaryColor = newBaseColor:Lerp(Color3.new(1,1,1), 0.08)
    local secondaryColor = newBaseColor:Lerp(Color3.new(1,1,1), 0.15)
    local dropFrameColor = newBaseColor:Lerp(Color3.new(1,1,1), 0.2)
    local dropItemColor = newBaseColor:Lerp(Color3.new(1,1,1), 0.3)
    local inputColor = newBaseColor:Lerp(Color3.new(0,0,0), 0.4)
    SidebarPanel.BackgroundColor3 = newBaseColor
    ContentContainer.BackgroundColor3 = newBaseColor
    for _, item in ipairs(ThemedElements) do
        local el = item.Element
        if el and el.Parent then
            if item.Type == "Primary" then el.BackgroundColor3 = primaryColor
            elseif item.Type == "Secondary" then el.BackgroundColor3 = secondaryColor
            elseif item.Type == "DropFrame" then el.BackgroundColor3 = dropFrameColor
            elseif item.Type == "DropItem" then el.BackgroundColor3 = dropItemColor
            elseif item.Type == "Input" then el.BackgroundColor3 = inputColor
            end
        end
    end
end

for i, th in ipairs(menuThemeList) do
    local tBtn = Instance.new("TextButton", themeDropFrame)
    tBtn.LayoutOrder = i
    tBtn.Size = UDim2.new(1, 0, 0, 22)
    tBtn.BackgroundColor3, tBtn.BackgroundTransparency = Color3.fromRGB(90, 25, 65), 0
    tBtn.Text, tBtn.TextColor3, tBtn.TextSize, tBtn.Font, tBtn.TextXAlignment = " " .. th.Name, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 4)
    TrackStroke(Instance.new("UIStroke", tBtn)).Color = Color3.fromRGB(40, 43, 52)
    RegisterTheme(tBtn, "DropItem")
    Connect(tBtn.MouseButton1Click, function()
        themeDropBtn.Text = " 🎨 Theme: " .. th.Name
        themeDropFrame.Visible = false
        ApplyTheme(th.Bg)
    end)
end
themeDropFrame.CanvasSize = UDim2.new(0, 0, 0, #menuThemeList * 25)
Connect(themeDropBtn.MouseButton1Click, function() themeDropFrame.Visible = not themeDropFrame.Visible end)

local transFrame = Instance.new("Frame", menuColorContainer)
transFrame.LayoutOrder = 3
transFrame.Size = UDim2.new(1, 0, 0, 26)
transFrame.BackgroundColor3, transFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", transFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", transFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(transFrame, "Primary")

local transLabel = Instance.new("TextLabel", transFrame)
transLabel.Size, transLabel.Position, transLabel.BackgroundTransparency = UDim2.new(1, -8, 1, 0), UDim2.new(0, 5, 0, 0), 1
transLabel.Text, transLabel.TextColor3, transLabel.TextSize, transLabel.Font, transLabel.TextXAlignment =
    "✨ Trong suốt: 0%", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local transBarBg = Instance.new("Frame", transFrame)
transBarBg.Size, transBarBg.Position, transBarBg.BackgroundColor3 = UDim2.new(0, 80, 0, 8), UDim2.new(1, -86, 0.5, -4), Color3.fromRGB(90, 25, 65)
Instance.new("UICorner", transBarBg).CornerRadius = UDim.new(1, 0)
TrackStroke(Instance.new("UIStroke", transBarBg)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(transBarBg, "DropItem")
local transBarFill = Instance.new("Frame", transBarBg)
transBarFill.Size, transBarFill.BackgroundColor3 = UDim2.new(0, 0, 1, 0), Color3.fromRGB(255, 105, 180)
Instance.new("UICorner", transBarFill).CornerRadius = UDim.new(1, 0)
local transBtn = Instance.new("TextButton", transBarBg)
transBtn.Size, transBtn.BackgroundTransparency, transBtn.Text = UDim2.new(1, 10, 1, 10), 1, ""

local adjustingTrans = false
Connect(transBtn.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then adjustingTrans = true end
end)
Connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then adjustingTrans = false end
end)
Connect(UserInputService.InputChanged, function(input)
    if adjustingTrans and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percent = math.clamp((input.Position.X - transBarBg.AbsolutePosition.X) / transBarBg.AbsoluteSize.X, 0, 1)
        transBarFill.Size = UDim2.new(percent, 0, 1, 0)
        MainFrame.BackgroundTransparency = 0.15 + (percent * 0.85)
        SidebarPanel.BackgroundTransparency = percent
        ContentContainer.BackgroundTransparency = percent
        transLabel.Text = "✨ Trong suốt: " .. math.floor(percent * 100) .. "%"
    end
end)

local colorList = {
    {Name = "🌈 Cầu Vồng (Rainbow)", Color = "Rainbow"},
    {Name = "🌸 Hồng Kẹo", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "🔴 Đỏ Đậm", Color = Color3.fromRGB(220, 20, 60)},
    {Name = "🔵 Xanh Dương", Color = Color3.fromRGB(0, 191, 255)},
    {Name = "❌ Không Viền", Color = "None"}
}
local selectedColorObj = colorList[1]
local colorDropBtn = Instance.new("TextButton", menuColorContainer)
colorDropBtn.LayoutOrder = 4
colorDropBtn.Size = UDim2.new(1, 0, 0, 26)
colorDropBtn.BackgroundColor3, colorDropBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
colorDropBtn.Text, colorDropBtn.TextColor3, colorDropBtn.TextSize, colorDropBtn.Font, colorDropBtn.TextXAlignment =
    " 🎨 Viền: 🌈 Cầu Vồng", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", colorDropBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", colorDropBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(colorDropBtn, "Primary")

local colorDropFrame = Instance.new("ScrollingFrame", menuColorContainer)
colorDropFrame.LayoutOrder = 5
colorDropFrame.Size, colorDropFrame.BackgroundColor3, colorDropFrame.BackgroundTransparency = UDim2.new(1, 0, 0, 95), Color3.fromRGB(80, 20, 60), 0
colorDropFrame.CanvasSize, colorDropFrame.ScrollBarThickness, colorDropFrame.Visible = UDim2.new(0, 0, 0, 0), 3, false
Instance.new("UICorner", colorDropFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", colorDropFrame)).Color = Color3.fromRGB(40, 43, 52)
local colorListLayout = Instance.new("UIListLayout", colorDropFrame)
colorListLayout.Padding = UDim.new(0, 3)
RegisterTheme(colorDropFrame, "DropFrame")
local colorPad = Instance.new("UIPadding", colorDropFrame)
colorPad.PaddingRight = UDim.new(0, 8)

for i, cItem in ipairs(colorList) do
    local cBtn = Instance.new("TextButton", colorDropFrame)
    cBtn.LayoutOrder = i
    cBtn.Size = UDim2.new(1, 0, 0, 22)
    cBtn.BackgroundColor3, cBtn.BackgroundTransparency = Color3.fromRGB(90, 25, 65), 0
    cBtn.Text, cBtn.TextColor3, cBtn.TextSize, cBtn.Font, cBtn.TextXAlignment = " " .. cItem.Name, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    TrackStroke(Instance.new("UIStroke", cBtn)).Color = Color3.fromRGB(40, 43, 52)
    RegisterTheme(cBtn, "DropItem")
    Connect(cBtn.MouseButton1Click, function()
        selectedColorObj = cItem
        colorDropBtn.Text = " 🎨 Viền: " .. cItem.Name
        colorDropFrame.Visible = false
        ApplyStrokeColor(cItem.Color)
    end)
end
colorDropFrame.CanvasSize = UDim2.new(0, 0, 0, #colorList * 25)
Connect(colorDropBtn.MouseButton1Click, function() colorDropFrame.Visible = not colorDropFrame.Visible end)

local rainbowAccum = 0
Connect(RunService.RenderStepped, function(dt)
    if CurrentStrokeMode == "Rainbow" then
        rainbowAccum = rainbowAccum + dt
        if rainbowAccum >= 1/30 then
            rainbowAccum = 0
            local targetColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            for _, stroke in ipairs(AllUIStrokes) do
                if stroke and stroke.Parent and stroke.Transparency < 1 then
                    stroke.Color = targetColor
                end
            end
        end
    end
end)
miscScroll.CanvasSize = UDim2.new(0, 0, 0, 1300)

--------------------------------------------------------------------------------
-- TAB CẤU HÌNH
--------------------------------------------------------------------------------
local tabConfigBtn = Instance.new("TextButton", SidebarScroll)
tabConfigBtn.Size = UDim2.new(1, -2, 0, 28)
tabConfigBtn.BackgroundColor3, tabConfigBtn.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
tabConfigBtn.Text, tabConfigBtn.TextColor3, tabConfigBtn.TextSize, tabConfigBtn.Font, tabConfigBtn.TextXAlignment = " 📦 CẤU HÌNH", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", tabConfigBtn).CornerRadius = UDim.new(0, 5)
local tabConfigStroke = TrackStroke(Instance.new("UIStroke", tabConfigBtn))
tabConfigStroke.Color, tabConfigStroke.Thickness = Color3.fromRGB(255, 255, 255), 3
tabConfigStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RegisterTheme(tabConfigBtn, "Primary")

local configIndicator = Instance.new("Frame", tabConfigBtn)
configIndicator.Size, configIndicator.Position, configIndicator.BackgroundColor3, configIndicator.BorderSizePixel, configIndicator.Visible =
    UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6), Color3.fromRGB(255, 105, 180), 0, false
Instance.new("UICorner", configIndicator).CornerRadius = UDim.new(0, 2)

local configScroll = Instance.new("ScrollingFrame", ContentContainer)
configScroll.Name = "Container_CONFIG"
configScroll.Size, configScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
configScroll.BackgroundTransparency, configScroll.BorderSizePixel, configScroll.ScrollBarThickness = 1, 0, 3
configScroll.Visible, configScroll.ClipsDescendants = false, true
local configLayout = Instance.new("UIListLayout", configScroll)
configLayout.SortOrder, configLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5)
configLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local cfgPad = Instance.new("UIPadding", configScroll)
cfgPad.PaddingLeft, cfgPad.PaddingRight, cfgPad.PaddingTop = UDim.new(0, 4), UDim.new(0, 10), UDim.new(0, 4)

Connect(tabConfigBtn.MouseButton1Click, function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    configScroll.Visible = true
    configIndicator.Visible = true
    ActiveTabTitle.Text = "📦 CẤU HÌNH"
end)
table.insert(Tabs, {Container = configScroll, Indicator = configIndicator})

local configFolder = "VzNamHub_Configs"
if typeof(makefolder) == "function" then pcall(makefolder, configFolder) end

local currentConfigName = "Default"
local startupConfigName = "Default"

local configToggleBtn = Instance.new("TextButton", configScroll)
configToggleBtn.LayoutOrder = 1
configToggleBtn.Size = UDim2.new(1, 0, 0, 34)
configToggleBtn.BackgroundColor3, configToggleBtn.BackgroundTransparency = Color3.fromRGB(55, 12, 40), 0
configToggleBtn.Text, configToggleBtn.TextColor3, configToggleBtn.TextSize, configToggleBtn.Font, configToggleBtn.TextXAlignment =
    " ↓ Cấu Hình", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", configToggleBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", configToggleBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(configToggleBtn, "Secondary")

local configSubLabel = Instance.new("TextLabel", configToggleBtn)
configSubLabel.Size, configSubLabel.Position, configSubLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14), 1
configSubLabel.Text, configSubLabel.TextColor3, configSubLabel.TextSize, configSubLabel.Font, configSubLabel.TextXAlignment =
    "Quản lý cấu hình hệ thống", Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Center

local mainConfigContainer = Instance.new("Frame", configScroll)
mainConfigContainer.LayoutOrder = 2
mainConfigContainer.Size, mainConfigContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
mainConfigContainer.BackgroundTransparency, mainConfigContainer.Visible = 1, true
local mainCfgLayout = Instance.new("UIListLayout", mainConfigContainer)
mainCfgLayout.SortOrder, mainCfgLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
mainCfgLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Connect(configToggleBtn.MouseButton1Click, function()
    mainConfigContainer.Visible = not mainConfigContainer.Visible
    configToggleBtn.Text = mainConfigContainer.Visible and " ↓ Cấu Hình" or " → Cấu Hình"
    configSubLabel.Visible = mainConfigContainer.Visible
end)

local startupFrame = Instance.new("Frame", mainConfigContainer)
startupFrame.LayoutOrder = 1
startupFrame.Size = UDim2.new(1, 0, 0, 30)
startupFrame.BackgroundColor3, startupFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", startupFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", startupFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(startupFrame, "Primary")
local startupLabel = Instance.new("TextLabel", startupFrame)
startupLabel.Size, startupLabel.Position, startupLabel.BackgroundTransparency = UDim2.new(1, -8, 1, 0), UDim2.new(0, 5, 0, 0), 1
startupLabel.Text, startupLabel.TextColor3, startupLabel.TextSize, startupLabel.Font, startupLabel.TextXAlignment =
    "Startup: " .. startupConfigName, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local autoSaveFrame = Instance.new("Frame", mainConfigContainer)
autoSaveFrame.LayoutOrder = 2
autoSaveFrame.Size = UDim2.new(1, 0, 0, 34)
autoSaveFrame.BackgroundColor3, autoSaveFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", autoSaveFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", autoSaveFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(autoSaveFrame, "Primary")
local asTitle = Instance.new("TextLabel", autoSaveFrame)
asTitle.Size, asTitle.Position, asTitle.BackgroundTransparency = UDim2.new(1, -38, 0, 15), UDim2.new(0, 5, 0, 2), 1
asTitle.Text, asTitle.TextColor3, asTitle.TextSize, asTitle.Font, asTitle.TextXAlignment =
    "Auto Lưu Cấu Hình", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local asSub = Instance.new("TextLabel", autoSaveFrame)
asSub.Size, asSub.Position, asSub.BackgroundTransparency = UDim2.new(1, -38, 0, 14), UDim2.new(0, 5, 0, 17), 1
asSub.Text, asSub.TextColor3, asSub.TextSize, asSub.Font, asSub.TextXAlignment =
    "Save: " .. currentConfigName, Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Left

local autoSaveToggle = Instance.new("TextButton", autoSaveFrame)
autoSaveToggle.Size, autoSaveToggle.Position = UDim2.new(0, 30, 0, 15), UDim2.new(1, -34, 0.5, -7.5)
autoSaveToggle.BackgroundColor3, autoSaveToggle.Text = Color3.fromRGB(50, 200, 50), ""
Instance.new("UICorner", autoSaveToggle).CornerRadius = UDim.new(1, 0)
TrackStroke(Instance.new("UIStroke", autoSaveToggle)).Color = Color3.fromRGB(40, 43, 52)
local asBox = Instance.new("Frame", autoSaveToggle)
asBox.Size, asBox.Position, asBox.BackgroundColor3 = UDim2.new(0, 11, 0, 11), UDim2.new(1, -13, 0.5, -5.5), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", asBox).CornerRadius = UDim.new(1, 0)
local isAutoSave = true
Connect(autoSaveToggle.MouseButton1Click, function()
    isAutoSave = not isAutoSave
    autoSaveToggle.BackgroundColor3 = isAutoSave and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 65, 75)
    asBox.Position = isAutoSave and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
end)

local autoLoadCfgFrame = Instance.new("Frame", mainConfigContainer)
autoLoadCfgFrame.LayoutOrder = 3
autoLoadCfgFrame.Size = UDim2.new(1, 0, 0, 34)
autoLoadCfgFrame.BackgroundColor3, autoLoadCfgFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", autoLoadCfgFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", autoLoadCfgFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(autoLoadCfgFrame, "Primary")
local alCfgTitle = Instance.new("TextLabel", autoLoadCfgFrame)
alCfgTitle.Size, alCfgTitle.Position, alCfgTitle.BackgroundTransparency = UDim2.new(1, -38, 0, 15), UDim2.new(0, 5, 0, 2), 1
alCfgTitle.Text, alCfgTitle.TextColor3, alCfgTitle.TextSize, alCfgTitle.Font, alCfgTitle.TextXAlignment =
    "Auto Tải Cấu Hình", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local alCfgSub = Instance.new("TextLabel", autoLoadCfgFrame)
alCfgSub.Size, alCfgSub.Position, alCfgSub.BackgroundTransparency = UDim2.new(1, -38, 0, 14), UDim2.new(0, 5, 0, 17), 1
alCfgSub.Text, alCfgSub.TextColor3, alCfgSub.TextSize, alCfgSub.Font, alCfgSub.TextXAlignment =
    "Load: " .. currentConfigName, Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Left

local autoLoadCfgToggle = Instance.new("TextButton", autoLoadCfgFrame)
autoLoadCfgToggle.Size, autoLoadCfgToggle.Position = UDim2.new(0, 30, 0, 15), UDim2.new(1, -34, 0.5, -7.5)
autoLoadCfgToggle.BackgroundColor3, autoLoadCfgToggle.Text = Color3.fromRGB(50, 200, 50), ""
Instance.new("UICorner", autoLoadCfgToggle).CornerRadius = UDim.new(1, 0)
TrackStroke(Instance.new("UIStroke", autoLoadCfgToggle)).Color = Color3.fromRGB(40, 43, 52)
local alCfgBox = Instance.new("Frame", autoLoadCfgToggle)
alCfgBox.Size, alCfgBox.Position, alCfgBox.BackgroundColor3 = UDim2.new(0, 11, 0, 11), UDim2.new(1, -13, 0.5, -5.5), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", alCfgBox).CornerRadius = UDim.new(1, 0)
local isAutoLoadCfg = true
Connect(autoLoadCfgToggle.MouseButton1Click, function()
    isAutoLoadCfg = not isAutoLoadCfg
    autoLoadCfgToggle.BackgroundColor3 = isAutoLoadCfg and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 65, 75)
    alCfgBox.Position = isAutoLoadCfg and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
end)

local profilesToggleBtn = Instance.new("TextButton", configScroll)
profilesToggleBtn.LayoutOrder = 3
profilesToggleBtn.Size = UDim2.new(1, 0, 0, 34)
profilesToggleBtn.BackgroundColor3, profilesToggleBtn.BackgroundTransparency = Color3.fromRGB(55, 12, 40), 0
profilesToggleBtn.Text, profilesToggleBtn.TextColor3, profilesToggleBtn.TextSize, profilesToggleBtn.Font, profilesToggleBtn.TextXAlignment =
    " ↓ Profiles", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", profilesToggleBtn).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", profilesToggleBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(profilesToggleBtn, "Secondary")

local profilesSubLabel = Instance.new("TextLabel", profilesToggleBtn)
profilesSubLabel.Size, profilesSubLabel.Position, profilesSubLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14), 1
profilesSubLabel.Text, profilesSubLabel.TextColor3, profilesSubLabel.TextSize, profilesSubLabel.Font, profilesSubLabel.TextXAlignment =
    "Quản lý các cấu hình", Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Center

local profilesContainer = Instance.new("Frame", configScroll)
profilesContainer.LayoutOrder = 4
profilesContainer.Size, profilesContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
profilesContainer.BackgroundTransparency, profilesContainer.Visible = 1, true
local profilesSubLayout = Instance.new("UIListLayout", profilesContainer)
profilesSubLayout.SortOrder, profilesSubLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
profilesSubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Connect(profilesToggleBtn.MouseButton1Click, function()
    profilesContainer.Visible = not profilesContainer.Visible
    profilesToggleBtn.Text = profilesContainer.Visible and " ↓ Profiles" or " → Profiles"
    profilesSubLabel.Visible = profilesContainer.Visible
end)

local newConfigFrame = Instance.new("Frame", profilesContainer)
newConfigFrame.LayoutOrder = 1
newConfigFrame.Size = UDim2.new(1, 0, 0, 30)
newConfigFrame.BackgroundColor3, newConfigFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", newConfigFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", newConfigFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(newConfigFrame, "Primary")
local ncLabel = Instance.new("TextLabel", newConfigFrame)
ncLabel.Size, ncLabel.Position, ncLabel.BackgroundTransparency = UDim2.new(0, 80, 1, 0), UDim2.new(0, 5, 0, 0), 1
ncLabel.Text, ncLabel.TextColor3, ncLabel.TextSize, ncLabel.Font, ncLabel.TextXAlignment =
    "Tên Config", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local configNameBox = Instance.new("TextBox", newConfigFrame)
configNameBox.Size, configNameBox.Position = UDim2.new(1, -95, 0, 20), UDim2.new(0, 85, 0.5, -10)
configNameBox.BackgroundColor3, configNameBox.BackgroundTransparency = Color3.fromRGB(50, 10, 35), 0
configNameBox.PlaceholderText, configNameBox.Text = "Name...", ""
configNameBox.TextColor3, configNameBox.TextSize, configNameBox.Font = Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham
Instance.new("UICorner", configNameBox).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", configNameBox)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(configNameBox, "Input")

local createFrame = Instance.new("Frame", profilesContainer)
createFrame.LayoutOrder = 2
createFrame.Size = UDim2.new(1, 0, 0, 34)
createFrame.BackgroundColor3, createFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", createFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", createFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(createFrame, "Primary")
local crTitle = Instance.new("TextLabel", createFrame)
crTitle.Size, crTitle.Position, crTitle.BackgroundTransparency = UDim2.new(1, -75, 0, 15), UDim2.new(0, 5, 0, 2), 1
crTitle.Text, crTitle.TextColor3, crTitle.TextSize, crTitle.Font, crTitle.TextXAlignment =
    "Tạo Mới Cấu Hình", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local crSub = Instance.new("TextLabel", createFrame)
crSub.Size, crSub.Position, crSub.BackgroundTransparency = UDim2.new(1, -75, 0, 14), UDim2.new(0, 5, 0, 17), 1
crSub.Text, crSub.TextColor3, crSub.TextSize, crSub.Font, crSub.TextXAlignment =
    "Sao chép cài đặt hiện tại", Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Left

local createBtn = Instance.new("TextButton", createFrame)
createBtn.Size, createBtn.Position = UDim2.new(0, 65, 0, 22), UDim2.new(1, -70, 0.5, -11)
createBtn.BackgroundColor3, createBtn.Text, createBtn.TextColor3, createBtn.TextSize, createBtn.Font =
    Color3.fromRGB(220, 50, 50), "Create", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold
Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", createBtn)).Color = Color3.fromRGB(40, 43, 52)

local deleteFrame = Instance.new("Frame", profilesContainer)
deleteFrame.LayoutOrder = 3
deleteFrame.Size = UDim2.new(1, 0, 0, 30)
deleteFrame.BackgroundColor3, deleteFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", deleteFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", deleteFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(deleteFrame, "Primary")
local delLabel = Instance.new("TextLabel", deleteFrame)
delLabel.Size, delLabel.Position, delLabel.BackgroundTransparency = UDim2.new(0, 80, 1, 0), UDim2.new(0, 5, 0, 0), 1
delLabel.Text, delLabel.TextColor3, delLabel.TextSize, delLabel.Font, delLabel.TextXAlignment =
    "Xóa Cấu Hình", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local delBtn = Instance.new("TextButton", deleteFrame)
delBtn.Size, delBtn.Position = UDim2.new(0, 85, 0, 20), UDim2.new(1, -90, 0.5, -10)
delBtn.BackgroundColor3, delBtn.BackgroundTransparency = Color3.fromRGB(50, 10, 35), 0
delBtn.Text, delBtn.TextColor3, delBtn.TextSize, delBtn.Font, delBtn.TextXAlignment =
    "Không có ∨", Color3.fromRGB(50, 200, 50), 8, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", delBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(delBtn, "Input")

local delDropFrame = Instance.new("ScrollingFrame", profilesContainer)
delDropFrame.LayoutOrder = 4
delDropFrame.Size, delDropFrame.BackgroundColor3, delDropFrame.BackgroundTransparency = UDim2.new(1, 0, 0, 80), Color3.fromRGB(80, 20, 60), 0
delDropFrame.CanvasSize, delDropFrame.ScrollBarThickness, delDropFrame.Visible = UDim2.new(0, 0, 0, 0), 3, false
Instance.new("UICorner", delDropFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", delDropFrame)).Color = Color3.fromRGB(40, 43, 52)
local delDropLayout = Instance.new("UIListLayout", delDropFrame)
delDropLayout.Padding = UDim.new(0, 3)
local delPad = Instance.new("UIPadding", delDropFrame)
delPad.PaddingRight = UDim.new(0, 8)
RegisterTheme(delDropFrame, "DropFrame")

local startupProfileFrame = Instance.new("Frame", profilesContainer)
startupProfileFrame.LayoutOrder = 5
startupProfileFrame.Size = UDim2.new(1, 0, 0, 30)
startupProfileFrame.BackgroundColor3, startupProfileFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", startupProfileFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", startupProfileFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(startupProfileFrame, "Primary")
local stProfileLabel = Instance.new("TextLabel", startupProfileFrame)
stProfileLabel.Size, stProfileLabel.Position, stProfileLabel.BackgroundTransparency = UDim2.new(0, 80, 1, 0), UDim2.new(0, 5, 0, 0), 1
stProfileLabel.Text, stProfileLabel.TextColor3, stProfileLabel.TextSize, stProfileLabel.Font, stProfileLabel.TextXAlignment =
    "Khởi Động", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local stProfileBtn = Instance.new("TextButton", startupProfileFrame)
stProfileBtn.Size, stProfileBtn.Position = UDim2.new(0, 85, 0, 20), UDim2.new(1, -90, 0.5, -10)
stProfileBtn.BackgroundColor3, stProfileBtn.BackgroundTransparency = Color3.fromRGB(50, 10, 35), 0
stProfileBtn.Text, stProfileBtn.TextColor3, stProfileBtn.TextSize, stProfileBtn.Font, stProfileBtn.TextXAlignment =
    startupConfigName .. " ∨", Color3.fromRGB(50, 200, 50), 8, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", stProfileBtn).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", stProfileBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(stProfileBtn, "Input")

local stProfileDrop = Instance.new("ScrollingFrame", profilesContainer)
stProfileDrop.LayoutOrder = 6
stProfileDrop.Size, stProfileDrop.BackgroundColor3, stProfileDrop.BackgroundTransparency = UDim2.new(1, 0, 0, 80), Color3.fromRGB(80, 20, 60), 0
stProfileDrop.CanvasSize, stProfileDrop.ScrollBarThickness, stProfileDrop.Visible = UDim2.new(0, 0, 0, 0), 3, false
Instance.new("UICorner", stProfileDrop).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", stProfileDrop)).Color = Color3.fromRGB(40, 43, 52)
local stProfileLayout = Instance.new("UIListLayout", stProfileDrop)
stProfileLayout.Padding = UDim.new(0, 3)
local stPad = Instance.new("UIPadding", stProfileDrop)
stPad.PaddingRight = UDim.new(0, 8)
RegisterTheme(stProfileDrop, "DropFrame")

local loadConfigFrame = Instance.new("Frame", profilesContainer)
loadConfigFrame.LayoutOrder = 7
loadConfigFrame.Size = UDim2.new(1, 0, 0, 30)
loadConfigFrame.BackgroundColor3, loadConfigFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", loadConfigFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", loadConfigFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(loadConfigFrame, "Primary")
local ldLabel = Instance.new("TextLabel", loadConfigFrame)
ldLabel.Size, ldLabel.Position, ldLabel.BackgroundTransparency = UDim2.new(0, 80, 1, 0), UDim2.new(0, 5, 0, 0), 1
ldLabel.Text, ldLabel.TextColor3, ldLabel.TextSize, ldLabel.Font, ldLabel.TextXAlignment =
    "Tải Config", Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local ldBtn = Instance.new("TextButton", loadConfigFrame)
ldBtn.Size, ldBtn.Position = UDim2.new(0, 85, 0, 20), UDim2.new(1, -90, 0.5, -10)
ldBtn.BackgroundColor3, ldBtn.BackgroundTransparency = Color3.fromRGB(50, 10, 35), 0
ldBtn.Text, ldBtn.TextColor3, ldBtn.TextSize, ldBtn.Font, ldBtn.TextXAlignment =
    currentConfigName .. " ∨", Color3.fromRGB(50, 200, 50), 8, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", ldBtn).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", ldBtn)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(ldBtn, "Input")

local ldDropFrame = Instance.new("ScrollingFrame", profilesContainer)
ldDropFrame.LayoutOrder = 8
ldDropFrame.Size, ldDropFrame.BackgroundColor3, ldDropFrame.BackgroundTransparency = UDim2.new(1, 0, 0, 80), Color3.fromRGB(80, 20, 60), 0
ldDropFrame.CanvasSize, ldDropFrame.ScrollBarThickness, ldDropFrame.Visible = UDim2.new(0, 0, 0, 0), 3, false
Instance.new("UICorner", ldDropFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", ldDropFrame)).Color = Color3.fromRGB(40, 43, 52)
local ldDropLayout = Instance.new("UIListLayout", ldDropFrame)
ldDropLayout.Padding = UDim.new(0, 3)
local ldPad = Instance.new("UIPadding", ldDropFrame)
ldPad.PaddingRight = UDim.new(0, 8)
RegisterTheme(ldDropFrame, "DropFrame")

local saveFrame = Instance.new("Frame", profilesContainer)
saveFrame.LayoutOrder = 9
saveFrame.Size = UDim2.new(1, 0, 0, 34)
saveFrame.BackgroundColor3, saveFrame.BackgroundTransparency = Color3.fromRGB(70, 15, 50), 0
Instance.new("UICorner", saveFrame).CornerRadius = UDim.new(0, 5)
TrackStroke(Instance.new("UIStroke", saveFrame)).Color = Color3.fromRGB(40, 43, 52)
RegisterTheme(saveFrame, "Primary")
local svTitle = Instance.new("TextLabel", saveFrame)
svTitle.Size, svTitle.Position, svTitle.BackgroundTransparency = UDim2.new(1, -75, 0, 15), UDim2.new(0, 5, 0, 2), 1
svTitle.Text, svTitle.TextColor3, svTitle.TextSize, svTitle.Font, svTitle.TextXAlignment =
    "Lưu Cấu Hình", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local svSub = Instance.new("TextLabel", saveFrame)
svSub.Size, svSub.Position, svSub.BackgroundTransparency = UDim2.new(1, -75, 0, 14), UDim2.new(0, 5, 0, 17), 1
svSub.Text, svSub.TextColor3, svSub.TextSize, svSub.Font, svSub.TextXAlignment =
    "Save: " .. currentConfigName, Color3.fromRGB(140, 140, 150), 7, Enum.Font.Gotham, Enum.TextXAlignment.Left

local saveBtn = Instance.new("TextButton", saveFrame)
saveBtn.Size, saveBtn.Position = UDim2.new(0, 65, 0, 22), UDim2.new(1, -70, 0.5, -11)
saveBtn.BackgroundColor3, saveBtn.Text, saveBtn.TextColor3, saveBtn.TextSize, saveBtn.Font =
    Color3.fromRGB(220, 50, 50), "Save", Color3.fromRGB(255, 255, 255), 9, Enum.Font.GothamBold
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 4)
TrackStroke(Instance.new("UIStroke", saveBtn)).Color = Color3.fromRGB(40, 43, 52)

local function refreshAllDropdowns()
    for _, drop in ipairs({delDropFrame, stProfileDrop, ldDropFrame}) do
        for _, child in ipairs(drop:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
    end
    local filesList = {}
    if typeof(listfiles) == "function" then
        local ok, files = pcall(listfiles, configFolder)
        if ok then
            for _, file in ipairs(files) do
                if string.sub(file, -5) == ".json" then
                    local fileName = string.match(file, "[^/\\]+$")
                    fileName = string.sub(fileName, 1, -6)
                    table.insert(filesList, fileName)
                end
            end
        end
    end
    if #filesList == 0 then delBtn.Text = "Không có ∨" end
    for _, name in ipairs(filesList) do
        local f1 = Instance.new("TextButton", delDropFrame)
        f1.Size = UDim2.new(1, 0, 0, 22)
        f1.BackgroundColor3, f1.BackgroundTransparency = Color3.fromRGB(90, 25, 65), 0
        f1.Text, f1.TextColor3, f1.TextSize, f1.Font, f1.TextXAlignment = " 🗑️ " .. name, Color3.fromRGB(255, 100, 100), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", f1).CornerRadius = UDim.new(0, 4)
        TrackStroke(Instance.new("UIStroke", f1)).Color = Color3.fromRGB(40, 43, 52)
        RegisterTheme(f1, "DropItem")
        Connect(f1.MouseButton1Click, function()
            if typeof(delfile) == "function" then pcall(delfile, configFolder .. "/" .. name .. ".json") end
            delBtn.Text = name .. " ∨"
            delDropFrame.Visible = false
            refreshAllDropdowns()
        end)
        local f2 = Instance.new("TextButton", stProfileDrop)
        f2.Size = UDim2.new(1, 0, 0, 22)
        f2.BackgroundColor3, f2.BackgroundTransparency = Color3.fromRGB(90, 25, 65), 0
        f2.Text, f2.TextColor3, f2.TextSize, f2.Font, f2.TextXAlignment = " 📁 " .. name, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", f2).CornerRadius = UDim.new(0, 4)
        TrackStroke(Instance.new("UIStroke", f2)).Color = Color3.fromRGB(40, 43, 52)
        RegisterTheme(f2, "DropItem")
        Connect(f2.MouseButton1Click, function()
            startupConfigName = name
            stProfileBtn.Text = name .. " ∨"
            startupLabel.Text = "Startup: " .. name
            stProfileDrop.Visible = false
        end)
        local f3 = Instance.new("TextButton", ldDropFrame)
        f3.Size = UDim2.new(1, 0, 0, 22)
        f3.BackgroundColor3, f3.BackgroundTransparency = Color3.fromRGB(90, 25, 65), 0
        f3.Text, f3.TextColor3, f3.TextSize, f3.Font, f3.TextXAlignment = " 📂 " .. name, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", f3).CornerRadius = UDim.new(0, 4)
        TrackStroke(Instance.new("UIStroke", f3)).Color = Color3.fromRGB(40, 43, 52)
        RegisterTheme(f3, "DropItem")
        Connect(f3.MouseButton1Click, function()
            currentConfigName = name
            ldBtn.Text = name .. " ∨"
            svSub.Text = "Save: " .. name
            asSub.Text = "Save: " .. name
            alCfgSub.Text = "Load: " .. name
            ldDropFrame.Visible = false
        end)
    end
    delDropFrame.CanvasSize = UDim2.new(0, 0, 0, #filesList * 25)
    stProfileDrop.CanvasSize = UDim2.new(0, 0, 0, #filesList * 25)
    ldDropFrame.CanvasSize = UDim2.new(0, 0, 0, #filesList * 25)
end

Connect(delBtn.MouseButton1Click, function()
    refreshAllDropdowns()
    delDropFrame.Visible = not delDropFrame.Visible
    stProfileDrop.Visible = false
    ldDropFrame.Visible = false
end)
Connect(stProfileBtn.MouseButton1Click, function()
    refreshAllDropdowns()
    stProfileDrop.Visible = not stProfileDrop.Visible
    delDropFrame.Visible = false
    ldDropFrame.Visible = false
end)
Connect(ldBtn.MouseButton1Click, function()
    refreshAllDropdowns()
    ldDropFrame.Visible = not ldDropFrame.Visible
    delDropFrame.Visible = false
    stProfileDrop.Visible = false
end)

Connect(createBtn.MouseButton1Click, function()
    local name = configNameBox.Text
    if name ~= "" and typeof(writefile) == "function" then
        pcall(writefile, configFolder .. "/" .. name .. ".json", HttpService:JSONEncode({SavedTime = os.time()}))
        currentConfigName = name
        ldBtn.Text = name .. " ∨"
        svSub.Text = "Save: " .. name
        asSub.Text = "Save: " .. name
        alCfgSub.Text = "Load: " .. name
        configNameBox.Text = ""
        refreshAllDropdowns()
    end
end)

Connect(saveBtn.MouseButton1Click, function()
    if typeof(writefile) == "function" then
        pcall(writefile, configFolder .. "/" .. currentConfigName .. ".json", HttpService:JSONEncode({SavedTime = os.time()}))
        svSub.Text = "Save: " .. currentConfigName
    end
end)

configScroll.CanvasSize = UDim2.new(0, 0, 0, 950)

local dh = 0
for i, scr in ipairs(RegisteredScripts) do
    local item = Instance.new("TextButton", dropFrame)
    item.LayoutOrder = i
    item.Size = UDim2.new(1, 0, 0, 22)
    item.BackgroundColor3, item.BackgroundTransparency = Color3.fromRGB(90, 25, 65), 0
    item.Text, item.TextColor3, item.TextSize, item.Font, item.TextXAlignment = " ▶ " .. scr.Name, Color3.fromRGB(255, 255, 255), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 4)
    TrackStroke(Instance.new("UIStroke", item)).Color = Color3.fromRGB(40, 43, 52)
    RegisterTheme(item, "DropItem")
    Connect(item.MouseButton1Click, function()
        selScript = scr
        dropBtn.Text = " 📜 " .. scr.Name
        dropFrame.Visible = false
    end)
    dh = dh + 25
end
dropFrame.CanvasSize = UDim2.new(0, 0, 0, dh)

--------------------------------------------------------------------------------
-- NÚT MỞ HUB 🌸
--------------------------------------------------------------------------------
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Name = "VzNamOpenBtn"
OpenButton.Size = UDim2.new(0, 40, 0, 40)
OpenButton.Position = UDim2.new(0, 15, 0.25, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
OpenButton.BackgroundTransparency = 0
OpenButton.Text = "🌸"
OpenButton.TextSize = 20
OpenButton.Active = true
OpenButton.Draggable = true
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
local OpenStroke = TrackStroke(Instance.new("UIStroke", OpenButton))
OpenStroke.Thickness = 3
OpenStroke.Color = Color3.fromRGB(255, 255, 255)

Connect(OpenButton.MouseButton1Click, function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------
-- KHỞI TẠO
--------------------------------------------------------------------------------
ApplyTheme(Color3.fromRGB(15, 16, 22))
ApplyStrokeColor("Rainbow")
