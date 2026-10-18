--[[
    ═══════════════════════════════════════════════════════
    VzNam Hub-Main - Steal an Egg Edition (Final Version)
    FULL UI + Logic Chạy Bộ Chống Kẹt + Lọc Rarity + Config
    ═══════════════════════════════════════════════════════
]]

local CoreGui         = game:GetService("CoreGui")
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local SoundService    = game:GetService("SoundService")
local HttpService     = game:GetService("HttpService")
local RunService      = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

if PlayerGui:FindFirstChild("VzNamHubV4UI") then PlayerGui.VzNamHubV4UI:Destroy() end
if PlayerGui:FindFirstChild("VzNamHubLoading") then PlayerGui.VzNamHubLoading:Destroy() end
if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end

-- ═════════════════ CONNECTION TRACKING ═════════════════
local Connections = {}
local function Track(c) if c then table.insert(Connections, c) end return c end

-- ═════════════════ STATE ═════════════════
local State = {
    ThemeBase   = Color3.fromRGB(15, 16, 22),
    StrokeMode  = "Solid",
    StrokeColor = Color3.fromRGB(0, 191, 255),
    Volume      = 0.5,
    SoundId     = "1837879082",
    CurrentConfig = "Default",
    Transparent = 0,
}

local FarmState = {
    AutoSteal     = false,
    SafeZonePos   = nil,
    SpeedBack     = 1500,
    MinRarity     = "Tất cả", -- Bộ lọc Rarity
    UseTeleport   = true,     -- Bay nhanh ra lấy trứng
}

-- ═════════════════ UI HELPERS ═════════════════
local function Corner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = r or UDim.new(0, 5); return c end
local AllUIStrokes = {}
local function Stroke(p, color, thick)
    local s = Instance.new("UIStroke", p)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color or State.StrokeColor; s.Thickness = thick or 1
    table.insert(AllUIStrokes, s); return s
end
local ThemedElements = {}
local function RegTheme(el, t) table.insert(ThemedElements, {Element = el, Type = t}); return el end

-- ═════════════════ ROOT UI ═════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VzNamHubV4UI"
ScreenGui.DisplayOrder = 99999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Corner(MainFrame, UDim.new(0, 8)); Stroke(MainFrame, Color3.fromRGB(0, 191, 255), 2)

-- ═════════════════ LOADING ═════════════════
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "VzNamHubLoading"
LoadingGui.DisplayOrder = 100000
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = PlayerGui

local LoadFrame = Instance.new("Frame", LoadingGui)
LoadFrame.Size = UDim2.new(0, 340, 0, 220)
LoadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
LoadFrame.BorderSizePixel = 0
Corner(LoadFrame, UDim.new(0, 8)); Stroke(LoadFrame, Color3.fromRGB(0, 191, 255), 2)

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0, 35); LoadTitle.Position = UDim2.new(0, 0, 0, 8)
LoadTitle.BackgroundTransparency = 1; LoadTitle.Text = "🌸 VzNam Hub-Main 🌸"
LoadTitle.TextColor3 = Color3.fromRGB(0, 191, 255); LoadTitle.TextSize = 13; LoadTitle.Font = Enum.Font.GothamBold

local BarBg = Instance.new("Frame", LoadFrame)
BarBg.Size = UDim2.new(1, -20, 0, 10); BarBg.Position = UDim2.new(0, 10, 1, -40); BarBg.BackgroundColor3 = Color3.fromRGB(25,26,35)
Corner(BarBg, UDim.new(1, 0)); Stroke(BarBg, Color3.fromRGB(0, 191, 255), 1)
local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromRGB(0, 191, 255); Corner(BarFill, UDim.new(1, 0))
local PercentLbl = Instance.new("TextLabel", LoadFrame)
PercentLbl.Size = UDim2.new(1, 0, 0, 18); PercentLbl.Position = UDim2.new(0, 0, 1, -24); PercentLbl.BackgroundTransparency = 1
PercentLbl.Text = "Đang tải: 0%"; PercentLbl.TextColor3 = Color3.fromRGB(200,205,215); PercentLbl.TextSize = 9; PercentLbl.Font = Enum.Font.GothamBold

-- ═════════════════ NÚT BÔNG HOA 🌸 ═════════════════
local flowerBtn = Instance.new("TextButton", ScreenGui)
flowerBtn.Name = "FlowerToggle"
flowerBtn.Size = UDim2.new(0, 50, 0, 50); flowerBtn.Position = UDim2.new(0, 20, 0.4, 0)
flowerBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); flowerBtn.BackgroundTransparency = 0.1
flowerBtn.Text = "🌸"; flowerBtn.TextSize = 26; flowerBtn.TextColor3 = Color3.fromRGB(255, 255, 255); flowerBtn.Font = Enum.Font.GothamBold
flowerBtn.Active = true; flowerBtn.Draggable = true; flowerBtn.Visible = false
Corner(flowerBtn, UDim.new(1, 0))
local fStroke = Instance.new("UIStroke", flowerBtn); fStroke.Thickness = 2.5; fStroke.Color = Color3.fromRGB(255, 105, 180)
table.insert(AllUIStrokes, fStroke)

local glow = Instance.new("Frame", flowerBtn)
glow.Size = UDim2.new(1, 8, 1, 8); glow.Position = UDim2.new(0, -4, 0, -4); glow.BackgroundColor3 = Color3.fromRGB(255, 105, 180); glow.BackgroundTransparency = 0.85; glow.BorderSizePixel = 0; glow.ZIndex = 0
Corner(glow, UDim.new(1, 0))
task.spawn(function()
    while flowerBtn.Parent do
        local tw = TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 14, 1, 14), Position = UDim2.new(0, -7, 0, -7), BackgroundTransparency = 0.7})
        tw:Play(); task.wait(1.2)
        if not flowerBtn.Parent then break end
        local tw2 = TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 8, 1, 8), Position = UDim2.new(0, -4, 0, -4), BackgroundTransparency = 0.85})
        tw2:Play(); task.wait(1.2)
    end
end)

local function UpdateFlowerIcon()
    if MainFrame.Visible then
        flowerBtn.Text = "✕"; fStroke.Color = Color3.fromRGB(255, 80, 80); glow.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    else
        flowerBtn.Text = "🌸"; fStroke.Color = Color3.fromRGB(255, 105, 180); glow.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    end
end

task.spawn(function()
    for i = 1, 10 do task.wait(0.1); BarFill.Size = UDim2.new(i / 10, 0, 1, 0); PercentLbl.Text = "Đang tải: " .. i*10 .. "%" end
    task.wait(0.2); LoadingGui:Destroy(); MainFrame.Visible = true; flowerBtn.Visible = true; UpdateFlowerIcon()
end)

-- ═════════════════ TOP BAR & SIDEBAR ═════════════════
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundTransparency = UDim2.new(1, 0, 0, 26), 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position = UDim2.new(1, -60, 1, 0), UDim2.new(0, 28, 0, 0); Title.BackgroundTransparency, Title.Text = 1, "🌸 VzNam Hub-Main 🌸"
Title.TextColor3, Title.TextSize = Color3.fromRGB(0, 191, 255), 10; Title.Font, Title.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 24, 0, 24), UDim2.new(1, -26, 0.5, -12); CloseBtn.BackgroundTransparency, CloseBtn.Text = 1, "✕"
CloseBtn.TextColor3, CloseBtn.TextSize = Color3.fromRGB(200, 200, 210), 10; CloseBtn.Font = Enum.Font.GothamBold
Track(CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; UpdateFlowerIcon() end))

local SidebarPanel = Instance.new("Frame", MainFrame)
SidebarPanel.Size, SidebarPanel.Position = UDim2.new(0.3, -4, 1, -34), UDim2.new(0, 6, 0, 28); SidebarPanel.BackgroundColor3, SidebarPanel.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Corner(SidebarPanel, UDim.new(0, 6)); Stroke(SidebarPanel, Color3.fromRGB(0,191,255), 1)

local SidebarScroll = Instance.new("ScrollingFrame", SidebarPanel)
SidebarScroll.Size, SidebarScroll.Position = UDim2.new(1, -4, 1, -8), UDim2.new(0, 2, 0, 4); SidebarScroll.BackgroundTransparency, SidebarScroll.BorderSizePixel = 1, 0
SidebarScroll.ScrollBarThickness, SidebarScroll.ClipsDescendants = 2, true
local SidebarLayout = Instance.new("UIListLayout", SidebarScroll)
SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 3)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position = UDim2.new(0.68, -4, 1, -34), UDim2.new(0.315, 0, 0, 28); ContentContainer.BackgroundColor3, ContentContainer.BorderSizePixel = Color3.fromRGB(15,16,22), 0
Corner(ContentContainer, UDim.new(0, 6)); Stroke(ContentContainer, Color3.fromRGB(0,191,255), 1)
local Tabs = {}

-- ═════════════════ TAB HOME ═════════════════
local tabHomeBtn = Instance.new("TextButton", SidebarScroll)
tabHomeBtn.LayoutOrder = 0; tabHomeBtn.Size, tabHomeBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabHomeBtn.BackgroundTransparency, tabHomeBtn.Text = 0, " 🏠 Trang Chủ"; tabHomeBtn.TextColor3, tabHomeBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabHomeBtn.Font, tabHomeBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Corner(tabHomeBtn); RegTheme(tabHomeBtn, "Primary")

local homeScroll = Instance.new("ScrollingFrame", ContentContainer)
homeScroll.Size, homeScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28); homeScroll.BackgroundTransparency, homeScroll.BorderSizePixel = 1, 0
homeScroll.ScrollBarThickness, homeScroll.Visible, homeScroll.ClipsDescendants = 3, false, true
local homeLayout = Instance.new("UIListLayout", homeScroll)
homeLayout.SortOrder, homeLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); homeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
homeLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() homeScroll.CanvasSize = UDim2.new(0, 0, 0, homeLayout.AbsoluteContentSize.Y + 15) end)
Track(tabHomeBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false; if t.Indicator then t.Indicator.Visible = false end end
    homeScroll.Visible = true; 
end))
table.insert(Tabs, {Container = homeScroll}); homeScroll.Visible = true

-- ═════════════════ TAB FARM ═════════════════
local tabFarmBtn = Instance.new("TextButton", SidebarScroll)
tabFarmBtn.LayoutOrder = 1; tabFarmBtn.Size, tabFarmBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabFarmBtn.BackgroundTransparency, tabFarmBtn.Text = 0, " 🌾 Farm"; tabFarmBtn.TextColor3, tabFarmBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabFarmBtn.Font, tabFarmBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Corner(tabFarmBtn); RegTheme(tabFarmBtn, "Primary")

local farmScroll = Instance.new("ScrollingFrame", ContentContainer)
farmScroll.Size, farmScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28); farmScroll.BackgroundTransparency, farmScroll.BorderSizePixel = 1, 0
farmScroll.ScrollBarThickness, farmScroll.Visible, farmScroll.ClipsDescendants = 3, false, true
local farmLayout = Instance.new("UIListLayout", farmScroll)
farmLayout.SortOrder, farmLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); farmLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
farmLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() farmScroll.CanvasSize = UDim2.new(0, 0, 0, farmLayout.AbsoluteContentSize.Y + 20) end)
Track(tabFarmBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false; if t.Indicator then t.Indicator.Visible = false end end
    farmScroll.Visible = true; 
end))
table.insert(Tabs, {Container = farmScroll})

-- ═════════════════ UI FACTORIES ═════════════════
local function CreateToggle(parent, label, getter, setter, onChange)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -10, 0, 30); f.BackgroundColor3, f.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
    Corner(f); Stroke(f); RegTheme(f, "Primary")
    local lbl = Instance.new("TextLabel", f)
    lbl.Size, lbl.Position = UDim2.new(1, -50, 1, 0), UDim2.new(0, 6, 0, 0); lbl.BackgroundTransparency, lbl.Text = 1, label
    lbl.TextColor3, lbl.TextSize = Color3.fromRGB(255,255,255), 8; lbl.Font, lbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f)
    btn.Size, btn.Position = UDim2.new(0, 34, 0, 16), UDim2.new(1, -40, 0.5, -8); btn.BackgroundColor3, btn.Text = Color3.fromRGB(60,65,75), ""
    Corner(btn, UDim.new(1, 0)); Stroke(btn)
    local dot = Instance.new("Frame", btn)
    dot.Size, dot.Position = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6); dot.BackgroundColor3 = Color3.fromRGB(255,255,255); Corner(dot, UDim.new(1, 0))
    local function upd(s) if s then btn.BackgroundColor3 = Color3.fromRGB(50,200,50); dot.Position = UDim2.new(1, -14, 0.5, -6) else btn.BackgroundColor3 = Color3.fromRGB(60,65,75); dot.Position = UDim2.new(0, 2, 0.5, -6) end end
    upd(getter())
    Track(btn.MouseButton1Click:Connect(function() local n = not getter(); setter(n); upd(n); if onChange then onChange(n) end end))
    return f
end

local function CreateSlider(parent, label, minV, maxV, getter, setter)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -10, 0, 34); f.BackgroundColor3, f.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
    Corner(f); Stroke(f); RegTheme(f, "Primary")
    local lbl = Instance.new("TextLabel", f)
    lbl.Size, lbl.Position = UDim2.new(1, -10, 0, 12), UDim2.new(0, 6, 0, 2); lbl.BackgroundTransparency, lbl.Text = 1, label
    lbl.TextColor3, lbl.TextSize = Color3.fromRGB(255,255,255), 8; lbl.Font, lbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
    local valLbl = Instance.new("TextLabel", f)
    valLbl.Size, valLbl.Position = UDim2.new(0, 50, 0, 12), UDim2.new(1, -56, 0, 2); valLbl.BackgroundTransparency, valLbl.Text = 1, tostring(getter())
    valLbl.TextColor3, valLbl.TextSize = Color3.fromRGB(0,200,255), 8; valLbl.Font, valLbl.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Right
    local barBg = Instance.new("Frame", f)
    barBg.Size, barBg.Position = UDim2.new(1, -12, 0, 8), UDim2.new(0, 6, 1, -13); barBg.BackgroundColor3 = Color3.fromRGB(90,25,65)
    Corner(barBg, UDim.new(1, 0)); Stroke(barBg); RegTheme(barBg, "DropItem")
    local barFill = Instance.new("Frame", barBg)
    barFill.BackgroundColor3 = Color3.fromRGB(0,180,255); Corner(barFill, UDim.new(1, 0))
    local pct = (getter() - minV) / (maxV - minV); barFill.Size = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0)
    local drag = Instance.new("TextButton", barBg)
    drag.Size, drag.BackgroundTransparency, drag.Text = UDim2.new(1, 10, 1, 10), 1, ""
    local dragging = false
    Track(drag.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end))
    Track(UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end))
    Track(UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local ap, as = barBg.AbsolutePosition.X, barBg.AbsoluteSize.X
            local p = math.clamp((i.Position.X - ap) / as, 0, 1)
            local v = math.floor(minV + p * (maxV - minV))
            barFill.Size = UDim2.new(p, 0, 1, 0); valLbl.Text = tostring(v); setter(v)
        end
    end))
    return f
end

local function CreateDropdown(parent, prefix, options, getter, setter)
    local f = Instance.new("Frame", parent)
    f.Size, f.AutomaticSize = UDim2.new(1, -10, 0, 0), Enum.AutomaticSize.Y; f.BackgroundTransparency = 1
    local fl = Instance.new("UIListLayout", f)
    fl.SortOrder, fl.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 3)
    local mainBtn = Instance.new("TextButton", f)
    mainBtn.LayoutOrder, mainBtn.Size = 1, UDim2.new(1, 0, 0, 26); mainBtn.BackgroundColor3, mainBtn.BackgroundTransparency = Color3.fromRGB(70,15,50), 0
    mainBtn.Text = " " .. prefix .. ": " .. tostring(getter()) .. " ✓"; mainBtn.TextColor3, mainBtn.TextSize = Color3.fromRGB(255,255,255), 8
    mainBtn.Font, mainBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Left
    Corner(mainBtn); Stroke(mainBtn); RegTheme(mainBtn, "Primary")
    
    local dropFrame = Instance.new("ScrollingFrame", f)
    dropFrame.LayoutOrder, dropFrame.Size = 2, UDim2.new(1, 0, 0, math.min(#options * 22 + 6, 105)); dropFrame.BackgroundColor3, dropFrame.BackgroundTransparency = Color3.fromRGB(80,20,60), 0
    dropFrame.CanvasSize = UDim2.new(0,0,0,#options*22+6); dropFrame.ScrollBarThickness, dropFrame.Visible = 3, false
    Corner(dropFrame); Stroke(dropFrame); RegTheme(dropFrame, "DropFrame")
    local dl = Instance.new("UIListLayout", dropFrame); dl.Padding = UDim.new(0, 3)
    Instance.new("UIPadding", dropFrame).PaddingRight = UDim.new(0, 8)
    
    for i, opt in ipairs(options) do
        local ob = Instance.new("TextButton", dropFrame)
        ob.LayoutOrder, ob.Size = i, UDim2.new(1, 0, 0, 20); ob.BackgroundColor3, ob.BackgroundTransparency = Color3.fromRGB(90,25,65), 0
        ob.Text, ob.TextColor3, ob.TextSize = " " .. opt, Color3.fromRGB(255,255,255), 8
        ob.Font, ob.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
        Corner(ob, UDim.new(0, 4)); Stroke(ob); RegTheme(ob, "DropItem")
        Track(ob.MouseButton1Click:Connect(function() setter(opt); mainBtn.Text = " " .. prefix .. ": " .. opt .. " ✓"; dropFrame.Visible = false end))
    end
    Track(mainBtn.MouseButton1Click:Connect(function() dropFrame.Visible = not dropFrame.Visible end))
    return f
end

-- ═════════════════ LOGIC STEAL AN EGG ═════════════════
local function GetChar()
    local c = localPlayer.Character
    if not c then return nil, nil, nil end
    return c, c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

-- Hàm check Rarity (Dựa vào Attribute của trứng)
local RARITY_ORDER = {Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythical=6, Secret=7, OG=8}
local function CheckRarity(prompt)
    if FarmState.MinRarity == "Tất cả" then return true end
    local eggObj = prompt.Parent
    local rarity = "Common"
    
    -- Thử đọc attribute
    local ok, attr = pcall(function() return eggObj:GetAttribute("Rarity") end)
    if ok and attr then rarity = tostring(attr)
    else
        -- Thử đọc tên (nếu có chứa chữ)
        local n = string.lower(eggObj.Name)
        for r in pairs(RARITY_ORDER) do
            if string.find(n, string.lower(r)) then rarity = r; break end
        end
    end
    
    local eggRarityVal = RARITY_ORDER[rarity] or 1
    local targetRarityVal = RARITY_ORDER[FarmState.MinRarity] or 1
    return eggRarityVal >= targetRarityVal
end

-- Hàm Tween siêu tốc
local function FastTween(hrp, targetPos, speed)
    local dist = (hrp.Position - targetPos).Magnitude
    if dist < 3 then return end
    local t = dist / speed
    local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
    tw:Play()
    pcall(function() tw.Completed:Wait() end)
end

-- Hàm chạy bộ thông minh (Chống kẹt)
local function SmartWalk(hrp, humanoid, targetPos)
    humanoid:MoveTo(targetPos)
    local timeout = tick() + 1.5 -- Chạy bộ tối đa 1.5s
    local lastPos = hrp.Position
    local stuckTime = 0
    
    while (hrp.Position - targetPos).Magnitude > 5 and tick() < timeout do
        task.wait(0.1)
        -- Check kẹt
        if (hrp.Position - lastPos).Magnitude < 1 then
            stuckTime = stuckTime + 0.1
            if stuckTime > 0.5 then 
                -- Kẹt quá 0.5s -> Chuyển sang bay Tween
                humanoid:MoveTo(hrp.Position)
                FastTween(hrp, targetPos, 150)
                return
            end
        else
            stuckTime = 0
            lastPos = hrp.Position
        end
    end
    humanoid:MoveTo(hrp.Position)
    -- Nếu hết 1.5s vẫn chưa tới, bay nốt quãng đường còn lại
    if (hrp.Position - targetPos).Magnitude > 5 then
        FastTween(hrp, targetPos, 150)
    end
end

local function FindNearestEgg()
    local _, hrp = GetChar()
    if not hrp then return nil end
    local bestPrompt, bestDist = nil, math.huge
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "SmartPromptPart" then
            local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt and string.lower(prompt.ActionText) == "steal" then
                if FarmState.SafeZonePos and (v.Position - FarmState.SafeZonePos).Magnitude < 60 then continue end
                if CheckRarity(prompt) then
                    local dist = (hrp.Position - v.Position).Magnitude
                    if dist < bestDist then bestDist = dist; bestPrompt = prompt end
                end
            end
        end
    end
    return bestPrompt
end

local function FindEggNear(pos, radius)
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "SmartPromptPart" then
            local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt and string.lower(prompt.ActionText) == "steal" and (pos - v.Position).Magnitude <= radius then return prompt end
        end
    end
    return nil
end

local function GrabEgg(prompt)
    if not prompt then return end
    pcall(function()
        prompt.MaxActivationDistance = 500
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        fireproximityprompt(prompt)
    end)
end

local function DropEgg()
    local rs = game:GetService("ReplicatedStorage")
    local dropRF = rs:FindFirstChild("Packages", true) and rs.Packages:FindFirstChild("Networking", true) and rs.Packages.Networking:FindFirstChild("RF/EggWorld/AskFieldEggDrop", true)
    if dropRF then pcall(function() dropRF:InvokeServer() end) else
        local pg = localPlayer:FindFirstChild("PlayerGui")
        local gui = pg and pg:FindFirstChild("DropHeldEgg")
        if gui then for _, obj in ipairs(gui:GetDescendants()) do if obj:IsA("TextButton") or obj:IsA("ImageButton") then pcall(function() obj:Activate() end) end end end
    end
end

local running = false
local function StartFarmLoop()
    if running then return end
    running = true
    task.spawn(function()
        while running and FarmState.AutoSteal do
            pcall(function()
                local char, hrp, humanoid = GetChar()
                if not hrp or not humanoid or not FarmState.SafeZonePos then return end
                
                -- 1. Ra lấy trứng
                local prompt = FindNearestEgg()
                if prompt and prompt.Parent then
                    if FarmState.UseTeleport then
                        -- Bay thẳng ra (nhanh, không kẹt)
                        FastTween(hrp, prompt.Parent.Position, 300)
                    else
                        -- Chạy bộ (có chống kẹt)
                        SmartWalk(hrp, humanoid, prompt.Parent.Position)
                    end
                    task.wait(0.1)
                    GrabEgg(prompt)
                    task.wait(0.15)
                end
                
                -- 2. Bay về Safe Zone
                FastTween(hrp, FarmState.SafeZonePos, FarmState.SpeedBack)
                task.wait(0.1)
                
                -- 3. Thả & Lượm lại (Reset Anti-Cheat)
                DropEgg()
                task.wait(0.2)
                local newPrompt = FindEggNear(FarmState.SafeZonePos, 20)
                if newPrompt then
                    GrabEgg(newPrompt)
                    task.wait(0.2)
                    DropEgg()
                end
                task.wait(0.2)
            end)
            task.wait(0.1)
        end
        running = false
    end)
end

-- ═════════════════ TAB FARM UI ═════════════════
local autoStealBtn = Instance.new("TextButton", farmScroll)
autoStealBtn.Size, autoStealBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 34), Color3.fromRGB(55,12,40)
autoStealBtn.BackgroundTransparency, autoStealBtn.Text = 0, " → Tự Động Trộm Trứng"; autoStealBtn.TextColor3, autoStealBtn.TextSize = Color3.fromRGB(255,255,255), 10
autoStealBtn.Font, autoStealBtn.TextXAlignment = Enum.Font.GothamBold, Enum.TextXAlignment.Center
Corner(autoStealBtn); Stroke(autoStealBtn); RegTheme(autoStealBtn, "Secondary")

local autoStealContainer = Instance.new("Frame", farmScroll)
autoStealContainer.Size, autoStealContainer.AutomaticSize = UDim2.new(1, 0, 0, 0), Enum.AutomaticSize.Y
autoStealContainer.BackgroundTransparency = 1; autoStealContainer.Visible = false
local ascL = Instance.new("UIListLayout", autoStealContainer)
ascL.SortOrder, ascL.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); ascL.HorizontalAlignment = Enum.HorizontalAlignment.Center
Track(autoStealBtn.MouseButton1Click:Connect(function()
    autoStealContainer.Visible = not autoStealContainer.Visible
    autoStealBtn.Text = autoStealContainer.Visible and " ↓ Tự Động Trộm Trứng" or " → Tự Động Trộm Trứng"
end))

CreateToggle(autoStealContainer, "⚡ Bật Auto Steal", 
    function() return FarmState.AutoSteal end, function(v) FarmState.AutoSteal = v end, function(v) if v then StartFarmLoop() else running = false end end)

local setSafeBtn = Instance.new("TextButton", autoStealContainer)
setSafeBtn.Size = UDim2.new(1, 0, 0, 30); setSafeBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
setSafeBtn.Text = "📍 Đặt Vùng An Toàn (Chỗ Thả)"; setSafeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); setSafeBtn.Font = Enum.Font.GothamBold; setSafeBtn.TextSize = 9
Corner(setSafeBtn); Stroke(setSafeBtn)
setSafeBtn.MouseButton1Click:Connect(function()
    local _, hrp = GetChar()
    if hrp then
        FarmState.SafeZonePos = hrp.Position
        setSafeBtn.Text = "✅ Đã Lưu Vùng An Toàn!"
        task.wait(2); setSafeBtn.Text = "📍 Đặt Vùng An Toàn (Chỗ Thả)"
    end
end)

CreateDropdown(autoStealContainer, "💎 Min Rarity", 
    {"Tất cả", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret", "OG"}, 
    function() return FarmState.MinRarity end, function(v) FarmState.MinRarity = v end)

CreateToggle(autoStealContainer, "🚀 Tele Nhanh (Chống Kẹt)", function() return FarmState.UseTeleport end, function(v) FarmState.UseTeleport = v end)
CreateSlider(autoStealContainer, "⚡ Tốc độ bay về", 500, 3000, function() return FarmState.SpeedBack end, function(v) FarmState.SpeedBack = v end)

-- ═════════════════ TAB CẤU HÌNH (Config) ═════════════════
local tabCfgBtn = Instance.new("TextButton", SidebarScroll)
tabCfgBtn.LayoutOrder = 3; tabCfgBtn.Size, tabCfgBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 26), Color3.fromRGB(70,15,50)
tabCfgBtn.BackgroundTransparency, tabCfgBtn.Text = 0, " 📦 CẤU HÌNH"; tabCfgBtn.TextColor3, tabCfgBtn.TextSize = Color3.fromRGB(255,255,255), 8
tabCfgBtn.Font, tabCfgBtn.TextXAlignment = Enum.Font.Gotham, Enum.TextXAlignment.Left
Corner(tabCfgBtn); RegTheme(tabCfgBtn, "Primary")

local cfgScroll = Instance.new("ScrollingFrame", ContentContainer)
cfgScroll.Size, cfgScroll.Position = UDim2.new(1, -12, 1, -29), UDim2.new(0, 6, 0, 28)
cfgScroll.BackgroundTransparency, cfgScroll.BorderSizePixel = 1, 0; cfgScroll.ScrollBarThickness, cfgScroll.Visible, cfgScroll.ClipsDescendants = 3, false, true
local cfgLayout = Instance.new("UIListLayout", cfgScroll)
cfgLayout.SortOrder, cfgLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 5); cfgLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", cfgScroll).PaddingTop = UDim.new(0, 4)
Track(tabCfgBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(Tabs) do t.Container.Visible = false; if t.Indicator then t.Indicator.Visible = false end end
    cfgScroll.Visible = true;
end))
table.insert(Tabs, {Container = cfgScroll})

-- Logic Lưu/Tải Config
local CONFIG_FOLDER = "VzNamHub_Configs"
if typeof(makefolder) == "function" then pcall(makefolder, CONFIG_FOLDER) end

local function SaveConfig(name)
    if typeof(writefile) ~= "function" then return false end
    local data = HttpService:JSONEncode({
        ThemeBase = {State.ThemeBase.R, State.ThemeBase.G, State.ThemeBase.B},
        FarmState = FarmState
    })
    return pcall(writefile, CONFIG_FOLDER .. "/" .. name .. ".json", data)
end

local function LoadConfig(name)
    if typeof(readfile) ~= "function" then return false end
    local ok, contents = pcall(readfile, CONFIG_FOLDER .. "/" .. name .. ".json")
    if not ok or not contents then return false end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, contents)
    if not ok2 then return false end
    if data.FarmState then
        for k, v in pairs(data.FarmState) do if FarmState[k] ~= nil then FarmState[k] = v end end
    end
    return true
end

local cfNameBox = Instance.new("TextBox", cfgScroll)
cfNameBox.Size = UDim2.new(1, -10, 0, 30); cfNameBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
cfNameBox.PlaceholderText = "Nhập tên Config..."; cfNameBox.Text = ""; cfNameBox.TextColor3 = Color3.fromRGB(255,255,255)
cfNameBox.TextSize = 10; cfNameBox.Font = Enum.Font.Gotham; Corner(cfNameBox); Stroke(cfNameBox)

local saveBtn = Instance.new("TextButton", cfgScroll)
saveBtn.Size = UDim2.new(1, -10, 0, 30); saveBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
saveBtn.Text = "💾 LƯU CẤU HÌNH"; saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 10
Corner(saveBtn); Stroke(saveBtn)
saveBtn.MouseButton1Click:Connect(function()
    if cfNameBox.Text ~= "" then
        if SaveConfig(cfNameBox.Text) then
            saveBtn.Text = "✅ Đã Lưu!"; task.wait(1.5); saveBtn.Text = "💾 LƯU CẤU HÌNH"
        else
            saveBtn.Text = "❌ Lỗi Lưu!"; task.wait(1.5); saveBtn.Text = "💾 LƯU CẤU HÌNH"
        end
    end
end)

local loadBtn = Instance.new("TextButton", cfgScroll)
loadBtn.Size = UDim2.new(1, -10, 0, 30); loadBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
loadBtn.Text = "📂 TẢI CẤU HÌNH"; loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255); loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 10
Corner(loadBtn); Stroke(loadBtn)
loadBtn.MouseButton1Click:Connect(function()
    if cfNameBox.Text ~= "" then
        if LoadConfig(cfNameBox.Text) then
            loadBtn.Text = "✅ Đã Tải!"; task.wait(1.5); loadBtn.Text = "📂 TẢI CẤU HÌNH"
        else
            loadBtn.Text = "❌ Không tìm thấy!"; task.wait(1.5); loadBtn.Text = "📂 TẢI CẤU HÌNH"
        end
    end
end)

local delBtn = Instance.new("TextButton", cfgScroll)
delBtn.Size = UDim2.new(1, -10, 0, 30); delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
delBtn.Text = "🗑️ XÓA CẤU HÌNH"; delBtn.TextColor3 = Color3.fromRGB(255, 255, 255); delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 10
Corner(delBtn); Stroke(delBtn)
delBtn.MouseButton1Click:Connect(function()
    if cfNameBox.Text ~= "" and typeof(delfile) == "function" then
        pcall(delfile, CONFIG_FOLDER .. "/" .. cfNameBox.Text .. ".json")
        delBtn.Text = "✅ Đã Xóa!"; task.wait(1.5); delBtn.Text = "🗑️ XÓA CẤU HÌNH"
    end
end)

Track(flowerBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible; UpdateFlowerIcon() end))
print("[VzNam Hub-Main] ✅ FULL LOADED - Đã sửa toàn bộ lỗi.")
