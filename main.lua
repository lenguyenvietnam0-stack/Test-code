--[[
    ═══════════════════════════════════════════════════════
    VzNam Hub v4 — ĐÃ SỬA LỖI
    ═══════════════════════════════════════════════════════
    • Tab "ĐÁNH CẮC TRỨNG CHÍNH" ngay dưới Trang Chủ
    • Cấu hình: Tên Config / Tạo Mới / Xóa / Tải / Lưu trực tiếp trong Cấu hình
    • Đã xóa: Auto Lưu cấu hình, Auto Tải cấu hình, mục "Profiles"
]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end
if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end

-- ═════════════════ THEO DÕI KẾT NỐI ═════════════════
Kết nối cục bộ = {}
hàm cục bộ Track(conn)
    if conn then table.insert(Connections, conn) end
    trả về kết nối
kết thúc
hàm cục bộ DisconnectAll()
    for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
    Kết nối = {}
kết thúc

-- ═════════════════ TRẠNG THÁI ═════════════════
Bang địa phương = {
    ThemeBase = Color3.fromRGB(15, 16, 22),
    StrokeMode = "Solid",
    StrokeColor = Color3.fromRGB(0, 191, 255),
    Thể tích = 0,5,
    SoundId = "1837879082",
    SelectedScript = nil,
    IsAutoLoad = false,
    CurrentConfig = "Default",
    Trong suốt = 0,
}

local RefreshStartupLabel = function() end

-- ═════════════════ TRỢ GIÚP UI ═════════════════
hàm cục bộ Corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = radius or UDim.new(0, 5)
    trả về c
kết thúc

cục bộ AllUIStrokes = {}
hàm cục bộ Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke", parent)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color or State.StrokeColor
    s.Thickness = độ dày hoặc 1
    table.insert(AllUIStrokes, s)
    trả về s
kết thúc

local ThemeElements = {}
hàm cục bộ RegTheme(el, t)
    table.insert(ThemedElements, {Element = el, Type = t})
    trả về el
kết thúc

-- ═════════════════ TẢI TRỌNG AN TOÀN ═════════════════
local ALLOWED_HOSTS = {
    "raw.githubusercontent.com",
    "gist.githubusercontent.com",
    "github.com",
    "api.luarmor.net",
    "fyycommunity.my.id",
    "id.tomroblox.com",
}
hàm cục bộ IsUrlAllowed(url)
    if typeof(url) ~= "string" then return false end
    máy chủ cục bộ = chuỗi.match(url, "^https?://([^/]+)")
    nếu không phải là máy chủ thì trả về false.
    máy chủ = máy chủ:lower()
    for _, h in ipairs(ALLOWED_HOSTS) do
        if host == h or host:sub(-(#h + 1)) == "." .. h then return true end
    kết thúc
    trả về false
kết thúc

hàm cục bộ SafeLoad(url)
    nếu không phải là IsUrlAllowed(url) thì
        cảnh báo("[VzNam] Tên miền bị chặn: " .. tostring(url))
        trả về false
    kết thúc
    cục bộ ok, nguồn = pcall(function() trả về trò chơi:HttpGet(url, true) kết thúc)
    Nếu không ổn hoặc không phải nguồn thì trả về false.
    local ok2, fn = pcall(loadstring, source)
    nếu không phải ok2 hoặc không phải fn thì trả về false.
    cục bộ ok3, err = pcall(fn)
    if not ok3 then warn("[VzNam] Runtime error: " .. tostring(err)) end
    trả về ok3
kết thúc

-- ═════════════════ Giao diện người dùng gốc ═════════════════
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
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Góc(Khung chính, UDim.new(0, 8))
local OuterStroke = Stroke(MainFrame, Color3.fromRGB(0, 191, 255), 2)

local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size, ResizeBtn.Position = UDim2.new(0, 18, 0, 18), UDim2.new(1, -18, 1, -18)
ResizeBtn.BackgroundTransparency, ResizeBtn.Text = 1, "◢"
ResizeBtn.TextColor3, ResizeBtn.TextSize, ResizeBtn.ZIndex = Color3.fromRGB(0, 191, 255), 12, 10

thay đổi kích thước cục bộ, resizeStart, startSize = false, nil, nil
Theo dõi(ResizeBtn.InputBegan:Connect(function(input)
    nếu input.UserInputType == Enum.UserInputType.MouseButton1
       hoặc input.UserInputType == Enum.UserInputType.Touch thì
        thay đổi kích thước = đúng
        resizeStart = input.Position
        startSize = MainFrame.AbsoluteSize
    kết thúc
kết thúc))
Theo dõi(UserInputService.InputEnded:Connect(function(input)
    nếu input.UserInputType == Enum.UserInputType.MouseButton1
       hoặc input.UserInputType == Enum.UserInputType.Touch thì
        thay đổi kích thước = sai
    kết thúc
kết thúc))
Theo dõi(UserInputService.InputChanged:Connect(function(input)
    nếu thay đổi kích thước và (input.UserInputType == Enum.UserInputType.MouseMovement
       hoặc input.UserInputType == Enum.UserInputType.Touch) thì
        local d = input.Position - resizeStart
        MainFrame.Size = UDim2.new(0,
            math.clamp(startSize.X + dX, 320, 500), 0,
            math.clamp(startSize.Y + dY, 230, 450))
    kết thúc
kết thúc))

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1

local Logo = Instance.new("Frame", TopBar)
Logo.Size, Logo.Position = UDim2.new(0, 18, 0, 18), UDim2.new(0, 6, 0.5, -9)
Logo.BackgroundColor3, Logo.BorderSizePixel = Color3.fromRGB(0, 191, 255), 0
Góc(Logo, UDim.new(0, 4))
Stroke(Logo, Color3.fromRGB(0, 191, 255))

local LogoIcon = Instance.new("TextLabel", Logo)
LogoIcon.Size, LogoIcon.BackgroundTransparency = UDim2.new(1,0,1,0), 1
LogoIcon.Text, LogoIcon.TextColor3 = "**", Color3.fromRGB(255,255,255)
LogoIcon.TextSize, LogoIcon.Font = 10, Enum.Font.GothamBold

local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position = UDim2.new(1, -60, 1, 0), UDim2.new(0, 28, 0, 0)
Title.BackgroundTransparency, Title.Text = 1, "🌸 VzNam Hub v4 🌸"
Title.TextColor3, Title.TextSize = Color3.fromRGB(0, 191, 255), 11
Tiêu đề.Font, Tiêu đề.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 24, 0, 24), UDim2.new(1, -26, 0.5, -12)
CloseBtn.BackgroundTransparency, CloseBtn.Text = 1, "✕"
CloseBtn.TextColor3, CloseBtn.TextSize = Color3.fromRGB(200, 200, 210), 10
CloseBtn.Font = Enum.Font.GothamBold

Theo dõi(CloseBtn.MouseButton1Click:Connect(function()
    DisconnectAll()
    nếu SoundService:FindFirstChild("VzNamHubSound") thì
        SoundService.VzNamHubSound:Stop()
        SoundService.VzNamHubSound:Destroy()
    kết thúc
    ScreenGui:Destroy()
kết thúc))

local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Size, SidebarPanel.Position = UDim2.new(0.3, -4, 1, -34), UDim2.new(0, 6, 0, 28)
SidebarPanel.BackgroundColor3, SidebarPanel.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Góc(SidebarPanel, UDim.new(0, 6))
Stroke(SidebarPanel, Color3.fromRGB(0,191,255), 1)

local SearchBoxTab = Instance.new("TextBox", SidebarPanel)
SearchBoxTab.Size, SearchBoxTab.Position = UDim2.new(1, -8, 0, 18), UDim2.new(0, 4, 0, 4)
SearchBoxTab.BackgroundColor3 = Color3.fromRGB(12,12,17)
SearchBoxTab.Text, SearchBoxTab.PlaceholderText = "", "🔍 Tìm kiếm..."
SearchBoxTab.PlaceholderColor3, SearchBoxTab.TextColor3 = Color3.fromRGB(150,155,165), Color3.fromRGB(255,255,255)
SearchBoxTab.TextSize, SearchBoxTab.Font = 8, Enum.Font.Gotham
Góc(SearchBoxTab, UDim.new(0, 4))
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

Theo dõi (SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 10)
kết thúc))

Theo dõi(SearchBoxTab:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchBoxTab.Text)
    for _, item in ipairs(SidebarScroll:GetChildren()) do
        nếu mục là một "TextButton" thì
            item.Visible = (q == "" or string.find(string.lower(item.Text), q, 1, true)) and true or false
        kết thúc
    kết thúc
kết thúc))

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position = UDim2.new(0.68, -4, 1, -34), UDim2.new(0.315, 0, 0, 28)
ContentContainer.BackgroundColor3, ContentContainer.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Góc(ContentContainer, UDim.new(0, 6))
Stroke(ContentContainer, Color3.fromRGB(0,191,255), 1)

local ContentHeader = Instance.new("Frame", ContentContainer)
ContentHeader.Size, ContentHeader.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1

local ActiveTabTitle = Instance.new("TextLabel", ContentHeader)
ActiveTabTitle.Size, ActiveTabTitle.Position = UDim2.new(1, -30, 1, 0), UDim2.new(0, 6, 0, 0)
ActiveTabTitle.BackgroundTransparency, ActiveTabTitle.Text = 1, ""
ActiveTabTitle.TextColor3, ActiveTabTitle.TextSize = Color3.fromRGB(255,255,255), 10
ActiveTabTitle.Font, ActiveTabTitle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local SearchInputContent = Instance.new("TextBox", ContentHeader)
SearchInputContent.Size, SearchInputContent.Position = UDim2.new(1, -34, 0, 18), UDim2.new(0, 6, 0.5, -9)
SearchInputContent.BackgroundColor3 = Color3.fromRGB(12,12,17)
SearchInputContent.TextColor3, SearchInputContent.PlaceholderText = Color3.fromRGB(255,255,255), "Tính năng tìm kiếm..."
SearchInputContent.PlaceholderColor3, SearchInputContent.TextSize = Color3.fromRGB(150,155,165), 8
SearchInputContent.Font, SearchInputContent.Visible = Enum.Font.Gotham, false
Góc(SearchInputContent, UDim.new(0, 4))
Stroke(SearchInputContent)
RegTheme(SearchInputContent, "Input")

local SearchContentIcon = Instance.new("TextButton", ContentHeader)
SearchContentIcon.Size, SearchContentIcon.Position = UDim2.new(0, 20, 0, 20), UDim2.new(1, -24, 0.5, -10)
SearchContentIcon.BackgroundTransparency, SearchContentIcon.Text = 1, "🔍"
SearchContentIcon.TextSize, SearchContentIcon.TextColor3 = 9, Color3.fromRGB(200,205,215)

tìm kiếm cục bộ = sai
Theo dõi(SearchContentIcon.MouseButton1Click:Connect(function()
    tìm kiếm = không tìm kiếm
    SearchInputContent.Visible = đang tìm kiếm
    ActiveTabTitle.Visible = không tìm kiếm
    Nếu đang tìm kiếm thì SearchInputContent:CaptureFocus() ngược lại SearchInputContent.Text = ""
kết thúc))

local HeaderDivider = Instance.new("Frame", ContentContainer)
HeaderDivider.Size, HeaderDivider.Position = UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 26)
HeaderDivider.BackgroundColor3, HeaderDivider.BorderSizePixel = Color3.fromRGB(0,191,255), 0

tab cục bộ = {}

-- ═════════════════ TAB 0: TRANG CHỦ ═════════════════
local tabHomeBtn = Instance.new("TextButton", SidebarScroll)
tabHomeBtn.LayoutOrder = 0
tabHomeBtn.Size, tabHomeBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabHomeBtn.BackgroundTransparency, tabHomeBtn.Text = 0, " 🏠 Trang Chủ"
tabHomeBtn.TextColor3, tabHomeBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabHomeBtn.Font, tabHomeBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Góc (tab Trang chủ)
RegTheme(tabHomeBtn, "Primary")

local homeIndexor = Instance.new("Frame", tabHomeBtn)
homeIndicator.Size, homeIndicator.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6)
homeIndicator.BackgroundColor3, homeIndicator.BorderSizePixel = Color3.fromRGB(255,105,180), 0
homeIndicator.Visible = false
Góc(homeIndicator, UDim.new(0, 2))

local homeScroll = Instance.new("ScrollingFrame", ContentContainer)
homeScroll.Size, homeScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
homeScroll.BackgroundTransparency, homeScroll.BorderSizePixel = 1, 0
homeScroll.ScrollBarThickness, homeScroll.Visible, homeScroll.ClipsDescendants = 3, false, true
local homeLayout = Instance.new("UIListLayout", homeScroll)
homeLayout.SortOrder, homeLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5)
homeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local homePad = Instance.new("UIPadding", homeScroll)
homePad.PaddingLeft, homePad.PaddingRight = UDim.new(0, 4), UDim.new(0, 10)
homePad.PaddingTop, homePad.PaddingBottom = UDim.new(0, 4), UDim.new(0, 4)

Theo dõi(homeLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    homeScroll.CanvasSize = UDim2.new(0, 0, 0, homeLayout.AbsoluteContentSize.Y + 15)
kết thúc))

Theo dõi(tabHomeBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do
        t.Container.Visible = false
        if t.Indicator then t.Indicator.Visible = false end
    kết thúc
    homeScroll.Visible, homeIndicator.Visible = true, true
    ActiveTabTitle.Text = "🏠 Trang Chủ"
    SearchInputContent.Text = ""
kết thúc))

table.insert(Tabs, {Container = homeScroll, Indicator = homeIndicator})
homeScroll.Visible, homeIndicator.Visible = true, true
ActiveTabTitle.Text = "🏠 Trang Chủ"

local infoToggleBtn = Instance.new("TextButton", homeScroll)
infoToggleBtn.LayoutOrder = 1
infoToggleBtn.Size, infoToggleBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 32), Color3.fromRGB(55,12,40)
infoToggleBtn.BackgroundTransparency, infoToggleBtn.Text = 0, " → thông tin"
infoToggleBtn.TextColor3, infoToggleBtn.TextSize = Color3.fromRGB(255,255,255), 10
infoToggleBtn.Font, infoToggleBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Góc (infoToggleBtn)
Stroke(infoToggleBtn)
RegTheme(infoToggleBtn, "Secondary")

local infoSubLabel = Instance.new("TextLabel", infoToggleBtn)
infoSubLabel.Size, infoSubLabel.Position = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14)
infoSubLabel.BackgroundTransparency, infoSubLabel.Text = 1, "Xem Hub thông tin"
infoSubLabel.TextColor3, infoSubLabel.TextSize = Color3.fromRGB(140,140,150), 7
infoSubLabel.Font, infoSubLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Center

local infoContainer = Instance.new("Frame", homeScroll)
infoContainer.LayoutOrder = 2
infoContainer.Size, infoContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
infoContainer.BackgroundTransparency = 1
infoContainer.Visible = false
local infoLayout = Instance.new("UIListLayout", infoContainer)
infoLayout.SortOrder, infoLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
infoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Theo dõi(infoToggleBtn.MouseButton1Click:Connect(function()
    infoContainer.Visible = not infoContainer.Visible
    infoToggleBtn.Text = infoContainer.Visible và " ↓ thông tin" hoặc " → thông tin"
    infoSubLabel.Visible = infoContainer.Visible
kết thúc))

local function CreateHomeCard(parent, order, bgColor, titleText, mainText, copyText, borderColor, iconSymbol)
    thẻ cục bộ = Instance.new("Frame", parent)
    card.LayoutOrder, card.Size = order, UDim2.new(1, 0, 0, 26)
    card.BackgroundColor3, card.BorderSizePixel = bgColor, 0
    Góc (thẻ)
    Stroke(card, borderColor, 1)

    local iconCircle = Instance.new("Frame", card)
    iconCircle.Size, iconCircle.Position = UDim2.new(0, 16, 0, 16), UDim2.new(0, 4, 0.5, -8)
    iconCircle.BackgroundColor3, iconCircle.BorderSizePixel = borderColor, 0
    Góc(iconCircle, UDim.new(1, 0))
    Stroke(iconCircle, borderColor)

    local iconLbl = Instance.new("TextLabel", iconCircle)
    iconLbl.Size, iconLbl.BackgroundTransparency = UDim2.new(1,0,1,0), 1
    iconLbl.Text, iconLbl.TextColor3 = iconSymbol, Color3.fromRGB(255,255,255)
    iconLbl.TextSize, iconLbl.Font = 7, Enum.Font.GothamBold

    local tLbl = Instance.new("TextLabel", card)
    tLbl.Size, tLbl.Position = UDim2.new(1, -70, 0, 10), UDim2.new(0, 24, 0, 1)
    tLbl.BackgroundTransparency, tLbl.Text = 1, titleText
    tLbl.TextColor3, tLbl.TextSize = Color3.fromRGB(255,150,100), 7
    tLbl.Font, tLbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

    local mLbl = Instance.new("TextLabel", card)
    mLbl.Size, mLbl.Position = UDim2.new(1, -70, 0, 12), UDim2.new(0, 24, 0, 12)
    mLbl.BackgroundTransparency, mLbl.Text = 1, mainText
    mLbl.TextColor3, mLbl.TextSize = Color3.fromRGB(220,220,230), 7
    mLbl.Font, mLbl.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left

    nếu copyText ~= "" thì
        local copyBtn = Instance.new("TextButton", card)
        copyBtn.Size, copyBtn.Position = UDim2.new(0, 42, 0, 16), UDim2.new(1, -44, 0.5, -8)
        copyBtn.BackgroundTransparency, copyBtn.Text = 1, "📋 SAO CHÉP"
        copyBtn.TextColor3, copyBtn.TextSize = Color3.fromRGB(200,200,210), 7
        copyBtn.Font = Enum.Font.GothamBold

        hàm cục bộ doCopy()
            nếu kiểu dữ liệu của (setclipboard) == "function" thì
                pcall(setclipboard, copyText)
                copyBtn.Text = "✓ ĐÃ SAO CHÉP"
                task.delay(1.5, function()
                    if copyBtn.Parent then copyBtn.Text = "📋 COPY" end
                kết thúc)
            kết thúc
        kết thúc
        Theo dõi(copyBtn.MouseButton1Click:Connect(doCopy))
        Theo dõi(card.InputBegan:Connect(function(input)
            nếu input.UserInputType == Enum.UserInputType.MouseButton1
               hoặc input.UserInputType == Enum.UserInputType.Touch thì doCopy() kết thúc
        kết thúc))
    kết thúc
kết thúc

CreateHomeCard(infoContainer, 1, Color3.fromRGB(70,20,45), "ĐỢƯC TẠO BỞI", "VzNam ROBLOX", "", Color3.fromRGB(180,50,50), "👤")
CreateHomeCard(infoContainer, 2, Color3.fromRGB(30,40,70), "DISCORD SERVER",
    "https://discord.gg/6TG7krbsU",
    "https://discord.gg/6TG7krbsU",
    Color3.fromRGB(60,100,200), "💬")
CreateHomeCard(infoContainer, 3, Color3.fromRGB(45,45,65), "KÊNH TIKTOK",
    "https://www.tiktok.com/@uttop1gl.ovo",
    "https://www.tiktok.com/@uttop1gl.ovo?_r=1&_t=ZS-9AWatTQR08y",
    Color3.fromRGB(100,100,120), "🎵")

-- ═════════════════ TAB 1: CHÍNH TRÒ CHƠI TRỘM TRỨNG ═════════════════
local tabMainBtn = Instance.new("TextButton", SidebarScroll)
tabMainBtn.LayoutOrder = 1
tabMainBtn.Size, tabMainBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabMainBtn.BackgroundTransparency, tabMainBtn.Text = 0, " 📌 TRỘM TRỨNG CHÍNH"
tabMainBtn.TextColor3, tabMainBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabMainBtn.Font, tabMainBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Góc (tabMainBtn)
RegTheme(tabMainBtn, "Primary")

local mainIndicator = Instance.new("Frame", tabMainBtn)
mainIndicator.Size, mainIndicator.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6)
mainIndicator.BackgroundColor3, mainIndicator.BorderSizePixel = Color3.fromRGB(255,105,180), 0
mainIndicator.Visible = false
Góc(mainIndicator, UDim.new(0, 2))

local mainScroll = Instance.new("ScrollingFrame", ContentContainer)
mainScroll.Size, mainScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
mainScroll.BackgroundTransparency, mainScroll.BorderSizePixel = 1, 0
mainScroll.ScrollBarThickness, mainScroll.Visible, mainScroll.ClipsDescendants = 3, false, true
local mainLayout = Instance.new("UIListLayout", mainScroll)
mainLayout.SortOrder, mainLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5)
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local mainPad = Instance.new("UIPadding", mainScroll)
mainPad.PaddingLeft, mainPad.PaddingRight = UDim.new(0, 4), UDim.new(0, 10)
mainPad.PaddingTop, mainPad.PaddingBottom = UDim.new(0, 4), UDim.new(0, 4)

Theo dõi (mainLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    mainScroll.CanvasSize = UDim2.new(0, 0, 0, mainLayout.AbsoluteContentSize.Y + 15)
kết thúc))

Theo dõi(tabMainBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do
        t.Container.Visible = false
        if t.Indicator then t.Indicator.Visible = false end
    kết thúc
    mainScroll.Visible, mainIndicator.Visible = true, true
    ActiveTabTitle.Text = "📌 TRỘM TRỨNG CHÍNH"
    SearchInputContent.Text = ""
kết thúc))

table.insert(Tabs, {Container = mainScroll, Indicator = mainIndicator})

-- ═════════════════ MẪU TAB ═════════════════
local RegisteredScripts = {}
local LastSelectedScriptStroke = nil

hàm cục bộ CreateCategoryTab(tabName, layoutOrder)
    local tabBtn = Instance.new("TextButton", SidebarScroll)
    tabBtn.LayoutOrder = layoutOrder hoặc 0
    tabBtn.Size, tabBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
    tabBtn.BackgroundTransparency, tabBtn.Text = 0, " " .. tabName
    tabBtn.TextColor3, tabBtn.TextSize = Color3.fromRGB(255,255,255), 8
    tabBtn.Font, tabBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
    Góc (tabBtn)
    RegTheme(tabBtn, "Primary")

    chỉ báo cục bộ = Instance.new("Frame", tabBtn)
    indicator.Size, indicator.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6)
    indicator.BackgroundColor3, indicator.BorderSizePixel = Color3.fromRGB(255,105,180), 0
    indicator.Visible = false
    Góc(chỉ báo, UDim.new(0, 2))

    local containerFrame = Instance.new("Frame", ContentContainer)
    containerFrame.Size = UDim2.new(1, 0, 1, -27)
    containerFrame.Position = UDim2.new(0, 0, 0, 27)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Visible = false
    containerFrame.ClipsDescendants = true

    local subBar = Instance.new("Frame", containerFrame)
    subBar.Size, subBar.Position = UDim2.new(1, -12, 0, 22), UDim2.new(0, 6, 0, 0)
    subBar.BackgroundTransparency, subBar.ZIndex = 1, 5
    local subLayout = Instance.new("UIListLayout", subBar)
    subLayout.FillDirection, subLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 4)

    local noKeyBtn = Instance.new("TextButton", subBar)
    noKeyBtn.Size, noKeyBtn.BackgroundColor3 = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(70,15,50)
    noKeyBtn.BackgroundTransparency, noKeyBtn.Text = 0, "không có phím"
    noKeyBtn.TextColor3, noKeyBtn.TextSize = Color3.fromRGB(255,255,255), 9
    noKeyBtn.Font, noKeyBtn.ZIndex = Enum.Font.GothamBold, 6
    Góc (không có nút phím)
    local nkStroke = Stroke(noKeyBtn, Color3.fromRGB(255,50,50), 2)
    RegTheme(noKeyBtn, "Primary")

    local hasKeyBtn = Instance.new("TextButton", subBar)
    hasKeyBtn.Size, hasKeyBtn.BackgroundColor3 = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(70,15,50)
    hasKeyBtn.BackgroundTransparency, hasKeyBtn.Text = 0, "có key"
    hasKeyBtn.TextColor3, hasKeyBtn.TextSize = Color3.fromRGB(255,255,255), 9
    hasKeyBtn.Font, hasKeyBtn.ZIndex = Enum.Font.GothamBold, 6
    Góc (có nút khóa)
    local hkStroke = Stroke(hasKeyBtn, Color3.fromRGB(0,191,255), 1)
    RegTheme(hasKeyBtn, "Primary")

    hàm cục bộ makeScroll()
        local s = Instance.new("ScrollingFrame", containerFrame)
        s.Position, s.Size = UDim2.new(0, 6, 0, 26), UDim2.new(1, -12, 1, -26)
        s.BackgroundTransparency, s.BorderSizePixel = 1, 0
        s.ScrollBarThickness, s.ClipsDescendants, s.ZIndex = 3, true, 1
        local p = Instance.new("UIPadding", s)
        p.PaddingLeft, p.PaddingRight, p.PaddingTop = UDim.new(0,4), UDim.new(0,10), UDim.new(0,4)
        local l = Instance.new("UIListLayout", s)
        l.Padding, l.HorizontalAlignment = UDim.new(0, 3), Enum.HorizontalAlignment.Center
        Theo dõi(l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            s.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 10)
        kết thúc))
        trả về s
    kết thúc

    local scrollNoKey = makeScroll(); scrollNoKey.Visible = true
    local scrollHasKey = makeScroll(); scrollHasKey.Visible = false

    hàm cục bộ applySearchFilter()
        if not containerFrame.Visible then return end
        local q = string.lower(SearchInputContent.Text)
        local target = scrollNoKey.Visible and scrollNoKey or scrollHasKey
        for _, item in ipairs(target:GetChildren()) do
            nếu mục là một "TextButton" thì
                item.Visible = (q == "" or string.find(string.lower(item.Text), q, 1, true)) and true or false
            kết thúc
        kết thúc
    kết thúc
    Theo dõi(SearchInputContent:GetPropertyChangedSignal("Text"):Connect(applySearchFilter))

    Theo dõi(noKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible, scrollHasKey.Visible = true, false
        nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(255,50,50), 2
        hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(0,191,255), 1
    kết thúc))
    Theo dõi(hasKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible, scrollHasKey.Visible = false, true
        hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(255,50,50), 2
        nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(0,191,255), 1
    kết thúc))

    Theo dõi(tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            if t.Indicator then t.Indicator.Visible = false end
        kết thúc
        containerFrame.Visible, indicator.Visible = true, true
        ActiveTabTitle.Text = tabName
        SearchInputContent.Text = ""
    kết thúc))

    table.insert(Tabs, {Container = containerFrame, Indicator = indicator})

    Các phần tử cục bộ = {}
    hàm cục bộ AddBtnTo(parent, name, callback)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size, Btn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
        Btn.BackgroundTransparency, Btn.Text = 0, " ▶ " .. tên
        Btn.TextColor3, Btn.TextSize = Color3.fromRGB(255,255,255), 9
        Btn.Font, Btn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
        Góc (Nút)
        local bStroke = Stroke(Btn, Color3.fromRGB(0,191,255), 1)
        RegTheme(Btn, "Primary")

        Theo dõi(Btn.MouseButton1Click:Connect(function()
            nếu LastSelectedScriptStroke thì
                LastSelectedScriptStroke.Color = Color3.fromRGB(0,191,255)
                LastSelectedScriptStroke.Thickness = 1
            kết thúc
            bStroke.Color, bStroke.Thickness = Color3.fromRGB(255,50,50), 2
            LastSelectedScriptStroke = bStroke
            pcall(callback)
        kết thúc))

        table.insert(RegisteredScripts, {Name = name, Callback = callback})
        nếu _G.__vznam_rebuildScriptDropdown thì _G.__vznam_rebuildScriptDropdown() kết thúc
        nút trả về
    kết thúc

    function Elements:AddNoKey(name, cb) return AddBtnTo(scrollNoKey, name, cb) end
    function Elements:AddHasKey(name, cb) return AddBtnTo(scrollHasKey, name, cb) end
    trả về các phần tử
kết thúc

-- ═════════════════ TAB 2: ĂN TRỘM TRỨNG ═════════════════
local tab1 = CreateCategoryTab("🌸TRỘM TRỨNG🌸", 2)
tab1:AddNoKey("1. Hop sv1 người(nokey)", function() SafeLoad("https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua") end)
tab1:AddNoKey("2. FyyCommunity(lúc có key lúc không có key)", function() SafeLoad("https://FyyCommunity.my.id") end)
tab1:AddNoKey("3. Chilli Hub V4(nokey)", function() SafeLoad("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4") end)
tab1:AddNoKey("4. Night hub(nokey)", function() SafeLoad("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau") end)
tab1:AddHasKey("1. Lemon Hub v4(có key)", function() SafeLoad("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt") end)
tab1:AddHasKey("2. Hoshi hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua") end)
tab1:AddHasKey("3. Bigfroot(có key)", function() SafeLoad("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua") end)
tab1:AddHasKey("4. Chữ A(ajjans)|(có key)", function() SafeLoad("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua") end)
tab1:AddHasKey("5. Speed ​​hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end)
tab1:AddHasKey("6. Neohub(có key)", function() SafeLoad("https://raw.githubusercontent.com/neohubdev/script/main/script") end)
tab1:AddHasKey("7. Real kid(có key)", function() SafeLoad("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua") end)
tab1:AddHasKey("8. Chilli v2(có key)", function() SafeLoad("https://gist.githubusercontent.com/ronnei/1fa67c56dd9af203b192d15e752928e5/raw/4e2d5105640e09a008b4ae6df23f9708cadfef06/chilliv2-stealanegg") end)

-- ═════════════════ TAB 3: BLOX FRUIT ═════════════════
local tab2 = CreateCategoryTab("🌸BLOX FRUIT🌸", 3)
tab2:AddNoKey("1. RedzHub v2 (không có khóa)", function() SafeLoad("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2") end)
tab2:AddNoKey("2. Quantumx Hub(nokey)", function() SafeLoad("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua") end)
tab2:AddHasKey("1. Speed ​​Hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end)
tab2:AddHasKey("2. Omg Hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua") end)
tab2:AddHasKey("3. TeddyHub(có key)", function()
    lặp lại tác vụ.wait() cho đến khi trò chơi:IsLoaded() và Players.LocalPlayer và Players.LocalPlayer:FindFirstChild("PlayerGui")
    SafeLoad("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua")
kết thúc)
tab2:AddHasKey("4. Gravity Hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua") end)
tab2:AddHasKey("5. Realkid hub(có key)", function() SafeLoad("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua") end)
tab2:AddHasKey("6. BananaHub(có key)", function()
    lặp lại tác vụ.wait() cho đến khi trò chơi:IsLoaded() và người chơi cục bộ.LocalPlayer
    getgenv().Team = "Marines"
    SafeLoad("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua")
kết thúc)

-- ═════════════════ TAB 4: KHÁC ═════════════════
local tabMiscBtn = Instance.new("TextButton", SidebarScroll)
tabMiscBtn.LayoutOrder = 4
tabMiscBtn.Size, tabMiscBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabMiscBtn.BackgroundTransparency, tabMiscBtn.Text = 0, " ⚙️ KHÁC"
tabMiscBtn.TextColor3, tabMiscBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabMiscBtn.Font, tabMiscBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Góc (tabMiscBtn)
RegTheme(tabMiscBtn, "Primary")

local miscIndicator = Instance.new("Frame", tabMiscBtn)
miscIndicator.Size, miscIndicator.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6)
miscIndicator.BackgroundColor3, miscIndicator.BorderSizePixel = Color3.fromRGB(255,105,180), 0
miscIndicator.Visible = false
Góc(miscIndicator, UDim.new(0, 2))

local miscScroll = Instance.new("ScrollingFrame", ContentContainer)
miscScroll.Size, miscScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
miscScroll.BackgroundTransparency, miscScroll.BorderSizePixel = 1, 0
miscScroll.ScrollBarThickness, miscScroll.Visible, miscScroll.ClipsDescendants = 3, false, true
local miscLayout = Instance.new("UIListLayout", miscScroll)
miscLayout.SortOrder, miscLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5)
miscLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local miscPad = Instance.new("UIPadding", miscScroll)
miscPad.PaddingLeft, miscPad.PaddingRight, miscPad.PaddingTop = UDim.new(0,4), UDim.new(0,10), UDim.new(0,4)

Theo dõi (miscLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    miscScroll.CanvasSize = UDim2.new(0, 0, 0, miscLayout.AbsoluteContentSize.Y + 15)
kết thúc))

Theo dõi(tabMiscBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do
        t.Container.Visible = false
        if t.Indicator then t.Indicator.Visible = false end
    kết thúc
    miscScroll.Visible, miscIndicator.Visible = true, true
    ActiveTabTitle.Text = "⚙️ Khác"
kết thúc))
table.insert(Tabs, {Container = miscScroll, Indicator = miscIndicator})

-- ═════════════════ KỊCH BẢN TỰ ĐỘNG TẢI ═════════════════
local autoLoadToggleBtn = Instance.new("TextButton", miscScroll)
autoLoadToggleBtn.LayoutOrder = 1
autoLoadToggleBtn.Size, autoLoadToggleBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(55,12,40)
autoLoadToggleBtn.BackgroundTransparency, autoLoadToggleBtn.Text = 0, " ↓ tập lệnh tự động tải"
autoLoadToggleBtn.TextColor3, autoLoadToggleBtn.TextSize = Color3.fromRGB(255,255,255), 10
autoLoadToggleBtn.Font, autoLoadToggleBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Góc (autoLoadToggleBtn)
Stroke(autoLoadToggleBtn)
RegTheme(autoLoadToggleBtn, "Secondary")

local alSubLabel = Instance.new("TextLabel", autoLoadToggleBtn)
alSubLabel.Size, alSubLabel.Position = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14)
alSubLabel.BackgroundTransparency, alSubLabel.Text = 1, "Quản lý tự động tải script"
alSubLabel.TextColor3, alSubLabel.TextSize = Color3.fromRGB(140,140,150), 7
alSubLabel.Font, alSubLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Center

local autoLoadContainer = Instance.new("Frame", miscScroll)
autoLoadContainer.LayoutOrder = 2
autoLoadContainer.Size, autoLoadContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
autoLoadContainer.BackgroundTransparency = 1
autoLoadContainer.Visible = true
local alLayout = Instance.new("UIListLayout", autoLoadContainer)
alLayout.SortOrder, alLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
alLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Theo dõi(autoLoadToggleBtn.MouseButton1Click:Connect(function()
    autoLoadContainer.Visible = not autoLoadContainer.Visible
    autoLoadToggleBtn.Text = autoLoadContainer.Visible và " ↓ tự động tải tập lệnh" hoặc " → tự động tải tập lệnh"
    alSubLabel.Visible = autoLoadContainer.Visible
kết thúc))

local dropBtn = Instance.new("TextButton", autoLoadContainer)
dropBtn.LayoutOrder, dropBtn.Size = 1, UDim2.new(1, 0, 0, 26)
dropBtn.BackgroundColor3, dropBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
dropBtn.Text = " 📜 Chọn Tự động tải tập lệnh..."
dropBtn.TextColor3, dropBtn.TextSize = Color3.fromRGB(255,255,255), 9
dropBtn.Font, dropBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Góc (nút thả xuống)
Stroke(dropBtn)
RegTheme(dropBtn, "Primary")

local dropFrame = Instance.new("ScrollingFrame", autoLoadContainer)
dropFrame.LayoutOrder = 2
dropFrame.Size, dropFrame.BackgroundColor3 = UDim2.new(1, 0, 0, 90), Color3.fromRGB(80,20,60)
dropFrame.BackgroundTransparency, dropFrame.CanvasSize = 0, UDim2.new(0,0,0,0)
dropFrame.ScrollBarThickness, dropFrame.Visible = 3, false
Góc (dropFrame)
Stroke(dropFrame)
local dropLayout = Instance.new("UIListLayout", dropFrame)
dropLayout.Padding = UDim.new(0, 3)
RegTheme(dropFrame, "DropFrame")
local dropPad = Instance.new("UIPadding", dropFrame)
dropPad.PaddingRight = UDim.new(0, 8)

Theo dõi(dropBtn.MouseButton1Click:Connect(function()
    dropFrame.Visible = not dropFrame.Visible
kết thúc))

hàm cục bộ rebuildScriptDropdown()
    for _, c in ipairs(dropFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    kết thúc
    for i, scr in ipairs(RegisteredScripts) do
        local item = Instance.new("TextButton", dropFrame)
        item.LayoutOrder, item.Size = i, UDim2.new(1, 0, 0, 22)
        item.BackgroundColor3, item.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
        item.Text, item.TextColor3, item.TextSize = " ► " .. scr.Name, Color3.fromRGB(255,255,255), 9
        item.Font, item.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
        Góc(mục, UDim.new(0, 4))
        Stroke(item)
        RegTheme(item, "DropItem")
        Theo dõi(item.MouseButton1Click:Connect(function()
            State.SelectedScript = scr
            dropBtn.Text = " 📜 " .. scr.Name
            dropFrame.Visible = false
            if State.IsAutoLoad then pcall(scr.Callback) end
        kết thúc))
    kết thúc
    dropFrame.CanvasSize = UDim2.new(0, 0, 0, #RegisteredScripts * 25)
kết thúc
_G.__vznam_rebuildScriptDropdown = rebuildScriptDropdown
rebuildScriptDropdown()

local autoLoadScriptFrame = Instance.new("Frame", autoLoadContainer)
autoLoadScriptFrame.LayoutOrder, autoLoadScriptFrame.Size = 3, UDim2.new(1, 0, 0, 30)
autoLoadScriptFrame.BackgroundColor3, autoLoadScriptFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (autoLoadScriptFrame)
Stroke(autoLoadScriptFrame)
RegTheme(autoLoadScriptFrame, "Primary")

local alsTitle = Instance.new("TextLabel", autoLoadScriptFrame)
alsTitle.Size, alsTitle.Position = UDim2.new(1, -40, 1, 0), UDim2.new(0, 5, 0, 0)
alsTitle.BackgroundTransparency, alsTitle.Text = 1, "Khởi động tập lệnh tự động"
alsTitle.TextColor3, alsTitle.TextSize = Color3.fromRGB(255,255,255), 9
alsTitle.Font, alsTitle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local toggleAutoBtn = Instance.new("TextButton", autoLoadScriptFrame)
toggleAutoBtn.Size, toggleAutoBtn.Position = UDim2.new(0, 30, 0, 15), UDim2.new(1, -34, 0.5, -7.5)
toggleAutoBtn.BackgroundColor3, toggleAutoBtn.Text = Color3.fromRGB(60,65,75), ""
Góc(toggleAutoBtn, UDim.new(1, 0))
Stroke(toggleAutoBtn)
local autoDot = Instance.new("Frame", toggleAutoBtn)
autoDot.Size, autoDot.Position = UDim2.new(0, 11, 0, 11), UDim2.new(0, 2, 0.5, -5.5)
autoDot.BackgroundColor3 = Color3.fromRGB(255,255,255)
Góc(autoDot, UDim.new(1, 0))

Theo dõi(toggleAutoBtn.MouseButton1Click:Connect(function()
    nếu không phải State.SelectedScript thì
        dropBtn.Text = " ⚠️ Chọn tập lệnh trước!"
        task.delay(1.5, function()
            nếu dropBtn.Parent thì
                dropBtn.Text = " 📜 Chọn Tự động tải tập lệnh..."
            kết thúc
        kết thúc)
        trở lại
    kết thúc
    State.IsAutoLoad = not State.IsAutoLoad
    nếu State.IsAutoLoad thì
        toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
        autoDot.Position = UDim2.new(1, -13, 0.5, -5.5)
        pcall(State.SelectedScript.Callback)
    khác
        toggleAutoBtn.BackgroundColor3 = Color3.fromRGB(60,65,75)
        autoDot.Position = UDim2.new(0, 2, 0.5, -5.5)
    kết thúc
kết thúc))

-- ═════════════════ ÂM NHẠC ═════════════════
local musicToggleBtn = Instance.new("TextButton", miscScroll)
musicToggleBtn.LayoutOrder = 3
musicToggleBtn.Size, musicToggleBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(55,12,40)
musicToggleBtn.BackgroundTransparency, musicToggleBtn.Text = 0, " ↓ âm nhạc"
musicToggleBtn.TextColor3, musicToggleBtn.TextSize = Color3.fromRGB(255,255,255), 10
musicToggleBtn.Font, musicToggleBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Góc (nút chuyển đổi nhạc)
Stroke(musicToggleBtn)
RegTheme(musicToggleBtn, "Phụ")

local muSubLabel = Instance.new("TextLabel", musicToggleBtn)
muSubLabel.Size, muSubLabel.Position = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14)
muSubLabel.BackgroundTransparency, muSubLabel.Text = 1, "Cài đặt nhạc nền"
muSubLabel.TextColor3, muSubLabel.TextSize = Color3.fromRGB(140,140,150), 7
muSubLabel.Font, muSubLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Center

local musicContainer = Instance.new("Frame", miscScroll)
musicContainer.LayoutOrder, musicContainer.Size = 4, UDim2.new(1, 0, 0, 0)
musicContainer.AutomaticSize, musicContainer.BackgroundTransparency = Enum.AutomaticSize.Y, 1
musicContainer.Visible = true
local muLayout = Instance.new("UIListLayout", musicContainer)
muLayout.SortOrder, muLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
muLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Theo dõi(musicToggleBtn.MouseButton1Click:Connect(function()
    musicContainer.Visible = not musicContainer.Visible
    musicToggleBtn.Text = musicContainer.Visible và " ↓ âm nhạc" hoặc " → âm nhạc"
    muSubLabel.Visible = musicContainer.Visible
kết thúc))

local HubSound = Instance.new("Sound", SoundService)
HubSound.Name, HubSound.Looped, HubSound.Volume = "VzNamHubSound", true, State.Volume
HubSound.SoundId = "rbxassetid://" .. State.SoundId

local customIdBox = Instance.new("TextBox", musicContainer)
customIdBox.LayoutOrder, customIdBox.Size = 1, UDim2.new(1, 0, 0, 26)
customIdBox.BackgroundColor3, customIdBox.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
customIdBox.PlaceholderText, customIdBox.Text = "🎶 Nhập ID...", ""
customIdBox.TextColor3, customIdBox.TextSize = Color3.fromRGB(255,255,255), 9
customIdBox.Font = Enum.Font.Gotham
Góc (customIdBox)
Stroke(customIdBox)
RegTheme(customIdBox, "Input")

local musicDropBtn = Instance.new("TextButton", musicContainer)
musicDropBtn.LayoutOrder, musicDropBtn.Size = 2, UDim2.new(1, 0, 0, 26)
musicDropBtn.BackgroundColor3, musicDropBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
musicDropBtn.Text, musicDropBtn.TextColor3 = " 🎵 Chọn Nhạc...", Color3.fromRGB(255,255,255)
musicDropBtn.TextSize, musicDropBtn.Font = 9, Enum.Font.Gotham
musicDropBtn.TextXAlignment = Enum.TextXAlignment.Left
Góc (nút thả nhạc)
Stroke(musicDropBtn)
RegTheme(musicDropBtn, "Primary")

local musicDropFrame = Instance.new("ScrollingFrame", musicContainer)
musicDropFrame.LayoutOrder, musicDropFrame.Size = 3, UDim2.new(1, 0, 0, 95)
musicDropFrame.BackgroundColor3, musicDropFrame.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
musicDropFrame.CanvasSize, musicDropFrame.ScrollBarThickness, musicDropFrame.Visible = UDim2.new(0,0,0,0), 3, false
Góc(musicDropFrame)
Stroke(musicDropFrame)
local musicListLayout = Instance.new("UIListLayout", musicDropFrame)
musicListLayout.Padding = UDim.new(0, 3)
RegTheme(musicDropFrame, "DropFrame")
local musicPad = Instance.new("UIPadding", musicDropFrame)
musicPad.PaddingRight = UDim.new(0, 8)

local presetMusics = {
    {Tên = "🎵 Chill Lofi", ID = "1837879082"},
    {Name = "🎶 Phonk Beat", Id = "1843404008"},
    {Tên = "🎵 Anime Relax", ID = "9043887091"},
    {Tên = "🎶 EDM Hype", ID = "1837871000"},
    {Name = "🎶 Như Một Người Dung",Id = "91897652967267"},
}
for i, m in ipairs(presetMusics) do
    local mBtn = Instance.new("TextButton", musicDropFrame)
    mBtn.LayoutOrder, mBtn.Size = i, UDim2.new(1, 0, 0, 22)
    mBtn.BackgroundColor3, mBtn.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
    mBtn.Text, mBtn.TextColor3, mBtn.TextSize = " " .. m.Name, Color3.fromRGB(255,255,255), 9
    mBtn.Font, mBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
    Góc(mBtn, UDim.new(0, 4))
    Đột quỵ (mBtn)
    RegTheme(mBtn, "DropItem")
    Theo dõi(mBtn.MouseButton1Click:Connect(function()
        State.SoundId = m.Id
        musicDropBtn.Text = " 🎵 " .. m.Name
        musicDropFrame.Visible = false
        nếu HubSound.IsPlaying thì
            HubSound.SoundId = "rbxassetid://" .. State.SoundId
            HubSound:Play()
        kết thúc
    kết thúc))
kết thúc
musicDropFrame.CanvasSize = UDim2.new(0, 0, 0, #presetMusics * 25)
Theo dõi(musicDropBtn.MouseButton1Click:Connect(function()
    musicDropFrame.Visible = not musicDropFrame.Visible
kết thúc))

local volumeFrame = Instance.new("Frame", musicContainer)
volumeFrame.LayoutOrder, volumeFrame.Size = 4, UDim2.new(1, 0, 0, 26)
volumeFrame.BackgroundColor3, volumeFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (khung thể tích)
Stroke(volumeFrame)
RegTheme(volumeFrame, "Primary")

local volumeLabel = Instance.new("TextLabel", volumeFrame)
volumeLabel.Size, volumeLabel.Position = UDim2.new(1, -8, 1, 0), UDim2.new(0, 5, 0, 0)
volumeLabel.BackgroundTransparency, volumeLabel.Text = 1, "🔊 Âm lượng: 50%"
VolumeLabel.TextColor3, VolumeLabel.TextSize = Color3.fromRGB(255,255,255), 9
volumeLabel.Font, volumeLabel.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local volumeBarBg = Instance.new("Frame", volumeFrame)
volumeBarBg.Size, volumeBarBg.Position = UDim2.new(0, 80, 0, 8), UDim2.new(1, -86, 0.5, -4)
volumeBarBg.BackgroundColor3 = Color3.fromRGB(90,25,65)
Góc(volumeBarBg, UDim.new(1, 0))
Stroke(volumeBarBg)
RegTheme(volumeBarBg, "DropItem")

local volumeBarFill = Instance.new("Frame", volumeBarBg)
volumeBarFill.Size, volumeBarFill.BackgroundColor3 = UDim2.new(0.5, 0, 1, 0), Color3.fromRGB(0,180,255)
Góc(volumeBarFill, UDim.new(1, 0))

local volumeBtn = Instance.new("TextButton", volumeBarBg)
volumeBtn.Size, volumeBtn.BackgroundTransparency, volumeBtn.Text = UDim2.new(1, 10, 1, 10), 1, ""

local adjustingVol = false
Theo dõi(volumeBtn.InputBegan:Connect(function(input)
    nếu input.UserInputType == Enum.UserInputType.MouseButton1
       hoặc input.UserInputType == Enum.UserInputType.Touch thì adjustingVol = true kết thúc
kết thúc))
Theo dõi(UserInputService.InputEnded:Connect(function(input)
    nếu input.UserInputType == Enum.UserInputType.MouseButton1
       hoặc input.UserInputType == Enum.UserInputType.Touch thì
        điều chỉnh thể tích = sai
    kết thúc
kết thúc))
Theo dõi(UserInputService.InputChanged:Connect(function(input)
    nếu điều chỉnh âm lượng và (input.UserInputType == Enum.UserInputType.MouseMovement
       hoặc input.UserInputType == Enum.UserInputType.Touch) thì
        local absPos, absSize = volumeBarBg.AbsolutePosition.X, volumeBarBg.AbsoluteSize.X
        local p = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
        volumeBarFill.Size = UDim2.new(p, 0, 1, 0)
        Thể tích trạng thái = p
        HubSound.Volume = p
        volumeLabel.Text = "🔊 Âm lượng: " .. math.floor(p * 100) .. "%"
    kết thúc
kết thúc))

local musicToggleFrame = Instance.new("Frame", musicContainer)
musicToggleFrame.LayoutOrder, musicToggleFrame.Size = 5, UDim2.new(1, 0, 0, 30)
musicToggleFrame.BackgroundColor3, musicToggleFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (khung chuyển đổi nhạc)
Stroke(musicToggleFrame)
RegTheme(musicToggleFrame, "Chính")

local musicTitle = Instance.new("TextLabel", musicToggleFrame)
musicTitle.Size, musicTitle.Position = UDim2.new(1, -40, 1, 0), UDim2.new(0, 5, 0, 0)
musicTitle.BackgroundTransparency, musicTitle.Text = 1, "Phát Nhạc Nền"
musicTitle.TextColor3, musicTitle.TextSize = Color3.fromRGB(255,255,255), 9
musicTitle.Font, musicTitle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local toggleMusicBtn = Instance.new("TextButton", musicToggleFrame)
toggleMusicBtn.Size, toggleMusicBtn.Position = UDim2.new(0, 30, 0, 15), UDim2.new(1, -34, 0.5, -7.5)
toggleMusicBtn.BackgroundColor3, toggleMusicBtn.Text = Color3.fromRGB(60,65,75), ""
Góc(toggleMusicBtn, UDim.new(1, 0))
Stroke(toggleMusicBtn)
local musicDot = Instance.new("Frame", toggleMusicBtn)
musicDot.Size, musicDot.Position = UDim2.new(0, 11, 0, 11), UDim2.new(0, 2, 0.5, -5.5)
musicDot.BackgroundColor3 = Color3.fromRGB(255,255,255)
Góc(musicDot, UDim.new(1, 0))

local isMusicPlaying = false
Theo dõi(toggleMusicBtn.MouseButton1Click:Connect(function()
    isMusicPlaying = not isMusicPlaying
    nếu isMusicPlaying thì
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        musicDot.Position = UDim2.new(1, -13, 0.5, -5.5)
        local customId = tonumber(customIdBox.Text)
        HubSound.SoundId = "rbxassetid://" .. (customId and tostring(customId) or State.SoundId)
        HubSound:Play()
    khác
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
        musicDot.Position = UDim2.new(0, 2, 0.5, -5.5)
        HubSound:Stop()
    kết thúc
kết thúc))

-- ═════════════════ MÀU MENU ═════════════════
local menuColorToggleBtn = Instance.new("TextButton", miscScroll)
menuColorToggleBtn.LayoutOrder = 5
menuColorToggleBtn.Size, menuColorToggleBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(55,12,40)
menuColorToggleBtn.BackgroundTransparency, menuColorToggleBtn.Text = 0, " ↓ màu menu"
menuColorToggleBtn.TextColor3, menuColorToggleBtn.TextSize = Color3.fromRGB(255,255,255), 10
menuColorToggleBtn.Font, menuColorToggleBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Góc (menuColorToggleBtn)
Stroke(menuColorToggleBtn)
RegTheme(menuColorToggleBtn, "Secondary")

local mcSubLabel = Instance.new("TextLabel", menuColorToggleBtn)
mcSubLabel.Size, mcSubLabel.Position = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14)
mcSubLabel.BackgroundTransparency, mcSubLabel.Text = 1, "Tùy chỉnh màu sắc & độ trong suốt"
mcSubLabel.TextColor3, mcSubLabel.TextSize = Color3.fromRGB(140,140,150), 7
mcSubLabel.Font, mcSubLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Center

local menuColorContainer = Instance.new("Frame", miscScroll)
menuColorContainer.LayoutOrder, menuColorContainer.Size = 6, UDim2.new(1, 0, 0, 0)
menuColorContainer.AutomaticSize, menuColorContainer.BackgroundTransparency = Enum.AutomaticSize.Y, 1
menuColorContainer.Visible = true
local mcLayout = Instance.new("UIListLayout", menuColorContainer)
mcLayout.SortOrder, mcLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
mcLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Theo dõi(menuColorToggleBtn.MouseButton1Click:Connect(function()
    menuColorContainer.Visible = not menuColorContainer.Visible
    menuColorToggleBtn.Text = menuColorContainer.Visible và " ↓ màu menu" hoặc " → màu menu"
    mcSubLabel.Visible = menuColorContainer.Visible
kết thúc))

local menuThemeList = {
    {Name = "🌸 Hồng Pastel", Bg = Color3.fromRGB(70, 15, 50)},
    {Name = "🌙 Đêm Đen Sâu", Bg = Color3.fromRGB(15, 16, 22)},
    {Name = "🔥 Đỏ Lửa", Bg = Color3.fromRGB(70, 10, 15)},
    {Name = "🌊 Xanh Đại Dương", Bg = Color3.fromRGB(10, 22, 50)},
}

hàm cục bộ ApplyTheme(newBaseColor)
    State.ThemeBase = newBaseColor
    local primary = newBaseColor:Lerp(Color3.new(1,1,1), 0.08)
    local secondary = newBaseColor:Lerp(Color3.new(1,1,1), 0.15)
    local dropFrame = newBaseColor:Lerp(Color3.new(1,1,1), 0.2)
    local dropItem = newBaseColor:Lerp(Color3.new(1,1,1), 0.3)
    đầu vào cục bộ = newBaseColor:Lerp(Color3.new(0,0,0), 0.4)

    SidebarPanel.BackgroundColor3 = newBaseColor
    ContentContainer.BackgroundColor3 = newBaseColor

    for _, item in ipairs(ThemedElements) do
        local el = item.Element
        nếu el và el.Parent thì
            Nếu item.Type == "Primary" thì el.BackgroundColor3 = primary
            elseif item.Type == "Secondary" then el.BackgroundColor3 = secondary
            elseif item.Type == "DropFrame" then el.BackgroundColor3 = dropFrame
            elseif item.Type == "DropItem" then el.BackgroundColor3 = dropItem
            elseif item.Type == "Input" then el.BackgroundColor3 = input
            kết thúc
        kết thúc
    kết thúc
kết thúc

local themeDropBtn = Instance.new("TextButton", menuColorContainer)
themeDropBtn.LayoutOrder, themeDropBtn.Size = 1, UDim2.new(1, 0, 0, 26)
themeDropBtn.BackgroundColor3, themeDropBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
themeDropBtn.Text, themeDropBtn.TextColor3 = " 🎨 Theme: 🌊 Xanh Đại Dương", Color3.fromRGB(255,255,255)
themeDropBtn.TextSize, themeDropBtn.Font = 9, Enum.Font.Gotham
themeDropBtn.TextXAlignment = Enum.TextXAlignment.Left
Góc (nút thả chủ đề)
Stroke(themeDropBtn)
RegTheme(themeDropBtn, "Primary")

local themeDropFrame = Instance.new("ScrollingFrame", menuColorContainer)
themeDropFrame.LayoutOrder, themeDropFrame.Size = 2, UDim2.new(1, 0, 0, 95)
themeDropFrame.BackgroundColor3, themeDropFrame.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
themeDropFrame.CanvasSize, themeDropFrame.ScrollBarThickness, themeDropFrame.Visible = UDim2.new(0,0,0,0), 3, false
Góc (themeDropFrame)
Stroke(themeDropFrame)
local themeListLayout = Instance.new("UIListLayout", themeDropFrame)
themeListLayout.Padding = UDim.new(0, 3)
RegTheme(themeDropFrame, "DropFrame")
local themePad = Instance.new("UIPadding", themeDropFrame)
themePad.PaddingRight = UDim.new(0, 8)

for i, th in ipairs(menuThemeList) do
    local tBtn = Instance.new("TextButton", themeDropFrame)
    tBtn.LayoutOrder, tBtn.Size = i, UDim2.new(1, 0, 0, 22)
    tBtn.BackgroundColor3, tBtn.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
    tBtn.Text, tBtn.TextColor3, tBtn.TextSize = " " .. th.Name, Color3.fromRGB(255,255,255), 9
    tBtn.Font, tBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
    Góc(tBtn, UDim.new(0, 4))
    Đột quỵ (tBtn)
    RegTheme(tBtn, "DropItem")
    Theo dõi(tBtn.MouseButton1Click:Connect(function()
        themeDropBtn.Text = " 🎨 Chủ đề: " .. th.Name
        themeDropFrame.Visible = false
        ApplyTheme(th.Bg)
    kết thúc))
kết thúc
themeDropFrame.CanvasSize = UDim2.new(0, 0, 0, #menuThemeList * 25)
Theo dõi (themeDropBtn.MouseButton1Click:Connect(function()
    themeDropFrame.Visible = not themeDropFrame.Visible
kết thúc))

local transFrame = Instance.new("Frame", menuColorContainer)
transFrame.LayoutOrder, transFrame.Size = 3, UDim2.new(1, 0, 0, 26)
transFrame.BackgroundColor3, transFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (transFrame)
Stroke(transFrame)
RegTheme(transFrame, "Primary")

local transLabel = Instance.new("TextLabel", transFrame)
transLabel.Size, transLabel.Position = UDim2.new(1, -8, 1, 0), UDim2.new(0, 5, 0, 0)
transLabel.BackgroundTransparency, transLabel.Text = 1, "✨ Trong suốt: 0%"
transLabel.TextColor3, transLabel.TextSize = Color3.fromRGB(255,255,255), 9
transLabel.Font, transLabel.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local transBarBg = Instance.new("Frame", transFrame)
transBarBg.Size, transBarBg.Position = UDim2.new(0, 80, 0, 8), UDim2.new(1, -86, 0.5, -4)
transBarBg.BackgroundColor3 = Color3.fromRGB(90,25,65)
Góc(transBarBg, UDim.new(1, 0))
Đột quỵ(transBarBg)
RegTheme(transBarBg, "DropItem")

local transBarFill = Instance.new("Frame", transBarBg)
transBarFill.Size, transBarFill.BackgroundColor3 = UDim2.new(0, 0, 1, 0), Color3.fromRGB(255,105,180)
Góc(transBarFill, UDim.new(1, 0))

local transBtn = Instance.new("TextButton", transBarBg)
transBtn.Size, transBtn.BackgroundTransparency, transBtn.Text = UDim2.new(1, 10, 1, 10), 1, ""

điều chỉnh cục bộ = false
Theo dõi(transBtn.InputBegan:Connect(function(input)
    nếu input.UserInputType == Enum.UserInputType.MouseButton1
       hoặc input.UserInputType == Enum.UserInputType.Touch thì adjustingTrans = true end
kết thúc))
Theo dõi(UserInputService.InputEnded:Connect(function(input)
    nếu input.UserInputType == Enum.UserInputType.MouseButton1
       hoặc input.UserInputType == Enum.UserInputType.Touch thì
        điều chỉnhTrans = false
    kết thúc
kết thúc))
Theo dõi(UserInputService.InputChanged:Connect(function(input)
    nếu điều chỉnhTrans và (input.UserInputType == Enum.UserInputType.MouseMovement
       hoặc input.UserInputType == Enum.UserInputType.Touch) thì
        local absPos, absSize = transBarBg.AbsolutePosition.X, transBarBg.AbsoluteSize.X
        local p = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
        transBarFill.Size = UDim2.new(p, 0, 1, 0)
        State.Transparent = p
        MainFrame.BackgroundTransparency = 0.15 + (p * 0.85)
        SidebarPanel.BackgroundTransparency = p
        ContentContainer.BackgroundTransparency = p
        transLabel.Text = "✨ Trong suốt: " .. math.floor(p * 100) .. "%"
    kết thúc
kết thúc))

local colorList = {
    {Name = "🔵 Xanh Dương", Color = Color3.fromRGB(0, 191, 255)},
    {Tên = "🌈 Cầu Vồng", Màu sắc = "Cầu Vồng"},
    {Name = "✨ Hồng Kẹo", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "🔴 Đỏ Đậm", Color = Color3.fromRGB(220, 20, 60)},
    {Name = "❌ Không viền", Color = "Không"},
}
local selectedColorObj = colorList[1]

local colorDropBtn = Instance.new("TextButton", menuColorContainer)
colorDropBtn.LayoutOrder, colorDropBtn.Size = 4, UDim2.new(1, 0, 0, 26)
colorDropBtn.BackgroundColor3, colorDropBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
colorDropBtn.Text, colorDropBtn.TextColor3 = " 🎨 Viền: 🔵 Xanh Dương", Color3.fromRGB(255,255,255)
colorDropBtn.TextSize, colorDropBtn.Font = 9, Enum.Font.Gotham
colorDropBtn.TextXAlignment = Enum.TextXAlignment.Left
Góc (colorDropBtn)
Stroke(colorDropBtn)
RegTheme(colorDropBtn, "Chính")

local colorDropFrame = Instance.new("ScrollingFrame", menuColorContainer)
colorDropFrame.LayoutOrder, colorDropFrame.Size = 5, UDim2.new(1, 0, 0, 95)
colorDropFrame.BackgroundColor3, colorDropFrame.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
colorDropFrame.CanvasSize, colorDropFrame.ScrollBarThickness, colorDropFrame.Visible = UDim2.new(0,0,0,0), 3, false
Góc(colorDropFrame)
Stroke(colorDropFrame)
local colorListLayout = Instance.new("UIListLayout", colorDropFrame)
colorListLayout.Padding = UDim.new(0, 3)
RegTheme(colorDropFrame, "DropFrame")
local colorPad = Instance.new("UIPadding", colorDropFrame)
colorPad.PaddingRight = UDim.new(0, 8)

hàm cục bộ UpdateAllStokes(target)
    nếu target == "None" thì
        for _, s in ipairs(AllUIStrokes) do if s then s.Transparency = 1 end end
    elseif target == "Rainbow" then
        for _, s in ipairs(AllUIStrokes) do if s then s.Transparency = 0 end end
    khác
        State.StrokeColor = target
        cho _, s trong ipairs(AllUIStrokes) làm
            if s then s.Transparency = 0; s.Color = target end
        kết thúc
    kết thúc
kết thúc

for i, cItem in ipairs(colorList) do
    local cBtn = Instance.new("TextButton", colorDropFrame)
    cBtn.LayoutOrder, cBtn.Size = i, UDim2.new(1, 0, 0, 22)
    cBtn.BackgroundColor3, cBtn.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
    cBtn.Text, cBtn.TextColor3, cBtn.TextSize = " " .. cItem.Name, Color3.fromRGB(255,255,255), 9
    cBtn.Font, cBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
    Góc(cBtn, UDim.new(0, 4))
    Đột quỵ (cBtn)
    RegTheme(cBtn, "DropItem")
    Theo dõi(cBtn.MouseButton1Click:Connect(function()
        selectedColorObj = cItem
        colorDropBtn.Text = " 🎨 Viền: " .. cItem.Name
        colorDropFrame.Visible = false
        nếu cItem.Color == "Rainbow" thì
            State.StrokeMode = "Rainbow"
            UpdateAllStrokes("Rainbow")
        elseif cItem.Color == "None" then
            State.StrokeMode = "None"
            UpdateAllStrokes("None")
        khác
            State.StrokeMode = "Solid"
            UpdateAllStrokes(cItem.Color)
        kết thúc
    kết thúc))
kết thúc
colorDropFrame.CanvasSize = UDim2.new(0, 0, 0, #colorList * 25)
Theo dõi(colorDropBtn.MouseButton1Click:Connect(function()
    colorDropFrame.Visible = not colorDropFrame.Visible
kết thúc))

cầu vồng cục bộConn = RunService.RenderStepped:Connect(function()
    if State.StrokeMode ~= "Rainbow" then return end
    local rainbow = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    cho _, s trong ipairs(AllUIStrokes) làm
        nếu s thì s.Transparency = 0; s.Color = rainbow end
    kết thúc
kết thúc)
Đường đua (rainbowConn)

-- ═════════════════ TAB 5: CẤU HÌNH ═════════════════
local tabConfigBtn = Instance.new("TextButton", SidebarScroll)
tabConfigBtn.LayoutOrder = 5
tabConfigBtn.Size, tabConfigBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabConfigBtn.BackgroundTransparency, tabConfigBtn.Text = 0," 📦 CẤU HÌNH"
tabConfigBtn.TextColor3, tabConfigBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabConfigBtn.Font, tabConfigBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Góc (tabConfigBtn)
RegTheme(tabConfigBtn, "Primary")

local configIndicator = Instance.new("Frame", tabConfigBtn)
configIndicator.Size, configIndicator.Position = UDim2.new(0, 3, 0, 12), UDim2.new(0, 0, 0.5, -6)
configIndicator.BackgroundColor3, configIndicator.BorderSizePixel = Color3.fromRGB(255,105,180), 0
configIndicator.Visible = false
Góc(configIndicator, UDim.new(0, 2))

local configScroll = Instance.new("ScrollingFrame", ContentContainer)
configScroll.Size, configScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
configScroll.BackgroundTransparency, configScroll.BorderSizePixel = 1, 0
configScroll.ScrollBarThickness, configScroll.Visible, configScroll.ClipsDescendants = 3, false, true
local configLayout = Instance.new("UIListLayout", configScroll)
configLayout.SortOrder, configLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5)
configLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local cfgPad = Instance.new("UIPadding", configScroll)
cfgPad.PaddingLeft, cfgPad.PaddingRight, cfgPad.PaddingTop = UDim.new(0,4), UDim.new(0,10), UDim.new(0,4)

Theo dõi(configLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    configScroll.CanvasSize = UDim2.new(0, 0, 0, configLayout.AbsoluteContentSize.Y + 15)
kết thúc))

Theo dõi(tabConfigBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do
        t.Container.Visible = false
        if t.Indicator then t.Indicator.Visible = false end
    kết thúc
    configScroll.Visible, configIndicator.Visible = true, true
    ActiveTabTitle.Text = "📦 CẤU HÌNH"
kết thúc))
table.insert(Tabs, {Container = configScroll, Indicator = configIndicator})

local CONFIG_FOLDER = "VzNamHub_Configs"
if typeof(makefolder) == "function" then pcall(makefolder, CONFIG_FOLDER) end

hàm cục bộ SerializeState(scriptName)
    trở lại {
        Phiên bản = 4,
        SavedTime = os.time(),
        ThemeBase = {State.ThemeBase.R, State.ThemeBase.G, State.ThemeBase.B},
        StrokeMode = State.StrokeMode,
        Màu nét vẽ = {Trạng thái.Màu nét vẽ.R, Trạng thái.Màu nét vẽ.G, Trạng thái.Màu nét vẽ.B},
        Thể tích = Thể tích trạng thái,
        SoundId = State.SoundId,
        SelectedScript = scriptName,
        Trong suốt = Trạng thái trong suốt,
    }
kết thúc

hàm cục bộ ValidateConfig(data)
    if type(data) ~= "table" then return false end
    if data.Version ~= 4 then return false end
    if data.ThemeBase and type(data.ThemeBase) ~= "table" then return false end
    if data.StrokeColor and type(data.StrokeColor) ~= "table" then return false end
    if data.Volume and type(data.Volume) ~= "number" then return false end
    trả về giá trị đúng
kết thúc

hàm cục bộ SaveConfig(name)
    if typeof(writefile) ~= "function" then return false end
    local scriptName = State.SelectedScript and State.SelectedScript.Name or nil
    cục bộ ok = pcall(writefile,
        THƯ MỤC CẤU HÌNH .. "/" .. tên .. ".json",
        HttpService:JSONEncode(SerializeState(scriptName)))
    trả về ok
kết thúc

hàm cục bộ LoadConfigRaw(name)
    if typeof(readfile) ~= "function" then return false, "no readfile" end
    Đường dẫn cục bộ = THƯ MỤC CẤU HÌNH .. "/" .. tên .. ".json"
    cục bộ ok, nội dung = pcall(readfile, path)
    Nếu không hợp lệ hoặc không có nội dung thì trả về false, "đọc thất bại"
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, contents)
    Nếu không phải ok2 thì trả về false, "JSON không hợp lệ"
    if not ValidateConfig(data) then return false, "invalid schema" end
    trả về giá trị true, dữ liệu
kết thúc

-- Nút tiêu đề "Cấu hình"
local configToggleBtn = Instance.new("TextButton", configScroll)
configToggleBtn.LayoutOrder, configToggleBtn.Size = 1, UDim2.new(1, 0, 0, 34)
configToggleBtn.BackgroundColor3, configToggleBtn.BackgroundTransparency = Color3.fromRGB(55,12,40), 0
configToggleBtn.Text, configToggleBtn.TextColor3 = " ↓ Cấu hình", Color3.fromRGB(255,255,255)
configToggleBtn.TextSize, configToggleBtn.Font = 10, Enum.Font.GothamBold
configToggleBtn.TextXAlignment = Enum.TextXAlignment.Center
Góc (configToggleBtn)
Stroke(configToggleBtn)
RegTheme(configToggleBtn, "Secondary")

local configSubLabel = Instance.new("TextLabel", configToggleBtn)
configSubLabel.Size, configSubLabel.Position = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 1, -14)
configSubLabel.BackgroundTransparency, configSubLabel.Text = 1, "Quản lý hệ thống cấu hình"
configSubLabel.TextColor3, configSubLabel.TextSize = Color3.fromRGB(140,140,150), 7
configSubLabel.Font, configSubLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Center

local mainConfigContainer = Instance.new("Frame", configScroll)
mainConfigContainer.LayoutOrder, mainConfigContainer.Size = 2, UDim2.new(1, 0, 0, 0)
mainConfigContainer.AutomaticSize, mainConfigContainer.BackgroundTransparency = Enum.AutomaticSize.Y, 1
mainConfigContainer.Visible = true
local mainCfgLayout = Instance.new("UIListLayout", mainConfigContainer)
mainCfgLayout.SortOrder, mainCfgLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
mainCfgLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Theo dõi(configToggleBtn.MouseButton1Click:Connect(function()
    mainConfigContainer.Visible = not mainConfigContainer.Visible
    configToggleBtn.Text = mainConfigContainer.Visible và " ↓ Cấu hình" hoặc " → Cấu hình"
    configSubLabel.Visible = mainConfigContainer.Visible
kết thúc))

-- 1) Khởi nghiệp
local startupFrame = Instance.new("Frame", mainConfigContainer)
startupFrame.LayoutOrder, startupFrame.Size = 1, UDim2.new(1, 0, 0, 30)
startupFrame.BackgroundColor3, startupFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (khung khởi động)
Stroke(startupFrame)
RegTheme(startupFrame, "Primary")

local startupLabel = Instance.new("TextLabel", startupFrame)
startupLabel.Size, startupLabel.Position = UDim2.new(1, -8, 1, 0), UDim2.new(0, 5, 0, 0)
startupLabel.BackgroundTransparency = 1
startupLabel.Text = "Khởi động: " .. State.CurrentConfig
startupLabel.TextColor3, startupLabel.TextSize = Color3.fromRGB(255,255,255), 9
startupLabel.Font, startupLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left

RefreshStartupLabel = function()
    startupLabel.Text = "Khởi động: " .. State.CurrentConfig
kết thúc

-- 2) Tên Cấu hình
local newConfigFrame = Instance.new("Frame", mainConfigContainer)
newConfigFrame.LayoutOrder, newConfigFrame.Size = 2, UDim2.new(1, 0, 0, 30)
newConfigFrame.BackgroundColor3, newConfigFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (Khung cấu hình mới)
Stroke(newConfigFrame)
RegTheme(newConfigFrame, "Chính")

local ncLabel = Instance.new("TextLabel", newConfigFrame)
ncLabel.Size, ncLabel.Position = UDim2.new(0, 80, 1, 0), UDim2.new(0, 5, 0, 0)
ncLabel.BackgroundTransparency, ncLabel.Text = 1, "Tên cấu hình"
ncLabel.TextColor3, ncLabel.TextSize = Color3.fromRGB(255,255,255), 9
ncLabel.Font, ncLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left

local configNameBox = Instance.new("TextBox", newConfigFrame)
configNameBox.Size, configNameBox.Position = UDim2.new(1, -95, 0, 20), UDim2.new(0, 85, 0.5, -10)
configNameBox.BackgroundColor3, configNameBox.BackgroundTransparency = Color3.fromRGB(50,10,35), 0
configNameBox.PlaceholderText, configNameBox.Text = "Tên...", ""
configNameBox.TextColor3, configNameBox.TextSize = Color3.fromRGB(255,255,255), 9
configNameBox.Font = Enum.Font.Gotham
Góc(configNameBox, UDim.new(0, 4))
Stroke(configNameBox)
RegTheme(configNameBox, "Input")

-- 3) Tạo Mới Cấu Hình
local createFrame = Instance.new("Frame", mainConfigContainer)
createFrame.LayoutOrder, createFrame.Size = 3, UDim2.new(1, 0, 0, 34)
createFrame.BackgroundColor3, createFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (tạo khung)
Stroke(createFrame)
RegTheme(createFrame, "Primary")

local crTitle = Instance.new("TextLabel", createFrame)
crTitle.Size, crTitle.Position = UDim2.new(1, -75, 0, 15), UDim2.new(0, 5, 0, 2)
crTitle.BackgroundTransparency, crTitle.Text = 1, "Tạo Mới Cấu Hình"
crTitle.TextColor3, crTitle.TextSize = Color3.fromRGB(255,255,255), 9
crTitle.Font, crTitle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local crSub = Instance.new("TextLabel", createFrame)
crSub.Size, crSub.Position = UDim2.new(1, -75, 0, 14), UDim2.new(0, 5, 0, 17)
crSub.BackgroundTransparency, crSub.Text = 1, "Sao chép hiện tại cài đặt"
crSub.TextColor3, crSub.TextSize = Color3.fromRGB(140,140,150), 7
crSub.Font, crSub.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left

local createBtn = Instance.new("TextButton", createFrame)
createBtn.Size, createBtn.Position = UDim2.new(0, 65, 0, 22), UDim2.new(1, -70, 0.5, -11)
createBtn.BackgroundColor3, createBtn.Text = Color3.fromRGB(220,50,50), "Tạo"
createBtn.TextColor3, createBtn.TextSize = Color3.fromRGB(255,255,255), 9
createBtn.Font = Enum.Font.GothamBold
Góc(createBtn, UDim.new(0, 4))
Stroke(createBtn)

-- 4) Xấu Cấu Hình
local deleteFrame = Instance.new("Frame", mainConfigContainer)
deleteFrame.LayoutOrder, deleteFrame.Size = 4, UDim2.new(1, 0, 0, 30)
deleteFrame.BackgroundColor3, deleteFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (xóa khung)
Stroke(deleteFrame)
RegTheme(deleteFrame, "Primary")

local delLabel = Instance.new("TextLabel", deleteFrame)
delLabel.Size, delLabel.Position = UDim2.new(0, 80, 1, 0), UDim2.new(0, 5, 0, 0)
delLabel.BackgroundTransparency, delLabel.Text = 1, "Xóa Cấu hình"
delLabel.TextColor3, delLabel.TextSize = Color3.fromRGB(255,255,255), 9
delLabel.Font, delLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left

local delBtn = Instance.new("TextButton", deleteFrame)
delBtn.Size, delBtn.Position = UDim2.new(0, 85, 0, 20), UDim2.new(1, -90, 0.5, -10)
delBtn.BackgroundColor3, delBtn.BackgroundTransparency = Color3.fromRGB(50,10,35), 0
delBtn.Text, delBtn.TextColor3 = "Không có ∨", Color3.fromRGB(50,200,50)
delBtn.TextSize, delBtn.Font = 8, Enum.Font.GothamBold
delBtn.TextXAlignment = Enum.TextXAlignment.Center
Góc(delBtn, UDim.new(0, 4))
Đột quỵ (delBtn)
RegTheme(delBtn, "Input")

local delDropFrame = Instance.new("ScrollingFrame", mainConfigContainer)
delDropFrame.LayoutOrder, delDropFrame.Size = 5, UDim2.new(1, 0, 0, 80)
delDropFrame.BackgroundColor3, delDropFrame.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
delDropFrame.CanvasSize, delDropFrame.ScrollBarThickness, delDropFrame.Visible = UDim2.new(0,0,0,0), 3, false
Góc(delDropFrame)
Stroke(delDropFrame)
local delDropLayout = Instance.new("UIListLayout", delDropFrame)
delDropLayout.Padding = UDim.new(0, 3)
local delPad = Instance.new("UIPadding", delDropFrame)
delPad.PaddingRight = UDim.new(0, 8)
RegTheme(delDropFrame, "DropFrame")

-- 5) Tải Config
local loadConfigFrame = Instance.new("Frame", mainConfigContainer)
loadConfigFrame.LayoutOrder, loadConfigFrame.Size = 6, UDim2.new(1, 0, 0, 30)
loadConfigFrame.BackgroundColor3, loadConfigFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (loadConfigFrame)
Stroke(loadConfigFrame)
RegTheme(loadConfigFrame, "Primary")

local ldLabel = Instance.new("TextLabel", loadConfigFrame)
ldLabel.Size, ldLabel.Position = UDim2.new(0, 80, 1, 0), UDim2.new(0, 5, 0, 0)
ldLabel.BackgroundTransparency, ldLabel.Text = 1, "Tải cấu hình"
ldLabel.TextColor3, ldLabel.TextSize = Color3.fromRGB(255,255,255), 9
ldLabel.Font, ldLabel.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left

local ldBtn = Instance.new("TextButton", loadConfigFrame)
ldBtn.Size, ldBtn.Position = UDim2.new(0, 85, 0, 20), UDim2.new(1, -90, 0.5, -10)
ldBtn.BackgroundColor3, ldBtn.BackgroundTransparency = Color3.fromRGB(50,10,35), 0
ldBtn.Text, ldBtn.TextColor3 = State.CurrentConfig .. " ∨", Color3.fromRGB(50,200,50)
ldBtn.TextSize, ldBtn.Font = 8, Enum.Font.GothamBold
ldBtn.TextXAlignment = Enum.TextXAlignment.Center
Góc(ldBtn, UDim.new(0, 4))
Đột quỵ (ldBtn)
RegTheme(ldBtn, "Input")

local ldDropFrame = Instance.new("ScrollingFrame", mainConfigContainer)
ldDropFrame.LayoutOrder, ldDropFrame.Size = 7, UDim2.new(1, 0, 0, 80)
ldDropFrame.BackgroundColor3, ldDropFrame.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
ldDropFrame.CanvasSize, ldDropFrame.ScrollBarThickness, ldDropFrame.Visible = UDim2.new(0,0,0,0), 3, false
Góc (ldDropFrame)
Stroke(ldDropFrame)
local ldDropLayout = Instance.new("UIListLayout", ldDropFrame)
ldDropLayout.Padding = UDim.new(0, 3)
local ldPad = Instance.new("UIPadding", ldDropFrame)
ldPad.PaddingRight = UDim.new(0, 8)
RegTheme(ldDropFrame, "DropFrame")

-- 6) Lưu Cấu Hình
local saveFrame = Instance.new("Frame", mainConfigContainer)
saveFrame.LayoutOrder, saveFrame.Size = 8, UDim2.new(1, 0, 0, 34)
saveFrame.BackgroundColor3, saveFrame.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
Góc (saveFrame)
Stroke(saveFrame)
RegTheme(saveFrame, "Primary")

local svTitle = Instance.new("TextLabel", saveFrame)
svTitle.Size, svTitle.Position = UDim2.new(1, -75, 0, 15), UDim2.new(0, 5, 0, 2)
svTitle.BackgroundTransparency, svTitle.Text = 1, "Lưu Cấu hình"
svTitle.TextColor3, svTitle.TextSize = Color3.fromRGB(255,255,255), 9
svTitle.Font, svTitle.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left

local svSub = Instance.new("TextLabel", saveFrame)
svSub.Size, svSub.Position = UDim2.new(1, -75, 0, 14), UDim2.new(0, 5, 0, 17)
svSub.BackgroundTransparency, svSub.Text = 1, "Lưu: " .. State.CurrentConfig
svSub.TextColor3, svSub.TextSize = Color3.fromRGB(140,140,150), 7
svSub.Font, svSub.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left

local saveBtn = Instance.new("TextButton", saveFrame)
saveBtn.Size, saveBtn.Position = UDim2.new(0, 65, 0, 22), UDim2.new(1, -70, 0.5, -11)
saveBtn.BackgroundColor3, saveBtn.Text = Color3.fromRGB(220,50,50), "Lưu"
saveBtn.TextColor3, saveBtn.TextSize = Color3.fromRGB(255,255,255), 9
saveBtn.Font = Enum.Font.GothamBold
Góc(saveBtn, UDim.new(0, 4))
Stroke(saveBtn)

-- ═════════════ ÁP sử dụng / TẢI CONFIG ═════════════
hàm cục bộ ApplyConfig(data)
    nếu data.ThemeBase thì
        local c = Color3.new(data.ThemeBase[1], data.ThemeBase[2], data.ThemeBase[3])
        ApplyTheme(c)
    kết thúc
    nếu data.StrokeMode == "Rainbow" thì
        State.StrokeMode = "Rainbow"
        UpdateAllStrokes("Rainbow")
    elseif data.StrokeMode == "None" then
        State.StrokeMode = "None"
        UpdateAllStrokes("None")
    nếu data.StrokeColor thì
        local c = Color3.new(data.StrokeColor[1], data.StrokeColor[2], data.StrokeColor[3])
        State.StrokeMode = "Solid"
        UpdateAllStrokes(c)
    kết thúc
    nếu kiểu dữ liệu (data.Volume) == "number" thì
        State.Volume = math.clamp(data.Volume, 0, 1)
        HubSound.Volume = State.Volume
        volumeBarFill.Size = UDim2.new(State.Volume, 0, 1, 0)
        volumeLabel.Text = "🔊 Âm lượng: " .. math.floor(State.Volume * 100) .. "%"
    kết thúc
    nếu kiểu dữ liệu (data.SoundId) == "string" thì
        State.SoundId = data.SoundId
        HubSound.SoundId = "rbxassetid://" .. State.SoundId
    kết thúc
    nếu kiểu dữ liệu (data.Transparent) == "number" thì
        State.Transparent = math.clamp(data.Transparent, 0, 1)
        transBarFill.Size = UDim2.new(State.Transparent, 0, 1, 0)
        MainFrame.BackgroundTransparency = 0.15 + (State.Transparent * 0.85)
        SidebarPanel.BackgroundTransparency = State.Transparent
        ContentContainer.BackgroundTransparency = State.Transparent
        transLabel.Text = "✨ Trong suốt: " .. math.floor(State.Transparent * 100) .. "%"
    kết thúc
    nếu data.SelectedScript thì
        for _, scr in ipairs(RegisteredScripts) do
            nếu scr.Name == data.SelectedScript thì
                State.SelectedScript = scr
                dropBtn.Text = " 📜 " .. scr.Name
                phá vỡ
            kết thúc
        kết thúc
    kết thúc
kết thúc

hàm cục bộ LoadConfig(name)
    cục bộ ok, dataOrErr = LoadConfigRaw(name)
    Nếu không ổn thì trả về false, dataOrErr end
    ApplyConfig(dataOrErr)
    trả về giá trị đúng
kết thúc

hàm cục bộ refreshAllDropdowns()
    for _, drop in ipairs({delDropFrame, ldDropFrame}) do
        for _, child in ipairs(drop:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        kết thúc
    kết thúc

    local filesList = {}
    if typeof(listfiles) == "function" then
        cục bộ ok, files = pcall(listfiles, CONFIG_FOLDER)
        nếu ok và loại (tệp) == "table" thì
            for _, file in ipairs(files) do
                nếu type(file) == "string" và string.sub(file, -5) == ".json" thì
                    local fileName = string.match(file, "[^/\\]+$") or file
                    table.insert(fileList, string.sub(fileName, 1, -6))
                kết thúc
            kết thúc
        kết thúc
    kết thúc
    if #filesList == 0 thì delBtn.Text = "Không có ∨" end

    for _, name in ipairs(filesList) do
        local f1 = Instance.new("TextButton", delDropFrame)
        f1.Size, f1.BackgroundColor3, f1.BackgroundTransparency = UDim2.new(1, 0, 0, 22), Color3.fromRGB(90,25,65), 0
        f1.Text, f1.TextColor3, f1.TextSize = " 🗑️ " .. name, Color3.fromRGB(255,100,100), 9
        f1.Font, f1.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
        Góc(f1, UDim.new(0, 4))
        Đột quỵ (f1)
        RegTheme(f1, "DropItem")
        Theo dõi(f1.MouseButton1Click:Connect(function()
            nếu kiểu dữ liệu của delfile là "function" thì
                pcall(delfile, CONFIG_FOLDER .. "/" .. name .. ".json")
            kết thúc
            delBtn.Text = tên .. " ∨"
            delDropFrame.Visible = false
            refreshAllDropdowns()
        kết thúc))

        local f3 = Instance.new("TextButton", ldDropFrame)
        f3.Size, f3.BackgroundColor3, f3.BackgroundTransparency = UDim2.new(1, 0, 0, 22), Color3.fromRGB(90,25,65), 0
        f3.Text, f3.TextColor3, f3.TextSize = " 📂 " .. name, Color3.fromRGB(255,255,255), 9
        f3.Font, f3.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
        Góc(f3, UDim.new(0, 4))
        Đột quỵ (f3)
        RegTheme(f3, "DropItem")
        Theo dõi(f3.MouseButton1Click:Connect(function()
            State.CurrentConfig = name
            ldBtn.Text = tên .. " ∨"
            svSub.Text = "Lưu: " .. tên
            ldDropFrame.Visible = false
            RefreshStartupLabel()
            cục bộ ok, err = LoadConfig(name)
            nếu không ổn thì cảnh báo ("[VzNam] Tải cấu hình thất bại: " .. tostring(err)) kết thúc
        kết thúc))
    kết thúc
    delDropFrame.CanvasSize = UDim2.new(0, 0, 0, #filesList * 25)
    ldDropFrame.CanvasSize = UDim2.new(0, 0, 0, #filesList * 25)
kết thúc

Theo dõi(delBtn.MouseButton1Click:Connect(function()
    refreshAllDropdowns()
    delDropFrame.Visible = not delDropFrame.Visible
    ldDropFrame.Visible = false
kết thúc))
Theo dõi(ldBtn.MouseButton1Click:Connect(function()
    refreshAllDropdowns()
    ldDropFrame.Visible = not ldDropFrame.Visible
    delDropFrame.Visible = false
kết thúc))

Theo dõi(createBtn.MouseButton1Click:Connect(function()
    tên cục bộ = configNameBox.Text
    nếu tên == "" thì trả về kết thúc
    if string.find(name, "[\\/:*?\"<>|]") then
        Warn("[VzNam] Cấu hình tên chứa ký tự không hợp lệ")
        trở lại
    kết thúc
    if typeof(writefile) ~= "function" then return end
    nếu SaveConfig(name) thì
        State.CurrentConfig = name
        ldBtn.Text = tên .. " ∨"
        svSub.Text = "Lưu: " .. tên
        configNameBox.Text = ""
        RefreshStartupLabel()
        refreshAllDropdowns()
    kết thúc
kết thúc))

Theo dõi(saveBtn.MouseButton1Click:Connect(function()
    nếu SaveConfig(State.CurrentConfig) thì
        svSub.Text = "Lưu: " .. State.CurrentConfig
    kết thúc
kết thúc))

-- ═════════════════ NÚT MỞ HUB ═════════════════
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size, OpenButton.Position = UDim2.new(0, 40, 0, 40), UDim2.new(0, 15, 0.25, 0)
OpenButton.BackgroundColor3, OpenButton.BackgroundTransparency = Color3.fromRGB(20,22,28), 0
OpenButton.Text, OpenButton.TextSize = "🌸", 20
OpenButton.Active, OpenButton.Draggable = true, true
Góc(OpenButton, UDim.new(1, 0))
local OpenStroke = Instance.new("UIStroke", OpenButton)
OpenStroke.Thickness, OpenStroke.Color = 3, Color3.fromRGB(0,191,255)
table.insert(AllUIStrokes, OpenStroke)

Theo dõi(OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
kết thúc))

-- ═════════════════ KHỞI TẠO ═════════════════
ApplyTheme(Color3.fromRGB(15, 16, 22))
UpdateAllStrokes(Color3.fromRGB(0, 191, 255))
RefreshStartupLabel()

print("[VzNam Hub v4] ✅ Đã tải. Thư mục cấu hình: " .. CONFIG_FOLDER)
