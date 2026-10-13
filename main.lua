local CoreGui, Players, UserInputService, SoundService, HttpService = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("UserInputService"), game:GetService("SoundService"), game:GetService("HttpService")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end

local LastSelectedScriptStroke = nil
local RegisteredScripts = {}
local AllUIStrokes = {}

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

local MainCorner = Instance.new("UICorner", MainFrame) MainCorner.CornerRadius = UDim.new(0, 8)
local OuterStroke = Instance.new("UIStroke", MainFrame) OuterStroke.Color, OuterStroke.Thickness, OuterStroke.Transparency = Color3.fromRGB(0, 0, 0), 1, 0.1
table.insert(AllUIStrokes, OuterStroke)

local TopBar = Instance.new("Frame", MainFrame) TopBar.Size, TopBar.BackgroundTransparency = UDim2.new(1, 0, 0, 28), 1

local Logo = Instance.new("ImageLabel", TopBar) Logo.Size, Logo.Position, Logo.BackgroundTransparency, Logo.Image = UDim2.new(0, 18, 0, 18), UDim2.new(0, 10, 0.5, -9), 1, avatarUrl
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency, Title.Text, Title.TextColor3, Title.TextSize, Title.Font, Title.TextXAlignment = UDim2.new(1, -70, 1, 0), UDim2.new(0, 32, 0, 0), 1, "🌸 VzNam Hub v4 🌸", Color3.fromRGB(255, 105, 180), 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundTransparency, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize, CloseBtn.Font = UDim2.new(0, 26, 0, 26), UDim2.new(1, -28, 0.5, -13), 1, "✕", Color3.fromRGB(200, 200, 210), 11, Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end
    ScreenGui:Destroy()
end)

local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Name = "SidebarPanel"
SidebarPanel.Size, SidebarPanel.Position, SidebarPanel.BackgroundColor3, SidebarPanel.BackgroundTransparency, SidebarPanel.BorderSizePixel = UDim2.new(0, 145, 1, -34), UDim2.new(0, 6, 0, 28), Color3.fromRGB(15, 16, 22), 0, 0
Instance.new("UICorner", SidebarPanel).CornerRadius = UDim.new(0, 6)
local SidebarStroke = Instance.new("UIStroke", SidebarPanel) SidebarStroke.Color, SidebarStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, SidebarStroke)

local SearchBoxTab = Instance.new("TextBox", SidebarPanel)
SearchBoxTab.Size, SearchBoxTab.Position, SearchBoxTab.BackgroundColor3, SearchBoxTab.BackgroundTransparency, SearchBoxTab.Text, SearchBoxTab.PlaceholderText, SearchBoxTab.PlaceholderColor3, SearchBoxTab.TextColor3, SearchBoxTab.TextSize, SearchBoxTab.Font = UDim2.new(1, -10, 0, 24), UDim2.new(0, 5, 0, 5), Color3.fromRGB(22, 25, 34), 0, "", "🔍 Search section...", Color3.fromRGB(130, 135, 145), Color3.fromRGB(255, 255, 255), 10, Enum.Font.Gotham
Instance.new("UICorner", SearchBoxTab).CornerRadius = UDim.new(0, 4)
local sboxStroke = Instance.new("UIStroke", SearchBoxTab) sboxStroke.Color, sboxStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, sboxStroke)

local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
SidebarScroll.Size, SidebarScroll.Position, SidebarScroll.BackgroundTransparency, SidebarScroll.BorderSizePixel, SidebarScroll.ScrollBarThickness = UDim2.new(1, -8, 1, -34), UDim2.new(0, 4, 0, 32), 1, 0, 2
local SidebarLayout = Instance.new("UIListLayout", SidebarScroll) SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

SearchBoxTab:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBoxTab.Text)
    for _, item in ipairs(SidebarScroll:GetChildren()) do
        if item:IsA("TextButton") then
            if query == "" or string.find(string.lower(item.Text), query) then item.Visible = true else item.Visible = false end
        end
    end
end)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundColor3, ContentContainer.BackgroundTransparency, ContentContainer.BorderSizePixel = UDim2.new(1, -158, 1, -34), UDim2.new(0, 153, 0, 28), Color3.fromRGB(15, 16, 22), 0, 0
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 6)
local ContentStroke = Instance.new("UIStroke", ContentContainer) ContentStroke.Color, ContentStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, ContentStroke)

local ContentHeader = Instance.new("Frame", ContentContainer) ContentHeader.Size, ContentHeader.BackgroundTransparency = UDim2.new(1, 0, 0, 30), 1

local ActiveTabTitle = Instance.new("TextLabel", ContentHeader)
ActiveTabTitle.Size, ActiveTabTitle.Position, ActiveTabTitle.BackgroundTransparency, ActiveTabTitle.Text, ActiveTabTitle.TextColor3, ActiveTabTitle.TextSize, ActiveTabTitle.Font, ActiveTabTitle.TextXAlignment = UDim2.new(1, -40, 1, 0), UDim2.new(0, 12, 0, 0), 1, "", Color3.fromRGB(255, 255, 255), 12, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local SearchInputContent = Instance.new("TextBox", ContentHeader)
SearchInputContent.Size, SearchInputContent.Position, SearchInputContent.BackgroundColor3, SearchInputContent.TextColor3, SearchInputContent.PlaceholderText, SearchInputContent.PlaceholderColor3, SearchInputContent.TextSize, SearchInputContent.Font, SearchInputContent.Visible = UDim2.new(1, -45, 0, 22), UDim2.new(0, 10, 0.5, -11), Color3.fromRGB(22, 25, 34), Color3.fromRGB(255, 255, 255), "Search features...", Color3.fromRGB(140, 140, 150), 10, Enum.Font.Gotham, false
Instance.new("UICorner", SearchInputContent).CornerRadius = UDim.new(0, 4)
local scontentStroke = Instance.new("UIStroke", SearchInputContent) scontentStroke.Color, scontentStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, scontentStroke)

local SearchContentIcon = Instance.new("TextButton", ContentHeader)
SearchContentIcon.Size, SearchContentIcon.Position, SearchContentIcon.BackgroundTransparency, SearchContentIcon.Text, SearchContentIcon.TextSize, SearchContentIcon.TextColor3 = UDim2.new(0, 24, 0, 24), UDim2.new(1, -28, 0.5, -12), 1, "🔍", 12, Color3.fromRGB(200, 205, 215)

local searching = false
SearchContentIcon.MouseButton1Click:Connect(function()
    searching = not searching
    SearchInputContent.Visible = searching
    ActiveTabTitle.Visible = not searching
    if searching then SearchInputContent:CaptureFocus() else SearchInputContent.Text = "" end
end)

local HeaderDivider = Instance.new("Frame", ContentContainer) HeaderDivider.Size, HeaderDivider.Position, HeaderDivider.BackgroundColor3, HeaderDivider.BorderSizePixel = UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 30), Color3.fromRGB(40, 43, 52), 0
local Tabs = {}

-- TAB 0: TRANG CHỦ
local tabHomeBtn = Instance.new("TextButton", SidebarScroll)
tabHomeBtn.LayoutOrder = 0
tabHomeBtn.Size, tabHomeBtn.BackgroundColor3, tabHomeBtn.BackgroundTransparency, tabHomeBtn.Text, tabHomeBtn.TextColor3, tabHomeBtn.TextSize, tabHomeBtn.Font, tabHomeBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), 0, "   🏠 Trang Chủ", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", tabHomeBtn).CornerRadius = UDim.new(0, 5)
local tabHomeStroke = Instance.new("UIStroke", tabHomeBtn) tabHomeStroke.Color, tabHomeStroke.Thickness = Color3.fromRGB(255, 255, 255), 0.8
table.insert(AllUIStrokes, tabHomeStroke)

local homeIndicator = Instance.new("Frame", tabHomeBtn)
homeIndicator.Size, homeIndicator.Position, homeIndicator.BackgroundColor3, homeIndicator.BorderSizePixel, homeIndicator.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, 0, 0.5, -7), Color3.fromRGB(255, 105, 180), 0, false
Instance.new("UICorner", homeIndicator).CornerRadius = UDim.new(0, 2)

local homeScroll = Instance.new("ScrollingFrame", ContentContainer)
homeScroll.Name = "Container_HOME"
homeScroll.Size, homeScroll.Position, homeScroll.BackgroundTransparency, homeScroll.BorderSizePixel, homeScroll.ScrollBarThickness, homeScroll.Visible, homeScroll.ClipsDescendants = UDim2.new(1, -12, 1, -38), UDim2.new(0, 6, 0, 34), 1, 0, 3, false, true
local homeLayout = Instance.new("UIListLayout", homeScroll) homeLayout.SortOrder = Enum.SortOrder.LayoutOrder homeLayout.Padding = UDim.new(0, 6)

tabHomeBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    homeScroll.Visible = true homeIndicator.Visible = true ActiveTabTitle.Text = "🏠 Trang Chủ"
    SearchInputContent.Text = ""
end)

table.insert(Tabs, { Container = homeScroll, Indicator = homeIndicator })
homeScroll.Visible, homeIndicator.Visible = true, true
ActiveTabTitle.Text = "🏠 Trang Chủ"

local function CreateHomeCardWithIcon(parent, order, bgColor, titleText, mainText, copyText, borderColor, iconSymbol)
    local card = Instance.new("Frame", parent)
    card.LayoutOrder = order
    card.Size, card.BackgroundColor3, card.BorderSizePixel = UDim2.new(1, -4, 0, 42), bgColor, 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", card) stroke.Color, stroke.Thickness = borderColor, 1
    table.insert(AllUIStrokes, stroke)

    local iconCircle = Instance.new("Frame", card)
    iconCircle.Size, iconCircle.Position, iconCircle.BackgroundColor3, iconCircle.BorderSizePixel = UDim2.new(0, 30, 0, 30), UDim2.new(0, 6, 0.5, -15), borderColor, 0
    Instance.new("UICorner", iconCircle).CornerRadius = UDim.new(1, 0)
    
    local iconLbl = Instance.new("TextLabel", iconCircle)
    iconLbl.Size, iconLbl.BackgroundTransparency, iconLbl.Text, iconLbl.TextColor3, iconLbl.TextSize, iconLbl.Font = UDim2.new(1, 0, 1, 0), 1, iconSymbol, Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold

    local tLbl = Instance.new("TextLabel", card)
    tLbl.Size, tLbl.Position, tLbl.BackgroundTransparency, tLbl.Text, tLbl.TextColor3, tLbl.TextSize, tLbl.Font, tLbl.TextXAlignment = UDim2.new(1, -120, 0, 14), UDim2.new(0, 44, 0, 4), 1, titleText, Color3.fromRGB(255, 150, 100), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left

    local mLbl = Instance.new("TextLabel", card)
    mLbl.Size, mLbl.Position, mLbl.BackgroundTransparency, mLbl.Text, mLbl.TextColor3, mLbl.TextSize, mLbl.Font, mLbl.TextXAlignment = UDim2.new(1, -120, 0, 18), UDim2.new(0, 44, 0, 19), 1, mainText, Color3.fromRGB(220, 220, 230), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

    if copyText ~= "" then
        local copyBtn = Instance.new("TextButton", card)
        copyBtn.Size, copyBtn.Position, copyBtn.BackgroundTransparency, copyBtn.Text, copyBtn.TextColor3, copyBtn.TextSize, copyBtn.Font = UDim2.new(0, 65, 0, 24), UDim2.new(1, -73, 0.5, -12), 1, "📋 COPY", Color3.fromRGB(200, 200, 210), 10, Enum.Font.GothamBold
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 4)
        local cbtnStroke = Instance.new("UIStroke", copyBtn) cbtnStroke.Color, cbtnStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
        table.insert(AllUIStrokes, cbtnStroke)
        
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

CreateHomeCardWithIcon(homeScroll, 1, Color3.fromRGB(45, 25, 30), "ĐƯỢC TẠO BỞI", "VzNam ROBLOX", "", Color3.fromRGB(180, 50, 50), "👤")
CreateHomeCardWithIcon(homeScroll, 2, Color3.fromRGB(30, 35, 55), "DISCORD SERVER", "https://discord.gg/6TG7krbsU", "https://discord.gg/6TG7krbsU", Color3.fromRGB(60, 100, 200), "💬")
CreateHomeCardWithIcon(homeScroll, 3, Color3.fromRGB(35, 35, 45), "TIKTOK CHANNEL", "https://www.tiktok.com/@uttop1gl.ovo?_r=1&_t=ZS-9AWatTQR08y", "https://www.tiktok.com/@uttop1gl.ovo?_r=1&_t=ZS-9AWatTQR08y", Color3.fromRGB(100, 100, 120), "🎵")
homeScroll.CanvasSize = UDim2.new(0, 0, 0, 160)

local function CreateCategoryTab(tabName)
    local tabBtn = Instance.new("TextButton", SidebarScroll)
    tabBtn.Size, tabBtn.BackgroundColor3, tabBtn.BackgroundTransparency, tabBtn.Text, tabBtn.TextColor3, tabBtn.TextSize, tabBtn.Font, tabBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), 0, "   " .. tabName, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
    local tabStroke = Instance.new("UIStroke", tabBtn) tabStroke.Color, tabStroke.Thickness = Color3.fromRGB(255, 255, 255), 0.8
    table.insert(AllUIStrokes, tabStroke)

    local indicator = Instance.new("Frame", tabBtn)
    indicator.Size, indicator.Position, indicator.BackgroundColor3, indicator.BorderSizePixel, indicator.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, 0, 0.5, -7), Color3.fromRGB(255, 105, 180), 0, false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local containerFrame = Instance.new("Frame", ContentContainer)
    containerFrame.Name = "Container_" .. tabName
    containerFrame.Size, containerFrame.Position, containerFrame.BackgroundTransparency, containerFrame.Visible = UDim2.new(1, -12, 1, -38), UDim2.new(0, 6, 0, 34), 1, false

    local subBar = Instance.new("Frame", containerFrame) subBar.Size, subBar.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1
    local subLayout = Instance.new("UIListLayout", subBar) subLayout.FillDirection, subLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)

    local noKeyBtn = Instance.new("TextButton", subBar)
    noKeyBtn.Size, noKeyBtn.BackgroundColor3, noKeyBtn.Text, noKeyBtn.TextColor3, noKeyBtn.TextSize, noKeyBtn.Font = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(22, 25, 34), "no key", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold
    Instance.new("UICorner", noKeyBtn).CornerRadius = UDim.new(0, 5)
    local nkStroke = Instance.new("UIStroke", noKeyBtn) nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
    table.insert(AllUIStrokes, nkStroke)

    local hasKeyBtn = Instance.new("TextButton", subBar)
    hasKeyBtn.Size, hasKeyBtn.BackgroundColor3, hasKeyBtn.Text, hasKeyBtn.TextColor3, hasKeyBtn.TextSize, hasKeyBtn.Font = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(22, 25, 34), "có key", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold
    Instance.new("UICorner", hasKeyBtn).CornerRadius = UDim.new(0, 5)
    local hkStroke = Instance.new("UIStroke", hasKeyBtn) hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
    table.insert(AllUIStrokes, hkStroke)

    local scrollNoKey = Instance.new("ScrollingFrame", containerFrame) scrollNoKey.Position, scrollNoKey.Size, scrollNoKey.BackgroundTransparency, scrollNoKey.BorderSizePixel, scrollNoKey.ScrollBarThickness, scrollNoKey.Visible, scrollNoKey.ClipsDescendants = UDim2.new(0, 0, 0, 32), UDim2.new(1, 0, 1, -32), 1, 0, 3, true, true
    local l1 = Instance.new("UIListLayout", scrollNoKey) l1.Padding = UDim.new(0, 5)

    local scrollHasKey = Instance.new("ScrollingFrame", containerFrame) scrollHasKey.Position, scrollHasKey.Size, scrollHasKey.BackgroundTransparency, scrollHasKey.BorderSizePixel, scrollHasKey.ScrollBarThickness, scrollHasKey.Visible, scrollHasKey.ClipsDescendants = UDim2.new(0, 0, 0, 32), UDim2.new(1, 0, 1, -32), 1, 0, 3, false, true
    local l2 = Instance.new("UIListLayout", scrollHasKey) l2.Padding = UDim.new(0, 5)

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
        hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
    end)
    hasKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible, scrollHasKey.Visible = false, true
        hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
        nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
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
        local Btn = Instance.new("TextButton", parent)
        Btn.Size, Btn.BackgroundColor3, Btn.Text, Btn.TextColor3, Btn.TextSize, Btn.Font, Btn.TextXAlignment = UDim2.new(1, -4, 0, 30), Color3.fromRGB(22, 25, 34), "  ▶ " .. name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        local btnStroke = Instance.new("UIStroke", Btn) btnStroke.Color, btnStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
        table.insert(AllUIStrokes, btnStroke)
        
        Btn.MouseButton1Click:Connect(function()
            if LastSelectedScriptStroke then LastSelectedScriptStroke.Color, LastSelectedScriptStroke.Thickness = Color3.fromRGB(40, 43, 52), 1 end
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

-- TẠO CÁC TAB CHỨC NĂNG
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

local tab4 = CreateCategoryTab("Tab 4")
local tab5 = CreateCategoryTab("Tab 5")

-- TAB 6: MISC
local tabMiscBtn = Instance.new("TextButton", SidebarScroll)
tabMiscBtn.Size, tabMiscBtn.BackgroundColor3, tabMiscBtn.BackgroundTransparency, tabMiscBtn.Text, tabMiscBtn.TextColor3, tabMiscBtn.TextSize, tabMiscBtn.Font, tabMiscBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), 0, "   ⚙️ MISC", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", tabMiscBtn).CornerRadius = UDim.new(0, 5)
local tabMiscStroke = Instance.new("UIStroke", tabMiscBtn) tabMiscStroke.Color, tabMiscStroke.Thickness = Color3.fromRGB(255, 255, 255), 0.8
table.insert(AllUIStrokes, tabMiscStroke)

local miscIndicator = Instance.new("Frame", tabMiscBtn)
miscIndicator.Size, miscIndicator.Position, miscIndicator.BackgroundColor3, miscIndicator.BorderSizePixel, miscIndicator.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, 0, 0.5, -7), Color3.fromRGB(255, 105, 180), 0, false
Instance.new("UICorner", miscIndicator).CornerRadius = UDim.new(0, 2)

local miscScroll = Instance.new("ScrollingFrame", ContentContainer)
miscScroll.Name = "Container_MISC"
miscScroll.Size, miscScroll.Position, miscScroll.BackgroundTransparency, miscScroll.BorderSizePixel, miscScroll.ScrollBarThickness, miscScroll.Visible, miscScroll.ClipsDescendants = UDim2.new(1, -12, 1, -38), UDim2.new(0, 6, 0, 34), 1, 0, 3, false, true
local miscLayout = Instance.new("UIListLayout", miscScroll) miscLayout.SortOrder = Enum.SortOrder.LayoutOrder miscLayout.Padding = UDim.new(0, 8)

tabMiscBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    miscScroll.Visible = true miscIndicator.Visible = true ActiveTabTitle.Text = "⚙️ MISC"
end)
table.insert(Tabs, {Container = miscScroll, Indicator = miscIndicator})

-- Auto Load Script
local autoLoadToggleBtn = Instance.new("TextButton", miscScroll)
autoLoadToggleBtn.LayoutOrder = 1
autoLoadToggleBtn.Size, autoLoadToggleBtn.BackgroundColor3, autoLoadToggleBtn.Text, autoLoadToggleBtn.TextColor3, autoLoadToggleBtn.TextSize, autoLoadToggleBtn.Font, autoLoadToggleBtn.TextXAlignment = UDim2.new(1, -4, 0, 42), Color3.fromRGB(20, 22, 30), "  ↓ auto load script", Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", autoLoadToggleBtn).CornerRadius = UDim.new(0, 5)
local altStroke = Instance.new("UIStroke", autoLoadToggleBtn) altStroke.Color, altStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, altStroke)

local alSubLabel = Instance.new("TextLabel", autoLoadToggleBtn)
alSubLabel.Size, alSubLabel.Position, alSubLabel.BackgroundTransparency, alSubLabel.Text, alSubLabel.TextColor3, alSubLabel.TextSize, alSubLabel.Font, alSubLabel.TextXAlignment = UDim2.new(1, 0, 0, 16), UDim2.new(0, 0, 1, -16), 1, "Quản lý auto load script", Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Center

local autoLoadContainer = Instance.new("Frame", miscScroll)
autoLoadContainer.LayoutOrder = 2
autoLoadContainer.Size, autoLoadContainer.AutomaticSize = UDim2.new(1, -4, 0, 0), Enum.AutomaticSize.Y
autoLoadContainer.BackgroundTransparency = 1
autoLoadContainer.Visible = true
local alLayout = Instance.new("UIListLayout", autoLoadContainer) alLayout.SortOrder = Enum.SortOrder.LayoutOrder alLayout.Padding = UDim.new(0, 5)

autoLoadToggleBtn.MouseButton1Click:Connect(function()
    autoLoadContainer.Visible = not autoLoadContainer.Visible
    autoLoadToggleBtn.Text = autoLoadContainer.Visible and "  ↓ auto load script" or "  → auto load script"
    alSubLabel.Visible = autoLoadContainer.Visible
end)

local selScript, isAuto = nil, false
local dropBtn = Instance.new("TextButton", autoLoadContainer)
dropBtn.LayoutOrder = 1 dropBtn.Size, dropBtn.BackgroundColor3, dropBtn.Text, dropBtn.TextColor3, dropBtn.TextSize, dropBtn.Font, dropBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), " 📜 Chọn Script Auto Load...", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)
local dropBtnStroke = Instance.new("UIStroke", dropBtn) dropBtnStroke.Color, dropBtnStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, dropBtnStroke)

local dropFrame = Instance.new("ScrollingFrame", autoLoadContainer)
dropFrame.LayoutOrder = 2 dropFrame.Size, dropFrame.BackgroundColor3, dropFrame.CanvasSize, dropFrame.ScrollBarThickness, dropFrame.Visible = UDim2.new(1, 0, 0, 110), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
local dropFrameStroke = Instance.new("UIStroke", dropFrame) dropFrameStroke.Color, dropFrameStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, dropFrameStroke)
local dropLayout = Instance.new("UIListLayout", dropFrame) dropLayout.Padding = UDim.new(0, 4)

dropBtn.MouseButton1Click:Connect(function() dropFrame.Visible = not dropFrame.Visible end)

local autoLoadScriptFrame = Instance.new("Frame", autoLoadContainer)
autoLoadScriptFrame.LayoutOrder = 3 autoLoadScriptFrame.Size, autoLoadScriptFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", autoLoadScriptFrame).CornerRadius = UDim.new(0, 5) 
local alsStroke = Instance.new("UIStroke", autoLoadScriptFrame) alsStroke.Color, alsStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, alsStroke)

local alsTitle = Instance.new("TextLabel", autoLoadScriptFrame)
alsTitle.Size, alsTitle.Position, alsTitle.BackgroundTransparency, alsTitle.Text, alsTitle.TextColor3, alsTitle.TextSize, alsTitle.Font, alsTitle.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Auto Load Script Chạy", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local toggleAutoBtn = Instance.new("TextButton", autoLoadScriptFrame)
toggleAutoBtn.Size, toggleAutoBtn.Position, toggleAutoBtn.BackgroundColor3, toggleAutoBtn.Text = UDim2.new(0, 38, 0, 20), UDim2.new(1, -46, 0.5, -10), Color3.fromRGB(60, 65, 75), ""
Instance.new("UICorner", toggleAutoBtn).CornerRadius = UDim.new(1, 0)
local autoDot = Instance.new("Frame", toggleAutoBtn)
autoDot.Size, autoDot.Position, autoDot.BackgroundColor3 = UDim2.new(0, 16, 0, 16), UDim2.new(0, 2, 0.5, -8), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", autoDot).CornerRadius = UDim.new(1, 0)

toggleAutoBtn.MouseButton1Click:Connect(function()
    if not selScript then return end
    isAuto = not isAuto
    if isAuto then
        toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) autoDot.Position = UDim2.new(1, -18, 0.5, -8)
        pcall(selScript.Callback)
    else
        toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75) autoDot.Position = UDim2.new(0, 2, 0.5, -8)
    end
end)

-- Âm nhạc
local musicToggleBtn = Instance.new("TextButton", miscScroll)
musicToggleBtn.LayoutOrder = 3
musicToggleBtn.Size, musicToggleBtn.BackgroundColor3, musicToggleBtn.Text, musicToggleBtn.TextColor3, musicToggleBtn.TextSize, musicToggleBtn.Font, musicToggleBtn.TextXAlignment = UDim2.new(1, -4, 0, 42), Color3.fromRGB(20, 22, 30), "  ↓ âm nhạc", Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", musicToggleBtn).CornerRadius = UDim.new(0, 5)
local mttStroke = Instance.new("UIStroke", musicToggleBtn) mttStroke.Color, mttStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, mttStroke)

local muSubLabel = Instance.new("TextLabel", musicToggleBtn)
muSubLabel.Size, muSubLabel.Position, muSubLabel.BackgroundTransparency, muSubLabel.Text, muSubLabel.TextColor3, muSubLabel.TextSize, muSubLabel.Font, muSubLabel.TextXAlignment = UDim2.new(1, 0, 0, 16), UDim2.new(0, 0, 1, -16), 1, "Cài đặt âm nhạc nền", Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Center

local musicContainer = Instance.new("Frame", miscScroll)
musicContainer.LayoutOrder = 4
musicContainer.Size, musicContainer.AutomaticSize = UDim2.new(1, -4, 0, 0), Enum.AutomaticSize.Y
musicContainer.BackgroundTransparency = 1
musicContainer.Visible = true
local muLayout = Instance.new("UIListLayout", musicContainer) muLayout.SortOrder = Enum.SortOrder.LayoutOrder muLayout.Padding = UDim.new(0, 5)

musicToggleBtn.MouseButton1Click:Connect(function()
    musicContainer.Visible = not musicContainer.Visible
    musicToggleBtn.Text = musicContainer.Visible and "  ↓ âm nhạc" or "  → âm nhạc"
    muSubLabel.Visible = musicContainer.Visible
end)

local HubSound = SoundService:FindFirstChild("VzNamHubSound") or Instance.new("Sound", SoundService)
HubSound.Name, HubSound.Looped, HubSound.Volume = "VzNamHubSound", true, 0.5
local currentSoundId = "1837879082"

local customIdBox = Instance.new("TextBox", musicContainer)
customIdBox.LayoutOrder = 1 customIdBox.Size, customIdBox.BackgroundColor3, customIdBox.PlaceholderText, customIdBox.Text, customIdBox.TextColor3, customIdBox.TextSize, customIdBox.Font = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), "🎶 Nhập Sound ID tùy chỉnh...", "", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham
Instance.new("UICorner", customIdBox).CornerRadius = UDim.new(0, 5)
local cidStroke = Instance.new("UIStroke", customIdBox) cidStroke.Color, cidStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, cidStroke)

local musicDropBtn = Instance.new("TextButton", musicContainer)
musicDropBtn.LayoutOrder = 2 musicDropBtn.Size, musicDropBtn.BackgroundColor3, musicDropBtn.Text, musicDropBtn.TextColor3, musicDropBtn.TextSize, musicDropBtn.Font, musicDropBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), " 🎵 Chọn Nhạc Nền...", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", musicDropBtn).CornerRadius = UDim.new(0, 5)
local mdbStroke = Instance.new("UIStroke", musicDropBtn) mdbStroke.Color, mdbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, mdbStroke)

local musicDropFrame = Instance.new("ScrollingFrame", musicContainer)
musicDropFrame.LayoutOrder = 3 musicDropFrame.Size, musicDropFrame.BackgroundColor3, musicDropFrame.CanvasSize, musicDropFrame.ScrollBarThickness, musicDropFrame.Visible = UDim2.new(1, 0, 0, 120), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false
Instance.new("UICorner", musicDropFrame).CornerRadius = UDim.new(0, 5)
local mdfStroke = Instance.new("UIStroke", musicDropFrame) mdfStroke.Color, mdfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, mdfStroke)
local musicListLayout = Instance.new("UIListLayout", musicDropFrame) musicListLayout.Padding = UDim.new(0, 4)

local presetMusics = {
    {Name = "🎵 Chill Lofi Music", Id = "1837879082"},
    {Name = "🎶 Phonk Beat", Id = "1843404008"},
    {Name = "🎵 Anime Relaxing", Id = "9043887091"},
    {Name = "🎶 EDM Hype", Id = "1837871000"},
    {Name = "🎶 Như Một Người Dưng", Id = "91897652967267"}
}
for i, m in ipairs(presetMusics) do
    local mBtn = Instance.new("TextButton", musicDropFrame)
    mBtn.LayoutOrder = i mBtn.Size, mBtn.BackgroundColor3, mBtn.Text, mBtn.TextColor3, mBtn.TextSize, mBtn.Font, mBtn.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), " " .. m.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 4)
    local mbs = Instance.new("UIStroke", mBtn) mbs.Color, mbs.Thickness = Color3.fromRGB(40, 43, 52), 1
    table.insert(AllUIStrokes, mbs)
    mBtn.MouseButton1Click:Connect(function()
        currentSoundId = m.Id musicDropBtn.Text = " 🎵 " .. m.Name musicDropFrame.Visible = false
        if HubSound.IsPlaying then HubSound.SoundId = "rbxassetid://" .. currentSoundId HubSound:Play() end
    end)
end
musicDropFrame.CanvasSize = UDim2.new(0, 0, 0, #presetMusics * 30)
musicDropBtn.MouseButton1Click:Connect(function() musicDropFrame.Visible = not musicDropFrame.Visible end)

local volumeFrame = Instance.new("Frame", musicContainer)
volumeFrame.LayoutOrder = 4 volumeFrame.Size, volumeFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", volumeFrame).CornerRadius = UDim.new(0, 5)
local vfStroke = Instance.new("UIStroke", volumeFrame) vfStroke.Color, vfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, vfStroke)

local volumeLabel = Instance.new("TextLabel", volumeFrame)
volumeLabel.Size, volumeLabel.Position, volumeLabel.BackgroundTransparency, volumeLabel.Text, volumeLabel.TextColor3, volumeLabel.TextSize, volumeLabel.Font, volumeLabel.TextXAlignment = UDim2.new(1, -12, 1, 0), UDim2.new(0, 8, 0, 0), 1, "🔊 Âm lượng: 50%", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local volumeBarBg = Instance.new("Frame", volumeFrame)
volumeBarBg.Size, volumeBarBg.Position, volumeBarBg.BackgroundColor3 = UDim2.new(0, 110, 0, 8), UDim2.new(1, -118, 0.5, -4), Color3.fromRGB(35, 40, 50)
Instance.new("UICorner", volumeBarBg).CornerRadius = UDim.new(1, 0)
local vbbStroke = Instance.new("UIStroke", volumeBarBg) vbbStroke.Color, vbbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, vbbStroke)

local volumeBarFill = Instance.new("Frame", volumeBarBg)
volumeBarFill.Size, volumeBarFill.BackgroundColor3 = UDim2.new(0.5, 0, 1, 0), Color3.fromRGB(0, 180, 255)
Instance.new("UICorner", volumeBarFill).CornerRadius = UDim.new(1, 0)
local volumeBtn = Instance.new("TextButton", volumeBarBg)
volumeBtn.Size, volumeBtn.BackgroundTransparency, volumeBtn.Text = UDim2.new(1, 10, 1, 10), 1, ""

local adjustingVol = false
volumeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then adjustingVol = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then adjustingVol = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if adjustingVol and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local absPos = volumeBarBg.AbsolutePosition.X local absSize = volumeBarBg.AbsoluteSize.X local mouseX = input.Position.X
        local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
        volumeBarFill.Size = UDim2.new(percent, 0, 1, 0) HubSound.Volume = percent
        volumeLabel.Text = "🔊 Âm lượng: " .. math.floor(percent * 100) .. "%"
    end
end)

local musicToggleFrame = Instance.new("Frame", musicContainer)
musicToggleFrame.LayoutOrder = 5 musicToggleFrame.Size, musicToggleFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", musicToggleFrame).CornerRadius = UDim.new(0, 5) 
local mtfStroke = Instance.new("UIStroke", musicToggleFrame) mtfStroke.Color, mtfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, mtfStroke)

local musicTitle = Instance.new("TextLabel", musicToggleFrame)
musicTitle.Size, musicTitle.Position, musicTitle.BackgroundTransparency, musicTitle.Text, musicTitle.TextColor3, musicTitle.TextSize, musicTitle.Font, musicTitle.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Phát Nhạc Background", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local toggleMusicBtn = Instance.new("TextButton", musicToggleFrame)
toggleMusicBtn.Size, toggleMusicBtn.Position, toggleMusicBtn.BackgroundColor3, toggleMusicBtn.Text = UDim2.new(0, 38, 0, 20), UDim2.new(1, -46, 0.5, -10), Color3.fromRGB(60, 65, 75), ""
Instance.new("UICorner", toggleMusicBtn).CornerRadius = UDim.new(1, 0)
local musicDot = Instance.new("Frame", toggleMusicBtn)
musicDot.Size, musicDot.Position, musicDot.BackgroundColor3 = UDim2.new(0, 16, 0, 16), UDim2.new(0, 2, 0.5, -8), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", musicDot).CornerRadius = UDim.new(1, 0)

local isMusicPlaying = false
toggleMusicBtn.MouseButton1Click:Connect(function()
    isMusicPlaying = not isMusicPlaying
    if isMusicPlaying then
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) musicDot.Position = UDim2.new(1, -18, 0.5, -8)
        local customId = tonumber(customIdBox.Text)
        HubSound.SoundId = "rbxassetid://" .. (customId and tostring(customId) or currentSoundId)
        HubSound:Play()
    else
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75) musicDot.Position = UDim2.new(0, 2, 0.5, -8)
        HubSound:Stop()
    end
end)

-- Màu Menu & Viền Tab
local colorToggleBtn = Instance.new("TextButton", miscScroll)
colorToggleBtn.LayoutOrder = 5
colorToggleBtn.Size, colorToggleBtn.BackgroundColor3, colorToggleBtn.Text, colorToggleBtn.TextColor3, colorToggleBtn.TextSize, colorToggleBtn.Font, colorToggleBtn.TextXAlignment = UDim2.new(1, -4, 0, 42), Color3.fromRGB(20, 22, 30), "  ↓ màu menu", Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", colorToggleBtn).CornerRadius = UDim.new(0, 5)
local cttStroke = Instance.new("UIStroke", colorToggleBtn) cttStroke.Color, cttStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, cttStroke)

local coSubLabel = Instance.new("TextLabel", colorToggleBtn)
coSubLabel.Size, coSubLabel.Position, coSubLabel.BackgroundTransparency, coSubLabel.Text, coSubLabel.TextColor3, coSubLabel.TextSize, coSubLabel.Font, coSubLabel.TextXAlignment = UDim2.new(1, 0, 0, 16), UDim2.new(0, 0, 1, -16), 1, "Tùy chỉnh màu sắc giao diện và viền", Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Center

local colorContainer = Instance.new("Frame", miscScroll)
colorContainer.LayoutOrder = 6
colorContainer.Size, colorContainer.AutomaticSize = UDim2.new(1, -4, 0, 0), Enum.AutomaticSize.Y
colorContainer.BackgroundTransparency = 1
colorContainer.Visible = true
local coLayout = Instance.new("UIListLayout", colorContainer) coLayout.SortOrder = Enum.SortOrder.LayoutOrder coLayout.Padding = UDim.new(0, 5)

colorToggleBtn.MouseButton1Click:Connect(function()
    colorContainer.Visible = not colorContainer.Visible
    colorToggleBtn.Text = colorContainer.Visible and "  ↓ màu menu" or "  → màu menu"
    coSubLabel.Visible = colorContainer.Visible
end)

local colorList = {
    {Name = "🖤 Xám Tối", Color = Color3.fromRGB(15, 16, 22)},
    {Name = "🌸 Hồng Kẹo", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "🔴 Đỏ Đậm", Color = Color3.fromRGB(220, 20, 60)},
    {Name = "🔵 Xanh Dương", Color = Color3.fromRGB(0, 191, 255)}
}
local selectedColorObj = colorList[1]
local colorDropBtn = Instance.new("TextButton", colorContainer)
colorDropBtn.LayoutOrder = 1 colorDropBtn.Size, colorDropBtn.BackgroundColor3, colorDropBtn.Text, colorDropBtn.TextColor3, colorDropBtn.TextSize, colorDropBtn.Font, colorDropBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), " 🎨 Đã chọn: 🖤 Xám Tối", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", colorDropBtn).CornerRadius = UDim.new(0, 5)
local cdbStroke = Instance.new("UIStroke", colorDropBtn) cdbStroke.Color, cdbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, cdbStroke)

local colorDropFrame = Instance.new("ScrollingFrame", colorContainer)
colorDropFrame.LayoutOrder = 2 colorDropFrame.Size, colorDropFrame.BackgroundColor3, colorDropFrame.CanvasSize, colorDropFrame.ScrollBarThickness, colorDropFrame.Visible = UDim2.new(1, 0, 0, 110), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false
Instance.new("UICorner", colorDropFrame).CornerRadius = UDim.new(0, 5)
local cdfStroke = Instance.new("UIStroke", colorDropFrame) cdfStroke.Color, cdfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, cdfStroke)
local colorLayout = Instance.new("UIListLayout", colorDropFrame) colorLayout.Padding = UDim.new(0, 4)

for i, cItem in ipairs(colorList) do
    local cBtn = Instance.new("TextButton", colorDropFrame)
    cBtn.LayoutOrder = i cBtn.Size, cBtn.BackgroundColor3, cBtn.Text, cBtn.TextColor3, cBtn.TextSize, cBtn.Font, cBtn.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), " " .. cItem.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    local cbs = Instance.new("UIStroke", cBtn) cbs.Color, cbs.Thickness = Color3.fromRGB(40, 43, 52), 1
    table.insert(AllUIStrokes, cbs)
    cBtn.MouseButton1Click:Connect(function()
        selectedColorObj = cItem colorDropBtn.Text = " 🎨 Đã chọn: " .. cItem.Name colorDropFrame.Visible = false
    end)
end
colorDropFrame.CanvasSize = UDim2.new(0, 0, 0, #colorList * 30)
colorDropBtn.MouseButton1Click:Connect(function() colorDropFrame.Visible = not colorDropFrame.Visible end)

local colorToggleFrame = Instance.new("Frame", colorContainer)
colorToggleFrame.LayoutOrder = 3 colorToggleFrame.Size, colorToggleFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", colorToggleFrame).CornerRadius = UDim.new(0, 5) 
local ctfStroke = Instance.new("UIStroke", colorToggleFrame) ctfStroke.Color, ctfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, ctfStroke)

local colorTitle = Instance.new("TextLabel", colorToggleFrame)
colorTitle.Size, colorTitle.Position, colorTitle.BackgroundTransparency, colorTitle.Text, colorTitle.TextColor3, colorTitle.TextSize, colorTitle.Font, colorTitle.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Màu Menu Tùy Chỉnh", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left

local toggleColorBtn = Instance.new("TextButton", colorToggleFrame)
toggleColorBtn.Size, toggleColorBtn.Position, toggleColorBtn.BackgroundColor3, toggleColorBtn.Text = UDim2.new(0, 38, 0, 20), UDim2.new(1, -46, 0.5, -10), Color3.fromRGB(60, 65, 75), ""
Instance.new("UICorner", toggleColorBtn).CornerRadius = UDim.new(1, 0)
local colorDot = Instance.new("Frame", toggleColorBtn)
colorDot.Size, colorDot.Position, colorDot.BackgroundColor3 = UDim2.new(0, 16, 0, 16), UDim2.new(0, 2, 0.5, -8), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", colorDot).CornerRadius = UDim.new(1, 0)

local isColorApplied = false
toggleColorBtn.MouseButton1Click:Connect(function()
    isColorApplied = not isColorApplied
    if isColorApplied then
        toggleColorBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) colorDot.Position = UDim2.new(1, -18, 0.5, -8)
        SidebarPanel.BackgroundColor3 = selectedColorObj.Color 
        ContentContainer.BackgroundColor3 = selectedColorObj.Color
    else
        toggleColorBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75) colorDot.Position = UDim2.new(0, 2, 0.5, -8)
        SidebarPanel.BackgroundColor3 = Color3.fromRGB(15, 16, 22) 
        ContentContainer.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    end
end)

local borderList = {
    {Name = "🔵 Xanh Dương", Color = Color3.fromRGB(0, 160, 255)},
    {Name = "💖 Hồng Kẹo", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "🟢 Xanh Lá", Color = Color3.fromRGB(50, 205, 50)},
    {Name = "🟡 Vàng Nổi Bật", Color = Color3.fromRGB(255, 215, 0)}
}
local selectedBorderObj = borderList[1]

local borderDropBtn = Instance.new("TextButton", colorContainer)
borderDropBtn.LayoutOrder = 4 borderDropBtn.Size, borderDropBtn.BackgroundColor3, borderDropBtn.Text, borderDropBtn.TextColor3, borderDropBtn.TextSize, borderDropBtn.Font, borderDropBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), " 🖍️ Viền Tab: 🔵 Xanh Dương", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", borderDropBtn).CornerRadius = UDim.new(0, 5)
local bdbStroke = Instance.new("UIStroke", borderDropBtn) bdbStroke.Color, bdbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, bdbStroke)

local borderDropFrame = Instance.new("ScrollingFrame", colorContainer)
borderDropFrame.LayoutOrder = 5 borderDropFrame.Size, borderDropFrame.BackgroundColor3, borderDropFrame.CanvasSize, borderDropFrame.ScrollBarThickness, borderDropFrame.Visible = UDim2.new(1, 0, 0, 110), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false
Instance.new("UICorner", borderDropFrame).CornerRadius = UDim.new(0, 5)
local bdfStroke = Instance.new("UIStroke", borderDropFrame) bdfStroke.Color, bdfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, bdfStroke)
local borderLayout = Instance.new("UIListLayout", borderDropFrame) borderLayout.Padding = UDim.new(0, 4)

for i, bItem in ipairs(borderList) do
    local bBtn = Instance.new("TextButton", borderDropFrame)
    bBtn.LayoutOrder = i bBtn.Size, bBtn.BackgroundColor3, bBtn.Text, bBtn.TextColor3, bBtn.TextSize, bBtn.Font, bBtn.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), " " .. bItem.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", bBtn).CornerRadius = UDim.new(0, 4)
    local bbs = Instance.new("UIStroke", bBtn) bbs.Color, bbs.Thickness = Color3.fromRGB(40, 43, 52), 1
    table.insert(AllUIStrokes, bbs)
    bBtn.MouseButton1Click:Connect(function()
        selectedBorderObj = bItem 
        borderDropBtn.Text = " 🖍️ Viền Tab: " .. bItem.Name 
        borderDropFrame.Visible = false
        for _, stroke in ipairs(AllUIStrokes) do
            if stroke and stroke.Parent then stroke.Color = selectedBorderObj.Color end
        end
    end)
end
borderDropFrame.CanvasSize = UDim2.new(0, 0, 0, #borderList * 30)
borderDropBtn.MouseButton1Click:Connect(function() borderDropFrame.Visible = not borderDropFrame.Visible end)

miscScroll.CanvasSize = UDim2.new(0, 0, 0, 1400)

-- TAB 7: CẤU HÌNH & PROFILES
local tabConfigBtn = Instance.new("TextButton", SidebarScroll)
tabConfigBtn.Size, tabConfigBtn.BackgroundColor3, tabConfigBtn.BackgroundTransparency, tabConfigBtn.Text, tabConfigBtn.TextColor3, tabConfigBtn.TextSize, tabConfigBtn.Font, tabConfigBtn.TextXAlignment = UDim2.new(1, 0, 0, 32), Color3.fromRGB(22, 25, 34), 0, "   📦 CẤU HÌNH", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
Instance.new("UICorner", tabConfigBtn).CornerRadius = UDim.new(0, 5)
local tabConfigStroke = Instance.new("UIStroke", tabConfigBtn) tabConfigStroke.Color, tabConfigStroke.Thickness = Color3.fromRGB(255, 255, 255), 0.8
table.insert(AllUIStrokes, tabConfigStroke)

local configIndicator = Instance.new("Frame", tabConfigBtn)
configIndicator.Size, configIndicator.Position, configIndicator.BackgroundColor3, configIndicator.BorderSizePixel, configIndicator.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, 0, 0.5, -7), Color3.fromRGB(255, 105, 180), 0, false
Instance.new("UICorner", configIndicator).CornerRadius = UDim.new(0, 2)

local configScroll = Instance.new("ScrollingFrame", ContentContainer)
configScroll.Name = "Container_CONFIG"
configScroll.Size, configScroll.Position, configScroll.BackgroundTransparency, configScroll.BorderSizePixel, configScroll.ScrollBarThickness, configScroll.Visible, configScroll.ClipsDescendants = UDim2.new(1, -12, 1, -38), UDim2.new(0, 6, 0, 34), 1, 0, 3, false, true
local configLayout = Instance.new("UIListLayout", configScroll) configLayout.SortOrder = Enum.SortOrder.LayoutOrder configLayout.Padding = UDim.new(0, 8)

tabConfigBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
    configScroll.Visible = true configIndicator.Visible = true ActiveTabTitle.Text = "📦 CẤU HÌNH"
end)
table.insert(Tabs, {Container = configScroll, Indicator = configIndicator})

local configFolder = "VzNamHub_Configs"
if typeof(makefolder) == "function" then pcall(makefolder, configFolder) end

local currentConfigName = "Default"
local startupConfigName = "Default"

local configToggleBtn = Instance.new("TextButton", configScroll)
configToggleBtn.LayoutOrder = 1
configToggleBtn.Size, configToggleBtn.BackgroundColor3, configToggleBtn.Text, configToggleBtn.TextColor3, configToggleBtn.TextSize, configToggleBtn.Font, configToggleBtn.TextXAlignment = UDim2.new(1, -4, 0, 42), Color3.fromRGB(20, 22, 30), "  ↓ Cấu Hình", Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", configToggleBtn).CornerRadius = UDim.new(0, 5)
local ctt2Stroke = Instance.new("UIStroke", configToggleBtn) ctt2Stroke.Color, ctt2Stroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, ctt2Stroke)

local configSubLabel = Instance.new("TextLabel", configToggleBtn)
configSubLabel.Size, configSubLabel.Position, configSubLabel.BackgroundTransparency, configSubLabel.Text, configSubLabel.TextColor3, configSubLabel.TextSize, configSubLabel.Font, configSubLabel.TextXAlignment = UDim2.new(1, 0, 0, 16), UDim2.new(0, 0, 1, -16), 1, "Ấn để ẩn/hiện chức năng", Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Center

local mainConfigContainer = Instance.new("Frame", configScroll)
mainConfigContainer.LayoutOrder = 2
mainConfigContainer.Size, mainConfigContainer.AutomaticSize = UDim2.new(1, -4, 0, 0), Enum.AutomaticSize.Y
mainConfigContainer.BackgroundTransparency = 1
mainConfigContainer.Visible = true
local mainCfgLayout = Instance.new("UIListLayout", mainConfigContainer) mainCfgLayout.SortOrder = Enum.SortOrder.LayoutOrder mainCfgLayout.Padding = UDim.new(0, 5)

configToggleBtn.MouseButton1Click:Connect(function()
    mainConfigContainer.Visible = not mainConfigContainer.Visible
    configToggleBtn.Text = mainConfigContainer.Visible and "  ↓ Cấu Hình" or "  → Cấu Hình"
    configSubLabel.Visible = mainConfigContainer.Visible
end)

local startupFrame = Instance.new("Frame", mainConfigContainer)
startupFrame.LayoutOrder = 1 startupFrame.Size, startupFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", startupFrame).CornerRadius = UDim.new(0, 5) 
local stfStroke = Instance.new("UIStroke", startupFrame) stfStroke.Color, stfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, stfStroke)

local startupLabel = Instance.new("TextLabel", startupFrame)
startupLabel.Size, startupLabel.Position, startupLabel.BackgroundTransparency, startupLabel.Text, startupLabel.TextColor3, startupLabel.TextSize, startupLabel.Font, startupLabel.TextXAlignment = UDim2.new(1, -12, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Startup Cấu Hình: " .. startupConfigName, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left

local autoSaveFrame = Instance.new("Frame", mainConfigContainer)
autoSaveFrame.LayoutOrder = 2 autoSaveFrame.Size, autoSaveFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 44), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", autoSaveFrame).CornerRadius = UDim.new(0, 5) 
local asfStroke = Instance.new("UIStroke", autoSaveFrame) asfStroke.Color, asfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, asfStroke)

local asTitle = Instance.new("TextLabel", autoSaveFrame)
asTitle.Size, asTitle.Position, asTitle.BackgroundTransparency, asTitle.Text, asTitle.TextColor3, asTitle.TextSize, asTitle.Font, asTitle.TextXAlignment = UDim2.new(1, -50, 0, 20), UDim2.new(0, 8, 0, 3), 1, "Auto Lưu Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local asSub = Instance.new("TextLabel", autoSaveFrame)
asSub.Size, asSub.Position, asSub.BackgroundTransparency, asSub.Text, asSub.TextColor3, asSub.TextSize, asSub.Font, asSub.TextXAlignment = UDim2.new(1, -50, 0, 16), UDim2.new(0, 8, 0, 22), 1, "Auto save: " .. currentConfigName, Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local autoSaveToggle = Instance.new("TextButton", autoSaveFrame)
autoSaveToggle.Size, autoSaveToggle.Position, autoSaveToggle.BackgroundColor3, autoSaveToggle.Text = UDim2.new(0, 38, 0, 20), UDim2.new(1, -46, 0.5, -10), Color3.fromRGB(50, 200, 50), ""
Instance.new("UICorner", autoSaveToggle).CornerRadius = UDim.new(1, 0)
local asBox = Instance.new("Frame", autoSaveToggle)
asBox.Size, asBox.Position, asBox.BackgroundColor3 = UDim2.new(0, 16, 0, 16), UDim2.new(1, -18, 0.5, -8), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", asBox).CornerRadius = UDim.new(1, 0)
local isAutoSave = true
autoSaveToggle.MouseButton1Click:Connect(function()
    isAutoSave = not isAutoSave
    autoSaveToggle.BackgroundColor3 = isAutoSave and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 65, 75)
    asBox.Position = isAutoSave and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
end)

local autoLoadFrame = Instance.new("Frame", mainConfigContainer)
autoLoadFrame.LayoutOrder = 3 autoLoadFrame.Size, autoLoadFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 44), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", autoLoadFrame).CornerRadius = UDim.new(0, 5) 
local alfStroke = Instance.new("UIStroke", autoLoadFrame) alfStroke.Color, alfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, alfStroke)

local alTitle = Instance.new("TextLabel", autoLoadFrame)
alTitle.Size, alTitle.Position, alTitle.BackgroundTransparency, alTitle.Text, alTitle.TextColor3, alTitle.TextSize, alTitle.Font, alTitle.TextXAlignment = UDim2.new(1, -50, 0, 20), UDim2.new(0, 8, 0, 3), 1, "Auto Tải Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local alSub = Instance.new("TextLabel", autoLoadFrame)
alSub.Size, alSub.Position, alSub.BackgroundTransparency, alSub.Text, alSub.TextColor3, alSub.TextSize, alSub.Font, alSub.TextXAlignment = UDim2.new(1, -50, 0, 16), UDim2.new(0, 8, 0, 22), 1, "Auto load: " .. currentConfigName, Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local autoLoadToggle = Instance.new("TextButton", autoLoadFrame)
autoLoadToggle.Size, autoLoadToggle.Position, autoLoadToggle.BackgroundColor3, autoLoadToggle.Text = UDim2.new(0, 38, 0, 20), UDim2.new(1, -46, 0.5, -10), Color3.fromRGB(50, 200, 50), ""
Instance.new("UICorner", autoLoadToggle).CornerRadius = UDim.new(1, 0)
local alBox = Instance.new("Frame", autoLoadToggle)
alBox.Size, alBox.Position, alBox.BackgroundColor3 = UDim2.new(0, 16, 0, 16), UDim2.new(1, -18, 0.5, -8), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", alBox).CornerRadius = UDim.new(1, 0)
local isAutoLoad = true
autoLoadToggle.MouseButton1Click:Connect(function()
    isAutoLoad = not isAutoLoad
    autoLoadToggle.BackgroundColor3 = isAutoLoad and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 65, 75)
    alBox.Position = isAutoLoad and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
end)

local profilesToggleBtn = Instance.new("TextButton", configScroll)
profilesToggleBtn.LayoutOrder = 3
profilesToggleBtn.Size, profilesToggleBtn.BackgroundColor3, profilesToggleBtn.Text, profilesToggleBtn.TextColor3, profilesToggleBtn.TextSize, profilesToggleBtn.Font, profilesToggleBtn.TextXAlignment = UDim2.new(1, -4, 0, 42), Color3.fromRGB(20, 22, 30), "  ↓ Profiles", Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", profilesToggleBtn).CornerRadius = UDim.new(0, 5)
local pttStroke = Instance.new("UIStroke", profilesToggleBtn) pttStroke.Color, pttStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, pttStroke)

local profilesSubLabel = Instance.new("TextLabel", profilesToggleBtn)
profilesSubLabel.Size, profilesSubLabel.Position, profilesSubLabel.BackgroundTransparency, profilesSubLabel.Text, profilesSubLabel.TextColor3, profilesSubLabel.TextSize, profilesSubLabel.Font, profilesSubLabel.TextXAlignment = UDim2.new(1, 0, 0, 16), UDim2.new(0, 0, 1, -16), 1, "Quản lý các cấu hình", Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Center

local profilesContainer = Instance.new("Frame", configScroll)
profilesContainer.LayoutOrder = 4
profilesContainer.Size, profilesContainer.AutomaticSize = UDim2.new(1, -4, 0, 0), Enum.AutomaticSize.Y
profilesContainer.BackgroundTransparency = 1
profilesContainer.Visible = true
local profilesSubLayout = Instance.new("UIListLayout", profilesContainer) profilesSubLayout.SortOrder = Enum.SortOrder.LayoutOrder profilesSubLayout.Padding = UDim.new(0, 5)

profilesToggleBtn.MouseButton1Click:Connect(function()
    profilesContainer.Visible = not profilesContainer.Visible
    profilesToggleBtn.Text = profilesContainer.Visible and "  ↓ Profiles" or "  → Profiles"
    profilesSubLabel.Visible = profilesContainer.Visible
end)

local newConfigFrame = Instance.new("Frame", profilesContainer)
newConfigFrame.LayoutOrder = 1 newConfigFrame.Size, newConfigFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", newConfigFrame).CornerRadius = UDim.new(0, 5) 
local ncfStroke = Instance.new("UIStroke", newConfigFrame) ncfStroke.Color, ncfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, ncfStroke)

local ncLabel = Instance.new("TextLabel", newConfigFrame)
ncLabel.Size, ncLabel.Position, ncLabel.BackgroundTransparency, ncLabel.Text, ncLabel.TextColor3, ncLabel.TextSize, ncLabel.Font, ncLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "New Cấu Hình Name", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left

local configNameBox = Instance.new("TextBox", newConfigFrame)
configNameBox.Size, configNameBox.Position, configNameBox.BackgroundColor3, configNameBox.PlaceholderText, configNameBox.Text, configNameBox.TextColor3, configNameBox.TextSize, configNameBox.Font = UDim2.new(0.45, 0, 0, 24), UDim2.new(0.53, 0, 0.5, -12), Color3.fromRGB(15, 16, 22), "New config name...", "", Color3.fromRGB(255, 255, 255), 10, Enum.Font.Gotham
Instance.new("UICorner", configNameBox).CornerRadius = UDim.new(0, 4)
local cnbStroke = Instance.new("UIStroke", configNameBox) cnbStroke.Color, cnbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, cnbStroke)

local createFrame = Instance.new("Frame", profilesContainer)
createFrame.LayoutOrder = 2 createFrame.Size, createFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 42), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", createFrame).CornerRadius = UDim.new(0, 5) 
local crfStroke = Instance.new("UIStroke", createFrame) crfStroke.Color, crfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, crfStroke)

local crTitle = Instance.new("TextLabel", createFrame)
crTitle.Size, crTitle.Position, crTitle.BackgroundTransparency, crTitle.Text, crTitle.TextColor3, crTitle.TextSize, crTitle.Font, crTitle.TextXAlignment = UDim2.new(1, -110, 0, 20), UDim2.new(0, 8, 0, 3), 1, "Create New Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local crSub = Instance.new("TextLabel", createFrame)
crSub.Size, crSub.Position, crSub.BackgroundTransparency, crSub.Text, crSub.TextColor3, crSub.TextSize, crSub.Font, crSub.TextXAlignment = UDim2.new(1, -110, 0, 16), UDim2.new(0, 8, 0, 21), 1, "New config copies current settings", Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local createBtn = Instance.new("TextButton", createFrame)
createBtn.Size, createBtn.Position, createBtn.BackgroundColor3, createBtn.Text, createBtn.TextColor3, createBtn.TextSize, createBtn.Font = UDim2.new(0, 95, 0, 26), UDim2.new(1, -103, 0.5, -13), Color3.fromRGB(220, 50, 50), "Create New", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold
Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 4)
local cbStroke = Instance.new("UIStroke", createBtn) cbStroke.Color, cbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, cbStroke)

local deleteFrame = Instance.new("Frame", profilesContainer)
deleteFrame.LayoutOrder = 3 deleteFrame.Size, deleteFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", deleteFrame).CornerRadius = UDim.new(0, 5) 
local dlfStroke = Instance.new("UIStroke", deleteFrame) dlfStroke.Color, dlfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, dlfStroke)

local delLabel = Instance.new("TextLabel", deleteFrame)
delLabel.Size, delLabel.Position, delLabel.BackgroundTransparency, delLabel.Text, delLabel.TextColor3, delLabel.TextSize, delLabel.Font, delLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Delete Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left

local delBtn = Instance.new("TextButton", deleteFrame)
delBtn.Size, delBtn.Position, delBtn.BackgroundColor3, delBtn.Text, delBtn.TextColor3, delBtn.TextSize, delBtn.Font, delBtn.TextXAlignment = UDim2.new(0, 115, 0, 24), UDim2.new(1, -123, 0.5, -12), Color3.fromRGB(15, 16, 22), "Không có ∨", Color3.fromRGB(50, 200, 50), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
local dbStroke = Instance.new("UIStroke", delBtn) dbStroke.Color, dbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, dbStroke)

local delDropFrame = Instance.new("ScrollingFrame", profilesContainer)
delDropFrame.LayoutOrder = 4 delDropFrame.Size, delDropFrame.BackgroundColor3, delDropFrame.CanvasSize, delDropFrame.ScrollBarThickness, delDropFrame.Visible = UDim2.new(1, 0, 0, 90), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false
Instance.new("UICorner", delDropFrame).CornerRadius = UDim.new(0, 5)
local ddfStroke = Instance.new("UIStroke", delDropFrame) ddfStroke.Color, ddfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, ddfStroke)
local delDropLayout = Instance.new("UIListLayout", delDropFrame) delDropLayout.Padding = UDim.new(0, 4)

local startupProfileFrame = Instance.new("Frame", profilesContainer)
startupProfileFrame.LayoutOrder = 5 startupProfileFrame.Size, startupProfileFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", startupProfileFrame).CornerRadius = UDim.new(0, 5) 
local spfStroke = Instance.new("UIStroke", startupProfileFrame) spfStroke.Color, spfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, spfStroke)

local stProfileLabel = Instance.new("TextLabel", startupProfileFrame)
stProfileLabel.Size, stProfileLabel.Position, stProfileLabel.BackgroundTransparency, stProfileLabel.Text, stProfileLabel.TextColor3, stProfileLabel.TextSize, stProfileLabel.Font, stProfileLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Cấu Hình Khởi Động", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left

local stProfileBtn = Instance.new("TextButton", startupProfileFrame)
stProfileBtn.Size, stProfileBtn.Position, stProfileBtn.BackgroundColor3, stProfileBtn.Text, stProfileBtn.TextColor3, stProfileBtn.TextSize, stProfileBtn.Font, stProfileBtn.TextXAlignment = UDim2.new(0, 115, 0, 24), UDim2.new(1, -123, 0.5, -12), Color3.fromRGB(15, 16, 22), startupConfigName .. " ∨", Color3.fromRGB(50, 200, 50), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", stProfileBtn).CornerRadius = UDim.new(0, 4)
local stpStroke = Instance.new("UIStroke", stProfileBtn) stpStroke.Color, stpStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, stpStroke)

local stProfileDrop = Instance.new("ScrollingFrame", profilesContainer)
stProfileDrop.LayoutOrder = 6 stProfileDrop.Size, stProfileDrop.BackgroundColor3, stProfileDrop.CanvasSize, stProfileDrop.ScrollBarThickness, stProfileDrop.Visible = UDim2.new(1, 0, 0, 90), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false
Instance.new("UICorner", stProfileDrop).CornerRadius = UDim.new(0, 5)
local stpdStroke = Instance.new("UIStroke", stProfileDrop) stpdStroke.Color, stpdStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, stpdStroke)
local stProfileLayout = Instance.new("UIListLayout", stProfileDrop) stProfileLayout.Padding = UDim.new(0, 4)

local loadConfigFrame = Instance.new("Frame", profilesContainer)
loadConfigFrame.LayoutOrder = 7 loadConfigFrame.Size, loadConfigFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", loadConfigFrame).CornerRadius = UDim.new(0, 5) 
local lcfStroke = Instance.new("UIStroke", loadConfigFrame) lcfStroke.Color, lcfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, lcfStroke)

local ldLabel = Instance.new("TextLabel", loadConfigFrame)
ldLabel.Size, ldLabel.Position, ldLabel.BackgroundTransparency, ldLabel.Text, ldLabel.TextColor3, ldLabel.TextSize, ldLabel.Font, ldLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Tải Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left

local ldBtn = Instance.new("TextButton", loadConfigFrame)
ldBtn.Size, ldBtn.Position, ldBtn.BackgroundColor3, ldBtn.Text, ldBtn.TextColor3, ldBtn.TextSize, ldBtn.Font, ldBtn.TextXAlignment = UDim2.new(0, 115, 0, 24), UDim2.new(1, -123, 0.5, -12), Color3.fromRGB(15, 16, 22), currentConfigName .. " ∨", Color3.fromRGB(50, 200, 50), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center
Instance.new("UICorner", ldBtn).CornerRadius = UDim.new(0, 4)
local ldbStroke = Instance.new("UIStroke", ldBtn) ldbStroke.Color, ldbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, ldbStroke)

local ldDropFrame = Instance.new("ScrollingFrame", profilesContainer)
ldDropFrame.LayoutOrder = 8 ldDropFrame.Size, ldDropFrame.BackgroundColor3, ldDropFrame.CanvasSize, ldDropFrame.ScrollBarThickness, ldDropFrame.Visible = UDim2.new(1, 0, 0, 90), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false
Instance.new("UICorner", ldDropFrame).CornerRadius = UDim.new(0, 5)
local ldf2Stroke = Instance.new("UIStroke", ldDropFrame) ldf2Stroke.Color, ldf2Stroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, ldf2Stroke)
local ldDropLayout = Instance.new("UIListLayout", ldDropFrame) ldDropLayout.Padding = UDim.new(0, 4)

local saveFrame = Instance.new("Frame", profilesContainer)
saveFrame.LayoutOrder = 9 saveFrame.Size, saveFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 42), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", saveFrame).CornerRadius = UDim.new(0, 5) 
local svfStroke = Instance.new("UIStroke", saveFrame) svfStroke.Color, svfStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, svfStroke)

local svTitle = Instance.new("TextLabel", saveFrame)
svTitle.Size, svTitle.Position, svTitle.BackgroundTransparency, svTitle.Text, svTitle.TextColor3, svTitle.TextSize, svTitle.Font, svTitle.TextXAlignment = UDim2.new(1, -110, 0, 20), UDim2.new(0, 8, 0, 3), 1, "Lưu Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Left
local svSub = Instance.new("TextLabel", saveFrame)
svSub.Size, svSub.Position, svSub.BackgroundTransparency, svSub.Text, svSub.TextColor3, svSub.TextSize, svSub.Font, svSub.TextXAlignment = UDim2.new(1, -110, 0, 16), UDim2.new(0, 8, 0, 21), 1, "Save: " .. currentConfigName, Color3.fromRGB(140, 140, 150), 9, Enum.Font.Gotham, Enum.TextXAlignment.Left

local saveBtn = Instance.new("TextButton", saveFrame)
saveBtn.Size, saveBtn.Position, saveBtn.BackgroundColor3, saveBtn.Text, saveBtn.TextColor3, saveBtn.TextSize, saveBtn.Font = UDim2.new(0, 95, 0, 26), UDim2.new(1, -103, 0.5, -13), Color3.fromRGB(220, 50, 50), "Save", Color3.fromRGB(255, 255, 255), 10, Enum.Font.GothamBold
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 4)
local sbStroke = Instance.new("UIStroke", saveBtn) sbStroke.Color, sbStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
table.insert(AllUIStrokes, sbStroke)

local function refreshAllDropdowns()
    for _, drop in ipairs({delDropFrame, stProfileDrop, ldDropFrame}) do
        for _, child in ipairs(drop:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
    end
    
    local filesList = {}
    if typeof(listfiles) == "function" then
        local success, files = pcall(listfiles, configFolder)
        if success then
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
        f1.Size, f1.BackgroundColor3, f1.Text, f1.TextColor3, f1.TextSize, f1.Font, f1.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), "  🗑️ " .. name, Color3.fromRGB(255, 100, 100), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", f1).CornerRadius = UDim.new(0, 4)
        local f1s = Instance.new("UIStroke", f1) f1s.Color, f1s.Thickness = Color3.fromRGB(40, 43, 52), 1
        table.insert(AllUIStrokes, f1s)
        f1.MouseButton1Click:Connect(function()
            if typeof(delfile) == "function" then pcall(delfile, configFolder .. "/" .. name .. ".json") end
            delBtn.Text = name .. " ∨"
            delDropFrame.Visible = false
            refreshAllDropdowns()
        end)

        local f2 = Instance.new("TextButton", stProfileDrop)
        f2.Size, f2.BackgroundColor3, f2.Text, f2.TextColor3, f2.TextSize, f2.Font, f2.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), "  📁 " .. name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", f2).CornerRadius = UDim.new(0, 4)
        local f2s = Instance.new("UIStroke", f2) f2s.Color, f2s.Thickness = Color3.fromRGB(40, 43, 52), 1
        table.insert(AllUIStrokes, f2s)
        f2.MouseButton1Click:Connect(function()
            startupConfigName = name
            stProfileBtn.Text = name .. " ∨"
            startupLabel.Text = "Startup Cấu Hình: " .. name
            stProfileDrop.Visible = false
        end)

        local f3 = Instance.new("TextButton", ldDropFrame)
        f3.Size, f3.BackgroundColor3, f3.Text, f3.TextColor3, f3.TextSize, f3.Font, f3.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), "  📂 " .. name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
        Instance.new("UICorner", f3).CornerRadius = UDim.new(0, 4)
        local f3s = Instance.new("UIStroke", f3) f3s.Color, f3s.Thickness = Color3.fromRGB(40, 43, 52), 1
        table.insert(AllUIStrokes, f3s)
        f3.MouseButton1Click:Connect(function()
            currentConfigName = name
            ldBtn.Text = name .. " ∨"
            svSub.Text = "Save: " .. name
            asSub.Text = "Auto save: " .. name
            alSub.Text = "Auto load: " .. name
            ldDropFrame.Visible = false
        end)
    end
    
    delDropFrame.CanvasSize = UDim2.new(0, 0, 0, #filesList * 30)
    stProfileDrop.CanvasSize = UDim2.new(0, 0, 0, #filesList * 30)
    ldDropFrame.CanvasSize = UDim2.new(0, 0, 0, #filesList * 30)
end

delBtn.MouseButton1Click:Connect(function()
    refreshAllDropdowns()
    delDropFrame.Visible = not delDropFrame.Visible
    stProfileDrop.Visible = false ldDropFrame.Visible = false
end)

stProfileBtn.MouseButton1Click:Connect(function()
    refreshAllDropdowns()
    stProfileDrop.Visible = not stProfileDrop.Visible
    delDropFrame.Visible = false ldDropFrame.Visible = false
end)

ldBtn.MouseButton1Click:Connect(function()
    refreshAllDropdowns()
    ldDropFrame.Visible = not ldDropFrame.Visible
    delDropFrame.Visible = false stProfileDrop.Visible = false
end)

createBtn.MouseButton1Click:Connect(function()
    local name = configNameBox.Text
    if name ~= "" and typeof(writefile) == "function" then
        pcall(writefile, configFolder .. "/" .. name .. ".json", HttpService:JSONEncode({SavedTime = os.time()}))
        currentConfigName = name
        ldBtn.Text = name .. " ∨"
        svSub.Text = "Save: " .. name
        asSub.Text = "Auto save: " .. name
        alSub.Text = "Auto load: " .. name
        configNameBox.Text = ""
        refreshAllDropdowns()
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    if typeof(writefile) == "function" then
        pcall(writefile, configFolder .. "/" .. currentConfigName .. ".json", HttpService:JSONEncode({SavedTime = os.time()}))
        svSub.Text = "Save: " .. currentConfigName
    end
end)

configScroll.CanvasSize = UDim2.new(0, 0, 0, 1100)

local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size, ResizeBtn.Position, ResizeBtn.BackgroundTransparency, ResizeBtn.Text, ResizeBtn.TextColor3, ResizeBtn.TextSize, ResizeBtn.Font = UDim2.new(0, 16, 0, 16), UDim2.new(1, -18, 1, -18), 1, "◢", Color3.fromRGB(180, 180, 190), 12, Enum.Font.GothamBold

local resizing = false local startInput, startSize
ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true startInput = input.Position startSize = MainFrame.Size
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startInput
        local newX = math.max(400, startSize.X.Offset + delta.X) local newY = math.max(260, startSize.Y.Offset + delta.Y)
        MainFrame.Size = UDim2.new(0, newX, 0, newY)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end
end)

local dh = 0
for i, scr in ipairs(RegisteredScripts) do
    local item = Instance.new("TextButton", dropFrame)
    item.LayoutOrder = i item.Size, item.BackgroundColor3, item.Text, item.TextColor3, item.TextSize, item.Font, item.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), "  ▶ " .. scr.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 4)
    local its = Instance.new("UIStroke", item) its.Color, its.Thickness = Color3.fromRGB(40, 43, 52), 1
    table.insert(AllUIStrokes, its)
    
    item.MouseButton1Click:Connect(function()
        selScript = scr
        dropBtn.Text = " 📜 " .. scr.Name
        dropFrame.Visible = false
        if isAuto and selScript and selScript.Callback then
            pcall(selScript.Callback)
        end
    end)
    dh = dh + 30
end
dropFrame.CanvasSize = UDim2.new(0, 0, 0, dh)

-- NÚT MỞ/ĐÓNG MENU TRÒN & CÓ VIỀN TRẮNG DÀY
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Name = "VzNamOpenBtn"
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Position = UDim2.new(0, 15, 0.2, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
OpenButton.BorderSizePixel = 0
OpenButton.Text = ""
OpenButton.Active = true
OpenButton.Draggable = true
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)

local OpenStroke = Instance.new("UIStroke", OpenButton)
OpenStroke.Thickness = 4
OpenStroke.Color = Color3.fromRGB(255, 255, 255)

local FlowerLabel = Instance.new("TextLabel", OpenButton)
FlowerLabel.Size = UDim2.new(1, 0, 1, 0)
FlowerLabel.BackgroundTransparency = 1
FlowerLabel.Text = "🌸"
FlowerLabel.TextSize = 20
FlowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlowerLabel.Font = Enum.Font.GothamBold

local FlowerStroke = Instance.new("UIStroke", FlowerLabel)
FlowerStroke.Thickness = 2
FlowerStroke.Color = Color3.fromRGB(255, 255, 255)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
