local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then 
    PlayerGui.VzNamHubV4UI:Destroy() 
end

local RegisteredScripts = {}
local AllUIStrokes = {}
local LastSelectedScriptStroke = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.DisplayOrder = 99999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local avatarUrl = "rbxassetid://15298567397"

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local OuterStroke = Instance.new("UIStroke")
OuterStroke.Color = Color3.fromRGB(0, 160, 255)
OuterStroke.Thickness = 1.5
OuterStroke.Transparency = 0.1
OuterStroke.Parent = MainFrame
table.insert(AllUIStrokes, OuterStroke)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 18, 0, 18)
Logo.Position = UDim2.new(0, 10, 0.5, -9)
Logo.BackgroundTransparency = 1
Logo.Image = avatarUrl
Logo.Parent = TopBar
local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 32, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌸 VzNam Hub v4 🌸"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -13)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function()
    if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end
    ScreenGui:Destroy()
end)

-- ĐÃ SỬA LẠI TỌA ĐỘ VÀ KÍCH THƯỚC ĐỂ KHÔNG BỊ MẤT VIỀN TRÁI
local SidebarPanel = Instance.new("Frame")
SidebarPanel.Name = "SidebarPanel"
SidebarPanel.Size = UDim2.new(0, 140, 1, -34)
SidebarPanel.Position = UDim2.new(0, 6, 0, 30)
SidebarPanel.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
SidebarPanel.BorderSizePixel = 0
SidebarPanel.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 6)
SidebarCorner.Parent = SidebarPanel

local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Color = Color3.fromRGB(0, 160, 255)
SidebarStroke.Thickness = 1.5
SidebarStroke.Parent = SidebarPanel
table.insert(AllUIStrokes, SidebarStroke)

local SearchBoxTab = Instance.new("TextBox")
SearchBoxTab.Size = UDim2.new(1, -10, 0, 24)
SearchBoxTab.Position = UDim2.new(0, 5, 0, 5)
SearchBoxTab.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
SearchBoxTab.Text = ""
SearchBoxTab.PlaceholderText = "🔍 Search section..."
SearchBoxTab.PlaceholderColor3 = Color3.fromRGB(130, 135, 145)
SearchBoxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBoxTab.TextSize = 10
SearchBoxTab.Font = Enum.Font.Gotham
SearchBoxTab.Parent = SidebarPanel

local SearchBoxCorner = Instance.new("UICorner")
SearchBoxCorner.CornerRadius = UDim.new(0, 4)
SearchBoxCorner.Parent = SearchBoxTab

local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Size = UDim2.new(1, -6, 1, -34)
SidebarScroll.Position = UDim2.new(0, 3, 0, 32)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.BorderSizePixel = 0
SidebarScroll.ScrollBarThickness = 2
SidebarScroll.Parent = SidebarPanel

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.Parent = SidebarScroll

SearchBoxTab:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBoxTab.Text)
    for _, item in ipairs(SidebarScroll:GetChildren()) do
        if item:IsA("TextButton") then
            if query == "" or string.find(string.lower(item.Text), query) then 
                item.Visible = true 
            else 
                item.Visible = false 
            end
        end
    end
end)

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -154, 1, -34)
ContentContainer.Position = UDim2.new(0, 150, 0, 30)
ContentContainer.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = ContentContainer

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(0, 160, 255)
ContentStroke.Thickness = 1.5
ContentStroke.Parent = ContentContainer
table.insert(AllUIStrokes, ContentStroke)

local ContentHeader = Instance.new("Frame")
ContentHeader.Size = UDim2.new(1, 0, 0, 30)
ContentHeader.BackgroundTransparency = 1
ContentHeader.Parent = ContentContainer

local ActiveTabTitle = Instance.new("TextLabel")
ActiveTabTitle.Size = UDim2.new(1, -40, 1, 0)
ActiveTabTitle.Position = UDim2.new(0, 12, 0, 0)
ActiveTabTitle.BackgroundTransparency = 1
ActiveTabTitle.Text = ""
ActiveTabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ActiveTabTitle.TextSize = 12
ActiveTabTitle.Font = Enum.Font.GothamBold
ActiveTabTitle.TextXAlignment = Enum.TextXAlignment.Left
ActiveTabTitle.Parent = ContentHeader

local SearchInputContent = Instance.new("TextBox")
SearchInputContent.Size = UDim2.new(1, -45, 0, 22)
SearchInputContent.Position = UDim2.new(0, 10, 0.5, -11)
SearchInputContent.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
SearchInputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchInputContent.PlaceholderText = "Search features..."
SearchInputContent.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
SearchInputContent.TextSize = 10
SearchInputContent.Font = Enum.Font.Gotham
SearchInputContent.Visible = false
SearchInputContent.Parent = ContentHeader

local SearchInputCorner = Instance.new("UICorner")
SearchInputCorner.CornerRadius = UDim.new(0, 4)
SearchInputCorner.Parent = SearchInputContent

local SearchContentIcon = Instance.new("TextButton")
SearchContentIcon.Size = UDim2.new(0, 24, 0, 24)
SearchContentIcon.Position = UDim2.new(1, -28, 0.5, -12)
SearchContentIcon.BackgroundTransparency = 1
SearchContentIcon.Text = "🔍"
SearchContentIcon.TextSize = 12
SearchContentIcon.TextColor3 = Color3.fromRGB(200, 205, 215)
SearchContentIcon.Parent = ContentHeader

local searching = false
SearchContentIcon.MouseButton1Click:Connect(function()
    searching = not searching
    SearchInputContent.Visible = searching
    ActiveTabTitle.Visible = not searching
    if searching then SearchInputContent:CaptureFocus() else SearchInputContent.Text = "" end
end)

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 0, 30)
HeaderDivider.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = ContentContainer

local Tabs = {}

-- TAB 0: TRANG CHỦ
local tabHomeBtn = Instance.new("TextButton")
tabHomeBtn.LayoutOrder = 0
tabHomeBtn.Size = UDim2.new(1, -6, 0, 30)
tabHomeBtn.Position = UDim2.new(0, 3, 0, 0)
tabHomeBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
tabHomeBtn.Text = "   🏠 Trang Chủ"
tabHomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabHomeBtn.TextSize = 11
tabHomeBtn.Font = Enum.Font.Gotham
tabHomeBtn.TextXAlignment = Enum.TextXAlignment.Left
tabHomeBtn.Parent = SidebarScroll

local tabHomeCorner = Instance.new("UICorner")
tabHomeCorner.CornerRadius = UDim.new(0, 5)
tabHomeCorner.Parent = tabHomeBtn

local tabHomeStroke = Instance.new("UIStroke")
tabHomeStroke.Color = Color3.fromRGB(0, 160, 255)
tabHomeStroke.Thickness = 1.5
tabHomeStroke.Parent = tabHomeBtn
table.insert(AllUIStrokes, tabHomeStroke)

local homeIndicator = Instance.new("Frame")
homeIndicator.Size = UDim2.new(0, 3, 0, 14)
homeIndicator.Position = UDim2.new(0, 0, 0.5, -7)
homeIndicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
homeIndicator.BorderSizePixel = 0
homeIndicator.Visible = false
homeIndicator.Parent = tabHomeBtn

local homeIndicatorCorner = Instance.new("UICorner")
homeIndicatorCorner.CornerRadius = UDim.new(0, 2)
homeIndicatorCorner.Parent = homeIndicator

local homeScroll = Instance.new("ScrollingFrame")
homeScroll.Name = "Container_HOME"
homeScroll.Size = UDim2.new(1, -12, 1, -38)
homeScroll.Position = UDim2.new(0, 6, 0, 34)
homeScroll.BackgroundTransparency = 1
homeScroll.BorderSizePixel = 0
homeScroll.ScrollBarThickness = 3
homeScroll.Visible = false
homeScroll.ClipsDescendants = true
homeScroll.Parent = ContentContainer

local homeLayout = Instance.new("UIListLayout")
homeLayout.SortOrder = Enum.SortOrder.LayoutOrder
homeLayout.Padding = UDim.new(0, 5)
homeLayout.Parent = homeScroll

tabHomeBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    homeScroll.Visible = true 
    homeIndicator.Visible = true 
    ActiveTabTitle.Text = "🏠 Trang Chủ"
    SearchInputContent.Text = ""
end)

table.insert(Tabs, { Container = homeScroll, Indicator = homeIndicator })
homeScroll.Visible, homeIndicator.Visible = true, true
ActiveTabTitle.Text = "🏠 Trang Chủ"

local function CreateHomeCardWithIcon(parent, order, bgColor, titleText, mainText, copyText, borderColor, iconSymbol)
    local card = Instance.new("Frame")
    card.LayoutOrder = order
    card.Size = UDim2.new(1, -16, 0, 34)
    card.Position = UDim2.new(0, 8, 0, 0)
    card.BackgroundColor3 = bgColor
    card.BorderSizePixel = 0
    card.Parent = parent

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 5)
    cardCorner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = borderColor
    stroke.Thickness = 1.5
    stroke.Parent = card
    table.insert(AllUIStrokes, stroke)

    local iconCircle = Instance.new("Frame")
    iconCircle.Size = UDim2.new(0, 22, 0, 22)
    iconCircle.Position = UDim2.new(0, 6, 0.5, -11)
    iconCircle.BackgroundColor3 = borderColor
    iconCircle.BorderSizePixel = 0
    iconCircle.Parent = card

    local iconCircleCorner = Instance.new("UICorner")
    iconCircleCorner.CornerRadius = UDim.new(1, 0)
    iconCircleCorner.Parent = iconCircle
    
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(1, 0, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = iconSymbol
    iconLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLbl.TextSize = 10
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = iconCircle

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -100, 0, 12)
    tLbl.Position = UDim2.new(0, 34, 0, 3)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = titleText
    tLbl.TextColor3 = Color3.fromRGB(255, 150, 100)
    tLbl.TextSize = 8
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local mLbl = Instance.new("TextLabel")
    mLbl.Size = UDim2.new(1, -100, 0, 16)
    mLbl.Position = UDim2.new(0, 34, 0, 14)
    mLbl.BackgroundTransparency = 1
    mLbl.Text = mainText
    mLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    mLbl.TextSize = 8
    mLbl.Font = Enum.Font.Gotham
    mLbl.TextXAlignment = Enum.TextXAlignment.Left
    mLbl.Parent = card

    if copyText ~= "" then
        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 55, 0, 20)
        copyBtn.Position = UDim2.new(1, -63, 0.5, -10)
        copyBtn.BackgroundTransparency = 1
        copyBtn.Text = "📋 COPY"
        copyBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
        copyBtn.TextSize = 8
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.Parent = card
        
        local function doCopy()
            if typeof(setclipboard) == "function" then
                pcall(setclipboard, copyText)
                copyBtn.Text = "✓ COPIED"
                task.delay(1.5, function() copyBtn.Text = "📋 COPY" end)
            end
        end
        copyBtn.MouseButton1Click:Connect(doCopy)
        card.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then doCopy() end
        end)
    end
end

CreateHomeCardWithIcon(homeScroll, 1, Color3.fromRGB(45, 25, 30), "ĐƯỢC TẠO BỞI", "VzNam ROBLOX", "", Color3.fromRGB(0, 160, 255), "👤")
CreateHomeCardWithIcon(homeScroll, 2, Color3.fromRGB(30, 35, 55), "DISCORD SERVER", "https://discord.gg/6TG7krbsU", "https://discord.gg/6TG7krbsU", Color3.fromRGB(0, 160, 255), "💬")
CreateHomeCardWithIcon(homeScroll, 3, Color3.fromRGB(35, 35, 45), "TIKTOK CHANNEL", "https://www.tiktok.com/@uttop1gl.ovo?_r=1&_t=ZS-9AWatTQR08y", "https://www.tiktok.com/@uttop1gl.ovo?_r=1&_t=ZS-9AWatTQR08y", Color3.fromRGB(0, 160, 255), "🎵")

homeScroll.CanvasSize = UDim2.new(0, 0, 0, 120)

local function CreateCategoryTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -6, 0, 30)
    tabBtn.Position = UDim2.new(0, 3, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    tabBtn.Text = "   " .. tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = SidebarScroll

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 5)
    tabCorner.Parent = tabBtn

    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Color3.fromRGB(0, 160, 255)
    tabStroke.Thickness = 1.5
    tabStroke.Parent = tabBtn
    table.insert(AllUIStrokes, tabStroke)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 14)
    indicator.Position = UDim2.new(0, 0, 0.5, -7)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = tabBtn

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator

    local containerFrame = Instance.new("Frame")
    containerFrame.Name = "Container_" .. tabName
    containerFrame.Size = UDim2.new(1, -12, 1, -38)
    containerFrame.Position = UDim2.new(0, 6, 0, 34)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Visible = false
    containerFrame.Parent = ContentContainer

    local subBar = Instance.new("Frame")
    subBar.Size = UDim2.new(1, -16, 0, 26)
    subBar.Position = UDim2.new(0, 8, 0, 0)
    subBar.BackgroundTransparency = 1
    subBar.Parent = containerFrame

    local subLayout = Instance.new("UIListLayout")
    subLayout.FillDirection = Enum.FillDirection.Horizontal
    subLayout.Padding = UDim.new(0, 6)
    subLayout.Parent = subBar

    local noKeyBtn = Instance.new("TextButton")
    noKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    noKeyBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    noKeyBtn.Text = "no key"
    noKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noKeyBtn.TextSize = 11
    noKeyBtn.Font = Enum.Font.GothamBold
    noKeyBtn.Parent = subBar

    local nkCorner = Instance.new("UICorner")
    nkCorner.CornerRadius = UDim.new(0, 5)
    nkCorner.Parent = noKeyBtn

    local nkStroke = Instance.new("UIStroke")
    nkStroke.Color = Color3.fromRGB(255, 50, 50)
    nkStroke.Thickness = 2
    nkStroke.Parent = noKeyBtn

    local hasKeyBtn = Instance.new("TextButton")
    hasKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    hasKeyBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    hasKeyBtn.Text = "có key"
    hasKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hasKeyBtn.TextSize = 11
    hasKeyBtn.Font = Enum.Font.GothamBold
    hasKeyBtn.Parent = subBar

    local hkCorner = Instance.new("UICorner")
    hkCorner.CornerRadius = UDim.new(0, 5)
    hkCorner.Parent = hasKeyBtn

    local hkStroke = Instance.new("UIStroke")
    hkStroke.Color = Color3.fromRGB(0, 160, 255)
    hkStroke.Thickness = 1.5
    hkStroke.Parent = hasKeyBtn
    table.insert(AllUIStrokes, hkStroke)

    local scrollNoKey = Instance.new("ScrollingFrame")
    scrollNoKey.Position = UDim2.new(0, 0, 0, 32)
    scrollNoKey.Size = UDim2.new(1, 0, 1, -32)
    scrollNoKey.BackgroundTransparency = 1
    scrollNoKey.BorderSizePixel = 0
    scrollNoKey.ScrollBarThickness = 3
    scrollNoKey.Visible = true
    scrollNoKey.ClipsDescendants = true
    scrollNoKey.Parent = containerFrame

    local l1 = Instance.new("UIListLayout")
    l1.Padding = UDim.new(0, 5)
    l1.Parent = scrollNoKey

    local scrollHasKey = Instance.new("ScrollingFrame")
    scrollHasKey.Position = UDim2.new(0, 0, 0, 32)
    scrollHasKey.Size = UDim2.new(1, 0, 1, -32)
    scrollHasKey.BackgroundTransparency = 1
    scrollHasKey.BorderSizePixel = 0
    scrollHasKey.ScrollBarThickness = 3
    scrollHasKey.Visible = false
    scrollHasKey.ClipsDescendants = true
    scrollHasKey.Parent = containerFrame

    local l2 = Instance.new("UIListLayout")
    l2.Padding = UDim.new(0, 5)
    l2.Parent = scrollHasKey

    SearchInputContent:GetPropertyChangedSignal("Text"):Connect(function()
        if containerFrame.Visible then
            local query = string.lower(SearchInputContent.Text)
            local targetScroll = scrollNoKey.Visible and scrollNoKey or scrollHasKey
            for _, item in ipairs(targetScroll:GetChildren()) do
                if item:IsA("TextButton") then
                    if query == "" or string.find(string.lower(item.Text), query) then item.Visible = true else item.Visible = false end
                end
            end
        end
    end)

    noKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible, scrollHasKey.Visible = true, false
        nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
        hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    end)
    hasKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible, scrollHasKey.Visible = false, true
        hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
        nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    end)

    tabBtn.MouseButton1Click:Connect(function()
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
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -16, 0, 30)
        Btn.Position = UDim2.new(0, 8, 0, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
        Btn.Text = "  ▶ " .. name
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.TextSize = 11
        Btn.Font = Enum.Font.Gotham
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = Btn

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(0, 160, 255)
        btnStroke.Thickness = 1.5
        btnStroke.Parent = Btn
        table.insert(AllUIStrokes, btnStroke)
        
        Btn.MouseButton1Click:Connect(function()
            if LastSelectedScriptStroke then LastSelectedScriptStroke.Color, LastSelectedScriptStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5 end
            btnStroke.Color, btnStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
            LastSelectedScriptStroke = btnStroke
            callback()
        end)
        table.insert(RegisteredScripts, {Name = name, Callback = callback})
    end

    function Elements:AddNoKey(name, callback) AddBtnTo(scrollNoKey, name, callback) end
    function Elements:AddHasKey(name, callback) AddBtnTo(scrollHasKey, name, callback) end
    return Elements
end

-- TAB 1: STEAL AN EGG
local tab1 = CreateCategoryTab("🌸STEAL AN EGG🌸")
tab1:AddNoKey("1. Hop sv1 người(nokey)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
tab1:AddNoKey("2. FyyCommunity(lúc có key lúc no key)", function() loadstring(game:HttpGet("https://FyyCommunity.my.id"))() end)
tab1:AddNoKey("3. Chilli Hub V4(nokey)", function() loadstring(game:HttpGet("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4"))() end)
tab1:AddNoKey("4. Night hub(nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"))() end)

tab1:AddHasKey("1. Lemon Hub v4(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt", true))() end)
tab1:AddHasKey("2. Hoshi hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua"))() end)
tab1:AddHasKey("3. Bigfroot(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))() end)
tab1:AddHasKey("4. Chữ A(ajjans)|(có key)", function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"))() end)
tab1:AddHasKey("5. Speed hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end)
tab1:AddHasKey("6. Neohub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/neohubdev/script/main/script"))() end)
tab1:AddHasKey("7. Real kid(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() end)
tab1:AddHasKey("8. Chilli v2(có key)", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/ronnei/1fa67c56dd9af203b192d15e752928e5/raw/4e2d5105640e09a008b4ae6df23f9708cadfef06/chilliv2-stealanegg"))() end)

-- TAB 2: BLOX FRUIT
local tab2 = CreateCategoryTab("🌸BLOX FRUIT🌸")
tab2:AddNoKey("1. RedzHub v2 (no key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))() end)
tab2:AddNoKey("2. Quantumx Hub(nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))() end)

tab2:AddHasKey("1. Speed Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end)
tab2:AddHasKey("2. Omg Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))() end)
tab2:AddHasKey("3. TeddyHub(có key)", function() repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))() end)
tab2:AddHasKey("4. Gravity Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))() end)
tab2:AddHasKey("5. Realkid hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() end)
tab2:AddHasKey("6. BananaHub(có key)", function() repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer getgenv().Team = "Marines" loadstring(game:HttpGet("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua"))() end)

local tab3 = CreateCategoryTab("🌸BREAK AN STEAL🌸")
tab3:AddNoKey("1. break and steal an egg", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))() end)

CreateCategoryTab("Tab 4")
CreateCategoryTab("Tab 5")

-- TAB 6: MISC
local tabMiscBtn = Instance.new("TextButton")
tabMiscBtn.LayoutOrder = 6
tabMiscBtn.Size = UDim2.new(1, -6, 0, 30)
tabMiscBtn.Position = UDim2.new(0, 3, 0, 0)
tabMiscBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
tabMiscBtn.Text = "   ⚙️ MISC"
tabMiscBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabMiscBtn.TextSize = 11
tabMiscBtn.Font = Enum.Font.Gotham
tabMiscBtn.TextXAlignment = Enum.TextXAlignment.Left
tabMiscBtn.Parent = SidebarScroll

local tabMiscCorner = Instance.new("UICorner")
tabMiscCorner.CornerRadius = UDim.new(0, 5)
tabMiscCorner.Parent = tabMiscBtn

local tabMiscStroke = Instance.new("UIStroke")
tabMiscStroke.Color = Color3.fromRGB(0, 160, 255)
tabMiscStroke.Thickness = 1.5
tabMiscStroke.Parent = tabMiscBtn
table.insert(AllUIStrokes, tabMiscStroke)

local miscIndicator = Instance.new("Frame")
miscIndicator.Size = UDim2.new(0, 3, 0, 14)
miscIndicator.Position = UDim2.new(0, 0, 0.5, -7)
miscIndicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
miscIndicator.BorderSizePixel = 0
miscIndicator.Visible = false
miscIndicator.Parent = tabMiscBtn

local miscIndicatorCorner = Instance.new("UICorner")
miscIndicatorCorner.CornerRadius = UDim.new(0, 2)
miscIndicatorCorner.Parent = miscIndicator

local miscScroll = Instance.new("ScrollingFrame")
miscScroll.Name = "Container_MISC"
miscScroll.Size = UDim2.new(1, -12, 1, -38)
miscScroll.Position = UDim2.new(0, 6, 0, 34)
miscScroll.BackgroundTransparency = 1
miscScroll.BorderSizePixel = 0
miscScroll.ScrollBarThickness = 3
miscScroll.Visible = false
miscScroll.ClipsDescendants = true
miscScroll.Parent = ContentContainer

local miscLayout = Instance.new("UIListLayout")
miscLayout.SortOrder = Enum.SortOrder.LayoutOrder
miscLayout.Padding = UDim.new(0, 8)
miscLayout.Parent = miscScroll

tabMiscBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    miscScroll.Visible = true 
    miscIndicator.Visible = true 
    ActiveTabTitle.Text = "⚙️ MISC"
end)
table.insert(Tabs, {Container = miscScroll, Indicator = miscIndicator})

local colorToggleBtn = Instance.new("TextButton")
colorToggleBtn.LayoutOrder = 1
colorToggleBtn.Size = UDim2.new(1, -16, 0, 42)
colorToggleBtn.Position = UDim2.new(0, 8, 0, 0)
colorToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
colorToggleBtn.Text = "  ↓ màu menu & viền"
colorToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorToggleBtn.TextSize = 13
colorToggleBtn.Font = Enum.Font.GothamBold
colorToggleBtn.Parent = miscScroll

local colorToggleCorner = Instance.new("UICorner")
colorToggleCorner.CornerRadius = UDim.new(0, 5)
colorToggleCorner.Parent = colorToggleBtn

local colorToggleBtnStroke = Instance.new("UIStroke")
colorToggleBtnStroke.Color = Color3.fromRGB(0, 160, 255)
colorToggleBtnStroke.Thickness = 1.5
colorToggleBtnStroke.Parent = colorToggleBtn
table.insert(AllUIStrokes, colorToggleBtnStroke)

local coSubLabel = Instance.new("TextLabel")
coSubLabel.Size = UDim2.new(1, 0, 0, 16)
coSubLabel.Position = UDim2.new(0, 0, 1, -16)
coSubLabel.BackgroundTransparency = 1
coSubLabel.Text = "Tùy chỉnh màu sắc giao diện và viền"
coSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
coSubLabel.TextSize = 9
coSubLabel.Font = Enum.Font.Gotham
coSubLabel.Parent = colorToggleBtn

local colorContainer = Instance.new("Frame")
colorContainer.LayoutOrder = 2
colorContainer.Size = UDim2.new(1, -16, 0, 0)
colorContainer.AutomaticSize = Enum.AutomaticSize.Y
colorContainer.Position = UDim2.new(0, 8, 0, 0)
colorContainer.BackgroundTransparency = 1
colorContainer.Visible = true
colorContainer.Parent = miscScroll

local coLayout = Instance.new("UIListLayout")
coLayout.SortOrder = Enum.SortOrder.LayoutOrder
coLayout.Padding = UDim.new(0, 5)
coLayout.Parent = colorContainer

colorToggleBtn.MouseButton1Click:Connect(function()
    colorContainer.Visible = not colorContainer.Visible
    colorToggleBtn.Text = colorContainer.Visible and "  ↓ màu menu & viền" or "  → màu menu & viền"
    coSubLabel.Visible = colorContainer.Visible
end)

-- PHẦN CHỈNH MÀU VIỀN TRONG TAB MISC
local borderList = {
    {Name = "🔵 Xanh Dương (Mặc Định)", Color = Color3.fromRGB(0, 160, 255)},
    {Name = "🌈 Cầu Vồng", Color = "Rainbow"},
    {Name = "💖 Hồng Kẹo", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "🟢 Xanh Lá", Color = Color3.fromRGB(50, 205, 50)},
    {Name = "🟡 Vàng Nổi Bật", Color = Color3.fromRGB(255, 215, 0)}
}
local selectedBorderObj = borderList[1]

local borderDropBtn = Instance.new("TextButton")
borderDropBtn.LayoutOrder = 1
borderDropBtn.Size = UDim2.new(1, 0, 0, 32)
borderDropBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
borderDropBtn.Text = " 🖍️ Đã chọn màu viền: 🔵 Xanh Dương"
borderDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
borderDropBtn.TextSize = 11
borderDropBtn.Font = Enum.Font.Gotham
borderDropBtn.TextXAlignment = Enum.TextXAlignment.Left
borderDropBtn.Parent = colorContainer

local borderDropBtnCorner = Instance.new("UICorner")
borderDropBtnCorner.CornerRadius = UDim.new(0, 5)
borderDropBtnCorner.Parent = borderDropBtn

local borderDropBtnStroke = Instance.new("UIStroke")
borderDropBtnStroke.Color = Color3.fromRGB(0, 160, 255)
borderDropBtnStroke.Thickness = 1.5
borderDropBtnStroke.Parent = borderDropBtn
table.insert(AllUIStrokes, borderDropBtnStroke)

local borderDropFrame = Instance.new("ScrollingFrame")
borderDropFrame.LayoutOrder = 2
borderDropFrame.Size = UDim2.new(1, 0, 0, 130)
borderDropFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
borderDropFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
borderDropFrame.ScrollBarThickness = 3
borderDropFrame.Visible = false
borderDropFrame.Parent = colorContainer

local borderDropFrameCorner = Instance.new("UICorner")
borderDropFrameCorner.CornerRadius = UDim.new(0, 5)
borderDropFrameCorner.Parent = borderDropFrame

local borderDropFrameStroke = Instance.new("UIStroke")
borderDropFrameStroke.Color = Color3.fromRGB(0, 160, 255)
borderDropFrameStroke.Thickness = 1.5
borderDropFrameStroke.Parent = borderDropFrame
table.insert(AllUIStrokes, borderDropFrameStroke)

local borderLayout = Instance.new("UIListLayout")
borderLayout.Padding = UDim.new(0, 4)
borderLayout.Parent = borderDropFrame

for i, bItem in ipairs(borderList) do
    local bBtn = Instance.new("TextButton")
    bBtn.LayoutOrder = i
    bBtn.Size = UDim2.new(1, 0, 0, 26)
    bBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    bBtn.Text = " " .. bItem.Name
    bBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    bBtn.TextSize = 11
    bBtn.Font = Enum.Font.Gotham
    bBtn.TextXAlignment = Enum.TextXAlignment.Left
    bBtn.Parent = borderDropFrame

    local bBtnCorner = Instance.new("UICorner")
    bBtnCorner.CornerRadius = UDim.new(0, 4)
    bBtnCorner.Parent = bBtn

    local bBtnStroke = Instance.new("UIStroke")
    bBtnStroke.Color = Color3.fromRGB(0, 160, 255)
    bBtnStroke.Thickness = 1.5
    bBtnStroke.Parent = bBtn
    table.insert(AllUIStrokes, bBtnStroke)

    bBtn.MouseButton1Click:Connect(function()
        selectedBorderObj = bItem 
        borderDropBtn.Text = " 🖍️ Đã chọn màu viền: " .. bItem.Name 
        borderDropFrame.Visible = false
    end)
end
borderDropFrame.CanvasSize = UDim2.new(0, 0, 0, #borderList * 30)
borderDropBtn.MouseButton1Click:Connect(function() borderDropFrame.Visible = not borderDropFrame.Visible end)

local borderToggleFrame = Instance.new("Frame")
borderToggleFrame.LayoutOrder = 3
borderToggleFrame.Size = UDim2.new(1, 0, 0, 38)
borderToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
borderToggleFrame.Parent = colorContainer

local borderToggleFrameCorner = Instance.new("UICorner")
borderToggleFrameCorner.CornerRadius = UDim.new(0, 5)
borderToggleFrameCorner.Parent = borderToggleFrame

local borderToggleFrameStroke = Instance.new("UIStroke")
borderToggleFrameStroke.Color = Color3.fromRGB(0, 160, 255)
borderToggleFrameStroke.Thickness = 1.5
borderToggleFrameStroke.Parent = borderToggleFrame
table.insert(AllUIStrokes, borderToggleFrameStroke)

local borderTitle = Instance.new("TextLabel")
borderTitle.Size = UDim2.new(1, -50, 1, 0)
borderTitle.Position = UDim2.new(0, 8, 0, 0)
borderTitle.BackgroundTransparency = 1
borderTitle.Text = "Màu Viền Tùy Chỉnh"
borderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
borderTitle.TextSize = 11
borderTitle.Font = Enum.Font.GothamBold
borderTitle.TextXAlignment = Enum.TextXAlignment.Left
borderTitle.Parent = borderToggleFrame

local toggleBorderBtn = Instance.new("TextButton")
toggleBorderBtn.Size = UDim2.new(0, 38, 0, 20)
toggleBorderBtn.Position = UDim2.new(1, -46, 0.5, -10)
toggleBorderBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
toggleBorderBtn.Text = ""
toggleBorderBtn.Parent = borderToggleFrame

local toggleBorderBtnCorner = Instance.new("UICorner")
toggleBorderBtnCorner.CornerRadius = UDim.new(1, 0)
toggleBorderBtnCorner.Parent = toggleBorderBtn

local borderDot = Instance.new("Frame")
borderDot.Size = UDim2.new(0, 16, 0, 16)
borderDot.Position = UDim2.new(0, 2, 0.5, -8)
borderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
borderDot.Parent = toggleBorderBtn

local borderDotCorner = Instance.new("UICorner")
borderDotCorner.CornerRadius = UDim.new(1, 0)
borderDotCorner.Parent = borderDot

local isBorderApplied = false
toggleBorderBtn.MouseButton1Click:Connect(function()
    isBorderApplied = not isBorderApplied
    if isBorderApplied then
        toggleBorderBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
        borderDot.Position = UDim2.new(1, -18, 0.5, -8)
    else
        toggleBorderBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75) 
        borderDot.Position = UDim2.new(0, 2, 0.5, -8)
        for _, stroke in ipairs(AllUIStrokes) do
            if stroke and stroke.Parent then stroke.Color = Color3.fromRGB(0, 160, 255) end
        end
    end
end)

miscScroll.CanvasSize = UDim2.new(0, 0, 0, 400)

-- TAB 7: CẤU HÌNH & PROFILES
local tabConfigBtn = Instance.new("TextButton")
tabConfigBtn.LayoutOrder = 7
tabConfigBtn.Size = UDim2.new(1, -6, 0, 30)
tabConfigBtn.Position = UDim2.new(0, 3, 0, 0)
tabConfigBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
tabConfigBtn.Text = "   📦 CẤU HÌNH"
tabConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabConfigBtn.TextSize = 11
tabConfigBtn.Font = Enum.Font.Gotham
tabConfigBtn.TextXAlignment = Enum.TextXAlignment.Left
tabConfigBtn.Parent = SidebarScroll

local tabConfigCorner = Instance.new("UICorner")
tabConfigCorner.CornerRadius = UDim.new(0, 5)
tabConfigCorner.Parent = tabConfigBtn

local tabConfigStroke = Instance.new("UIStroke")
tabConfigStroke.Color = Color3.fromRGB(0, 160, 255)
tabConfigStroke.Thickness = 1.5
tabConfigStroke.Parent = tabConfigBtn
table.insert(AllUIStrokes, tabConfigStroke)

local configIndicator = Instance.new("Frame")
configIndicator.Size = UDim2.new(0, 3, 0, 14)
configIndicator.Position = UDim2.new(0, 0, 0.5, -7)
configIndicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
configIndicator.BorderSizePixel = 0
configIndicator.Visible = false
configIndicator.Parent = tabConfigBtn

local configIndicatorCorner = Instance.new("UICorner")
configIndicatorCorner.CornerRadius = UDim.new(0, 2)
configIndicatorCorner.Parent = configIndicator

local configScroll = Instance.new("ScrollingFrame")
configScroll.Name = "Container_CONFIG"
configScroll.Size = UDim2.new(1, -12, 1, -38)
configScroll.Position = UDim2.new(0, 6, 0, 34)
configScroll.BackgroundTransparency = 1
configScroll.BorderSizePixel = 0
configScroll.ScrollBarThickness = 3
configScroll.Visible = false
configScroll.ClipsDescendants = true
configScroll.Parent = ContentContainer

local configLayout = Instance.new("UIListLayout")
configLayout.SortOrder = Enum.SortOrder.LayoutOrder
configLayout.Padding = UDim.new(0, 8)
configLayout.Parent = configScroll

tabConfigBtn.MouseButton1Click:Connect(function()
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

local configToggleBtn = Instance.new("TextButton")
configToggleBtn.LayoutOrder = 1
configToggleBtn.Size = UDim2.new(1, -16, 0, 42)
configToggleBtn.Position = UDim2.new(0, 8, 0, 0)
configToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
configToggleBtn.Text = "  ↓ Cấu Hình"
configToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
configToggleBtn.TextSize = 13
configToggleBtn.Font = Enum.Font.GothamBold
configToggleBtn.Parent = configScroll

local configToggleCorner = Instance.new("UICorner")
configToggleCorner.CornerRadius = UDim.new(0, 5)
configToggleCorner.Parent = configToggleBtn

local cfgToggleStroke = Instance.new("UIStroke")
cfgToggleStroke.Color = Color3.fromRGB(0, 160, 255)
cfgToggleStroke.Thickness = 1.5
cfgToggleStroke.Parent = configToggleBtn
table.insert(AllUIStrokes, cfgToggleStroke)

local configSubLabel = Instance.new("TextLabel")
configSubLabel.Size = UDim2.new(1, 0, 0, 16)
configSubLabel.Position = UDim2.new(0, 0, 1, -16)
configSubLabel.BackgroundTransparency = 1
configSubLabel.Text = "Ấn để ẩn/hiện chức năng"
configSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
configSubLabel.TextSize = 9
configSubLabel.Font = Enum.Font.Gotham
configSubLabel.Parent = configToggleBtn

local mainConfigContainer = Instance.new("Frame")
mainConfigContainer.LayoutOrder = 2
mainConfigContainer.Size = UDim2.new(1, -16, 0, 0)
mainConfigContainer.AutomaticSize = Enum.AutomaticSize.Y
mainConfigContainer.Position = UDim2.new(0, 8, 0, 0)
mainConfigContainer.BackgroundTransparency = 1
mainConfigContainer.Visible = true
mainConfigContainer.Parent = configScroll

local mainCfgLayout = Instance.new("UIListLayout")
mainCfgLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainCfgLayout.Padding = UDim.new(0, 5)
mainCfgLayout.Parent = mainConfigContainer

configToggleBtn.MouseButton1Click:Connect(function()
    mainConfigContainer.Visible = not mainConfigContainer.Visible
    configToggleBtn.Text = mainConfigContainer.Visible and "  ↓ Cấu Hình" or "  → Cấu Hình"
    configSubLabel.Visible = mainConfigContainer.Visible
end)

local startupFrame = Instance.new("Frame")
startupFrame.LayoutOrder = 1
startupFrame.Size = UDim2.new(1, 0, 0, 38)
startupFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
startupFrame.Parent = mainConfigContainer

local startupCorner = Instance.new("UICorner")
startupCorner.CornerRadius = UDim.new(0, 5)
startupCorner.Parent = startupFrame

local stFrameStroke = Instance.new("UIStroke")
stFrameStroke.Color = Color3.fromRGB(0, 160, 255)
stFrameStroke.Thickness = 1.5
stFrameStroke.Parent = startupFrame
table.insert(AllUIStrokes, stFrameStroke)

local startupLabel = Instance.new("TextLabel")
startupLabel.Size = UDim2.new(1, -12, 1, 0)
startupLabel.Position = UDim2.new(0, 8, 0, 0)
startupLabel.BackgroundTransparency = 1
startupLabel.Text = "Startup Cấu Hình: " .. startupConfigName
startupLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
startupLabel.TextSize = 11
startupLabel.Font = Enum.Font.Gotham
startupLabel.TextXAlignment = Enum.TextXAlignment.Left
startupLabel.Parent = startupFrame

-- Profiles Container
local profilesToggleBtn = Instance.new("TextButton")
profilesToggleBtn.LayoutOrder = 3
profilesToggleBtn.Size = UDim2.new(1, -16, 0, 42)
profilesToggleBtn.Position = UDim2.new(0, 8, 0, 0)
profilesToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
profilesToggleBtn.Text = "  ↓ Profiles"
profilesToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
profilesToggleBtn.TextSize = 13
profilesToggleBtn.Font = Enum.Font.GothamBold
profilesToggleBtn.Parent = configScroll

local profilesToggleCorner = Instance.new("UICorner")
profilesToggleCorner.CornerRadius = UDim.new(0, 5)
profilesToggleCorner.Parent = profilesToggleBtn

local pfToggleStroke = Instance.new("UIStroke")
pfToggleStroke.Color = Color3.fromRGB(0, 160, 255)
pfToggleStroke.Thickness = 1.5
pfToggleStroke.Parent = profilesToggleBtn
table.insert(AllUIStrokes, pfToggleStroke)

local profilesSubLabel = Instance.new("TextLabel")
profilesSubLabel.Size = UDim2.new(1, 0, 0, 16)
profilesSubLabel.Position = UDim2.new(0, 0, 1, -16)
profilesSubLabel.BackgroundTransparency = 1
profilesSubLabel.Text = "Quản lý các cấu hình"
profilesSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
profilesSubLabel.TextSize = 9
profilesSubLabel.Font = Enum.Font.Gotham
profilesSubLabel.Parent = profilesToggleBtn

local profilesContainer = Instance.new("Frame")
profilesContainer.LayoutOrder = 4
profilesContainer.Size = UDim2.new(1, -16, 0, 0)
profilesContainer.AutomaticSize = Enum.AutomaticSize.Y
profilesContainer.Position = UDim2.new(0, 8, 0, 0)
profilesContainer.BackgroundTransparency = 1
profilesContainer.Visible = true
profilesContainer.Parent = configScroll

local profilesSubLayout = Instance.new("UIListLayout")
profilesSubLayout.SortOrder = Enum.SortOrder.LayoutOrder
profilesSubLayout.Padding = UDim.new(0, 5)
profilesSubLayout.Parent = profilesContainer

profilesToggleBtn.MouseButton1Click:Connect(function()
    profilesContainer.Visible = not profilesContainer.Visible
    profilesToggleBtn.Text = profilesContainer.Visible and "  ↓ Profiles" or "  → Profiles"
    profilesSubLabel.Visible = profilesContainer.Visible
end)

local newConfigFrame = Instance.new("Frame")
newConfigFrame.LayoutOrder = 1
newConfigFrame.Size = UDim2.new(1, 0, 0, 38)
newConfigFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
newConfigFrame.Parent = profilesContainer

local ncCorner = Instance.new("UICorner")
ncCorner.CornerRadius = UDim.new(0, 5)
ncCorner.Parent = newConfigFrame

local ncFrameStroke = Instance.new("UIStroke")
ncFrameStroke.Color = Color3.fromRGB(0, 160, 255)
ncFrameStroke.Thickness = 1.5
ncFrameStroke.Parent = newConfigFrame
table.insert(AllUIStrokes, ncFrameStroke)

local ncLabel = Instance.new("TextLabel")
ncLabel.Size = UDim2.new(0.5, 0, 1, 0)
ncLabel.Position = UDim2.new(0, 8, 0, 0)
ncLabel.BackgroundTransparency = 1
ncLabel.Text = "New Cấu Hình Name"
ncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ncLabel.TextSize = 11
ncLabel.Font = Enum.Font.Gotham
ncLabel.TextXAlignment = Enum.TextXAlignment.Left
ncLabel.Parent = newConfigFrame

local configNameBox = Instance.new("TextBox")
configNameBox.Size = UDim2.new(0.45, 0, 0, 24)
configNameBox.Position = UDim2.new(0.53, 0, 0.5, -12)
configNameBox.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
configNameBox.PlaceholderText = "New config name..."
configNameBox.Text = ""
configNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
configNameBox.TextSize = 10
configNameBox.Font = Enum.Font.Gotham
configNameBox.Parent = newConfigFrame

local cnbCorner = Instance.new("UICorner")
cnbCorner.CornerRadius = UDim.new(0, 4)
cnbCorner.Parent = configNameBox

local cnbStroke = Instance.new("UIStroke")
cnbStroke.Color = Color3.fromRGB(0, 160, 255)
cnbStroke.Thickness = 1.5
cnbStroke.Parent = configNameBox
table.insert(AllUIStrokes, cnbStroke)

configScroll.CanvasSize = UDim2.new(0, 0, 0, 500)

RunService.RenderStepped:Connect(function()
    if isBorderApplied then
        if selectedBorderObj.Color == "Rainbow" then
            local rainbowBorder = Color3.fromHSV((tick() % 4) / 4, 1, 1)
            for _, stroke in ipairs(AllUIStrokes) do
                if stroke and stroke.Parent then stroke.Color = rainbowBorder end
            end
        elseif typeof(selectedBorderObj.Color) == "Color3" then
            for _, stroke in ipairs(AllUIStrokes) do
                if stroke and stroke.Parent then stroke.Color = selectedBorderObj.Color end
            end
        end
    end
end)

local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "VzNamOpenBtn"
OpenButton.Size = UDim2.new(0, 42, 0, 42)
OpenButton.Position = UDim2.new(0, 15, 0.2, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
OpenButton.BorderSizePixel = 0
OpenButton.Image = avatarUrl
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Parent = ScreenGui

local OpenButtonCorner = Instance.new("UICorner")
OpenButtonCorner.CornerRadius = UDim.new(1, 0)
OpenButtonCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 3.5
OpenStroke.Parent = OpenButton

RunService.RenderStepped:Connect(function()
    OpenStroke.Color = Color3.fromHSV((tick() % 4) / 4, 1, 1)
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
