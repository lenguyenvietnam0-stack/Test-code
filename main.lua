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

    -- TAB 6: MISC (CÓ ĐỦ TÍNH NĂNG CHỈNH MÀU MENU / VIỀN)
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
    Instance.new("UICorner", indicator or miscIndicator).CornerRadius = UDim.new(0, 2)

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

    -- MISC SECTION: MÀU MENU (CHỈNH MÀU NỀN & MÀU VIỀN)
    local colorToggleBtn = Instance.new("TextButton", miscScroll)
    colorToggleBtn.LayoutOrder = 1
    colorToggleBtn.Size = UDim2.new(1, -4, 0, 42)
    colorToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    colorToggleBtn.Text = "  ↓ màu menu"
    colorToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorToggleBtn.TextSize = 13
    colorToggleBtn.Font = Enum.Font.GothamBold
    colorToggleBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", colorToggleBtn).CornerRadius = UDim.new(0, 5)
    local coStroke = Instance.new("UIStroke", colorToggleBtn) 
    coStroke.Color = Color3.fromRGB(0, 160, 255)
    coStroke.Thickness = 1.5
    table.insert(AllUIStrokes, coStroke)

    local coSubLabel = Instance.new("TextLabel", colorToggleBtn)
    coSubLabel.Size = UDim2.new(1, 0, 0, 16)
    coSubLabel.Position = UDim2.new(0, 0, 1, -16)
    coSubLabel.BackgroundTransparency = 1
    coSubLabel.Text = "Tùy chỉnh màu sắc giao diện"
    coSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
    coSubLabel.TextSize = 9
    coSubLabel.Font = Enum.Font.Gotham
    coSubLabel.TextXAlignment = Enum.TextXAlignment.Center

    local colorContainer = Instance.new("Frame", miscScroll)
    colorContainer.LayoutOrder = 2
    colorContainer.Size = UDim2.new(1, -4, 0, 0)
    colorContainer.AutomaticSize = Enum.AutomaticSize.Y
    colorContainer.BackgroundTransparency = 1
    local coLayout = Instance.new("UIListLayout", colorContainer) 
    coLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    coLayout.Padding = UDim.new(0, 5)

    colorToggleBtn.MouseButton1Click:Connect(function()
        colorContainer.Visible = not colorContainer.Visible
        colorToggleBtn.Text = colorContainer.Visible and "  ↓ màu menu" or "  → màu menu"
        coSubLabel.Visible = colorContainer.Visible
    end)

    -- Tùy chọn màu viền menu
    local borderList = {
        {Name = "🔵 Xanh Dương (Mặc Định)", Color = Color3.fromRGB(0, 160, 255)},
        {Name = "🌈 Cầu Vồng", Color = "Rainbow"},
        {Name = "💖 Hồng Kẹo", Color = Color3.fromRGB(255, 105, 180)},
        {Name = "🟢 Xanh Lá", Color = Color3.fromRGB(50, 205, 50)},
        {Name = "🟡 Vàng Nổi Bật", Color = Color3.fromRGB(255, 215, 0)}
    }
    local selectedBorderObj = borderList[1]
    local borderDropBtn = Instance.new("TextButton", colorContainer)
    borderDropBtn.LayoutOrder = 1 
    borderDropBtn.Size = UDim2.new(1, 0, 0, 32)
    borderDropBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    borderDropBtn.Text = " 🖍️ Đã chọn màu viền: 🔵 Xanh Dương"
    borderDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    borderDropBtn.TextSize = 11
    borderDropBtn.Font = Enum.Font.Gotham
    borderDropBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", borderDropBtn).CornerRadius = UDim.new(0, 5)
    local bdbStroke = Instance.new("UIStroke", borderDropBtn) 
    bdbStroke.Color = Color3.fromRGB(0, 160, 255)
    bdbStroke.Thickness = 1.5
    table.insert(AllUIStrokes, bdbStroke)

    local borderDropFrame = Instance.new("ScrollingFrame", colorContainer)
    borderDropFrame.LayoutOrder = 2 
    borderDropFrame.Size = UDim2.new(1, 0, 0, 130)
    borderDropFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    borderDropFrame.CanvasSize = UDim2.new(0,0,0,0)
    borderDropFrame.ScrollBarThickness = 3
    borderDropFrame.Visible = false
    Instance.new("UICorner", borderDropFrame).CornerRadius = UDim.new(0, 5)
    local bdfStroke = Instance.new("UIStroke", borderDropFrame) 
    bdfStroke.Color = Color3.fromRGB(0, 160, 255)
    bdfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, bdfStroke)

    local borderLayout = Instance.new("UIListLayout", borderDropFrame) 
    borderLayout.Padding = UDim.new(0, 4)

    for i, bItem in ipairs(borderList) do
        local bBtn = Instance.new("TextButton", borderDropFrame)
        bBtn.LayoutOrder = i 
        bBtn.Size = UDim2.new(1, 0, 0, 26)
        bBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
        bBtn.Text = " " .. bItem.Name
        bBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        bBtn.TextSize = 11
        bBtn.Font = Enum.Font.Gotham
        bBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", bBtn).CornerRadius = UDim.new(0, 4)
        local bbStroke = Instance.new("UIStroke", bBtn) 
        bbStroke.Color = Color3.fromRGB(0, 160, 255)
        bbStroke.Thickness = 1.5
        table.insert(AllUIStrokes, bbStroke)

        bBtn.MouseButton1Click:Connect(function()
            selectedBorderObj = bItem 
            borderDropBtn.Text = " 🖍️ Đã chọn màu viền: " .. bItem.Name 
            borderDropFrame.Visible = false
        end)
    end
    borderDropFrame.CanvasSize = UDim2.new(0, 0, 0, #borderList * 30)
    borderDropBtn.MouseButton1Click:Connect(function() borderDropFrame.Visible = not borderDropFrame.Visible end)

    local borderToggleFrame = Instance.new("Frame", colorContainer)
    borderToggleFrame.LayoutOrder = 3 
    borderToggleFrame.Size = UDim2.new(1, 0, 0, 38)
    borderToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", borderToggleFrame).CornerRadius = UDim.new(0, 5) 
    local btfStroke = Instance.new("UIStroke", borderToggleFrame) 
    btfStroke.Color = Color3.fromRGB(0, 160, 255)
    btfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, btfStroke)

    local borderTitle = Instance.new("TextLabel", borderToggleFrame)
    borderTitle.Size = UDim2.new(1, -50, 1, 0)
    borderTitle.Position = UDim2.new(0, 8, 0, 0)
    borderTitle.BackgroundTransparency = 1
    borderTitle.Text = "Kích Hoạt Đổi Màu Viền"
    borderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    borderTitle.TextSize = 11
    borderTitle.Font = Enum.Font.GothamBold
    borderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBorderBtn = Instance.new("TextButton", borderToggleFrame)
    toggleBorderBtn.Size = UDim2.new(0, 38, 0, 20)
    toggleBorderBtn.Position = UDim2.new(1, -46, 0.5, -10)
    toggleBorderBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
    toggleBorderBtn.Text = ""
    Instance.new("UICorner", toggleBorderBtn).CornerRadius = UDim.new(1, 0)
    local borderDot = Instance.new("Frame", toggleBorderBtn)
    borderDot.Size = UDim2.new(0, 16, 0, 16)
    borderDot.Position = UDim2.new(0, 2, 0.5, -8)
    borderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", borderDot).CornerRadius = UDim.new(1, 0)

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

    miscScroll.CanvasSize = UDim2.new(0, 0, 0, 300)

    -- TAB 7: CẤU HÌNH & PROFILES (ĐỦ HỆ THỐNG PROFILES QUẢN LÝ CẤU HÌNH)
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

    -- Profiles Toggle Button
    local profilesToggleBtn = Instance.new("TextButton", configScroll)
    profilesToggleBtn.LayoutOrder = 1
    profilesToggleBtn.Size = UDim2.new(1, -4, 0, 42)
    profilesToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    profilesToggleBtn.Text = "  ↓ Profiles"
    profilesToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    profilesToggleBtn.TextSize = 13
    profilesToggleBtn.Font = Enum.Font.GothamBold
    profilesToggleBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", profilesToggleBtn).CornerRadius = UDim.new(0, 5)
    local pfStroke = Instance.new("UIStroke", profilesToggleBtn) 
    pfStroke.Color = Color3.fromRGB(0, 160, 255)
    pfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, pfStroke)

    local profilesSubLabel = Instance.new("TextLabel", profilesToggleBtn)
    profilesSubLabel.Size = UDim2.new(1, 0, 0, 16)
    profilesSubLabel.Position = UDim2.new(0, 0, 1, -16)
    profilesSubLabel.BackgroundTransparency = 1
    profilesSubLabel.Text = "Quản lý các cấu hình"
    profilesSubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
    profilesSubLabel.TextSize = 9
    profilesSubLabel.Font = Enum.Font.Gotham
    profilesSubLabel.TextXAlignment = Enum.TextXAlignment.Center

    local profilesContainer = Instance.new("Frame", configScroll)
    profilesContainer.LayoutOrder = 2
    profilesContainer.Size = UDim2.new(1, -4, 0, 0)
    profilesContainer.AutomaticSize = Enum.AutomaticSize.Y
    profilesContainer.BackgroundTransparency = 1
    local profilesSubLayout = Instance.new("UIListLayout", profilesContainer) 
    profilesSubLayout.SortOrder = Enum.SortOrder.LayoutOrder 
    profilesSubLayout.Padding = UDim.new(0, 5)

    profilesToggleBtn.MouseButton1Click:Connect(function()
        profilesContainer.Visible = not profilesContainer.Visible
        profilesToggleBtn.Text = profilesContainer.Visible and "  ↓ Profiles" or "  → Profiles"
        profilesSubLabel.Visible = profilesContainer.Visible
    end)

    -- New Config Name Box
    local newConfigFrame = Instance.new("Frame", profilesContainer)
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
    ncLabel.Text = "New Cấu Hình Name"
    ncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ncLabel.TextSize = 11
    ncLabel.Font = Enum.Font.Gotham
    ncLabel.TextXAlignment = Enum.TextXAlignment.Left

    local configNameBox = Instance.new("TextBox", newConfigFrame)
    configNameBox.Size = UDim2.new(0.45, 0, 0, 24)
    configNameBox.Position = UDim2.new(0.53, 0, 0.5, -12)
    configNameBox.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    configNameBox.PlaceholderText = "New config name..."
    configNameBox.Text = ""
    configNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    configNameBox.TextSize = 10
    configNameBox.Font = Enum.Font.Gotham
    Instance.new("UICorner", configNameBox).CornerRadius = UDim.new(0, 4)

    -- Create New Config
    local createFrame = Instance.new("Frame", profilesContainer)
    createFrame.LayoutOrder = 2 
    createFrame.Size = UDim2.new(1, 0, 0, 42)
    createFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", createFrame).CornerRadius = UDim.new(0, 5) 
    local crStroke = Instance.new("UIStroke", createFrame) 
    crStroke.Color = Color3.fromRGB(0, 160, 255)
    crStroke.Thickness = 1.5
    table.insert(AllUIStrokes, crStroke)

    local crTitle = Instance.new("TextLabel", createFrame)
    crTitle.Size = UDim2.new(1, -110, 0, 20)
    crTitle.Position = UDim2.new(0, 8, 0, 3)
    crTitle.BackgroundTransparency = 1
    crTitle.Text = "Create New Cấu Hình"
    crTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    crTitle.TextSize = 11
    crTitle.Font = Enum.Font.GothamBold
    crTitle.TextXAlignment = Enum.TextXAlignment.Left

    local createBtn = Instance.new("TextButton", createFrame)
    createBtn.Size = UDim2.new(0, 95, 0, 26)
    createBtn.Position = UDim2.new(1, -103, 0.5, -13)
    createBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    createBtn.Text = "Create New"
    createBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    createBtn.TextSize = 10
    createBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 4)

    -- Delete Config
    local deleteFrame = Instance.new("Frame", profilesContainer)
    deleteFrame.LayoutOrder = 3 
    deleteFrame.Size = UDim2.new(1, 0, 0, 38)
    deleteFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", deleteFrame).CornerRadius = UDim.new(0, 5) 
    local delStroke = Instance.new("UIStroke", deleteFrame) 
    delStroke.Color = Color3.fromRGB(0, 160, 255)
    delStroke.Thickness = 1.5
    table.insert(AllUIStrokes, delStroke)

    local delLabel = Instance.new("TextLabel", deleteFrame)
    delLabel.Size = UDim2.new(0.5, 0, 1, 0)
    delLabel.Position = UDim2.new(0, 8, 0, 0)
    delLabel.BackgroundTransparency = 1
    delLabel.Text = "Delete Cấu Hình"
    delLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    delLabel.TextSize = 11
    delLabel.Font = Enum.Font.Gotham
    delLabel.TextXAlignment = Enum.TextXAlignment.Left

    local delBtn = Instance.new("TextButton", deleteFrame)
    delBtn.Size = UDim2.new(0, 115, 0, 24)
    delBtn.Position = UDim2.new(1, -123, 0.5, -12)
    delBtn.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    delBtn.Text = "Không có ∨"
    delBtn.TextColor3 = Color3.fromRGB(50, 200, 50)
    delBtn.TextSize = 10
    delBtn.Font = Enum.Font.GothamBold
    delBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)

    local delDropFrame = Instance.new("ScrollingFrame", profilesContainer)
    delDropFrame.LayoutOrder = 4 
    delDropFrame.Size = UDim2.new(1, 0, 0, 90)
    delDropFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    delDropFrame.CanvasSize = UDim2.new(0,0,0,0)
    delDropFrame.ScrollBarThickness = 3
    delDropFrame.Visible = false
    Instance.new("UICorner", delDropFrame).CornerRadius = UDim.new(0, 5)
    local ddfStroke = Instance.new("UIStroke", delDropFrame) 
    ddfStroke.Color = Color3.fromRGB(0, 160, 255)
    ddfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, ddfStroke)
    local delDropLayout = Instance.new("UIListLayout", delDropFrame) delDropLayout.Padding = UDim.new(0, 4)

    -- Startup Profile
    local startupProfileFrame = Instance.new("Frame", profilesContainer)
    startupProfileFrame.LayoutOrder = 5 
    startupProfileFrame.Size = UDim2.new(1, 0, 0, 38)
    startupProfileFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", startupProfileFrame).CornerRadius = UDim.new(0, 5) 
    local spfStroke = Instance.new("UIStroke", startupProfileFrame) 
    spfStroke.Color = Color3.fromRGB(0, 160, 255)
    spfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, spfStroke)

    local stProfileLabel = Instance.new("TextLabel", startupProfileFrame)
    stProfileLabel.Size = UDim2.new(0.5, 0, 1, 0)
    stProfileLabel.Position = UDim2.new(0, 8, 0, 0)
    stProfileLabel.BackgroundTransparency = 1
    stProfileLabel.Text = "Cấu Hình Khởi Động"
    stProfileLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stProfileLabel.TextSize = 11
    stProfileLabel.Font = Enum.Font.Gotham
    stProfileLabel.TextXAlignment = Enum.TextXAlignment.Left

    local stProfileBtn = Instance.new("TextButton", startupProfileFrame)
    stProfileBtn.Size = UDim2.new(0, 115, 0, 24)
    stProfileBtn.Position = UDim2.new(1, -123, 0.5, -12)
    stProfileBtn.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    stProfileBtn.Text = startupConfigName .. " ∨"
    stProfileBtn.TextColor3 = Color3.fromRGB(50, 200, 50)
    stProfileBtn.TextSize = 10
    stProfileBtn.Font = Enum.Font.GothamBold
    stProfileBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", stProfileBtn).CornerRadius = UDim.new(0, 4)

    local stProfileDrop = Instance.new("ScrollingFrame", profilesContainer)
    stProfileDrop.LayoutOrder = 6 
    stProfileDrop.Size = UDim2.new(1, 0, 0, 90)
    stProfileDrop.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    stProfileDrop.CanvasSize = UDim2.new(0,0,0,0)
    stProfileDrop.ScrollBarThickness = 3
    stProfileDrop.Visible = false
    Instance.new("UICorner", stProfileDrop).CornerRadius = UDim.new(0, 5)
    local spdStroke = Instance.new("UIStroke", stProfileDrop) 
    spdStroke.Color = Color3.fromRGB(0, 160, 255)
    spdStroke.Thickness = 1.5
    table.insert(AllUIStrokes, spdStroke)
    local stProfileLayout = Instance.new("UIListLayout", stProfileDrop) stProfileLayout.Padding = UDim.new(0, 4)

    -- Load Config
    local loadConfigFrame = Instance.new("Frame", profilesContainer)
    loadConfigFrame.LayoutOrder = 7 
    loadConfigFrame.Size = UDim2.new(1, 0, 0, 38)
    loadConfigFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    Instance.new("UICorner", loadConfigFrame).CornerRadius = UDim.new(0, 5) 
    local lcfStroke = Instance.new("UIStroke", loadConfigFrame) 
    lcfStroke.Color = Color3.fromRGB(0, 160, 255)
    lcfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, lcfStroke)

    local ldLabel = Instance.new("TextLabel", loadConfigFrame)
    ldLabel.Size = UDim2.new(0.5, 0, 1, 0)
    ldLabel.Position = UDim2.new(0, 8, 0, 0)
    ldLabel.BackgroundTransparency = 1
    ldLabel.Text = "Tải Cấu Hình"
    ldLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ldLabel.TextSize = 11
    ldLabel.Font = Enum.Font.Gotham
    ldLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ldBtn = Instance.new("TextButton", loadConfigFrame)
    ldBtn.Size = UDim2.new(0, 115, 0, 24)
    ldBtn.Position = UDim2.new(1, -123, 0.5, -12)
    ldBtn.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    ldBtn.Text = currentConfigName .. " ∨"
    ldBtn.TextColor3 = Color3.fromRGB(50, 200, 50)
    ldBtn.TextSize = 10
    ldBtn.Font = Enum.Font.GothamBold
    ldBtn.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", ldBtn).CornerRadius = UDim.new(0, 4)

    local ldDropFrame = Instance.new("ScrollingFrame", profilesContainer)
    ldDropFrame.LayoutOrder = 8 
    ldDropFrame.Size = UDim2.new(1, 0, 0, 90)
    ldDropFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    ldDropFrame.CanvasSize = UDim2.new(0,0,0,0)
    ldDropFrame.ScrollBarThickness = 3
    ldDropFrame.Visible = false
    Instance.new("UICorner", ldDropFrame).CornerRadius = UDim.new(0, 5)
    local ldfStroke = Instance.new("UIStroke", ldDropFrame) 
    ldfStroke.Color = Color3.fromRGB(0, 160, 255)
    ldfStroke.Thickness = 1.5
    table.insert(AllUIStrokes, ldfStroke)
    local ldDropLayout = Instance.new("UIListLayout", ldDropFrame) ldDropLayout.Padding = UDim.new(0, 4)

    -- Save Config Button
    local saveFrame = Instance.new("Frame", profilesContainer)
    saveFrame.LayoutOrder = 9 
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

    -- Logic làm mới danh sách Profiles
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
            f1.Size = UDim2.new(1, 0, 0, 26)
            f1.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
            f1.Text = "  🗑️ " .. name
            f1.TextColor3 = Color3.fromRGB(255, 100, 100)
            f1.TextSize = 11
            f1.Font = Enum.Font.Gotham
            f1.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", f1).CornerRadius = UDim.new(0, 4)
            local f1Stroke = Instance.new("UIStroke", f1) f1Stroke.Color, f1Stroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
            table.insert(AllUIStrokes, f1Stroke)

            f1.MouseButton1Click:Connect(function()
                if typeof(delfile) == "function" then pcall(delfile, configFolder .. "/" .. name .. ".json") end
                delBtn.Text = name .. " ∨"
                delDropFrame.Visible = false
                refreshAllDropdowns()
            end)

            local f2 = Instance.new("TextButton", stProfileDrop)
            f2.Size = UDim2.new(1, 0, 0, 26)
            f2.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
            f2.Text = "  📁 " .. name
            f2.TextColor3 = Color3.fromRGB(255, 255, 255)
            f2.TextSize = 11
            f2.Font = Enum.Font.Gotham
            f2.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", f2).CornerRadius = UDim.new(0, 4)
            local f2Stroke = Instance.new("UIStroke", f2) f2Stroke.Color, f2Stroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
            table.insert(AllUIStrokes, f2Stroke)

            f2.MouseButton1Click:Connect(function()
                startupConfigName = name
                stProfileBtn.Text = name .. " ∨"
                stProfileDrop.Visible = false
            end)

            local f3 = Instance.new("TextButton", ldDropFrame)
            f3.Size = UDim2.new(1, 0, 0, 26)
            f3.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
            f3.Text = "  📂 " .. name
            f3.TextColor3 = Color3.fromRGB(255, 255, 255)
            f3.TextSize = 11
            f3.Font = Enum.Font.Gotham
            f3.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", f3).CornerRadius = UDim.new(0, 4)
            local f3Stroke = Instance.new("UIStroke", f3) f3Stroke.Color, f3Stroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
            table.insert(AllUIStrokes, f3Stroke)

            f3.MouseButton1Click:Connect(function()
                currentConfigName = name
                ldBtn.Text = name .. " ∨"
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
            configNameBox.Text = ""
            refreshAllDropdowns()
        end
    end)

    saveBtn.MouseButton1Click:Connect(function()
        if typeof(writefile) == "function" then
            pcall(writefile, configFolder .. "/" .. currentConfigName .. ".json", HttpService:JSONEncode({SavedTime = os.time()}))
        end
    end)

    configScroll.CanvasSize = UDim2.new(0, 0, 0, 450)

    -- VÒNG LẶP RENDER CHẠY HIỆU ỨNG VIỀN TOÀN DIỆN
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
