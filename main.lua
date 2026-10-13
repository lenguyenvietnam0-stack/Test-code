local CoreGui, Players, TweenService, UserInputService, SoundService, HttpService, RunService = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("SoundService"), game:GetService("HttpService"), game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end
if CoreGui:FindFirstChild("VzNamBlackScreen") then CoreGui.VzNamBlackScreen:Destroy() end

local LastSelectedScriptBtn, LastSelectedScriptStroke = nil, nil
local RegisteredScripts = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local BlackScreenGui = Instance.new("ScreenGui", CoreGui)
BlackScreenGui.Name = "VzNamBlackScreen"
BlackScreenGui.DisplayOrder = 5
BlackScreenGui.IgnoreGuiInset = true
BlackScreenGui.ResetOnSpawn = false
BlackScreenGui.Enabled = false

local BlackFrame = Instance.new("Frame", BlackScreenGui)
BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

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

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame
local OuterStroke = Instance.new("UIStroke") OuterStroke.Color = Color3.fromRGB(0, 0, 0) OuterStroke.Thickness = 1 OuterStroke.Transparency = 0.1 OuterStroke.Parent = MainFrame

local TopBar = Instance.new("Frame") TopBar.Size = UDim2.new(1, 0, 0, 28) TopBar.BackgroundTransparency = 1 TopBar.Parent = MainFrame

local Logo = Instance.new("ImageLabel") Logo.Size, Logo.Position, Logo.BackgroundTransparency, Logo.Image = UDim2.new(0, 18, 0, 18), UDim2.new(0, 10, 0.5, -9), 1, avatarUrl Logo.Parent = TopBar
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Size, Title.Position, Title.BackgroundTransparency, Title.Text, Title.TextColor3, Title.TextSize, Title.Font, Title.TextXAlignment = UDim2.new(1, -70, 1, 0), UDim2.new(0, 32, 0, 0), 1, "🌸 VzNam Hub v3 : Tổng Hợp 🌸", Color3.fromRGB(255, 105, 180), 12, Enum.Font.FredokaOne, Enum.TextXAlignment.Center
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundTransparency, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize, CloseBtn.Font = UDim2.new(0, 26, 0, 26), UDim2.new(1, -28, 0.5, -13), 1, "✕", Color3.fromRGB(200, 200, 210), 11, Enum.Font.GothamBold
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function()
    if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end
    ScreenGui:Destroy()
    BlackScreenGui:Destroy()
end)

local SidebarPanel = Instance.new("Frame")
SidebarPanel.Name = "SidebarPanel"
SidebarPanel.Size, SidebarPanel.Position, SidebarPanel.BackgroundColor3, SidebarPanel.BackgroundTransparency, SidebarPanel.BorderSizePixel = UDim2.new(0, 145, 1, -34), UDim2.new(0, 6, 0, 28), Color3.fromRGB(15, 16, 22), 0, 0
SidebarPanel.Parent = MainFrame
Instance.new("UICorner", SidebarPanel).CornerRadius = UDim.new(0, 6)
local SidebarStroke = Instance.new("UIStroke") SidebarStroke.Color, SidebarStroke.Thickness = Color3.fromRGB(40, 43, 52), 1 SidebarStroke.Parent = SidebarPanel

local SearchBox = Instance.new("TextBox")
SearchBox.Size, SearchBox.Position, SearchBox.BackgroundColor3, SearchBox.BackgroundTransparency, SearchBox.Text, SearchBox.PlaceholderText, SearchBox.PlaceholderColor3, SearchBox.TextColor3, SearchBox.TextSize, SearchBox.Font = UDim2.new(1, -10, 0, 24), UDim2.new(0, 5, 0, 5), Color3.fromRGB(22, 25, 34), 0, "", "🔍 Search section...", Color3.fromRGB(130, 135, 145), Color3.fromRGB(255, 255, 255), 10, Enum.Font.FredokaOne
SearchBox.Parent = SidebarPanel
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Size, SidebarScroll.Position, SidebarScroll.BackgroundTransparency, SidebarScroll.BorderSizePixel, SidebarScroll.ScrollBarThickness = UDim2.new(1, -8, 1, -34), UDim2.new(0, 4, 0, 32), 1, 0, 2
SidebarScroll.Parent = SidebarPanel
local SidebarLayout = Instance.new("UIListLayout") SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 2) SidebarLayout.Parent = SidebarScroll

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundColor3, ContentContainer.BackgroundTransparency, ContentContainer.BorderSizePixel = UDim2.new(1, -158, 1, -34), UDim2.new(0, 153, 0, 28), Color3.fromRGB(15, 16, 22), 0, 0
ContentContainer.Parent = MainFrame
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 6)
local ContentStroke = Instance.new("UIStroke") ContentStroke.Color, ContentStroke.Thickness = Color3.fromRGB(40, 43, 52), 1 ContentStroke.Parent = ContentContainer

local ContentHeader = Instance.new("Frame") ContentHeader.Size, ContentHeader.BackgroundTransparency = UDim2.new(1, 0, 0, 30), 1 ContentHeader.Parent = ContentContainer

local ActiveTabTitle = Instance.new("TextLabel")
ActiveTabTitle.Size, ActiveTabTitle.Position, ActiveTabTitle.BackgroundTransparency, ActiveTabTitle.Text, ActiveTabTitle.TextColor3, ActiveTabTitle.TextSize, ActiveTabTitle.Font, ActiveTabTitle.TextXAlignment = UDim2.new(1, -40, 1, 0), UDim2.new(0, 12, 0, 0), 1, "", Color3.fromRGB(255, 255, 255), 12, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
ActiveTabTitle.Parent = ContentHeader

local HeaderDivider = Instance.new("Frame") HeaderDivider.Size, HeaderDivider.Position, HeaderDivider.BackgroundColor3, HeaderDivider.BorderSizePixel = UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 30), Color3.fromRGB(40, 43, 52), 0 HeaderDivider.Parent = ContentContainer
local Tabs = {}
local FirstTab = nil

local function CreateTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size, tabBtn.BackgroundTransparency, tabBtn.Text, tabBtn.TextColor3, tabBtn.TextSize, tabBtn.Font, tabBtn.TextXAlignment = UDim2.new(1, 0, 0, 28), 1, "   " .. tabName, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
    tabBtn.Parent = SidebarScroll

    local indicator = Instance.new("Frame")
    indicator.Size, indicator.Position, indicator.BackgroundColor3, indicator.BorderSizePixel, indicator.Visible = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6), Color3.fromRGB(255, 105, 180), 0, false
    indicator.Parent = tabBtn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size, tabContent.Position, tabContent.BackgroundTransparency, tabContent.BorderSizePixel, tabContent.ScrollBarThickness, tabContent.Visible, tabContent.ClipsDescendants = UDim2.new(1, -12, 1, -38), UDim2.new(0, 6, 0, 34), 1, 0, 3, false, true
    tabContent.Parent = ContentContainer
    local contentLayout = Instance.new("UIListLayout") contentLayout.SortOrder, contentLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5) contentLayout.Parent = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Content.Visible, t.Indicator.Visible = false, false end
        tabContent.Visible, indicator.Visible = true, true
        ActiveTabTitle.Text = tabName
    end)

    local tabObj = { Button = tabBtn, Content = tabContent, Indicator = indicator }
    table.insert(Tabs, tabObj)

    if not FirstTab then
        FirstTab = tabObj
        tabContent.Visible, indicator.Visible = true, true
        ActiveTabTitle.Text = tabName
    end

    local Elements = {}
    function Elements:AddButton(name, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size, Btn.BackgroundColor3, Btn.BackgroundTransparency, Btn.Text, Btn.TextColor3, Btn.TextSize, Btn.Font = UDim2.new(1, -4, 0, 32), Color3.fromRGB(22, 25, 34), 0, "  " .. name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Parent = tabContent
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        local btnStroke = Instance.new("UIStroke") btnStroke.Color, btnStroke.Thickness = Color3.fromRGB(40, 43, 52), 1 btnStroke.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function()
            if LastSelectedScriptStroke then LastSelectedScriptStroke.Color, LastSelectedScriptStroke.Thickness = Color3.fromRGB(40, 43, 52), 1 end
            btnStroke.Color, btnStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
            LastSelectedScriptStroke = btnStroke
            callback()
        end)
        table.insert(RegisteredScripts, {Name = name, Callback = callback})
    end
    return Elements
end

-- TẠO 6 TAB TRÊN GIAO DIỆN MỚI
local tab1 = CreateTab("🌸 STEAL AN EGG 🌸")
tab1:AddButton("1. Hop sv1 người (nokey)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
tab1:AddButton("2. FyyCommunity (lúc có key lúc no key)", function() loadstring(game:HttpGet("https://FyyCommunity.my.id"))() end)
tab1:AddButton("3. Chilli Hub V4 (nokey)", function() loadstring(game:HttpGet("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4"))() end)
tab1:AddButton("4. Night hub (nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"))() end)
tab1:AddButton("5. Lemon Hub v4 (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt", true))() end)
tab1:AddButton("6. Hoshi hub (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua"))() end)
tab1:AddButton("7. Bigfroot (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))() end)
tab1:AddButton("8. Chữ A ajjans (có key)", function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"))() end)
tab1:AddButton("9. Speed hub (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end)
tab1:AddButton("10. Neohub (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/neohubdev/script/main/script"))() end)
tab1:AddButton("11. Real kid (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() end)
tab1:AddButton("12. Chilli v2 (có key)", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/ronnei/1fa67c56dd9af203b192d15e752928e5/raw/4e2d5105640e09a008b4ae6df23f9708cadfef06/chilliv2-stealanegg"))() end)

local tab2 = CreateTab("🌸 BLOX FRUIT 🌸")
tab2:AddButton("1. RedzHub v2 (no key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))() end)
tab2:AddButton("2. Quantumx Hub (nokey)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))() end)
tab2:AddButton("3. Speed Hub (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end)
tab2:AddButton("4. Omg Hub (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))() end)
tab2:AddButton("5. TeddyHub (có key)", function() repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))() end)
tab2:AddButton("6. Gravity Hub (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))() end)
tab2:AddButton("7. Realkid hub (có key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() end)
tab2:AddButton("8. BananaHub (có key)", function() repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer getgenv().Team = "Marines" loadstring(game:HttpGet("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua"))() end)
local tab3 = CreateTab("🌸BREAK AN STEAL🌸")
tab3:AddButton("1. break and steal an egg", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))() end)

local tab4 = CreateTab("Tab 4")
local tab5 = CreateTab("Tab 5")

local tab6 = CreateTab("👾KHÁC👾")
local t6Content = tab6.Content

local configFolder = "VzNamHub_Configs"
if typeof(makefolder) == "function" then pcall(makefolder, configFolder) end

local configNameBox = Instance.new("TextBox", t6Content)
configNameBox.Size, configNameBox.BackgroundColor3, configNameBox.PlaceholderText, configNameBox.Text, configNameBox.TextColor3, configNameBox.TextSize, configNameBox.Font = UDim2.new(1, -4, 0, 30), Color3.fromRGB(22, 25, 34), "📝 Nhập tên cấu hình...", "", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", configNameBox).CornerRadius = UDim.new(0, 5)

local saveConfigBtn = Instance.new("TextButton", t6Content)
saveConfigBtn.Size, saveConfigBtn.BackgroundColor3, saveConfigBtn.Text, saveConfigBtn.TextColor3, saveConfigBtn.TextSize, saveConfigBtn.Font = UDim2.new(1, -4, 0, 30), Color3.fromRGB(50, 200, 50), "💾 Lưu Cấu Hình Này ✅", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", saveConfigBtn).CornerRadius = UDim.new(0, 5)

local selectedConfigName = ""
local configDropBtn = Instance.new("TextButton", t6Content)
configDropBtn.Size, configDropBtn.BackgroundColor3, configDropBtn.Text, configDropBtn.TextColor3, configDropBtn.TextSize, configDropBtn.Font, configDropBtn.TextXAlignment = UDim2.new(1, -4, 0, 30), Color3.fromRGB(22, 25, 34), " 📂 Chọn Cấu Hình Đã Lưu...", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", configDropBtn).CornerRadius = UDim.new(0, 5)

local configDropFrame = Instance.new("ScrollingFrame", t6Content)
configDropFrame.Size, configDropFrame.BackgroundColor3, configDropFrame.CanvasSize, configDropFrame.ScrollBarThickness, configDropFrame.Visible, configDropFrame.ClipsDescendants = UDim2.new(1, -4, 0, 90), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false, true
Instance.new("UICorner", configDropFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIListLayout", configDropFrame).Padding = UDim.new(0, 4)

local loadConfigBtn = Instance.new("TextButton", t6Content)
loadConfigBtn.Size, loadConfigBtn.BackgroundColor3, loadConfigBtn.Text, loadConfigBtn.TextColor3, loadConfigBtn.TextSize, loadConfigBtn.Font = UDim2.new(1, -4, 0, 30), Color3.fromRGB(50, 150, 255), "📥 Tải Cấu Hình Đã Chọn 📂", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", loadConfigBtn).CornerRadius = UDim.new(0, 5)

local selScript, isAuto = nil, false
local dropBtn = Instance.new("TextButton", t6Content)
dropBtn.Size, dropBtn.BackgroundColor3, dropBtn.Text, dropBtn.TextColor3, dropBtn.TextSize, dropBtn.Font, dropBtn.TextXAlignment = UDim2.new(1, -4, 0, 30), Color3.fromRGB(22, 25, 34), " 📜 Chọn Script Auto Load...", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)

local dropFrame = Instance.new("ScrollingFrame", t6Content)
dropFrame.Size, dropFrame.BackgroundColor3, dropFrame.CanvasSize, dropFrame.ScrollBarThickness, dropFrame.Visible, dropFrame.ClipsDescendants = UDim2.new(1, -4, 0, 90), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false, true
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIListLayout", dropFrame).Padding = UDim.new(0, 4)

local toggleAuto = Instance.new("TextButton", t6Content)
toggleAuto.Size, toggleAuto.BackgroundColor3, toggleAuto.Text, toggleAuto.TextColor3, toggleAuto.TextSize, toggleAuto.Font = UDim2.new(1, -4, 0, 30), Color3.fromRGB(200, 50, 50), "Auto Load Script Chạy: TẮT ❌", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
Instance.new("UICorner", toggleAuto).CornerRadius = UDim.new(0, 5)
local HubSound = SoundService:FindFirstChild("VzNamHubSound") or Instance.new("Sound", SoundService)
HubSound.Name, HubSound.Looped, HubSound.Volume = "VzNamHubSound", true, 0.5
local currentSoundId = "1837879082"

local musicDropBtn = Instance.new("TextButton", t6Content)
musicDropBtn.Size, musicDropBtn.BackgroundColor3, musicDropBtn.Text, musicDropBtn.TextColor3, musicDropBtn.TextSize, musicDropBtn.Font, musicDropBtn.TextXAlignment = UDim2.new(1, -4, 0, 30), Color3.fromRGB(22, 25, 34), " 🎵 Chọn Nhạc Nền...", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
Instance.new("UICorner", musicDropBtn).CornerRadius = UDim.new(0, 5)

local musicDropFrame = Instance.new("ScrollingFrame", t6Content)
musicDropFrame.Size, musicDropFrame.BackgroundColor3, musicDropFrame.CanvasSize, musicDropFrame.ScrollBarThickness, musicDropFrame.Visible, musicDropFrame.ClipsDescendants = UDim2.new(1, -4, 0, 110), Color3.fromRGB(28, 32, 42), UDim2.new(0,0,0,0), 3, false, true
Instance.new("UICorner", musicDropFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIListLayout", musicDropFrame).Padding = UDim.new(0, 4)

local presetMusics = {
    {Name = "🎵 Chill Lofi Music", Id = "1837879082"},
    {Name = "🎶 Phonk Beat", Id = "1843404008"},
    {Name = "🎵 Anime Relaxing", Id = "9043887091"},
    {Name = "🎶 EDM Hype", Id = "1837871000"}
}
for i, m in ipairs(presetMusics) do
    local mBtn = Instance.new("TextButton", musicDropFrame)
    mBtn.Size, mBtn.BackgroundColor3, mBtn.Text, mBtn.TextColor3, mBtn.TextSize, mBtn.Font, mBtn.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), " " .. m.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 4)
    mBtn.MouseButton1Click:Connect(function()
        currentSoundId = m.Id
        musicDropBtn.Text = " 🎵 " .. m.Name
        musicDropFrame.Visible = false
        if HubSound.IsPlaying then HubSound.SoundId = "rbxassetid://" .. currentSoundId HubSound:Play() end
    end)
end
musicDropFrame.CanvasSize = UDim2.new(0, 0, 0, #presetMusics * 30)

local isMusicPlaying = false
local toggleMusicBtn = Instance.new("TextButton", t6Content)
toggleMusicBtn.Size, toggleMusicBtn.BackgroundColor3, toggleMusicBtn.Text, toggleMusicBtn.TextColor3, toggleMusicBtn.TextSize, toggleMusicBtn.Font = UDim2.new(1, -4, 0, 30), Color3.fromRGB(200, 50, 50), "Phát Nhạc Background: TẮT ❌", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
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

local isFpsModeOn = false
local toggleFpsBtn = Instance.new("TextButton", t6Content)
toggleFpsBtn.Size, toggleFpsBtn.BackgroundColor3, toggleFpsBtn.Text, toggleFpsBtn.TextColor3, toggleFpsBtn.TextSize, toggleFpsBtn.Font = UDim2.new(1, -4, 0, 30), Color3.fromRGB(200, 50, 50), "Màn Hình Đen Giảm FPS: TẮT ❌", Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne
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

-- HÀM XỬ LÝ DROPDOWN SCRIPT & CONFIG
local function refreshConfigList()
    for _, c in ipairs(configDropFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    if typeof(listfiles) ~= "function" then return end
    local success, files = pcall(listfiles, configFolder)
    if success and files then
        local h = 0
        for _, file in ipairs(files) do
            local fName = file:match("([^/]+)$"):gsub("%.json$", "")
            local cBtn = Instance.new("TextButton", configDropFrame)
            cBtn.Size, cBtn.BackgroundColor3, cBtn.Text, cBtn.TextColor3, cBtn.TextSize, cBtn.Font, cBtn.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), " 📁 " .. fName, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
            Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
            cBtn.MouseButton1Click:Connect(function() selectedConfigName = fName configDropBtn.Text = " 📂 " .. fName configDropFrame.Visible = false end)
            h = h + 30
        end
        configDropFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end
end

configDropBtn.MouseButton1Click:Connect(function() refreshConfigList() configDropFrame.Visible = not configDropFrame.Visible dropFrame.Visible = false musicDropFrame.Visible = false end)

saveConfigBtn.MouseButton1Click:Connect(function()
    local cName = configNameBox.Text
    if cName ~= "" and typeof(writefile) == "function" then
        pcall(writefile, configFolder .. "/" .. cName .. ".json", HttpService:JSONEncode({Script = selScript and selScript.Name or "", SoundId = currentSoundId}))
        saveConfigBtn.Text = "💾 Đã Lưu Thành Công! ✅"
        task.wait(1.5)
        saveConfigBtn.Text = "💾 Lưu Cấu Hình Này ✅"
        refreshConfigList()
    end
end)

loadConfigBtn.MouseButton1Click:Connect(function()
    if selectedConfigName ~= "" and typeof(readfile) == "function" and isfile(configFolder .. "/" .. selectedConfigName .. ".json") then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(configFolder .. "/" .. selectedConfigName .. ".json")) end)
        if success and data then
            currentSoundId = data.SoundId or currentSoundId
            if HubSound.IsPlaying then HubSound.SoundId = "rbxassetid://" .. currentSoundId HubSound:Play() end
            loadConfigBtn.Text = "📥 Tải Cấu Hình Thành Công! ✅"
            task.wait(1.5)
            loadConfigBtn.Text = "📥 Tải Cấu Hình Đã Chọn 📂"
        end
    end
end)

dropBtn.MouseButton1Click:Connect(function() dropFrame.Visible = not dropFrame.Visible configDropFrame.Visible = false musicDropFrame.Visible = false end)
musicDropBtn.MouseButton1Click:Connect(function() musicDropFrame.Visible = not musicDropFrame.Visible configDropFrame.Visible = false dropFrame.Visible = false end)

local dh = 0
for _, scr in ipairs(RegisteredScripts) do
    local item = Instance.new("TextButton", dropFrame)
    item.Size, item.BackgroundColor3, item.Text, item.TextColor3, item.TextSize, item.Font, item.TextXAlignment = UDim2.new(1, 0, 0, 26), Color3.fromRGB(35, 40, 50), "  ▶ " .. scr.Name, Color3.fromRGB(255, 255, 255), 11, Enum.Font.FredokaOne, Enum.TextXAlignment.Left
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

-- NÚT MỞ MENU AVATAR TRÒN + VIỀN RAINBOW
local OpenButton = Instance.new("ImageButton")
OpenButton.Name, OpenButton.Size, OpenButton.Position, OpenButton.BackgroundColor3, OpenButton.BorderSizePixel, OpenButton.Image, OpenButton.Active, OpenButton.Draggable = "VzNamOpenBtn", UDim2.new(0, 42, 0, 42), UDim2.new(0, 15, 0.2, 0), Color3.fromRGB(20, 22, 28), 0, avatarUrl, true, true
OpenButton.Parent = ScreenGui
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
local OpenStroke = Instance.new("UIStroke") OpenStroke.Thickness, OpenStroke.Parent = 3.5, OpenButton

RunService.RenderStepped:Connect(function()
    OpenStroke.Color = Color3.fromHSV((tick() % 4) / 4, 1, 1)
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
refreshConfigList()
