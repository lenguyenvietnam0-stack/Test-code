-- ==================== PHẦN 1/5: KHỞI TẠO DỊCH VỤ & KHUNG CHÍNH ====================
local CoreGui, Players, TweenService, UserInputService, SoundService, RunService = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("SoundService"), game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end
if CoreGui:FindFirstChild("VzNamBlackScreen") then CoreGui.VzNamBlackScreen:Destroy() end

local RegisteredScripts = {}
local currentSoundId = "1837879082"

-- Màn hình đen giảm FPS
local BlackScreenGui = Instance.new("ScreenGui", CoreGui)
BlackScreenGui.Name = "VzNamBlackScreen"
BlackScreenGui.DisplayOrder = 5
BlackScreenGui.IgnoreGuiInset = true
BlackScreenGui.ResetOnSpawn = false
BlackScreenGui.Enabled = false

local BlackFrame = Instance.new("Frame", BlackScreenGui)
BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- ScreenGui chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Lấy Avatar người chơi
local success, avatarThumbnail = pcall(function()
    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
local avatarUrl = success and avatarThumbnail or "rbxassetid://15298567397"

-- Khung MainFrame (Trong suốt xuyên thấu)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 360)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
MainFrame.BackgroundTransparency = 1 
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 8)

local OuterStroke = Instance.new("UIStroke", MainFrame)
OuterStroke.Color = Color3.fromRGB(0, 0, 0)
OuterStroke.Thickness = 1
OuterStroke.Transparency = 0.1

-- TopBar Thanh Tiêu Đề
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundTransparency = 1

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
Title.Text = "🌸TỔNG HỢP | 👑VzNam Hub v3👑 | 🌸"
Title.TextColor3 = Color3.fromRGB(0, 180, 255)
Title.TextSize = 12
Title.Font = Enum.Font.FredokaOne
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
    if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end
    ScreenGui:Destroy()
    BlackScreenGui:Destroy()
end)
-- ==================== PHẦN 2/5: SIDEBAR & BẢNG NỘI DUNG ====================
local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Name = "SidebarPanel"
SidebarPanel.Size = UDim2.new(0, 160, 1, -34)
SidebarPanel.Position = UDim2.new(0, 6, 0, 28)
SidebarPanel.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
SidebarPanel.BackgroundTransparency = 0
SidebarPanel.BorderSizePixel = 0

Instance.new("UICorner", SidebarPanel).CornerRadius = UDim.new(0, 6)
local SidebarStroke = Instance.new("UIStroke", SidebarPanel)
SidebarStroke.Color = Color3.fromRGB(40, 43, 52)
SidebarStroke.Thickness = 1

local SearchBox = Instance.new("TextBox", SidebarPanel)
SearchBox.Size = UDim2.new(1, -10, 0, 24)
SearchBox.Position = UDim2.new(0, 5, 0, 5)
SearchBox.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
SearchBox.BackgroundTransparency = 0
SearchBox.Text = ""
SearchBox.PlaceholderText = "🔍 Tìm kiếm Tab/Script..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 135, 145)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 10
SearchBox.Font = Enum.Font.FredokaOne
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
SidebarScroll.Size = UDim2.new(1, -8, 1, -34)
SidebarScroll.Position = UDim2.new(0, 4, 0, 32)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.BorderSizePixel = 0
SidebarScroll.ScrollBarThickness = 2
SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 320)

local SidebarLayout = Instance.new("UIListLayout", SidebarScroll)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -172, 1, -34)
ContentContainer.Position = UDim2.new(0, 168, 0, 28)
ContentContainer.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
ContentContainer.BackgroundTransparency = 0
ContentContainer.BorderSizePixel = 0
ContentContainer.ClipsDescendants = true

Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 6)
local ContentStroke = Instance.new("UIStroke", ContentContainer)
ContentStroke.Color = Color3.fromRGB(40, 43, 52)
ContentStroke.Thickness = 1

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
ActiveTabTitle.Font = Enum.Font.FredokaOne
ActiveTabTitle.TextXAlignment = Enum.TextXAlignment.Left

local HeaderDivider = Instance.new("Frame", ContentContainer)
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 0, 30)
HeaderDivider.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
HeaderDivider.BorderSizePixel = 0

local Tabs = {}
local FirstTab = nil
local tabNames = {"🌸STEAL AN EGG🌸", "🌸BLOX FRUIT🌸", "🌸BREAK AN STEAL AN EGG🌸", "Tab 4", "Tab 5", "👾KHÁC👾"}

local function CreateCategoryTab(tabName, index)
    local tabBtn = Instance.new("TextButton", SidebarScroll)
    tabBtn.Size = UDim2.new(1, 0, 0, 34)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.Text = "  " .. tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.FredokaOne
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.TextWrapped = true
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local indicator = Instance.new("Frame", tabBtn)
    indicator.Size = UDim2.new(0, 3, 0, 16)
    indicator.Position = UDim2.new(0, 0, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local containerFrame = Instance.new("Frame", ContentContainer)
    containerFrame.Size = UDim2.new(1, -12, 1, -38)
    containerFrame.Position = UDim2.new(0, 6, 0, 34)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Visible = false

    local scrollNoKey, scrollHasKey, customScroll

    if index ~= 6 then
        local subBar = Instance.new("Frame", containerFrame)
        subBar.Size = UDim2.new(1, 0, 0, 26)
        subBar.BackgroundTransparency = 1
        
        local noKeyBtn = Instance.new("TextButton", subBar)
        noKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
        noKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        noKeyBtn.Text = "no key"
        noKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        noKeyBtn.TextSize = 11
        noKeyBtn.Font = Enum.Font.FredokaOne
        Instance.new("UICorner", noKeyBtn).CornerRadius = UDim.new(0, 5)

        local hasKeyBtn = Instance.new("TextButton", subBar)
        hasKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
        hasKeyBtn.Position = UDim2.new(0.52, 0, 0, 0)
        hasKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
        hasKeyBtn.Text = "có key"
        hasKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        hasKeyBtn.TextSize = 11
        hasKeyBtn.Font = Enum.Font.FredokaOne
        Instance.new("UICorner", hasKeyBtn).CornerRadius = UDim.new(0, 5)

        scrollNoKey = Instance.new("ScrollingFrame", containerFrame)
        scrollNoKey.Size = UDim2.new(1, 0, 1, -32)
        scrollNoKey.Position = UDim2.new(0, 0, 0, 32)
        scrollNoKey.BackgroundTransparency = 1
        scrollNoKey.ScrollBarThickness = 3
        scrollNoKey.CanvasSize = UDim2.new(0, 0, 0, 1200)
        scrollNoKey.Visible = true
        Instance.new("UIListLayout", scrollNoKey).Padding = UDim.new(0, 6)

        scrollHasKey = Instance.new("ScrollingFrame", containerFrame)
        scrollHasKey.Size = UDim2.new(1, 0, 1, -32)
        scrollHasKey.Position = UDim2.new(0, 0, 0, 32)
        scrollHasKey.BackgroundTransparency = 1
        scrollHasKey.ScrollBarThickness = 3
        scrollHasKey.CanvasSize = UDim2.new(0, 0, 0, 1200)
        scrollHasKey.Visible = false
        Instance.new("UIListLayout", scrollHasKey).Padding = UDim.new(0, 6)

        noKeyBtn.MouseButton1Click:Connect(function()
            scrollNoKey.Visible = true
            scrollHasKey.Visible = false
            noKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            noKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            hasKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            hasKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end)

        hasKeyBtn.MouseButton1Click:Connect(function()
            scrollNoKey.Visible = false
            scrollHasKey.Visible = true
            hasKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            hasKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            noKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            noKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end)
    else
        customScroll = Instance.new("ScrollingFrame", containerFrame)
        customScroll.Size = UDim2.new(1, 0, 1, 0)
        customScroll.BackgroundTransparency = 1
        customScroll.ScrollBarThickness = 3
        customScroll.CanvasSize = UDim2.new(0, 0, 0, 650)
        Instance.new("UIListLayout", customScroll).Padding = UDim.new(0, 6)
    end

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Indicator.Visible = false
            t.Button.BackgroundTransparency = 0.5
        end
        containerFrame.Visible = true
        indicator.Visible = true
        tabBtn.BackgroundTransparency = 0.2
        ActiveTabTitle.Text = tabName
    end)

    local tabObj = { Button = tabBtn, Container = containerFrame, Indicator = indicator }
    table.insert(Tabs, tabObj)

    if not FirstTab then
        FirstTab = tabObj
        containerFrame.Visible = true
        indicator.Visible = true
        tabBtn.BackgroundTransparency = 0.2
        ActiveTabTitle.Text = tabName
    end

    return scrollNoKey, scrollHasKey, customScroll
end

local tabContainers = {}
for i = 1, 6 do
    local ns, hs, cs = CreateCategoryTab(tabNames[i], i)
    tabContainers[i] = {NoKeyScroll = ns, HasKeyScroll = hs, Scroll = cs}
end
-- ==================== PHẦN 3/5: HÀM TẠO NÚT & DANH SÁCH SCRIPT ====================
local function AddScriptButton(scrollParent, Name, Callback)
    local btn = Instance.new("TextButton", scrollParent)
    btn.Size = UDim2.new(1, -4, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    btn.BackgroundTransparency = 0
    btn.Text = "  ▶  " .. Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.FredokaOne
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40, 43, 52)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        stroke.Color = Color3.fromRGB(0, 180, 255)
        stroke.Thickness = 2
        Callback()
    end)

    table.insert(RegisteredScripts, {Name = Name, Callback = Callback})
end

-- TAB 1: STEAL AN EGG
AddScriptButton(tabContainers[1].NoKeyScroll, "1. Hop sv1 người(nokey)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddScriptButton(tabContainers[1].NoKeyScroll, "2. FyyCommunity(lúc có key lúc no key)", function() loadstring(game:HttpGet("https://FyyCommunity.my.id"))() end)
AddScriptButton(tabContainers[1].NoKeyScroll, "3. Chilli Hub V4(nokey)", function() loadstring(game:HttpGet("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4"))() end)
AddScriptButton(tabContainers[1].NoKeyScroll, "4. Night hub(nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"))() end)

AddScriptButton(tabContainers[1].HasKeyScroll, "1. Lemon Hub v4(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt", true))() end)
AddScriptButton(tabContainers[1].HasKeyScroll, "2. Hoshi hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua"))() end)
AddScriptButton(tabContainers[1].HasKeyScroll, "3. Bigfroot(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))() end)
AddScriptButton(tabContainers[1].HasKeyScroll, "4. Chữ A(ajjans)|(có key)", function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"))() end)
AddScriptButton(tabContainers[1].HasKeyScroll, "5. Speed hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end)
AddScriptButton(tabContainers[1].HasKeyScroll, "6. Neohub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/neohubdev/script/main/script"))() end)
AddScriptButton(tabContainers[1].HasKeyScroll, "7. Real kid(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() end)
AddScriptButton(tabContainers[1].HasKeyScroll, "8. Chilli v2(có key)", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/ronnei/1fa67c56dd9af203b192d15e752928e5/raw/4e2d5105640e09a008b4ae6df23f9708cadfef06/chilliv2-stealanegg"))() end)

-- TAB 2: BLOX FRUIT
AddScriptButton(tabContainers[2].NoKeyScroll, "1. RedzHub v2 (no key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))() end)
AddScriptButton(tabContainers[2].NoKeyScroll, "2. Quantumx Hub(nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))() end)

AddScriptButton(tabContainers[2].HasKeyScroll, "1. Speed Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end)
AddScriptButton(tabContainers[2].HasKeyScroll, "2. Omg Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))() end)
AddScriptButton(tabContainers[2].HasKeyScroll, "3. TeddyHub(có key)", function() repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))() end)
AddScriptButton(tabContainers[2].HasKeyScroll, "4. Gravity Hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))() end)
AddScriptButton(tabContainers[2].HasKeyScroll, "5. Realkid hub(có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() end)
AddScriptButton(tabContainers[2].HasKeyScroll, "6. BananaHub(có key)", function() repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer getgenv().Team = "Marines" loadstring(game:HttpGet("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua"))() end)

-- TAB 3
AddScriptButton(tabContainers[3].NoKeyScroll, "1. break and steal an egg(không sài dc nx)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))() end)
-- ==================== PHẦN 4/5: TAB 6 TIỆN ÍCH & NHẠC ====================
local t6 = tabContainers[6].Scroll

-- Auto Load Script
local dropBtn = Instance.new("TextButton", t6)
dropBtn.Size = UDim2.new(1, -4, 0, 36)
dropBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
dropBtn.Text = " 📜 Chọn Script Auto Load..."
dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropBtn.TextSize = 11
dropBtn.Font = Enum.Font.FredokaOne
dropBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)

local dropFrame = Instance.new("ScrollingFrame", t6)
dropFrame.Size = UDim2.new(1, -4, 0, 110)
dropFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
dropFrame.CanvasSize = UDim2.new(0, 0, 0, #RegisteredScripts * 32)
dropFrame.ScrollBarThickness = 3
dropFrame.Visible = false
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIListLayout", dropFrame).Padding = UDim.new(0, 2)

local selScript, isAuto = nil, false
for _, scr in ipairs(RegisteredScripts) do
    local item = Instance.new("TextButton", dropFrame)
    item.Size = UDim2.new(1, 0, 0, 30)
    item.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    item.Text = " ▶ " .. scr.Name
    item.TextColor3 = Color3.fromRGB(255, 255, 255)
    item.TextSize = 10
    item.Font = Enum.Font.FredokaOne
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.MouseButton1Click:Connect(function()
        selScript = scr
        dropBtn.Text = " 📜 Đã chọn: " .. scr.Name
        dropFrame.Visible = false
    end)
end

dropBtn.MouseButton1Click:Connect(function() dropFrame.Visible = not dropFrame.Visible end)

local toggleAuto = Instance.new("TextButton", t6)
toggleAuto.Size = UDim2.new(1, -4, 0, 36)
toggleAuto.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleAuto.Text = "Auto Load Script Chạy: TẮT ❌"
toggleAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAuto.TextSize = 11
toggleAuto.Font = Enum.Font.FredokaOne
Instance.new("UICorner", toggleAuto).CornerRadius = UDim.new(0, 5)

toggleAuto.MouseButton1Click:Connect(function()
    if not selScript then dropBtn.Text = " ⚠️ Bạn chưa chọn script!" return end
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

-- Màn hình đen giảm FPS
local isFpsModeOn = false
local toggleFpsBtn = Instance.new("TextButton", t6)
toggleFpsBtn.Size = UDim2.new(1, -4, 0, 36)
toggleFpsBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleFpsBtn.Text = "Màn Hình Đen Giảm FPS: TẮT ❌"
toggleFpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFpsBtn.TextSize = 11
toggleFpsBtn.Font = Enum.Font.FredokaOne
Instance.new("UICorner", toggleFpsBtn).CornerRadius = UDim.new(0, 5)

toggleFpsBtn.MouseButton1Click:Connect(function()
    isFpsModeOn = not isFpsModeOn
    if isFpsModeOn then
        toggleFpsBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        toggleFpsBtn.Text = "Màn Hình Đen Giảm FPS: BẬT ✅"
        BlackScreenGui.Enabled = true
    else
        toggleFpsBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleFpsBtn.Text = "Màn Hình Đen Giảm FPS: TẮT ❌"
        BlackScreenGui.Enabled = false
    end
end)

-- Trình phát nhạc
local HubSound = SoundService:FindFirstChild("VzNamHubSound") or Instance.new("Sound", SoundService)
HubSound.Name = "VzNamHubSound"
HubSound.Looped = true
HubSound.Volume = 0.5

local presetMusics = {
    {Name = "🎵 Chill Lofi Music", Id = "1837879082"},
    {Name = "🎶 Phonk Beat", Id = "1843404008"},
    {Name = "🎵 Anime Relaxing", Id = "9043887091"},
    {Name = "🎶 EDM Hype", Id = "1837871000"},
    {Name = "🎶 Như Một Người Dưng", Id = "91897652967267"}
}

local customIdBox = Instance.new("TextBox", t6)
customIdBox.Size = UDim2.new(1, -4, 0, 32)
customIdBox.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
customIdBox.PlaceholderText = "Nhập Sound ID tùy chỉnh..."
customIdBox.Text = ""
customIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
customIdBox.TextSize = 11
customIdBox.Font = Enum.Font.FredokaOne
Instance.new("UICorner", customIdBox).CornerRadius = UDim.new(0, 5)

local musicDropBtn = Instance.new("TextButton", t6)
musicDropBtn.Size = UDim2.new(1, -4, 0, 36)
musicDropBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
musicDropBtn.Text = " 🎵 Chọn Nhạc Nền..."
musicDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
musicDropBtn.TextSize = 11
musicDropBtn.Font = Enum.Font.FredokaOne
musicDropBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", musicDropBtn).CornerRadius = UDim.new(0, 5)

local musicDropFrame = Instance.new("ScrollingFrame", t6)
musicDropFrame.Size = UDim2.new(1, -4, 0, 110)
musicDropFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
musicDropFrame.CanvasSize = UDim2.new(0, 0, 0, #presetMusics * 30)
musicDropFrame.ScrollBarThickness = 3
musicDropFrame.Visible = false
Instance.new("UICorner", musicDropFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIListLayout", musicDropFrame).Padding = UDim.new(0, 2)

for _, mItem in ipairs(presetMusics) do
    local mBtn = Instance.new("TextButton", musicDropFrame)
    mBtn.Size = UDim2.new(1, 0, 0, 28)
    mBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    mBtn.Text = " " .. mItem.Name
    mBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mBtn.TextSize = 10
    mBtn.Font = Enum.Font.FredokaOne
    mBtn.TextXAlignment = Enum.TextXAlignment.Left
    mBtn.MouseButton1Click:Connect(function()
        currentSoundId = mItem.Id
        musicDropBtn.Text = " 🎵 Đã chọn: " .. mItem.Name
        musicDropFrame.Visible = false
        if HubSound.IsPlaying then
            HubSound.SoundId = "rbxassetid://" .. currentSoundId
            HubSound:Play()
        end
    end)
end

musicDropBtn.MouseButton1Click:Connect(function() musicDropFrame.Visible = not musicDropFrame.Visible end)

customIdBox.FocusLost:Connect(function()
    if customIdBox.Text ~= "" and tonumber(customIdBox.Text) then
        currentSoundId = customIdBox.Text
        musicDropBtn.Text = " 🎵 ID Custom: " .. currentSoundId
        if HubSound.IsPlaying then
            HubSound.SoundId = "rbxassetid://" .. currentSoundId
            HubSound:Play()
        end
    end
end)
-- ==================== PHẦN 5/5: ÂM LƯỢNG, TÌM KIẾM & NÚT MỞ MENU ====================
local volumeContainer = Instance.new("Frame", t6)
volumeContainer.Size = UDim2.new(1, -4, 0, 36)
volumeContainer.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
Instance.new("UICorner", volumeContainer).CornerRadius = UDim.new(0, 5)

local volLabel = Instance.new("TextLabel", volumeContainer)
volLabel.Size = UDim2.new(0, 130, 1, 0)
volLabel.Position = UDim2.new(0, 10, 0, 0)
volLabel.BackgroundTransparency = 1
volLabel.Text = "🔊 Âm lượng: 50%"
volLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
volLabel.TextSize = 11
volLabel.Font = Enum.Font.FredokaOne
volLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderBar = Instance.new("Frame", volumeContainer)
sliderBar.Size = UDim2.new(1, -150, 0, 8)
sliderBar.Position = UDim2.new(0, 135, 0.5, -4)
sliderBar.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame", sliderBar)
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local sliding = false
local function updateVolume(input)
    local absPos = sliderBar.AbsolutePosition.X
    local absSize = sliderBar.AbsoluteSize.X
    if absSize > 0 then
        local val = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
        sliderFill.Size = UDim2.new(val, 0, 1, 0)
        volLabel.Text = "🔊 Âm lượng: " .. math.floor(val * 100) .. "%"
        HubSound.Volume = val
    end
end

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateVolume(input)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateVolume(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

local isMusicPlaying = false
local toggleMusicBtn = Instance.new("TextButton", t6)
toggleMusicBtn.Size = UDim2.new(1, -4, 0, 36)
toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleMusicBtn.Text = "Phát Nhạc Background: TẮT ❌"
toggleMusicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleMusicBtn.TextSize = 11
toggleMusicBtn.Font = Enum.Font.FredokaOne
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

-- Tìm kiếm theo thời gian thực
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBox.Text)
    for _, tabObj in ipairs(Tabs) do
        local activeScroll = tabObj.Container:FindFirstChildOfClass("ScrollingFrame")
        if activeScroll then
            for _, item in ipairs(activeScroll:GetChildren()) do
                if item:IsA("TextButton") then
                    if query == "" or string.find(string.lower(item.Text), query) then
                        item.Visible = true
                    else
                        item.Visible = false
                    end
                end
            end
        end
    end
end)

-- Nút Tròn Mở Menu (Avatar + Viền Cầu Vồng)
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

task.spawn(function()
    while ScreenGui.Parent do
        OpenStroke.Color = Color3.fromHSV((tick() % 4) / 4, 1, 1)
        task.wait(0.03)
    end
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
