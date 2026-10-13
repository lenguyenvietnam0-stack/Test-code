task.spawn(function()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local SoundService = game:GetService("SoundService")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    
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

    local MainCorner = Instance.new("UICorner", MainFrame) 
    MainCorner.CornerRadius = UDim.new(0, 8)
    
    local OuterStroke = Instance.new("UIStroke", MainFrame) 
    OuterStroke.Color = Color3.fromRGB(0, 160, 255)
    OuterStroke.Thickness = 1.5
    OuterStroke.Transparency = 0.1
    table.insert(AllUIStrokes, OuterStroke)

    local TopBar = Instance.new("Frame", MainFrame) 
    TopBar.Size = UDim2.new(1, 0, 0, 28)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local Logo = Instance.new("ImageLabel", TopBar) 
    Logo.Size = UDim2.new(0, 18, 0, 18)
    Logo.Position = UDim2.new(0, 10, 0.5, -9)
    Logo.BackgroundTransparency = 1
    Logo.Image = avatarUrl
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 32, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🌸 VzNam Hub v4 🌸"
    Title.TextColor3 = Color3.fromRGB(255, 105, 180)
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Center

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -28, 0.5, -13)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
    CloseBtn.TextSize = 11
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.MouseButton1Click:Connect(function()
        if SoundService:FindFirstChild("VzNamHubSound") then 
            SoundService.VzNamHubSound:Destroy() 
        end
        ScreenGui:Destroy()
    end)

    local SidebarPanel = Instance.new("Frame", MainFrame)
    SidebarPanel.Name = "SidebarPanel"
    SidebarPanel.Size = UDim2.new(0, 145, 1, -34)
    SidebarPanel.Position = UDim2.new(0, 8, 0, 28)
    SidebarPanel.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    SidebarPanel.BackgroundTransparency = 0
    SidebarPanel.BorderSizePixel = 0
    Instance.new("UICorner", SidebarPanel).CornerRadius = UDim.new(0, 6)
    
    local SidebarStroke = Instance.new("UIStroke", SidebarPanel) 
    SidebarStroke.Color = Color3.fromRGB(0, 160, 255)
    SidebarStroke.Thickness = 1.5
    table.insert(AllUIStrokes, SidebarStroke)

    local SearchBoxTab = Instance.new("TextBox", SidebarPanel)
    SearchBoxTab.Size = UDim2.new(1, -10, 0, 24)
    SearchBoxTab.Position = UDim2.new(0, 5, 0, 5)
    SearchBoxTab.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    SearchBoxTab.BackgroundTransparency = 0
    SearchBoxTab.Text = ""
    SearchBoxTab.PlaceholderText = "🔍 Search section..."
    SearchBoxTab.PlaceholderColor3 = Color3.fromRGB(130, 135, 145)
    SearchBoxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBoxTab.TextSize = 10
    SearchBoxTab.Font = Enum.Font.Gotham
    Instance.new("UICorner", SearchBoxTab).CornerRadius = UDim.new(0, 4)

    local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
    SidebarScroll.Size = UDim2.new(1, -8, 1, -34)
    SidebarScroll.Position = UDim2.new(0, 4, 0, 32)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 2
    
    local SidebarLayout = Instance.new("UIListLayout", SidebarScroll) 
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    SidebarLayout.Padding = UDim.new(0, 4)

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

    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -160, 1, -34)
    ContentContainer.Position = UDim2.new(0, 156, 0, 28)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    ContentContainer.BackgroundTransparency = 0
    ContentContainer.BorderSizePixel = 0
    Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 6)
    
    local ContentStroke = Instance.new("UIStroke", ContentContainer) 
    ContentStroke.Color = Color3.fromRGB(0, 160, 255)
    ContentStroke.Thickness = 1.5
    table.insert(AllUIStrokes, ContentStroke)

    local ContentHeader = Instance.new("Frame", ContentContainer) 
    ContentHeader.Size = UDim2.new(1, 0, 0, 30)
    ContentHeader.BackgroundTransparency = 1

    local ActiveTabTitle = Instance.new("TextLabel", ContentHeader)
    ActiveTabTitle.Size = UDim2.new(1, -40, 1, 0)
    ActiveTabTitle.Position = UDim2.new(0, 12, 0, 0)
    ActiveTabTitle.BackgroundTransparency = 1
    ActiveTabTitle.Text = ""
    ActiveTabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActiveTabTitle.TextSize = 12
    ActiveTabTitle.Font = Enum.Font.GothamBold
    ActiveTabTitle.TextXAlignment = Enum.TextXAlignment.Left

    local SearchInputContent = Instance.new("TextBox", ContentHeader)
    SearchInputContent.Size = UDim2.new(1, -45, 0, 22)
    SearchInputContent.Position = UDim2.new(0, 10, 0.5, -11)
    SearchInputContent.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    SearchInputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchInputContent.PlaceholderText = "Search features..."
    SearchInputContent.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
    SearchInputContent.TextSize = 10
    SearchInputContent.Font = Enum.Font.Gotham
    SearchInputContent.Visible = false
    Instance.new("UICorner", SearchInputContent).CornerRadius = UDim.new(0, 4)

    local SearchContentIcon = Instance.new("TextButton", ContentHeader)
    SearchContentIcon.Size = UDim2.new(0, 24, 0, 24)
    SearchContentIcon.Position = UDim2.new(1, -28, 0.5, -12)
    SearchContentIcon.BackgroundTransparency = 1
    SearchContentIcon.Text = "🔍"
    SearchContentIcon.TextSize = 12
    SearchContentIcon.TextColor3 = Color3.fromRGB(200, 205, 215)

    local searching = false
    SearchContentIcon.MouseButton1Click:Connect(function()
        searching = not searching
        SearchInputContent.Visible = searching
        ActiveTabTitle.Visible = not searching
        if searching then SearchInputContent:CaptureFocus() else SearchInputContent.Text = "" end
    end)

    local Tabs = {}

    -- TRANG CHỦ
    local tabHomeBtn = Instance.new("TextButton", SidebarScroll)
    tabHomeBtn.LayoutOrder = 0
    tabHomeBtn.Size = UDim2.new(1, 0, 0, 32)
    tabHomeBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    tabHomeBtn.BackgroundTransparency = 0
    tabHomeBtn.Text = "   🏠 Trang Chủ"
    tabHomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabHomeBtn.TextSize = 11
    tabHomeBtn.Font = Enum.Font.Gotham
    tabHomeBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabHomeBtn).CornerRadius = UDim.new(0, 5)
    local tabHomeStroke = Instance.new("UIStroke", tabHomeBtn) 
    tabHomeStroke.Color = Color3.fromRGB(0, 160, 255)
    tabHomeStroke.Thickness = 1.5
    table.insert(AllUIStrokes, tabHomeStroke)

    local homeIndicator = Instance.new("Frame", tabHomeBtn)
    homeIndicator.Size = UDim2.new(0, 3, 0, 14)
    homeIndicator.Position = UDim2.new(0, 0, 0.5, -7)
    homeIndicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    homeIndicator.BorderSizePixel = 0
    homeIndicator.Visible = false
    Instance.new("UICorner", homeIndicator).CornerRadius = UDim.new(0, 2)

    local homeScroll = Instance.new("ScrollingFrame", ContentContainer)
    homeScroll.Name = "Container_HOME"
    homeScroll.Size = UDim2.new(1, -12, 1, -38)
    homeScroll.Position = UDim2.new(0, 6, 0, 34)
    homeScroll.BackgroundTransparency = 1
    homeScroll.BorderSizePixel = 0
    homeScroll.ScrollBarThickness = 3
    homeScroll.Visible = false
    homeScroll.ClipsDescendants = true
    
    local homeLayout = Instance.new("UIListLayout", homeScroll) 
    homeLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    homeLayout.Padding = UDim.new(0, 6)

    tabHomeBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do 
            t.Container.Visible = false 
            if t.Indicator then t.Indicator.Visible = false end 
        end
        homeScroll.Visible = true 
        homeIndicator.Visible = true 
        ActiveTabTitle.Text = "🏠 Trang Chủ"
        SearchInputContent.Text = ""
    end)

    table.insert(Tabs, { Container = homeScroll, Indicator = homeIndicator })
    homeScroll.Visible = true 
    homeIndicator.Visible = true
    ActiveTabTitle.Text = "🏠 Trang Chủ"

    local function CreateHomeCardWithIcon(parent, order, bgColor, titleText, mainText, copyText, borderColor, iconSymbol)
        local card = Instance.new("Frame", parent)
        card.LayoutOrder = order
        card.Size = UDim2.new(1, -4, 0, 42)
        card.BackgroundColor3 = bgColor
        card.BorderSizePixel = 0
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", card) 
        stroke.Color = Color3.fromRGB(0, 160, 255)
        stroke.Thickness = 1.5
        table.insert(AllUIStrokes, stroke)

        local iconCircle = Instance.new("Frame", card)
        iconCircle.Size = UDim2.new(0, 30, 0, 30)
        iconCircle.Position = UDim2.new(0, 6, 0.5, -15)
        iconCircle.BackgroundColor3 = borderColor
        iconCircle.BorderSizePixel = 0
        Instance.new("UICorner", iconCircle).CornerRadius = UDim.new(1, 0)
        
        local iconLbl = Instance.new("TextLabel", iconCircle)
        iconLbl.Size = UDim2.new(1, 0, 1, 0)
        iconLbl.BackgroundTransparency = 1
        iconLbl.Text = iconSymbol
        iconLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        iconLbl.TextSize = 13
        iconLbl.Font = Enum.Font.GothamBold

        local tLbl = Instance.new("TextLabel", card)
        tLbl.Size = UDim2.new(1, -120, 0, 14)
        tLbl.Position = UDim2.new(0, 44, 0, 4)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = titleText
        tLbl.TextColor3 = Color3.fromRGB(255, 150, 100)
        tLbl.TextSize = 9
        tLbl.Font = Enum.Font.GothamBold
        tLbl.TextXAlignment = Enum.TextXAlignment.Left

        local mLbl = Instance.new("TextLabel", card)
        mLbl.Size = UDim2.new(1, -120, 0, 18)
        mLbl.Position = UDim2.new(0, 44, 0, 19)
        mLbl.BackgroundTransparency = 1
        mLbl.Text = mainText
        mLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        mLbl.TextSize = 9
        mLbl.Font = Enum.Font.Gotham
        mLbl.TextXAlignment = Enum.TextXAlignment.Left

        if copyText ~= "" then
            local copyBtn = Instance.new("TextButton", card)
            copyBtn.Size = UDim2.new(0, 65, 0, 24)
            copyBtn.Position = UDim2.new(1, -73, 0.5, -12)
            copyBtn.BackgroundTransparency = 1
            copyBtn.Text = "📋 COPY"
            copyBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
            copyBtn.TextSize = 10
            copyBtn.Font = Enum.Font.GothamBold
            
            local function doCopy()
                if typeof(setclipboard) == "function" then
                    pcall(setclipboard, copyText)
                    copyBtn.Text = "✓ COPIED"
                    task.delay(1.5, function() copyBtn.Text = "📋 COPY" end)
                end
            end
            copyBtn.MouseButton1Click:Connect(doCopy)
        end
    end

    CreateHomeCardWithIcon(homeScroll, 1, Color3.fromRGB(45, 25, 30), "ĐƯỢC TẠO BỞI", "VzNam ROBLOX", "", Color3.fromRGB(180, 50, 50), "👤")
    CreateHomeCardWithIcon(homeScroll, 2, Color3.fromRGB(30, 35, 55), "DISCORD SERVER", "https://discord.gg/6TG7krbsU", "https://discord.gg/6TG7krbsU", Color3.fromRGB(60, 100, 200), "💬")
    CreateHomeCardWithIcon(homeScroll, 3, Color3.fromRGB(35, 35, 45), "TIKTOK CHANNEL", "https://www.tiktok.com/@uttop1gl.ovo", "https://www.tiktok.com/@uttop1gl.ovo", Color3.fromRGB(100, 100, 120), "🎵")

    homeScroll.CanvasSize = UDim2.new(0, 0, 0, 160)

    local function CreateCategoryTab(tabName)
        local tabBtn = Instance.new("TextButton", SidebarScroll)
        tabBtn.Size = UDim2.new(1, 0, 0, 32)
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
        tabBtn.BackgroundTransparency = 0
        tabBtn.Text = "   " .. tabName
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 11
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
        local tabStroke = Instance.new("UIStroke", tabBtn) 
        tabStroke.Color = Color3.fromRGB(0, 160, 255)
        tabStroke.Thickness = 1.5
        table.insert(AllUIStrokes, tabStroke)

        local indicator = Instance.new("Frame", tabBtn)
        indicator.Size = UDim2.new(0, 3, 0, 14)
        indicator.Position = UDim2.new(0, 0, 0.5, -7)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

        local containerFrame = Instance.new("Frame", ContentContainer)
        containerFrame.Name = "Container_" .. tabName
        containerFrame.Size = UDim2.new(1, -12, 1, -38)
        containerFrame.Position = UDim2.new(0, 6, 0, 34)
        containerFrame.BackgroundTransparency = 1
        containerFrame.Visible = false

        local subBar = Instance.new("Frame", containerFrame) 
        subBar.Size = UDim2.new(1, 0, 0, 26)
        subBar.BackgroundTransparency = 1
        local subLayout = Instance.new("UIListLayout", subBar) 
        subLayout.FillDirection = Enum.FillDirection.Horizontal 
        subLayout.Padding = UDim.new(0, 6)

        local noKeyBtn = Instance.new("TextButton", subBar)
        noKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
        noKeyBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
        noKeyBtn.Text = "no key"
        noKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        noKeyBtn.TextSize = 11
        noKeyBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", noKeyBtn).CornerRadius = UDim.new(0, 5)
        local nkStroke = Instance.new("UIStroke", noKeyBtn) 
        nkStroke.Color = Color3.fromRGB(255, 50, 50)
        nkStroke.Thickness = 2

        local hasKeyBtn = Instance.new("TextButton", subBar)
        hasKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
        hasKeyBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
        hasKeyBtn.Text = "có key"
        hasKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        hasKeyBtn.TextSize = 11
        hasKeyBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", hasKeyBtn).CornerRadius = UDim.new(0, 5)
        local hkStroke = Instance.new("UIStroke", hasKeyBtn) 
        hkStroke.Color = Color3.fromRGB(0, 160, 255)
        hkStroke.Thickness = 1.5
        table.insert(AllUIStrokes, hkStroke)

        local scrollNoKey = Instance.new("ScrollingFrame", containerFrame) 
        scrollNoKey.Position = UDim2.new(0, 0, 0, 32)
        scrollNoKey.Size = UDim2.new(1, 0, 1, -32)
        scrollNoKey.BackgroundTransparency = 1
        scrollNoKey.BorderSizePixel = 0
        scrollNoKey.ScrollBarThickness = 3
        scrollNoKey.Visible = true
        scrollNoKey.ClipsDescendants = true
        local l1 = Instance.new("UIListLayout", scrollNoKey) 
        l1.Padding = UDim.new(0, 5)

        local scrollHasKey = Instance.new("ScrollingFrame", containerFrame) 
        scrollHasKey.Position = UDim2.new(0, 0, 0, 32)
        scrollHasKey.Size = UDim2.new(1, 0, 1, -32)
        scrollHasKey.BackgroundTransparency = 1
        scrollHasKey.BorderSizePixel = 0
        scrollHasKey.ScrollBarThickness = 3
        scrollHasKey.Visible = false
        scrollHasKey.ClipsDescendants = true
        local l2 = Instance.new("UIListLayout", scrollHasKey) 
        l2.Padding = UDim.new(0, 5)

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
            scrollNoKey.Visible = true 
            scrollHasKey.Visible = false
            nkStroke.Color = Color3.fromRGB(255, 50, 50)
            hkStroke.Color = Color3.fromRGB(0, 160, 255)
        end)
        hasKeyBtn.MouseButton1Click:Connect(function()
            scrollNoKey.Visible = false 
            scrollHasKey.Visible = true
            hkStroke.Color = Color3.fromRGB(255, 50, 50)
            nkStroke.Color = Color3.fromRGB(0, 160, 255)
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
            Btn.Size = UDim2.new(1, -4, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
            Btn.Text = "  ▶ " .. name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 11
            Btn.Font = Enum.Font.Gotham
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
            local btnStroke = Instance.new("UIStroke", Btn) 
            btnStroke.Color = Color3.fromRGB(0, 160, 255)
            btnStroke.Thickness = 1.5
            table.insert(AllUIStrokes, btnStroke)
            
            Btn.MouseButton1Click:Connect(function()
                if LastSelectedScriptStroke then 
                    LastSelectedScriptStroke.Color = Color3.fromRGB(0, 160, 255)
                    LastSelectedScriptStroke.Thickness = 1.5 
                end
                btnStroke.Color = Color3.fromRGB(255, 50, 50)
                btnStroke.Thickness = 2
                LastSelectedScriptStroke = btnStroke
                callback()
            end)
            table.insert(RegisteredScripts, { Name = name, Callback = callback })
        end

        function Elements:AddNoKey(name, callback) AddBtnTo(scrollNoKey, name, callback) end
        function Elements:AddHasKey(name, callback) AddBtnTo(scrollHasKey, name, callback) end
        return Elements
    end

    -- TAB 1: STEAL AN EGG
    local tab1 = CreateCategoryTab("🌸STEAL AN EGG🌸")
    tab1:AddNoKey("1. Hop sv1 người(nokey)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
    tab1:AddNoKey("2. FyyCommunity", function() loadstring(game:HttpGet("https://FyyCommunity.my.id"))() end)
    tab1:AddNoKey("3. Chilli Hub V4(nokey)", function() loadstring(game:HttpGet("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4"))() end)
    tab1:AddNoKey("4. Night hub(nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"))() end)

    tab1:AddHasKey("1. Lemon Hub v4(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt", true))() end)
    tab1:AddHasKey("2. Hoshi hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua"))() end)
    tab1:AddHasKey("3. Bigfroot(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))() end)
    tab1:AddHasKey("4. Chữ A(ajjans)", function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"))() end)
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
    tab2:AddHasKey("3. TeddyHub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))() end)
    tab2:AddHasKey("4. Gravity Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))() end)
    tab2:AddHasKey("5. Realkid hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() end)
    tab2:AddHasKey("6. BananaHub(có key)", function() getgenv().Team = "Marines" loadstring(game:HttpGet("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua"))() end)

    local tab3 = CreateCategoryTab("🌸BREAK AN STEAL🌸")
    tab3:AddNoKey("1. break and steal an egg", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))() end)

    local tab4 = CreateCategoryTab("Tab 4")
    local tab5 = CreateCategoryTab("Tab 5")

    -- TAB 6: MISC (TÙY CHỈNH & ÂM NHẠC)
    local tabMiscBtn = Instance.new("TextButton", SidebarScroll)
    tabMiscBtn.Size = UDim2.new(1, 0, 0, 32)
    tabMiscBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    tabMiscBtn.BackgroundTransparency = 0
    tabMiscBtn.Text = "   ⚙️ MISC"
    tabMiscBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMiscBtn.TextSize = 11
    tabMiscBtn.Font = Enum.Font.Gotham
    tabMiscBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabMiscBtn).CornerRadius = UDim.new(0, 5)
    local tabMiscStroke = Instance.new("UIStroke", tabMiscBtn) 
    tabMiscStroke.Color = Color3.fromRGB(0, 160, 255)
    tabMiscStroke.Thickness = 1.5
    table.insert(AllUIStrokes, tabMiscStroke)

    local miscIndicator = Instance.new("Frame", tabMiscBtn)
    miscIndicator.Size = UDim2.new(0, 3, 0, 14)
    miscIndicator.Position = UDim2.new(0, 0, 0.5, -7)
    miscIndicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    miscIndicator.BorderSizePixel = 0
    miscIndicator.Visible = false
    Instance.new("UICorner", miscIndicator).CornerRadius = UDim.new(0, 2)

    local miscScroll = Instance.new("ScrollingFrame", ContentContainer)
    miscScroll.Name = "Container_MISC"
    miscScroll.Size = UDim2.new(1, -12, 1, -38)
    miscScroll.Position = UDim2.new(0, 6, 0, 34)
    miscScroll.BackgroundTransparency = 1
    miscScroll.BorderSizePixel = 0
    miscScroll.ScrollBarThickness = 3
    miscScroll.Visible = false
    miscScroll.ClipsDescendants = true
    local miscLayout = Instance.new("UIListLayout", miscScroll) 
    miscLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    miscLayout.Padding = UDim.new(0, 8)

    tabMiscBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
        miscScroll.Visible = true 
        miscIndicator.Visible = true 
        ActiveTabTitle.Text = "⚙️ MISC"
    end)
    table.insert(Tabs, { Container = miscScroll, Indicator = miscIndicator })

    -- MISC: AUTO LOAD SCRIPT
    local autoLoadToggleBtn = Instance.new("TextButton", miscScroll)
    autoLoadToggleBtn.LayoutOrder = 1
    autoLoadToggleBtn.Size = UDim2.new(1, -4, 0, 42)
    autoLoadToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    autoLoadToggleBtn.Text = "  ↓ auto load script"
    autoLoadToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoLoadToggleBtn.TextSize = 13
    autoLoadToggleBtn.Font = Enum.Font.GothamBold
    autoLoadToggleBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", autoLoadToggleBtn).CornerRadius = UDim.new(0, 5)
    local alStroke = Instance.new("UIStroke", autoLoadToggleBtn) 
    alStroke.Color = Color3.fromRGB(0, 160, 255)
    alStroke.Thickness = 1.5
    table.insert(AllUIStrokes, alStroke)

    local alSubLabel = Instance.new("TextLabel", autoLoadToggleBtn)
    alSubLabel.Size = UDim2.new(1, 0, 0, 16)
    alSubLabel.Position = UDim2.new(0, 0, 1, -16)
    alSubLabel.BackgroundTransparency = 1
    alSubLabel.Text = "Quản lý auto load script"
    alSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
    alSubLabel.TextSize = 9
    alSubLabel.Font = Enum.Font.Gotham
    alSubLabel.TextXAlignment = Enum.TextXAlignment.Center

    local autoLoadContainer = Instance.new("Frame", miscScroll)
    autoLoadContainer.LayoutOrder = 2
    autoLoadContainer.Size = UDim2.new(1, -4, 0, 0)
    autoLoadContainer.AutomaticSize = Enum.AutomaticSize.Y
    autoLoadContainer.BackgroundTransparency = 1
    local alLayout = Instance.new("UIListLayout", autoLoadContainer) 
    alLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    alLayout.Padding = UDim.new(0, 5)

    autoLoadToggleBtn.MouseButton1Click:Connect(function()
        autoLoadContainer.Visible = not autoLoadContainer.Visible
        autoLoadToggleBtn.Text = autoLoadContainer.Visible and "  ↓ auto load script" or "  → auto load script"
        alSubLabel.Visible = autoLoadContainer.Visible
    end)

    local selScript, isAuto = nil, false
    local dropBtn = Instance.new("TextButton", autoLoadContainer)
    dropBtn.LayoutOrder = 1 
    dropBtn.Size = UDim2.new(1, 0, 0, 32)
    dropBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    dropBtn.Text = " 📜 Chọn Script Auto Load..."
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 11
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)
    local dropBtnStroke = Instance.new("UIStroke", dropBtn) 
    dropBtnStroke.Color = Color3.fromRGB(0, 160, 255)
    dropBtnStroke.Thickness = 1.5
    table.insert(AllUIStrokes, dropBtnStroke)

    local dropFrame = Instance.new("ScrollingFrame", autoLoadContainer)
    dropFrame.LayoutOrder = 2 
    dropFrame.Size = UDim2.new(1, 0, 0, 110)
    dropFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    dropFrame.CanvasSize = UDim2.new(0,0,0,0)
    dropFrame.ScrollBarThickness = 3
    dropFrame.Visible = false
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
    local dropFrameStroke = Instance.new("UIStroke", dropFrame) 
    dropFrameStroke.Color = Color3.fromRGB(0, 160, 255)
    dropFrameStroke.Thickness = 1.5
    table.insert(AllUIStrokes, dropFrameStroke)

    local dropLayout = Instance.new("UIListLayout", dropFrame) 
    dropLayout.Padding = UDim.new(0, 4)

    dropBtn.MouseButton1Click:Connect(function() dropFrame.Visible = not dropFrame.Visible end)

    local autoLoadScriptFrame = Instance.new("Frame", autoLoadContainer)
    autoLoadScriptFrame.LayoutOrder = 3 
    autoLoadScriptFrame.Size = UDim2.new(1, 0, 0, 38)
    autoLoadScriptFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", autoLoadScriptFrame).CornerRadius = UDim.new(0, 5) 
    local alsStroke = Instance.new("UIStroke", autoLoadScriptFrame) 
    alsStroke.Color = Color3.fromRGB(0, 160, 255)
    alsStroke.Thickness = 1.5
    table.insert(AllUIStrokes, alsStroke)

    local alsTitle = Instance.new("TextLabel", autoLoadScriptFrame)
    alsTitle.Size = UDim2.new(1, -50, 1, 0)
    alsTitle.Position = UDim2.new(0, 8, 0, 0)
    alsTitle.BackgroundTransparency = 1
    alsTitle.Text = "Auto Load Script Chạy"
    alsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    alsTitle.TextSize = 11
    alsTitle.Font = Enum.Font.GothamBold
    alsTitle.TextXAlignment = Enum.TextXAlignment.Left

    local toggleAutoBtn = Instance.new("TextButton", autoLoadScriptFrame)
    toggleAutoBtn.Size = UDim2.new(0, 38, 0, 20)
    toggleAutoBtn.Position = UDim2.new(1, -46, 0.5, -10)
    toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
    toggleAutoBtn.Text = ""
    Instance.new("UICorner", toggleAutoBtn).CornerRadius = UDim.new(1, 0)
    local autoDot = Instance.new("Frame", toggleAutoBtn)
    autoDot.Size = UDim2.new(0, 16, 0, 16)
    autoDot.Position = UDim2.new(0, 2, 0.5, -8)
    autoDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", autoDot).CornerRadius = UDim.new(1, 0)

    toggleAutoBtn.MouseButton1Click:Connect(function()
        if not selScript then return end
        isAuto = not isAuto
        if isAuto then
            toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
            autoDot.Position = UDim2.new(1, -18, 0.5, -8)
            pcall(selScript.Callback)
        else
            toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75) 
            autoDot.Position = UDim2.new(0, 2, 0.5, -8)
        end
    end)

    -- MISC: ÂM NHẠC NỀN
    local musicToggleBtn = Instance.new("TextButton", miscScroll)
    musicToggleBtn.LayoutOrder = 3
    musicToggleBtn.Size = UDim2.new(1, -4, 0, 42)
    musicToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    musicToggleBtn.Text = "  ↓ âm nhạc"
    musicToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicToggleBtn.TextSize = 13
    musicToggleBtn.Font = Enum.Font.GothamBold
    musicToggleBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", musicToggleBtn).CornerRadius = UDim.new(0, 5)
    local muStroke = Instance.new("UIStroke", musicToggleBtn) 
    muStroke.Color = Color3.fromRGB(0, 160, 255)
    muStroke.Thickness = 1.5
    table.insert(AllUIStrokes, muStroke)

    local muSubLabel = Instance.new("TextLabel", musicToggleBtn)
    muSubLabel.Size = UDim2.new(1, 0, 0, 16)
    muSubLabel.Position = UDim2.new(0, 0, 1, -16)
    muSubLabel.BackgroundTransparency = 1
    muSubLabel.Text = "Cài đặt âm nhạc nền"
    muSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
    muSubLabel.TextSize = 9
    muSubLabel.Font = Enum.Font.Gotham
    muSubLabel.TextXAlignment = Enum.TextXAlignment.Center

    local musicContainer = Instance.new("Frame", miscScroll)
    musicContainer.LayoutOrder = 4
    musicContainer.Size = UDim2.new(1, -4, 0, 0)
    musicContainer.AutomaticSize = Enum.AutomaticSize.Y
    musicContainer.BackgroundTransparency = 1
    local muLayout = Instance.new("UIListLayout", musicContainer) 
    muLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    muLayout.Padding = UDim.new(0, 5)

    musicToggleBtn.MouseButton1Click:Connect(function()
        musicContainer.Visible = not musicContainer.Visible
        musicToggleBtn.Text = musicContainer.Visible and "  ↓ âm nhạc" or "  → âm nhạc"
        muSubLabel.Visible = musicContainer.Visible
    end)

    local HubSound = SoundService:FindFirstChild("VzNamHubSound") or Instance.new("Sound", SoundService)
    HubSound.Name = "VzNamHubSound"
    HubSound.Looped = true
    HubSound.Volume = 0.5
    local currentSoundId = "1837879082"

    local customIdBox = Instance.new("TextBox", musicContainer)
    customIdBox.LayoutOrder = 1 
    customIdBox.Size = UDim2.new(1, 0, 0, 32)
    customIdBox.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    customIdBox.PlaceholderText = "🎶 Nhập Sound ID tùy chỉnh..."
    customIdBox.Text = ""
    customIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    customIdBox.TextSize = 11
    customIdBox.Font = Enum.Font.Gotham
    Instance.new("UICorner", customIdBox).CornerRadius = UDim.new(0, 5)
    local cidStroke = Instance.new("UIStroke", customIdBox) 
    cidStroke.Color = Color3.fromRGB(0, 160, 255)
    cidStroke.Thickness = 1.5
    table.insert(AllUIStrokes, cidStroke)

    local musicDropBtn = Instance.new("TextButton", musicContainer)
    musicDropBtn.LayoutOrder = 2 
    musicDropBtn.Size = UDim2.new(1, 0, 0, 32)
    musicDropBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    musicDropBtn.Text = " 🎵 Chọn Nhạc Nền..."
    musicDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicDropBtn.TextSize = 11
    musicDropBtn.Font = Enum.Font.Gotham
    musicDropBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", musicDropBtn).CornerRadius = UDim.new(0, 5)
    local mdbStroke = Instance.new("UIStroke", musicDropBtn) 
    mdbStroke.Color = Color3.fromRGB(0, 160, 255)
    mdbStroke.Thickness = 1.5
    table.insert(AllUIStrokes, mdbStroke)

    local musicDropFrame = Instance.new("ScrollingFrame", musicContainer)
    musicDropFrame.LayoutOrder = 3 
    musicDropFrame.Size = UDim2.new(1, 0, 0, 120)
    musicDropFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    musicDropFrame.CanvasSize = UDim2.new(0,0,0,0)
    musicDropFrame.ScrollBarThickness = 3
    musicDropFrame.Visible = false
    Instance.new("UICorner", musicDropFrame).CornerRadius = UDim.new(0, 5)
    local mdfStroke = Instance.new("UIStroke", musicDropFrame) 
    mdfStroke.Color = Color3.fromRGB(0, 160, 255)
    mdfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, mdfStroke)

    local musicLayout = Instance.new("UIListLayout", musicDropFrame) 
    musicLayout.Padding = UDim.new(0, 4)

    local presetMusics = {
        {Name = "🎵 Chill Lofi Music", Id = "1837879082"},
        {Name = "🎶 Phonk Beat", Id = "1843404008"},
        {Name = "🎵 Anime Relaxing", Id = "9043887091"},
        {Name = "🎶 EDM Hype", Id = "1837871000"}
    }
    for i, m in ipairs(presetMusics) do
        local mBtn = Instance.new("TextButton", musicDropFrame)
        mBtn.LayoutOrder = i 
        mBtn.Size = UDim2.new(1, 0, 0, 26)
        mBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
        mBtn.Text = " " .. m.Name
        mBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mBtn.TextSize = 11
        mBtn.Font = Enum.Font.Gotham
        mBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 4)
        local mbStroke = Instance.new("UIStroke", mBtn) 
        mbStroke.Color = Color3.fromRGB(0, 160, 255)
        mbStroke.Thickness = 1.5
        table.insert(AllUIStrokes, mbStroke)

        mBtn.MouseButton1Click:Connect(function()
            currentSoundId = m.Id 
            musicDropBtn.Text = " 🎵 " .. m.Name 
            musicDropFrame.Visible = false
            if HubSound.IsPlaying then 
                HubSound.SoundId = "rbxassetid://" .. currentSoundId 
                HubSound:Play() 
            end
        end)
    end
    musicDropFrame.CanvasSize = UDim2.new(0, 0, 0, #presetMusics * 30)
    musicDropBtn.MouseButton1Click:Connect(function() musicDropFrame.Visible = not musicDropFrame.Visible end)

    local musicToggleFrame = Instance.new("Frame", musicContainer)
    musicToggleFrame.LayoutOrder = 4 
    musicToggleFrame.Size = UDim2.new(1, 0, 0, 38)
    musicToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", musicToggleFrame).CornerRadius = UDim.new(0, 5) 
    local mtfStroke = Instance.new("UIStroke", musicToggleFrame) 
    mtfStroke.Color = Color3.fromRGB(0, 160, 255)
    mtfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, mtfStroke)

    local musicTitle = Instance.new("TextLabel", musicToggleFrame)
    musicTitle.Size = UDim2.new(1, -50, 1, 0)
    musicTitle.Position = UDim2.new(0, 8, 0, 0)
    musicTitle.BackgroundTransparency = 1
    musicTitle.Text = "Phát Nhạc Background"
    musicTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicTitle.TextSize = 11
    musicTitle.Font = Enum.Font.GothamBold
    musicTitle.TextXAlignment = Enum.TextXAlignment.Left

    local toggleMusicBtn = Instance.new("TextButton", musicToggleFrame)
    toggleMusicBtn.Size = UDim2.new(0, 38, 0, 20)
    toggleMusicBtn.Position = UDim2.new(1, -46, 0.5, -10)
    toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
    toggleMusicBtn.Text = ""
    Instance.new("UICorner", toggleMusicBtn).CornerRadius = UDim.new(1, 0)
    local musicDot = Instance.new("Frame", toggleMusicBtn)
    musicDot.Size = UDim2.new(0, 16, 0, 16)
    musicDot.Position = UDim2.new(0, 2, 0.5, -8)
    musicDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", musicDot).CornerRadius = UDim.new(1, 0)

    local isMusicPlaying = false
    toggleMusicBtn.MouseButton1Click:Connect(function()
        isMusicPlaying = not isMusicPlaying
        if isMusicPlaying then
            toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
            musicDot.Position = UDim2.new(1, -18, 0.5, -8)
            local customId = tonumber(customIdBox.Text)
            HubSound.SoundId = "rbxassetid://" .. (customId and tostring(customId) or currentSoundId)
            HubSound:Play()
        else
            toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75) 
            musicDot.Position = UDim2.new(0, 2, 0.5, -8)
            HubSound:Stop()
        end
    end)

    miscScroll.CanvasSize = UDim2.new(0, 0, 0, 600)

    -- CẤU HÌNH & PROFILES
    local tabConfigBtn = Instance.new("TextButton", SidebarScroll)
    tabConfigBtn.Size = UDim2.new(1, 0, 0, 32)
    tabConfigBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    tabConfigBtn.BackgroundTransparency = 0
    tabConfigBtn.Text = "   📦 CẤU HÌNH"
    tabConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabConfigBtn.TextSize = 11
    tabConfigBtn.Font = Enum.Font.Gotham
    tabConfigBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabConfigBtn).CornerRadius = UDim.new(0, 5)
    local tabConfigStroke = Instance.new("UIStroke", tabConfigBtn) 
    tabConfigStroke.Color = Color3.fromRGB(0, 160, 255)
    tabConfigStroke.Thickness = 1.5
    table.insert(AllUIStrokes, tabConfigStroke)

    local configIndicator = Instance.new("Frame", tabConfigBtn)
    configIndicator.Size = UDim2.new(0, 3, 0, 14)
    configIndicator.Position = UDim2.new(0, 0, 0.5, -7)
    configIndicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    configIndicator.BorderSizePixel = 0
    configIndicator.Visible = false
    Instance.new("UICorner", configIndicator).CornerRadius = UDim.new(0, 2)

    local configScroll = Instance.new("ScrollingFrame", ContentContainer)
    configScroll.Name = "Container_CONFIG"
    configScroll.Size = UDim2.new(1, -12, 1, -38)
    configScroll.Position = UDim2.new(0, 6, 0, 34)
    configScroll.BackgroundTransparency = 1
    configScroll.BorderSizePixel = 0
    configScroll.ScrollBarThickness = 3
    configScroll.Visible = false
    configScroll.ClipsDescendants = true
    local configLayout = Instance.new("UIListLayout", configScroll) 
    configLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    configLayout.Padding = UDim.new(0, 8)

    tabConfigBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Container.Visible = false if t.Indicator then t.Indicator.Visible = false end end
        configScroll.Visible = true 
        configIndicator.Visible = true 
        ActiveTabTitle.Text = "📦 CẤU HÌNH"
    end)
    table.insert(Tabs, { Container = configScroll, Indicator = configIndicator })

    local configFolder = "VzNamHub_Configs"
    if typeof(makefolder) == "function" then pcall(makefolder, configFolder) end

    local currentConfigName = "Default"
    local startupConfigName = "Default"

    local configToggleBtn = Instance.new("TextButton", configScroll)
    configToggleBtn.LayoutOrder = 1
    configToggleBtn.Size = UDim2.new(1, -4, 0, 42)
    configToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    configToggleBtn.Text = "  ↓ Cấu Hình"
    configToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    configToggleBtn.TextSize = 13
    configToggleBtn.Font = Enum.Font.GothamBold
    configToggleBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", configToggleBtn).CornerRadius = UDim.new(0, 5)
    local cfgStroke = Instance.new("UIStroke", configToggleBtn) 
    cfgStroke.Color = Color3.fromRGB(0, 160, 255)
    cfgStroke.Thickness = 1.5
    table.insert(AllUIStrokes, cfgStroke)

    local configSubLabel = Instance.new("TextLabel", configToggleBtn)
    configSubLabel.Size = UDim2.new(1, 0, 0, 16)
    configSubLabel.Position = UDim2.new(0, 0, 1, -16)
    configSubLabel.BackgroundTransparency = 1
    configSubLabel.Text = "Quản lý profile cấu hình"
    configSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
    configSubLabel.TextSize = 9
    configSubLabel.Font = Enum.Font.Gotham
    configSubLabel.TextXAlignment = Enum.TextXAlignment.Center

    local mainConfigContainer = Instance.new("Frame", configScroll)
    mainConfigContainer.LayoutOrder = 2
    mainConfigContainer.Size = UDim2.new(1, -4, 0, 0)
    mainConfigContainer.AutomaticSize = Enum.AutomaticSize.Y
    mainConfigContainer.BackgroundTransparency = 1
    local mainCfgLayout = Instance.new("UIListLayout", mainConfigContainer) 
    mainCfgLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    mainCfgLayout.Padding = UDim.new(0, 5)

    configToggleBtn.MouseButton1Click:Connect(function()
        mainConfigContainer.Visible = not mainConfigContainer.Visible
        configToggleBtn.Text = mainConfigContainer.Visible and "  ↓ Cấu Hình" or "  → Cấu Hình"
        configSubLabel.Visible = mainConfigContainer.Visible
    end)

    local newConfigFrame = Instance.new("Frame", mainConfigContainer)
    newConfigFrame.LayoutOrder = 1 
    newConfigFrame.Size = UDim2.new(1, 0, 0, 38)
    newConfigFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", newConfigFrame).CornerRadius = UDim.new(0, 5) 
    local ncStroke = Instance.new("UIStroke", newConfigFrame) 
    ncStroke.Color = Color3.fromRGB(0, 160, 255)
    ncStroke.Thickness = 1.5
    table.insert(AllUIStrokes, ncStroke)

    local ncLabel = Instance.new("TextLabel", newConfigFrame)
    ncLabel.Size = UDim2.new(0.5, 0, 1, 0)
    ncLabel.Position = UDim2.new(0, 8, 0, 0)
    ncLabel.BackgroundTransparency = 1
    ncLabel.Text = "Tên Cấu Hình Mới"
    ncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ncLabel.TextSize = 11
    ncLabel.Font = Enum.Font.Gotham
    ncLabel.TextXAlignment = Enum.TextXAlignment.Left

    local configNameBox = Instance.new("TextBox", newConfigFrame)
    configNameBox.Size = UDim2.new(0.45, 0, 0, 24)
    configNameBox.Position = UDim2.new(0.53, 0, 0.5, -12)
    configNameBox.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    configNameBox.PlaceholderText = "Nhap ten..."
    configNameBox.Text = ""
    configNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    configNameBox.TextSize = 10
    configNameBox.Font = Enum.Font.Gotham
    Instance.new("UICorner", configNameBox).CornerRadius = UDim.new(0, 4)

    local saveFrame = Instance.new("Frame", mainConfigContainer)
    saveFrame.LayoutOrder = 2 
    saveFrame.Size = UDim2.new(1, 0, 0, 42)
    saveFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", saveFrame).CornerRadius = UDim.new(0, 5) 
    local svStroke = Instance.new("UIStroke", saveFrame) 
    svStroke.Color = Color3.fromRGB(0, 160, 255)
    svStroke.Thickness = 1.5
    table.insert(AllUIStrokes, svStroke)

    local svTitle = Instance.new("TextLabel", saveFrame)
    svTitle.Size = UDim2.new(1, -110, 0, 20)
    svTitle.Position = UDim2.new(0, 8, 0, 3)
    svTitle.BackgroundTransparency = 1
    svTitle.Text = "Lưu Cấu Hình"
    svTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    svTitle.TextSize = 11
    svTitle.Font = Enum.Font.GothamBold
    svTitle.TextXAlignment = Enum.TextXAlignment.Left

    local saveBtn = Instance.new("TextButton", saveFrame)
    saveBtn.Size = UDim2.new(0, 95, 0, 26)
    saveBtn.Position = UDim2.new(1, -103, 0.5, -13)
    saveBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    saveBtn.Text = "Save"
    saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveBtn.TextSize = 10
    saveBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 4)

    saveBtn.MouseButton1Click:Connect(function()
        local name = configNameBox.Text ~= "" and configNameBox.Text or currentConfigName
        if typeof(writefile) == "function" then
            pcall(writefile, configFolder .. "/" .. name .. ".json", HttpService:JSONEncode({SavedTime = os.time()}))
            currentConfigName = name
            configNameBox.Text = ""
        end
    end)

    configScroll.CanvasSize = UDim2.new(0, 0, 0, 500)

    -- RAINBOW VIỀN TOÀN DIỆN
    RunService.RenderStepped:Connect(function()
        local rainbowColor = Color3.fromHSV((tick() % 4) / 4, 1, 1)
        for _, stroke in ipairs(AllUIStrokes) do
            if stroke and stroke.Parent then 
                stroke.Color = rainbowColor 
            end
        end
    end)

    -- NÚT MỞ/ĐÓNG MENU (ICON)
    local OpenButton = Instance.new("ImageButton", ScreenGui)
    OpenButton.Name = "VzNamOpenBtn"
    OpenButton.Size = UDim2.new(0, 42, 0, 42)
    OpenButton.Position = UDim2.new(0, 15, 0.2, 0)
    OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    OpenButton.BorderSizePixel = 0
    OpenButton.Image = avatarUrl
    OpenButton.Active = true
    OpenButton.Draggable = true
    Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
    
    local OpenStroke = Instance.new("UIStroke", OpenButton) 
    OpenStroke.Thickness = 3.5
    RunService.RenderStepped:Connect(function()
        OpenStroke.Color = Color3.fromHSV((tick() % 4) / 4, 1, 1)
    end)

    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end)
