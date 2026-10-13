local CoreGui, Players, TweenService, UserInputService, SoundService, HttpService, RunService = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("SoundService"), game:GetService("HttpService"), game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end
if CoreGui:FindFirstChild("VzNamHubDropdowns") then CoreGui.VzNamHubDropdowns:Destroy() end

local LastSelectedScriptBtn, LastSelectedScriptStroke = nil, nil
local RegisteredScripts = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.DisplayOrder = 99999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local DropdownGui = Instance.new("ScreenGui", CoreGui)
DropdownGui.Name = "VzNamHubDropdowns"
DropdownGui.DisplayOrder = 999999
DropdownGui.ResetOnSpawn = false

local success, avatarThumbnail = pcall(function() return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
local avatarUrl = success and avatarThumbnail or "rbxassetid://15298567397"

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

local TopBar = Instance.new("Frame", MainFrame) TopBar.Size, TopBar.BackgroundTransparency = UDim2.new(1, 0, 0, 28), 1

local Logo = Instance.new("ImageLabel", TopBar) Logo.Size, Logo.Position, Logo.BackgroundTransparency, Logo.Image = UDim2.new(0, 18, 0, 18), UDim2.new(0, 10, 0.5, -9), 1, avatarUrl
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency, Title.Text, Title.TextColor3, Title.TextSize, Title.Font, Title.TextXAlignment = UDim2.new(1, -70, 1, 0), UDim2.new(0, 32, 0, 0), 1, "🌸 VzNam Hub v3 : Tổng Hợp 🌸", Color3.fromRGB(255, 105, 180), 12, Enum.Font.FredokaOne, Enum.TextXAlignment.Center

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundTransparency, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize, CloseBtn.Font = UDim2.new(0, 26, 0, 26), UDim2.new(1, -28, 0.5, -13), 1, "✕", Color3.fromRGB(200, 200, 210), 11, Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function()
    if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end
    ScreenGui:Destroy()
    DropdownGui:Destroy()
end)

local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Name = "SidebarPanel"
SidebarPanel.Size, SidebarPanel.Position, SidebarPanel.BackgroundColor3, SidebarPanel.BackgroundTransparency, SidebarPanel.BorderSizePixel = UDim2.new(0, 145, 1, -34), UDim2.new(0, 6, 0, 28), Color3.fromRGB(15, 16, 22), 0, 0
Instance.new("UICorner", SidebarPanel).CornerRadius = UDim.new(0, 6)
local SidebarStroke = Instance.new("UIStroke", SidebarPanel) SidebarStroke.Color, SidebarStroke.Thickness = Color3.fromRGB(40, 43, 52), 1

local SearchBoxTab = Instance.new("TextBox", SidebarPanel)
SearchBoxTab.Size, SearchBoxTab.Position, SearchBoxTab.BackgroundColor3, SearchBoxTab.BackgroundTransparency, SearchBoxTab.Text, SearchBoxTab.PlaceholderText, SearchBoxTab.PlaceholderColor3, SearchBoxTab.TextColor3, SearchBoxTab.TextSize, SearchBoxTab.Font = UDim2.new(1, -10, 0, 24), UDim2.new(0, 5, 0, 5), Color3.fromRGB(22, 25, 34), 0, "", "🔍 Search section...", Color3.fromRGB(130, 135, 145), Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne
Instance.new("UICorner", SearchBoxTab).CornerRadius = UDim.new(0, 4)

local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
SidebarScroll.Size, SidebarScroll.Position, SidebarScroll.BackgroundTransparency, SidebarScroll.BorderSizePixel, SidebarScroll.ScrollBarThickness = UDim2.new(1, -8, 1, -34), UDim2.new(0, 4, 0, 32), 1, 0, 2
local SidebarLayout = Instance.new("UIListLayout", SidebarScroll) SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 2)

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

local ContentHeader = Instance.new("Frame", ContentContainer) ContentHeader.Size, ContentHeader.BackgroundTransparency = UDim2.new(1, 0, 0, 30), 1

local ActiveTabTitle = Instance.new("TextLabel", ContentHeader)
ActiveTabTitle.Size, ActiveTabTitle.Position, ActiveTabTitle.BackgroundTransparency, ActiveTabTitle.Text, ActiveTabTitle.TextColor3, ActiveTabTitle.TextSize, ActiveTabTitle.Font, ActiveTabTitle.TextXAlignment = UDim2.new(1, -40, 1, 0), UDim2.new(0, 12, 0, 0), 1, "", Color3.fromRGB(255, 255, 255), 12, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local SearchInputContent = Instance.new("TextBox", ContentHeader)
SearchInputContent.Size, SearchInputContent.Position, SearchInputContent.BackgroundColor3, SearchInputContent.TextColor3, SearchInputContent.PlaceholderText, SearchInputContent.PlaceholderColor3, SearchInputContent.TextSize, SearchInputContent.Font, SearchInputContent.Visible = UDim2.new(1, -45, 0, 22), UDim2.new(0, 10, 0.5, -11), Color3.fromRGB(22, 25, 34), Color3.fromRGB(255, 255, 255), "Search features...", Color3.fromRGB(140, 140, 150), 10, Enum.Font.FredokaOne, false
Instance.new("UICorner", SearchInputContent).CornerRadius = UDim.new(0, 4)

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
local FirstTab = nil

local function CreateCategoryTab(tabName)
    local tabBtn = Instance.new("TextButton", SidebarScroll)
    tabBtn.Size, tabBtn.BackgroundTransparency, tabBtn.Text, tabBtn.TextColor3, tabBtn.TextSize, tabBtn.Font, tabBtn.TextXAlignment = UDim2.new(1, 0, 0, 28), 1, "   " .. tabName, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

    local indicator = Instance.new("Frame", tabBtn)
    indicator.Size, indicator.Position, indicator.BackgroundColor3, indicator.BorderSizePixel, indicator.Visible = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6), Color3.fromRGB(255, 105, 180), 0, false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local containerFrame = Instance.new("Frame", ContentContainer)
    containerFrame.Name = "Container_" .. tabName
    containerFrame.Size, containerFrame.Position, containerFrame.BackgroundTransparency, containerFrame.Visible = UDim2.new(1, -12, 1, -38), UDim2.new(0, 6, 0, 34), 1, false

    local subBar = Instance.new("Frame", containerFrame) subBar.Size, subBar.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1
    local subLayout = Instance.new("UIListLayout", subBar) subLayout.FillDirection, subLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)

    local noKeyBtn = Instance.new("TextButton", subBar)
    noKeyBtn.Size, noKeyBtn.BackgroundColor3, noKeyBtn.Text, noKeyBtn.TextColor3, noKeyBtn.TextSize, noKeyBtn.Font = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(22, 25, 34), "no key", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
    Instance.new("UICorner", noKeyBtn).CornerRadius = UDim.new(0, 5)
    local nkStroke = Instance.new("UIStroke", noKeyBtn) nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(255, 50, 50), 2

    local hasKeyBtn = Instance.new("TextButton", subBar)
    hasKeyBtn.Size, hasKeyBtn.BackgroundColor3, hasKeyBtn.Text, hasKeyBtn.TextColor3, hasKeyBtn.TextSize, hasKeyBtn.Font = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(22, 25, 34), "có key", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
    Instance.new("UICorner", hasKeyBtn).CornerRadius = UDim.new(0, 5)
    local hkStroke = Instance.new("UIStroke", hasKeyBtn) hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(40, 43, 52), 1

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

    local tabObj = { Container = containerFrame, Indicator = indicator }
    table.insert(Tabs, tabObj)

    if not FirstTab then
        FirstTab = tabObj
        containerFrame.Visible, indicator.Visible = true, true
        ActiveTabTitle.Text = tabName
    end

    local Elements = {}
    local function AddBtnTo(parent, name, callback)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size, Btn.BackgroundColor3, Btn.Text, Btn.TextColor3, Btn.TextSize, Btn.Font, Btn.TextXAlignment = UDim2.new(1, -4, 0, 30), Color3.fromRGB(22, 25, 34), "  ▶ " .. name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        local btnStroke = Instance.new("UIStroke", Btn) btnStroke.Color, btnStroke.Thickness = Color3.fromRGB(40, 43, 52), 1
        
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

-- TAB 3, 4, 5
local tab3 = CreateCategoryTab("🌸BREAK AN STEAL🌸")
tab3:AddNoKey("1. break and steal an egg", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))() end)

local tab4 = CreateCategoryTab("Tab 4")
local tab5 = CreateCategoryTab("Tab 5")

-- TAB 6: KHÁC
local tab6Btn = Instance.new("TextButton", SidebarScroll)
tab6Btn.Size, tab6Btn.BackgroundTransparency, tab6Btn.Text, tab6Btn.TextColor3, tab6Btn.TextSize, tab6Btn.Font, tab6Btn.TextXAlignment = UDim2.new(1, 0, 0, 28), 1, "   👾KHÁC👾", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local t6Indicator = Instance.new("Frame", tab6Btn)
t6Indicator.Size, t6Indicator.Position, t6Indicator.BackgroundColor3, t6Indicator.BorderSizePixel, t6Indicator.Visible = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6), Color3.fromRGB(255, 105, 180), 0, false
Instance.new("UICorner", t6Indicator).CornerRadius = UDim.new(0, 2)

local t6Scroll = Instance.new("ScrollingFrame", ContentContainer)
t6Scroll.Name = "Container_KHAC"
t6Scroll.Size, t6Scroll.Position, t6Scroll.BackgroundTransparency, t6Scroll.BorderSizePixel, t6Scroll.ScrollBarThickness, t6Scroll.Visible, t6Scroll.ClipsDescendants = UDim2.new(1, -12, 1, -38), UDim2.new(0, 6, 0, 34), 1, 0, 3, false, true
local t6Layout = Instance.new("UIListLayout", t6Scroll)
t6Layout.SortOrder = Enum.SortOrder.LayoutOrder
t6Layout.Padding = UDim.new(0, 6)

tab6Btn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do 
        t.Container.Visible = false 
        if t.Indicator then t.Indicator.Visible = false end 
    end
    t6Scroll.Visible = true
    t6Indicator.Visible = true
    ActiveTabTitle.Text = "👾KHÁC👾"
end)
table.insert(Tabs, {Container = t6Scroll, Indicator = t6Indicator})

local configFolder = "VzNamHub_Configs"
if typeof(makefolder) == "function" then pcall(makefolder, configFolder) end

-- 📦 PROFILES
local profileDropdownOpen = false
local profileToggleHeader = Instance.new("TextButton", t6Scroll)
profileToggleHeader.LayoutOrder = 1
profileToggleHeader.Size, profileToggleHeader.BackgroundColor3, profileToggleHeader.Text, profileToggleHeader.TextColor3, profileToggleHeader.TextSize, profileToggleHeader.Font = UDim2.new(1, -4, 0, 32), Color3.fromRGB(20, 22, 30), "👉 Profiles", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", profileToggleHeader).CornerRadius = UDim.new(0, 5)
local pHeaderStroke = Instance.new("UIStroke", profileToggleHeader) pHeaderStroke.Color, pHeaderStroke.Thickness = Color3.fromRGB(50, 150, 255), 1.5

local profileSubContainer = Instance.new("Frame", t6Scroll)
profileSubContainer.LayoutOrder = 2
profileSubContainer.Size, profileSubContainer.AutomaticSize = UDim2.new(1, -4, 0, 0), Enum.AutomaticSize.Y
profileSubContainer.BackgroundTransparency = 1
profileSubContainer.Visible = false

local subProfileLayout = Instance.new("UIListLayout", profileSubContainer)
subProfileLayout.SortOrder = Enum.SortOrder.LayoutOrder
subProfileLayout.Padding = UDim.new(0, 6)

profileToggleHeader.MouseButton1Click:Connect(function()
    profileDropdownOpen = not profileDropdownOpen
    if profileDropdownOpen then
        profileToggleHeader.Text = "👇 Profiles"
        profileSubContainer.Visible = true
    else
        profileToggleHeader.Text = "👉 Profiles"
        profileSubContainer.Visible = false
    end
end)

-- 1. New Cấu Hình Name
local newConfigFrame = Instance.new("Frame", profileSubContainer)
newConfigFrame.LayoutOrder = 1
newConfigFrame.Size, newConfigFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", newConfigFrame).CornerRadius = UDim.new(0, 5)

local newConfigLabel = Instance.new("TextLabel", newConfigFrame)
newConfigLabel.Size, newConfigLabel.Position, newConfigLabel.BackgroundTransparency, newConfigLabel.Text, newConfigLabel.TextColor3, newConfigLabel.TextSize, newConfigLabel.Font, newConfigLabel.TextXAlignment = UDim2.new(0.45, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "New Cấu Hình Name", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local newConfigInput = Instance.new("TextBox", newConfigFrame)
newConfigInput.Size, newConfigInput.Position, newConfigInput.BackgroundColor3, newConfigInput.TextColor3, newConfigInput.PlaceholderText, newConfigInput.PlaceholderColor3, newConfigInput.TextSize, newConfigInput.Font = UDim2.new(0.52, -6, 0, 24), UDim2.new(0.48, 0, 0.5, -12), Color3.fromRGB(28, 32, 42), Color3.fromRGB(255, 255, 255), "New config name...", Color3.fromRGB(140, 140, 150), 10, Enum.Font.FredokaOne
Instance.new("UICorner", newConfigInput).CornerRadius = UDim.new(0, 4)

-- 2. Create New Cấu Hình
local createFrame = Instance.new("Frame", profileSubContainer)
createFrame.LayoutOrder = 2
createFrame.Size, createFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", createFrame).CornerRadius = UDim.new(0, 5)

local createTitle = Instance.new("TextLabel", createFrame)
createTitle.Size, createTitle.Position, createTitle.BackgroundTransparency, createTitle.Text, createTitle.TextColor3, createTitle.TextSize, createTitle.Font, createTitle.TextXAlignment = UDim2.new(1, -100, 0, 20), UDim2.new(0, 8, 0, 2), 1, "Create New Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local createSub = Instance.new("TextLabel", createFrame)
createSub.Size, createSub.Position, createSub.BackgroundTransparency, createSub.Text, createSub.TextColor3, createSub.TextSize, createSub.Font, createSub.TextXAlignment = UDim2.new(1, -100, 0, 16), UDim2.new(0, 8, 0, 18), 1, "New config copies current settings", Color3.fromRGB(140, 140, 150), 9, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local createBtn = Instance.new("TextButton", createFrame)
createBtn.Size, createBtn.Position, createBtn.BackgroundColor3, createBtn.Text, createBtn.TextColor3, createBtn.TextSize, createBtn.Font = UDim2.new(0, 85, 0, 24), UDim2.new(1, -90, 0.5, -12), Color3.fromRGB(220, 50, 50), "Create New", Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne
Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 4)

-- 3. Delete Cấu Hình
local delFrame = Instance.new("Frame", profileSubContainer)
delFrame.LayoutOrder = 3
delFrame.Size, delFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", delFrame).CornerRadius = UDim.new(0, 5)

local delLabel = Instance.new("TextLabel", delFrame)
delLabel.Size, delLabel.Position, delLabel.BackgroundTransparency, delLabel.Text, delLabel.TextColor3, delLabel.TextSize, delLabel.Font, delLabel.TextXAlignment = UDim2.new(0.45, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Delete Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local selectedDeleteConfig = ""
local delDropBtn = Instance.new("TextButton", delFrame)
delDropBtn.Size, delDropBtn.Position, delDropBtn.BackgroundColor3, delDropBtn.Text, delDropBtn.TextColor3, delDropBtn.TextSize, delDropBtn.Font, delDropBtn.TextXAlignment = UDim2.new(0.52, -6, 0, 24), UDim2.new(0.48, 0, 0.5, -12), Color3.fromRGB(28, 32, 42), "Không có", Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", delDropBtn).CornerRadius = UDim.new(0, 4)

local delDropScroll = Instance.new("ScrollingFrame", DropdownGui)
delDropScroll.Size, delDropScroll.BackgroundColor3, delDropScroll.CanvasSize, delDropScroll.ScrollBarThickness, delDropScroll.Visible, delDropScroll.ZIndex = UDim2.new(0, 240, 0, 110), Color3.fromRGB(32, 36, 48), UDim2.new(0,0,0,0), 3, false, 999999
Instance.new("UICorner", delDropScroll).CornerRadius = UDim.new(0, 4)
local delLayout = Instance.new("UIListLayout", delDropScroll) delLayout.Padding = UDim.new(0, 2)

-- 4. Cấu Hình Khởi Động
local startFrame = Instance.new("Frame", profileSubContainer)
startFrame.LayoutOrder = 4
startFrame.Size, startFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", startFrame).CornerRadius = UDim.new(0, 5)

local startLabel = Instance.new("TextLabel", startFrame)
startLabel.Size, startLabel.Position, startLabel.BackgroundTransparency, startLabel.Text, startLabel.TextColor3, startLabel.TextSize, startLabel.Font, startLabel.TextXAlignment = UDim2.new(0.45, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Cấu Hình Khởi Động", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local selectedStartConfig = "Default"
local startDropBtn = Instance.new("TextButton", startFrame)
startDropBtn.Size, startDropBtn.Position, startDropBtn.BackgroundColor3, startDropBtn.Text, startDropBtn.TextColor3, startDropBtn.TextSize, startDropBtn.Font, startDropBtn.TextXAlignment = UDim2.new(0.52, -6, 0, 24), UDim2.new(0.48, 0, 0.5, -12), Color3.fromRGB(28, 32, 42), "Default", Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", startDropBtn).CornerRadius = UDim.new(0, 4)

local startDropScroll = Instance.new("ScrollingFrame", DropdownGui)
startDropScroll.Size, startDropScroll.BackgroundColor3, startDropScroll.CanvasSize, startDropScroll.ScrollBarThickness, startDropScroll.Visible, startDropScroll.ZIndex = UDim2.new(0, 240, 0, 110), Color3.fromRGB(32, 36, 48), UDim2.new(0,0,0,0), 3, false, 999999
Instance.new("UICorner", startDropScroll).CornerRadius = UDim.new(0, 4)
local startLayout = Instance.new("UIListLayout", startDropScroll) startLayout.Padding = UDim.new(0, 2)

-- 5. Tải Cấu Hình
local loadFrame = Instance.new("Frame", profileSubContainer)
loadFrame.LayoutOrder = 5
loadFrame.Size, loadFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", loadFrame).CornerRadius = UDim.new(0, 5)

local loadLabel = Instance.new("TextLabel", loadFrame)
loadLabel.Size, loadLabel.Position, loadLabel.BackgroundTransparency, loadLabel.Text, loadLabel.TextColor3, loadLabel.TextSize, loadLabel.Font, loadLabel.TextXAlignment = UDim2.new(0.45, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, "Tải Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local selectedLoadConfig = "Default"
local loadDropBtn = Instance.new("TextButton", loadFrame)
loadDropBtn.Size, loadDropBtn.Position, loadDropBtn.BackgroundColor3, loadDropBtn.Text, loadDropBtn.TextColor3, loadDropBtn.TextSize, loadDropBtn.Font, loadDropBtn.TextXAlignment = UDim2.new(0.52, -6, 0, 24), UDim2.new(0.48, 0, 0.5, -12), Color3.fromRGB(28, 32, 42), "Default", Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", loadDropBtn).CornerRadius = UDim.new(0, 4)

local loadDropScroll = Instance.new("ScrollingFrame", DropdownGui)
loadDropScroll.Size, loadDropScroll.BackgroundColor3, loadDropScroll.CanvasSize, loadDropScroll.ScrollBarThickness, loadDropScroll.Visible, loadDropScroll.ZIndex = UDim2.new(0, 240, 0, 110), Color3.fromRGB(32, 36, 48), UDim2.new(0,0,0,0), 3, false, 999999
Instance.new("UICorner", loadDropScroll).CornerRadius = UDim.new(0, 4)
local loadLayout = Instance.new("UIListLayout", loadDropScroll) loadLayout.Padding = UDim.new(0, 2)

-- 6. Lưu Cấu Hình
local saveFrame = Instance.new("Frame", profileSubContainer)
saveFrame.LayoutOrder = 6
saveFrame.Size, saveFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", saveFrame).CornerRadius = UDim.new(0, 5)

local saveTitle = Instance.new("TextLabel", saveFrame)
saveTitle.Size, saveTitle.Position, saveTitle.BackgroundTransparency, saveTitle.Text, saveTitle.TextColor3, saveTitle.TextSize, saveTitle.Font, saveTitle.TextXAlignment = UDim2.new(1, -100, 0, 20), UDim2.new(0, 8, 0, 2), 1, "Lưu Cấu Hình", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local saveSub = Instance.new("TextLabel", saveFrame)
saveSub.Size, saveSub.Position, saveSub.BackgroundTransparency, saveSub.Text, saveSub.TextColor3, saveSub.TextSize, saveSub.Font, saveSub.TextXAlignment = UDim2.new(1, -100, 0, 16), UDim2.new(0, 8, 0, 18), 1, "Save: Default", Color3.fromRGB(140, 140, 150), 9, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local saveBtn = Instance.new("TextButton", saveFrame)
saveBtn.Size, saveBtn.Position, saveBtn.BackgroundColor3, saveBtn.Text, saveBtn.TextColor3, saveBtn.TextSize, saveBtn.Font = UDim2.new(0, 85, 0, 24), UDim2.new(1, -90, 0.5, -12), Color3.fromRGB(220, 50, 50), "Save", Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 4)

-- SCRIPT AUTO LOAD
local selScript, isAuto = nil, false
local dropBtn = Instance.new("TextButton", t6Scroll)
dropBtn.LayoutOrder = 3
dropBtn.Size, dropBtn.BackgroundColor3, dropBtn.Text, dropBtn.TextColor3, dropBtn.TextSize, dropBtn.Font, dropBtn.TextXAlignment = UDim2.new(1, -4, 0, 32), Color3.fromRGB(22, 25, 34), " 📜 Chọn Script Auto Load...", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)

local dropFrame = Instance.new("ScrollingFrame", DropdownGui)
dropFrame.Size, dropFrame.BackgroundColor3, dropFrame.CanvasSize, dropFrame.ScrollBarThickness, dropFrame.Visible, dropFrame.ZIndex = UDim2.new(0, 320, 0, 120), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false, 999999
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
local dropLayout = Instance.new("UIListLayout", dropFrame) dropLayout.Padding = UDim.new(0, 4)

local toggleAuto = Instance.new("TextButton", t6Scroll)
toggleAuto.LayoutOrder = 5
toggleAuto.Size, toggleAuto.BackgroundColor3, toggleAuto.Text, toggleAuto.TextColor3, toggleAuto.TextSize, toggleAuto.Font = UDim2.new(1, -4, 0, 32), Color3.fromRGB(200, 50, 50), "Auto Load Script Chạy: TẮT ❌", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", toggleAuto).CornerRadius = UDim.new(0, 5)
local HubSound = SoundService:FindFirstChild("VzNamHubSound") or Instance.new("Sound", SoundService)
HubSound.Name, HubSound.Looped, HubSound.Volume = "VzNamHubSound", true, 0.5
local currentSoundId = "1837879082"

local customIdBox = Instance.new("TextBox", t6Scroll)
customIdBox.LayoutOrder = 6
customIdBox.Size, customIdBox.BackgroundColor3, customIdBox.PlaceholderText, customIdBox.Text, customIdBox.TextColor3, customIdBox.TextSize, customIdBox.Font = UDim2.new(1, -4, 0, 32), Color3.fromRGB(22, 25, 34), "🎶 Nhập Sound ID tùy chỉnh...", "", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", customIdBox).CornerRadius = UDim.new(0, 5)

local musicDropBtn = Instance.new("TextButton", t6Scroll)
musicDropBtn.LayoutOrder = 7
musicDropBtn.Size, musicDropBtn.BackgroundColor3, musicDropBtn.Text, musicDropBtn.TextColor3, musicDropBtn.TextSize, musicDropBtn.Font, musicDropBtn.TextXAlignment = UDim2.new(1, -4, 0, 32), Color3.fromRGB(22, 25, 34), " 🎵 Chọn Nhạc Nền...", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", musicDropBtn).CornerRadius = UDim.new(0, 5)

local musicDropFrame = Instance.new("ScrollingFrame", DropdownGui)
musicDropFrame.Size, musicDropFrame.BackgroundColor3, musicDropFrame.CanvasSize, musicDropFrame.ScrollBarThickness, musicDropFrame.Visible, musicDropFrame.ZIndex = UDim2.new(0, 320, 0, 130), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false, 999999
Instance.new("UICorner", musicDropFrame).CornerRadius = UDim.new(0, 5)
local musicLayout = Instance.new("UIListLayout", musicDropFrame) musicLayout.Padding = UDim.new(0, 4)

local presetMusics = {
    {Name = "🎵 Chill Lofi Music", Id = "1837879082"},
    {Name = "🎶 Phonk Beat", Id = "1843404008"},
    {Name = "🎵 Anime Relaxing", Id = "9043887091"},
    {Name = "🎶 EDM Hype", Id = "1837871000"},
    {Name = "🎶 Như Một Người Dưng", Id = "91897652967267"}
}
for i, m in ipairs(presetMusics) do
    local mBtn = Instance.new("TextButton", musicDropFrame)
    mBtn.LayoutOrder = i
    mBtn.Size, mBtn.BackgroundColor3, mBtn.Text, mBtn.TextColor3, mBtn.TextSize, mBtn.Font, mBtn.TextXAlignment, mBtn.ZIndex = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), " " .. m.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left, 999999
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 4)
    mBtn.MouseButton1Click:Connect(function()
        currentSoundId = m.Id
        musicDropBtn.Text = " 🎵 " .. m.Name
        musicDropFrame.Visible = false
        if HubSound.IsPlaying then HubSound.SoundId = "rbxassetid://" .. currentSoundId HubSound:Play() end
    end)
end
musicDropFrame.CanvasSize = UDim2.new(0, 0, 0, #presetMusics * 30)

customIdBox.FocusLost:Connect(function()
    if customIdBox.Text ~= "" and tonumber(customIdBox.Text) then
        currentSoundId = customIdBox.Text
        musicDropBtn.Text = " 🎵 ID Custom: " .. currentSoundId
        if HubSound.IsPlaying then HubSound.SoundId = "rbxassetid://" .. currentSoundId HubSound:Play() end
    end
end)

local isMusicPlaying = false
local toggleMusicBtn = Instance.new("TextButton", t6Scroll)
toggleMusicBtn.LayoutOrder = 9
toggleMusicBtn.Size, toggleMusicBtn.BackgroundColor3, toggleMusicBtn.Text, toggleMusicBtn.TextColor3, toggleMusicBtn.TextSize, toggleMusicBtn.Font = UDim2.new(1, -4, 0, 32), Color3.fromRGB(200, 50, 50), "Phát Nhạc Background: TẮT ❌", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", toggleMusicBtn).CornerRadius = UDim.new(0, 5)
toggleMusicBtn.MouseButton1Click:Connect(function()
    isMusicPlaying = not isMusicPlaying
    if isMusicPlaying then
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        toggleMusicBtn.Text = "Phát Nhạc Background: BẬT ✅"
        HubSound.SoundId = "rbxassetid://" .. currentSoundId
        HubSound:Play()
    else
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleMusicBtn.Text = "Phát Nhạc Background: TẮT ❌"
        HubSound:Stop()
    end
end)

-- THANH KÉO ÂM LƯỢNG
local volumeFrame = Instance.new("Frame", t6Scroll)
volumeFrame.LayoutOrder = 10
volumeFrame.Size, volumeFrame.BackgroundColor3 = UDim2.new(1, -4, 0, 32), Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", volumeFrame).CornerRadius = UDim.new(0, 5)

local volumeLabel = Instance.new("TextLabel", volumeFrame)
volumeLabel.Size, volumeLabel.Position, volumeLabel.BackgroundTransparency, volumeLabel.Text, volumeLabel.TextColor3, volumeLabel.TextSize, volumeLabel.Font, volumeLabel.TextXAlignment = UDim2.new(1, -12, 1, 0), UDim2.new(0, 8, 0, 0), 1, "🔊 Âm lượng: 50%", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left

local volumeBarBg = Instance.new("Frame", volumeFrame)
volumeBarBg.Size, volumeBarBg.Position, volumeBarBg.BackgroundColor3 = UDim2.new(0, 110, 0, 8), UDim2.new(1, -118, 0.5, -4), Color3.fromRGB(35, 40, 50)
Instance.new("UICorner", volumeBarBg).CornerRadius = UDim.new(1, 0)

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
        local absPos = volumeBarBg.AbsolutePosition.X
        local absSize = volumeBarBg.AbsoluteSize.X
        local mouseX = input.Position.X
        local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
        volumeBarFill.Size = UDim2.new(percent, 0, 1, 0)
        HubSound.Volume = percent
        volumeLabel.Text = "🔊 Âm lượng: " .. math.floor(percent * 100) .. "%"
    end
end)

-- CHỌN MÀU
local colorList = {
    {Name = "🖤 Xám Tối Mặc Định", Color = Color3.fromRGB(15, 16, 22)},
    {Name = "🌈 Màu Cầu Vồng (RGB)", Color = "Rainbow"},
    {Name = "🌸 Hồng Kẹo Đắng", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "🔴 Đỏ Đậm", Color = Color3.fromRGB(220, 20, 60)},
    {Name = "🔵 Xanh Dương Neon", Color = Color3.fromRGB(0, 191, 255)},
    {Name = "🟢 Xanh Lá Cây", Color = Color3.fromRGB(50, 205, 50)},
    {Name = "🟡 Vàng Nổi Bật", Color = Color3.fromRGB(255, 215, 0)},
    {Name = "🟣 Tím Mộng Mơ", Color = Color3.fromRGB(138, 43, 226)}
}
local selectedColorObj = colorList[1]
local isColorApplied = false

local colorDropBtn = Instance.new("TextButton", t6Scroll)
colorDropBtn.LayoutOrder = 11
colorDropBtn.Size, colorDropBtn.BackgroundColor3, colorDropBtn.Text, colorDropBtn.TextColor3, colorDropBtn.TextSize, colorDropBtn.Font, colorDropBtn.TextXAlignment = UDim2.new(1, -4, 0, 32), Color3.fromRGB(22, 25, 34), " 🎨 Đã chọn: 🖤 Xám Tối Mặc Định", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", colorDropBtn).CornerRadius = UDim.new(0, 5)

local colorDropFrame = Instance.new("ScrollingFrame", DropdownGui)
colorDropFrame.Size, colorDropFrame.BackgroundColor3, colorDropFrame.CanvasSize, colorDropFrame.ScrollBarThickness, colorDropFrame.Visible, colorDropFrame.ZIndex = UDim2.new(0, 320, 0, 130), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false, 999999
Instance.new("UICorner", colorDropFrame).CornerRadius = UDim.new(0, 5)
local colorLayout = Instance.new("UIListLayout", colorDropFrame) colorLayout.Padding = UDim.new(0, 4)

for i, cItem in ipairs(colorList) do
    local cBtn = Instance.new("TextButton", colorDropFrame)
    cBtn.LayoutOrder = i
    cBtn.Size, cBtn.BackgroundColor3, cBtn.Text, cBtn.TextColor3, cBtn.TextSize, cBtn.Font, cBtn.TextXAlignment, cBtn.ZIndex = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), " " .. cItem.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left, 999999
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    cBtn.MouseButton1Click:Connect(function()
        selectedColorObj = cItem
        colorDropBtn.Text = " 🎨 Đã chọn: " .. cItem.Name
        colorDropFrame.Visible = false
    end)
end
colorDropFrame.CanvasSize = UDim2.new(0, 0, 0, #colorList * 30)

-- HÀM FIX TỌA ĐỘ DROPDOWN TRỰC TIẾP DỰA TRÊN MÀN HÌNH NỀN GỐC (SCREEN GUI) ĐỂ KHÔNG BAO GIỜ BỊ LỆCH KHI CUỘN
local function showAbsoluteDropdown(drop, btn)
    local screenPoint = btn.AbsolutePosition
    local screenSize = btn.AbsoluteSize
    drop.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y + screenSize.Y + 4)
    drop.Visible = not drop.Visible
    
    if drop ~= dropFrame then dropFrame.Visible = false end
    if drop ~= musicDropFrame then musicDropFrame.Visible = false end
    if drop ~= colorDropFrame then colorDropFrame.Visible = false end
    if drop ~= delDropScroll then delDropScroll.Visible = false end
    if drop ~= startDropScroll then startDropScroll.Visible = false end
    if drop ~= loadDropScroll then loadDropScroll.Visible = false end
end

colorDropBtn.MouseButton1Click:Connect(function() showAbsoluteDropdown(colorDropFrame, colorDropBtn) end)
musicDropBtn.MouseButton1Click:Connect(function() showAbsoluteDropdown(musicDropFrame, musicDropBtn) end)
dropBtn.MouseButton1Click:Connect(function() showAbsoluteDropdown(dropFrame, dropBtn) end)
delDropBtn.MouseButton1Click:Connect(function() refreshAllProfileDropdowns() showAbsoluteDropdown(delDropScroll, delDropBtn) end)
startDropBtn.MouseButton1Click:Connect(function() refreshAllProfileDropdowns() showAbsoluteDropdown(startDropScroll, startDropBtn) end)
loadDropBtn.MouseButton1Click:Connect(function() refreshAllProfileDropdowns() showAbsoluteDropdown(loadDropScroll, loadDropBtn) end)

local toggleColorBtn = Instance.new("TextButton", t6Scroll)
toggleColorBtn.LayoutOrder = 12
toggleColorBtn.Size, toggleColorBtn.BackgroundColor3, toggleColorBtn.Text, toggleColorBtn.TextColor3, toggleColorBtn.TextSize, toggleColorBtn.Font = UDim2.new(1, -4, 0, 32), Color3.fromRGB(200, 50, 50), "Màu Menu Tùy Chỉnh: TẮT ❌", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", toggleColorBtn).CornerRadius = UDim.new(0, 5)

toggleColorBtn.MouseButton1Click:Connect(function()
    isColorApplied = not isColorApplied
    if isColorApplied then
        toggleColorBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        toggleColorBtn.Text = "Màu Menu Tùy Chỉnh: BẬT ✅"
    else
        toggleColorBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleColorBtn.Text = "Màu Menu Tùy Chỉnh: TẮT ❌"
        SidebarPanel.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
        ContentContainer.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    end
end)

RunService.RenderStepped:Connect(function()
    if isColorApplied then
        if selectedColorObj.Color == "Rainbow" then
            local rainbowColor = Color3.fromHSV((tick() % 4) / 4, 1, 1)
            SidebarPanel.BackgroundColor3 = rainbowColor
            ContentContainer.BackgroundColor3 = rainbowColor
        elseif typeof(selectedColorObj.Color) == "Color3" then
            SidebarPanel.BackgroundColor3 = selectedColorObj.Color
            ContentContainer.BackgroundColor3 = selectedColorObj.Color
        end
    end
end)

t6Scroll.CanvasSize = UDim2.new(0, 0, 0, 850)
-- RESIZE GÓC PHẢI DƯỚI
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size = UDim2.new(0, 16, 0, 16)
ResizeBtn.Position = UDim2.new(1, -18, 1, -18)
ResizeBtn.BackgroundTransparency = 1
ResizeBtn.Text = "◢"
ResizeBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
ResizeBtn.TextSize = 12
ResizeBtn.Font = Enum.Font.FredokaOne

local resizing = false
local startInput, startSize

ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        startInput = input.Position
        startSize = MainFrame.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startInput
        local newX = math.max(400, startSize.X.Offset + delta.X)
        local newY = math.max(260, startSize.Y.Offset + delta.Y)
        MainFrame.Size = UDim2.new(0, newX, 0, newY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

local function refreshAllProfileDropdowns()
    for _, c in ipairs(delDropScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, c in ipairs(startDropScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, c in ipairs(loadDropScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    
    if typeof(listfiles) ~= "function" then return end
    local success, files = pcall(listfiles, configFolder)
    if success and files then
        local hDel, hStart, hLoad = 0, 0, 0
        local idx = 0
        for _, file in ipairs(files) do
            idx = idx + 1
            local fName = file:match("([^/]+)$"):gsub("%.json$", "")
            
            local b1 = Instance.new("TextButton", delDropScroll)
            b1.LayoutOrder = idx
            b1.Size, b1.BackgroundColor3, b1.Text, b1.TextColor3, b1.TextSize, b1.Font, b1.TextXAlignment, b1.ZIndex = UDim2.new(1, 0, 0, 24), Color3.fromRGB(35, 40, 50), " " .. fName, Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne, Enum.TextXAlignment.Left, 999999
            Instance.new("UICorner", b1).CornerRadius = UDim.new(0, 3)
            b1.MouseButton1Click:Connect(function() selectedDeleteConfig = fName delDropBtn.Text = fName delDropScroll.Visible = false end)
            hDel = hDel + 26

            local b2 = Instance.new("TextButton", startDropScroll)
            b2.LayoutOrder = idx
            b2.Size, b2.BackgroundColor3, b2.Text, b2.TextColor3, b2.TextSize, b2.Font, b2.TextXAlignment, b2.ZIndex = UDim2.new(1, 0, 0, 24), Color3.fromRGB(35, 40, 50), " " .. fName, Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne, Enum.TextXAlignment.Left, 999999
            Instance.new("UICorner", b2).CornerRadius = UDim.new(0, 3)
            b2.MouseButton1Click:Connect(function() 
                selectedStartConfig = fName 
                startDropBtn.Text = fName 
                startDropScroll.Visible = false 
                if typeof(writefile) == "function" then pcall(writefile, configFolder .. "/autodefault.txt", fName) end
            end)
            hStart = hStart + 26

            local b3 = Instance.new("TextButton", loadDropScroll)
            b3.LayoutOrder = idx
            b3.Size, b3.BackgroundColor3, b3.Text, b3.TextColor3, b3.TextSize, b3.Font, b3.TextXAlignment, b3.ZIndex = UDim2.new(1, 0, 0, 24), Color3.fromRGB(35, 40, 50), " " .. fName, Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne, Enum.TextXAlignment.Left, 999999
            Instance.new("UICorner", b3).CornerRadius = UDim.new(0, 3)
            b3.MouseButton1Click:Connect(function() selectedLoadConfig = fName loadDropBtn.Text = fName loadDropScroll.Visible = false end)
            hLoad = hLoad + 26
        end
        delDropScroll.CanvasSize = UDim2.new(0, 0, 0, hDel)
        startDropScroll.CanvasSize = UDim2.new(0, 0, 0, hStart)
        loadDropScroll.CanvasSize = UDim2.new(0, 0, 0, hLoad)
    end
end

createBtn.MouseButton1Click:Connect(function()
    local cName = newConfigInput.Text
    if cName ~= "" and typeof(writefile) == "function" then
        pcall(writefile, configFolder .. "/" .. cName .. ".json", HttpService:JSONEncode({
            Script = selScript and selScript.Name or "", 
            SoundId = currentSoundId
        }))
        selectedLoadConfig = cName
        loadDropBtn.Text = cName
        saveSub.Text = "Save: " .. cName
        createBtn.Text = "Created!"
        task.wait(1.5)
        createBtn.Text = "Create New"
        newConfigInput.Text = ""
        refreshAllProfileDropdowns()
    end
end)

delDropBtn.MouseButton1Click:Connect(function()
    if selectedDeleteConfig ~= "" and typeof(delfile) == "function" then
        local target = configFolder .. "/" .. selectedDeleteConfig .. ".json"
        if isfile(target) then
            pcall(delfile, target)
            delDropBtn.Text = "Không có"
            selectedDeleteConfig = ""
            refreshAllProfileDropdowns()
        end
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    local cName = selectedLoadConfig ~= "" and selectedLoadConfig or "Default"
    if typeof(writefile) == "function" then
        pcall(writefile, configFolder .. "/" .. cName .. ".json", HttpService:JSONEncode({
            Script = selScript and selScript.Name or "", 
            SoundId = currentSoundId
        }))
        saveSub.Text = "Save: " .. cName
        saveBtn.Text = "Saved!"
        task.wait(1.5)
        saveBtn.Text = "Save"
        refreshAllProfileDropdowns()
    end
end)

local function loadConfigByName(cName)
    if cName ~= "" and typeof(readfile) == "function" and isfile(configFolder .. "/" .. cName .. ".json") then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(configFolder .. "/" .. cName .. ".json")) end)
        if success and data then
            if data.SoundId then
                currentSoundId = data.SoundId
                musicDropBtn.Text = " 🎵 ID: " .. currentSoundId
                if HubSound.IsPlaying then HubSound.SoundId = "rbxassetid://" .. currentSoundId HubSound:Play() end
            end
            if data.Script and data.Script ~= "" then
                for _, scr in ipairs(RegisteredScripts) do
                    if scr.Name == data.Script then
                        selScript = scr
                        dropBtn.Text = " 📜 " .. scr.Name
                        break
                    end
                end
            end
            saveSub.Text = "Save: " .. cName
            return true
        end
    end
    return false
end

loadDropBtn.MouseButton1Click:Connect(function()
    if loadConfigByName(selectedLoadConfig) then
        loadDropBtn.Text = selectedLoadConfig .. " (Loaded)"
        task.wait(1.5)
        loadDropBtn.Text = selectedLoadConfig
    end
end)

local dh = 0
for i, scr in ipairs(RegisteredScripts) do
    local item = Instance.new("TextButton", dropFrame)
    item.LayoutOrder = i
    item.Size, item.BackgroundColor3, item.Text, item.TextColor3, item.TextSize, item.Font, item.TextXAlignment, item.ZIndex = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), "  ▶ " .. scr.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left, 999999
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 4)
    item.MouseButton1Click:Connect(function() selScript = scr dropBtn.Text = " 📜 " .. scr.Name dropFrame.Visible = false end)
    dh = dh + 30
end
dropFrame.CanvasSize = UDim2.new(0, 0, 0, dh)

toggleAuto.MouseButton1Click:Connect(function()
    if not selScript then return end
    isAuto = not isAuto
    if isAuto then
        toggleAuto.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        toggleAuto.Text = "Auto Load Script Chạy: BẬT ✅"
        pcall(selScript.Callback)
    else
        toggleAuto.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleAuto.Text = "Auto Load Script Chạy: TẮT ❌"
    end
end)

-- NÚT AVATAR MỞ MENU VIỀN RAINBOW
local OpenButton = Instance.new("ImageButton", ScreenGui)
OpenButton.Name, OpenButton.Size, OpenButton.Position, OpenButton.BackgroundColor3, OpenButton.BorderSizePixel, OpenButton.Image, OpenButton.Active, OpenButton.Draggable = "VzNamOpenBtn", UDim2.new(0, 42, 0, 42), UDim2.new(0, 15, 0.2, 0), Color3.fromRGB(20, 22, 28), 0, avatarUrl, true, true
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
local OpenStroke = Instance.new("UIStroke", OpenButton) OpenStroke.Thickness = 3.5

RunService.RenderStepped:Connect(function()
    OpenStroke.Color = Color3.fromHSV((tick() % 4) / 4, 1, 1)
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

refreshAllProfileDropdowns()

-- TỰ ĐỘNG TẢI CẤU HÌNH STARTUP
pcall(function()
    if typeof(readfile) == "function" and isfile(configFolder .. "/autodefault.txt") then
        local defName = readfile(configFolder .. "/autodefault.txt")
        if defName and defName ~= "" then
            selectedLoadConfig = defName
            selectedStartConfig = defName
            startDropBtn.Text = defName
            loadDropBtn.Text = defName
            loadConfigByName(defName)
        end
    end
end)
