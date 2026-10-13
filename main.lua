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
    local AllMenuFrames = {}
    local LastSelectedScriptStroke = nil

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VzNamHubV4UI"
    ScreenGui.DisplayOrder = 99999
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local avatarUrl = "rbxassetid://15298567397"

    -- KHUNG CHÍNH TRONG SUỐT GỐC
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
    table.insert(AllMenuFrames, SidebarPanel)
    
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
    table.insert(AllMenuFrames, SearchBoxTab)

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
    table.insert(AllMenuFrames, ContentContainer)
    
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
    table.insert(AllMenuFrames, tabHomeBtn)

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
            
            copyBtn.MouseButton1Click:Connect(function()
                if typeof(setclipboard) == "function" then
                    pcall(setclipboard, copyText)
                    copyBtn.Text = "✓ COPIED"
                    task.delay(1.5, function() copyBtn.Text = "📋 COPY" end)
                end
            end)
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
        table.insert(AllMenuFrames, tabBtn)

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
        table.insert(AllMenuFrames, noKeyBtn)

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
        table.insert(AllMenuFrames, hasKeyBtn)

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
        local l1 = Instance.new("UIListLayout", scrollNoKey) l1.Padding = UDim.new(0, 5)

        local scrollHasKey = Instance.new("ScrollingFrame", containerFrame) 
        scrollHasKey.Position = UDim2.new(0, 0, 0, 32)
        scrollHasKey.Size = UDim2.new(1, 0, 1, -32)
        scrollHasKey.BackgroundTransparency = 1
        scrollHasKey.BorderSizePixel = 0
        scrollHasKey.ScrollBarThickness = 3
        scrollHasKey.Visible = false
        scrollHasKey.ClipsDescendants = true
        local l2 = Instance.new("UIListLayout", scrollHasKey) l2.Padding = UDim.new(0, 5)

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
        end)

        table.insert(Tabs, { Container = containerFrame, Indicator = indicator })

        local Elements = {}
        local function AddBtnTo(parent, name, callback)
            local Btn = Instance.new("TextButton", parent)
            Btn.Size = UDim2.new(1, -4, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
            Btn.BackgroundTransparency = 0
            Btn.Text = "  ▶ " .. name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 11
            Btn.Font = Enum.Font.Gotham
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
            table.insert(AllMenuFrames, Btn)

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

    -- TAB SCRIPT
    local tab1 = CreateCategoryTab("🌸STEAL AN EGG🌸")
    tab1:AddNoKey("1. Hop sv1 người(nokey)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
    tab1:AddNoKey("2. FyyCommunity", function() loadstring(game:HttpGet("https://FyyCommunity.my.id"))() end)
    tab1:AddNoKey("3. Chilli Hub V4(nokey)", function() loadstring(game:HttpGet("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4"))() end)
    tab1:AddNoKey("4. Night hub(nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"))() end)
    tab1:AddHasKey("1. Lemon Hub v4(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt", true))() end)
    tab1:AddHasKey("2. Hoshi hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua"))() end)

    local tab2 = CreateCategoryTab("🌸BLOX FRUIT🌸")
    tab2:AddNoKey("1. RedzHub v2 (no key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))() end)
    tab2:AddNoKey("2. Quantumx Hub(nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))() end)
    tab2:AddHasKey("1. Speed Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end)

    local tab3 = CreateCategoryTab("🌸BREAK AN STEAL🌸")
    tab3:AddNoKey("1. break and steal an egg", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))() end)

    CreateCategoryTab("Tab 4")
    CreateCategoryTab("Tab 5")

    -- TAB MISC (TÁCH RIÊNG MÀU MENU VÀ MÀU VIỀN ĐỘC LẬP)
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
    table.insert(AllMenuFrames, tabMiscBtn)

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

    -- 1. CHỌN MÀU MENU RIÊNG
    local menuColorToggle = Instance.new("TextButton", miscScroll)
    menuColorToggle.LayoutOrder = 1
    menuColorToggle.Size = UDim2.new(1, -4, 0, 42)
    menuColorToggle.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    menuColorToggle.BackgroundTransparency = 0
    menuColorToggle.Text = "  ↓ Chọn Màu Menu"
    menuColorToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    menuColorToggle.TextSize = 13
    menuColorToggle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", menuColorToggle).CornerRadius = UDim.new(0, 5)
    table.insert(AllMenuFrames, menuColorToggle)

    local mcStroke = Instance.new("UIStroke", menuColorToggle) mcStroke.Color, mcStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    table.insert(AllUIStrokes, mcStroke)

    local menuColorContainer = Instance.new("Frame", miscScroll)
    menuColorContainer.LayoutOrder = 2
    menuColorContainer.Size = UDim2.new(1, -4, 0, 0)
    menuColorContainer.AutomaticSize = Enum.AutomaticSize.Y
    menuColorContainer.BackgroundTransparency = 1
    menuColorContainer.Visible = false
    local mcLayout = Instance.new("UIListLayout", menuColorContainer) mcLayout.SortOrder = Enum.SortOrder.LayoutOrder mcLayout.Padding = UDim.new(0, 5)

    menuColorToggle.MouseButton1Click:Connect(function()
        menuColorContainer.Visible = not menuColorContainer.Visible
        menuColorToggle.Text = menuColorContainer.Visible and "  ↑ Chọn Màu Menu" or "  ↓ Chọn Màu Menu"
    end)

    local menuColorList = {
        {Name = "⚫ Mặc Định (Tối)", Color = Color3.fromRGB(15, 16, 22)},
        {Name = "🔵 Xanh Đậm", Color = Color3.fromRGB(15, 25, 45)},
        {Name = "🟣 Tím Đêm", Color = Color3.fromRGB(30, 15, 40)},
        {Name = "🟢 Xanh Than Khói", Color = Color3.fromRGB(15, 30, 20)}
    }

    for _, mItem in ipairs(menuColorList) do
        local mBtn = Instance.new("TextButton", menuColorContainer)
        mBtn.Size = UDim2.new(1, 0, 0, 28)
        mBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
        mBtn.BackgroundTransparency = 0
        mBtn.Text = "  🎨 " .. mItem.Name
        mBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mBtn.TextSize = 11
        mBtn.Font = Enum.Font.Gotham
        mBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 4)
        table.insert(AllMenuFrames, mBtn)

        local mBtnStroke = Instance.new("UIStroke", mBtn) mBtnStroke.Color, mBtnStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
        table.insert(AllUIStrokes, mBtnStroke)

        mBtn.MouseButton1Click:Connect(function()
            for _, f in ipairs(AllMenuFrames) do
                if f and f.Parent then f.BackgroundColor3 = mItem.Color end
            end
        end)
    end

    -- 2. CHỌN MÀU VIỀN RIÊNG
    local borderToggle = Instance.new("TextButton", miscScroll)
    borderToggle.LayoutOrder = 3
    borderToggle.Size = UDim2.new(1, -4, 0, 42)
    borderToggle.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    borderToggle.BackgroundTransparency = 0
    borderToggle.Text = "  ↓ Chọn Màu Viền"
    borderToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    borderToggle.TextSize = 13
    borderToggle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", borderToggle).CornerRadius = UDim.new(0, 5)
    table.insert(AllMenuFrames, borderToggle)

    local bcStroke = Instance.new("UIStroke", borderToggle) bcStroke.Color, bcStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    table.insert(AllUIStrokes, bcStroke)

    local borderContainer = Instance.new("Frame", miscScroll)
    borderContainer.LayoutOrder = 4
    borderContainer.Size = UDim2.new(1, -4, 0, 0)
    borderContainer.AutomaticSize = Enum.AutomaticSize.Y
    borderContainer.BackgroundTransparency = 1
    borderContainer.Visible = false
    local bcLayout = Instance.new("UIListLayout", borderContainer) bcLayout.SortOrder = Enum.SortOrder.LayoutOrder bcLayout.Padding = UDim.new(0, 5)

    borderToggle.MouseButton1Click:Connect(function()
        borderContainer.Visible = not borderContainer.Visible
        borderToggle.Text = borderContainer.Visible and "  ↑ Chọn Màu Viền" or "  ↓ Chọn Màu Viền"
    end)

    local borderList = {
        {Name = "🔵 Xanh Dương", Color = Color3.fromRGB(0, 160, 255)},
        {Name = "🌈 Cầu Vồng (Rainbow)", Color = "Rainbow"},
        {Name = "💖 Hồng Kẹo", Color = Color3.fromRGB(255, 105, 180)},
        {Name = "🟢 Xanh Lá", Color = Color3.fromRGB(50, 205, 50)},
        {Name = "🟡 Vàng Nổi Bật", Color = Color3.fromRGB(255, 215, 0)}
    }
    local selectedBorderObj = borderList[1]

    for _, bItem in ipairs(borderList) do
        local bBtn = Instance.new("TextButton", borderContainer)
        bBtn.Size = UDim2.new(1, 0, 0, 28)
        bBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
        bBtn.BackgroundTransparency = 0
        bBtn.Text = "  🖍️ " .. bItem.Name
        bBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        bBtn.TextSize = 11
        bBtn.Font = Enum.Font.Gotham
        bBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", bBtn).CornerRadius = UDim.new(0, 4)
        table.insert(AllMenuFrames, bBtn)

        local bBtnStroke = Instance.new("UIStroke", bBtn) bBtnStroke.Color, bBtnStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
        table.insert(AllUIStrokes, bBtnStroke)

        bBtn.MouseButton1Click:Connect(function()
            selectedBorderObj = bItem
        end)
    end

    miscScroll.CanvasSize = UDim2.new(0, 0, 0, 350)

    -- TAB CẤU HÌNH (CHUẨN CÁC TÍNH NĂNG NHƯ ẢNH MÀY GỬI)
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
    table.insert(AllMenuFrames, tabConfigBtn)

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

    -- 1. Mục Cấu Hình (Ẩn/hiện chức năng như ảnh)
    local cfgToggleBtn = Instance.new("TextButton", configScroll)
    cfgToggleBtn.LayoutOrder = 1
    cfgToggleBtn.Size = UDim2.new(1, -4, 0, 42)
    cfgToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    cfgToggleBtn.BackgroundTransparency = 0
    cfgToggleBtn.Text = "  ↓ Cấu Hình"
    cfgToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cfgToggleBtn.TextSize = 13
    cfgToggleBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", cfgToggleBtn).CornerRadius = UDim.new(0, 5)
    table.insert(AllMenuFrames, cfgToggleBtn)

    local cfgStroke = Instance.new("UIStroke", cfgToggleBtn) cfgStroke.Color, cfgStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    table.insert(AllUIStrokes, cfgStroke)

    local cfgSub = Instance.new("TextLabel", cfgToggleBtn)
    cfgSub.Size = UDim2.new(1, 0, 0, 14) cfgSub.Position = UDim2.new(0, 0, 1, -15)
    cfgSub.BackgroundTransparency = 1 cfgSub.Text = "Ẩn để ẩn/hiện chức năng"
    cfgSub.TextColor3 = Color3.fromRGB(150, 150, 160) cfgSub.TextSize = 9
    cfgSub.Font = Enum.Font.Gotham cfgSub.TextXAlignment = Enum.TextXAlignment.Center

    local cfgContainer = Instance.new("Frame", configScroll)
    cfgContainer.LayoutOrder = 2
    cfgContainer.Size = UDim2.new(1, -4, 0, 0)
    cfgContainer.AutomaticSize = Enum.AutomaticSize.Y
    cfgContainer.BackgroundTransparency = 1
    cfgContainer.Visible = true
    local cfgSubLayout = Instance.new("UIListLayout", cfgContainer) cfgSubLayout.SortOrder = Enum.SortOrder.LayoutOrder cfgSubLayout.Padding = UDim.new(0, 5)

    cfgToggleBtn.MouseButton1Click:Connect(function()
        cfgContainer.Visible = not cfgContainer.Visible
        cfgToggleBtn.Text = cfgContainer.Visible and "  ↓ Cấu Hình" or "  → Cấu Hình"
    end)

    -- Startup Cấu Hình
    local startupCard = Instance.new("Frame", cfgContainer)
    startupCard.LayoutOrder = 1 startupCard.Size = UDim2.new(1, 0, 0, 38)
    startupCard.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    startupCard.BackgroundTransparency = 0
    Instance.new("UICorner", startupCard).CornerRadius = UDim.new(0, 5)
    table.insert(AllMenuFrames, startupCard)
    local stStroke = Instance.new("UIStroke", startupCard) stStroke.Color, stStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    table.insert(AllUIStrokes, stStroke)

    local stLabel = Instance.new("TextLabel", startupCard)
    stLabel.Size = UDim2.new(1, -12, 1, 0) stLabel.Position = UDim2.new(0, 10, 0, 0)
    stLabel.BackgroundTransparency = 1 stLabel.Text = "Startup Cấu Hình: Default"
    stLabel.TextColor3 = Color3.fromRGB(255, 255, 255) stLabel.TextSize = 11
    stLabel.Font = Enum.Font.Gotham stLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Auto Lưu Cấu Hình (Toggle)
    local autoSaveCard = Instance.new("Frame", cfgContainer)
    autoSaveCard.LayoutOrder = 2 autoSaveCard.Size = UDim2.new(1, 0, 0, 48)
    autoSaveCard.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    autoSaveCard.BackgroundTransparency = 0
    Instance.new("UICorner", autoSaveCard).CornerRadius = UDim.new(0, 5)
    table.insert(AllMenuFrames, autoSaveCard)
    local asStroke = Instance.new("UIStroke", autoSaveCard) asStroke.Color, asStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    table.insert(AllUIStrokes, asStroke)

    local asTitle = Instance.new("TextLabel", autoSaveCard)
    asTitle.Size = UDim2.new(1, -60, 0, 20) asTitle.Position = UDim2.new(0, 10, 0, 4)
    asTitle.BackgroundTransparency = 1 asTitle.Text = "Auto Lưu Cấu Hình"
    asTitle.TextColor3 = Color3.fromRGB(255, 255, 255) asTitle.TextSize = 11
    asTitle.Font = Enum.Font.GothamBold asTitle.TextXAlignment = Enum.TextXAlignment.Left

    local asSub = Instance.new("TextLabel", autoSaveCard)
    asSub.Size = UDim2.new(1, -60, 0, 16) asSub.Position = UDim2.new(0, 10, 0, 24)
    asSub.BackgroundTransparency = 1 asSub.Text = "Auto save: Default"
    asSub.TextColor3 = Color3.fromRGB(150, 150, 160) asSub.TextSize = 9
    asSub.Font = Enum.Font.Gotham asSub.TextXAlignment = Enum.TextXAlignment.Left

    local asToggleBtn = Instance.new("TextButton", autoSaveCard)
    asToggleBtn.Size = UDim2.new(0, 38, 0, 20) asToggleBtn.Position = UDim2.new(1, -46, 0.5, -10)
    asToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) asToggleBtn.Text = ""
    Instance.new("UICorner", asToggleBtn).CornerRadius = UDim.new(1, 0)
    local asDot = Instance.new("Frame", asToggleBtn)
    asDot.Size = UDim2.new(0, 16, 0, 16) asDot.Position = UDim2.new(1, -18, 0.5, -8)
    asDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", asDot).CornerRadius = UDim.new(1, 0)

    local isAutoSave = true
    asToggleBtn.MouseButton1Click:Connect(function()
        isAutoSave = not isAutoSave
        asToggleBtn.BackgroundColor3 = isAutoSave and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 65, 75)
        asDot.Position = isAutoSave and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end)

    -- Auto Tải Cấu Hình (Toggle)
    local autoLoadCard = Instance.new("Frame", cfgContainer)
    autoLoadCard.LayoutOrder = 3 autoLoadCard.Size = UDim2.new(1, 0, 0, 48)
    autoLoadCard.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    autoLoadCard.BackgroundTransparency = 0
    Instance.new("UICorner", autoLoadCard).CornerRadius = UDim.new(0, 5)
    table.insert(AllMenuFrames, autoLoadCard)
    local alStroke = Instance.new("UIStroke", autoLoadCard) alStroke.Color, alStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    table.insert(AllUIStrokes, alStroke)

    local alTitle = Instance.new("TextLabel", autoLoadCard)
    alTitle.Size = UDim2.new(1, -60, 0, 20) alTitle.Position = UDim2.new(0, 10, 0, 4)
    alTitle.BackgroundTransparency = 1 alTitle.Text = "Auto Tải Cấu Hình"
    alTitle.TextColor3 = Color3.fromRGB(255, 255, 255) alTitle.TextSize = 11
    alTitle.Font = Enum.Font.GothamBold alTitle.TextXAlignment = Enum.TextXAlignment.Left

    local alSub = Instance.new("TextLabel", autoLoadCard)
    alSub.Size = UDim2.new(1, -60, 0, 16) alSub.Position = UDim2.new(0, 10, 0, 24)
    alSub.BackgroundTransparency = 1 alSub.Text = "Auto load: Default"
    alSub.TextColor3 = Color3.fromRGB(150, 150, 160) alSub.TextSize = 9
    alSub.Font = Enum.Font.Gotham asSub.TextXAlignment = Enum.TextXAlignment.Left

    local alToggleBtn = Instance.new("TextButton", autoLoadCard)
    alToggleBtn.Size = UDim2.new(0, 38, 0, 20) alToggleBtn.Position = UDim2.new(1, -46, 0.5, -10)
    alToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) alToggleBtn.Text = ""
    Instance.new("UICorner", alToggleBtn).CornerRadius = UDim.new(1, 0)
    local alDot = Instance.new("Frame", alToggleBtn)
    alDot.Size = UDim2.new(0, 16, 0, 16) alDot.Position = UDim2.new(1, -18, 0.5, -8)
    alDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", alDot).CornerRadius = UDim.new(1, 0)

    local isAutoLoad = true
    alToggleBtn.MouseButton1Click:Connect(function()
        isAutoLoad = not isAutoLoad
        alToggleBtn.BackgroundColor3 = isAutoLoad and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 65, 75)
        alDot.Position = isAutoLoad and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end)

    -- 2. Mục Profiles (Quản lý các cấu hình)
    local profToggleBtn = Instance.new("TextButton", configScroll)
    profToggleBtn.LayoutOrder = 3
    profToggleBtn.Size = UDim2.new(1, -4, 0, 42)
    profToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    profToggleBtn.BackgroundTransparency = 0
    profToggleBtn.Text = "  ↓ Profiles"
    profToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    profToggleBtn.TextSize = 13
    profToggleBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", profToggleBtn).CornerRadius = UDim.new(0, 5)
    table.insert(AllMenuFrames, profToggleBtn)

    local prStroke = Instance.new("UIStroke", profToggleBtn) prStroke.Color, prStroke.Thickness = Color3.fromRGB(0, 160, 255), 1.5
    table.insert(AllUIStrokes, prStroke)

    local profSub = Instance.new("TextLabel", profToggleBtn)
    profSub.Size = UDim2.new(1, 0, 0, 14) profSub.Position = UDim2.new(0, 0, 1, -15)
    profSub.BackgroundTransparency = 1 profSub.Text = "Quản lý các cấu hình"
    profSub.TextColor3 = Color3.fromRGB(150, 150, 160) profSub.TextSize = 9
    profSub.Font = Enum.Font.Gotham profSub.TextXAlignment = Enum.TextXAlignment.Center

    configScroll.CanvasSize = UDim2.new(0, 0, 0, 500)

    -- VÒNG LẶP RENDER MÀU VIỀN / RAINBOW
    RunService.RenderStepped:Connect(function()
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
    end)

    -- NÚT MỞ / ĐÓNG MENU BÊN NGOÀI
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
    
    local OpenStroke = Instance.new("UIStroke", OpenButton) OpenStroke.Thickness = 3.5
    RunService.RenderStepped:Connect(function()
        OpenStroke.Color = Color3.fromHSV((tick() % 4) / 4, 1, 1)
    end)

    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end)
