local CoreGui, Players, TweenService, UserInputService, SoundService = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("SoundService")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("VzNamHubGui") then CoreGui.VzNamHubGui:Destroy() end
if CoreGui:FindFirstChild("VzNamBlackScreen") then CoreGui.VzNamBlackScreen:Destroy() end

local LastSelectedScriptBtn, LastSelectedScriptStroke = nil, nil
local RegisteredScripts = {}

local function ApplyBlackTextWhiteOutline(textObj)
    textObj.TextColor3 = Color3.fromRGB(0, 0, 0)
    textObj.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    textObj.TextStrokeTransparency = 0
end

local VzNamGui = Instance.new("ScreenGui", CoreGui) 
VzNamGui.Name = "VzNamHubGui" 
VzNamGui.DisplayOrder = 10 
VzNamGui.ResetOnSpawn = false

local BlackScreenGui = Instance.new("ScreenGui", CoreGui)
BlackScreenGui.Name = "VzNamBlackScreen"
BlackScreenGui.DisplayOrder = 5
BlackScreenGui.IgnoreGuiInset = true
BlackScreenGui.ResetOnSpawn = false
BlackScreenGui.Enabled = false

local BlackFrame = Instance.new("Frame", BlackScreenGui)
BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local avatarUrl = "rbxassetid://6031094678"
pcall(function() avatarUrl = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)

local ToggleBtn = Instance.new("ImageButton", VzNamGui)
ToggleBtn.Name, ToggleBtn.BackgroundColor3, ToggleBtn.Position, ToggleBtn.Size, ToggleBtn.Active, ToggleBtn.Draggable, ToggleBtn.Image, ToggleBtn.ZIndex = "ToggleBtn", Color3.fromRGB(30, 30, 30), UDim2.new(0.05, 0, 0.2, 0), UDim2.new(0, 55, 0, 55), true, true, avatarUrl, 10
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn) ToggleStroke.Color, ToggleStroke.Thickness = Color3.fromRGB(255, 255, 255), 2

local MainFrame = Instance.new("Frame", VzNamGui)
MainFrame.Name, MainFrame.BackgroundColor3, MainFrame.Position, MainFrame.Size, MainFrame.ClipsDescendants, MainFrame.ZIndex = "MainFrame", Color3.fromRGB(255, 255, 255), UDim2.new(0.5, -170, 0.5, -150), UDim2.new(0, 370, 0, 310), true, 5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local RainbowGradient = Instance.new("UIGradient", MainFrame)
RainbowGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 180)), ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 220, 180)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 180)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(180, 255, 200)), ColorSequenceKeypoint.new(0.8, Color3.fromRGB(180, 220, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 180, 255))})
local RainbowTween = TweenService:Create(RainbowGradient, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), {Rotation = 360})
RainbowTween:Play()

local FrameStroke = Instance.new("UIStroke", MainFrame) FrameStroke.Color, FrameStroke.Thickness = Color3.fromRGB(255, 255, 255), 2

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name, TitleBar.Size, TitleBar.BackgroundColor3, TitleBar.BackgroundTransparency, TitleBar.ZIndex = "TitleBar", UDim2.new(1, 0, 0, 40), Color3.fromRGB(0, 0, 0), 0.6, 6
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

local HeaderAvatar = Instance.new("ImageLabel", TitleBar) HeaderAvatar.Position, HeaderAvatar.Size, HeaderAvatar.BackgroundTransparency, HeaderAvatar.Image, HeaderAvatar.ZIndex = UDim2.new(0, 10, 0.5, -14), UDim2.new(0, 28, 0, 28), 1, avatarUrl, 7
Instance.new("UICorner", HeaderAvatar).CornerRadius = UDim.new(1, 0)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Position, TitleText.Size, TitleText.BackgroundTransparency, TitleText.Text, TitleText.TextSize, TitleText.Font, TitleText.TextXAlignment, TitleText.ZIndex = UDim2.new(0, 45, 0, 0), UDim2.new(1, -85, 1, 0), 1, "🌸TỔNG HỢP | 👑VzNam Hub v3👑 | 🌸", 13, Enum.Font.SourceSansBold, Enum.TextXAlignment.Left, 7
ApplyBlackTextWhiteOutline(TitleText)

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Position, CloseBtn.Size, CloseBtn.BackgroundColor3, CloseBtn.BackgroundTransparency, CloseBtn.Text, CloseBtn.Font, CloseBtn.TextSize, CloseBtn.ZIndex = UDim2.new(1, -34, 0.5, -14), UDim2.new(0, 28, 0, 28), Color3.fromRGB(200, 50, 50), 0.2, "✖", Enum.Font.SourceSansBold, 14, 8
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(CloseBtn)
CloseBtn.MouseButton1Click:Connect(function()
    if SoundService:FindFirstChild("VzNamHubSound") then SoundService.VzNamHubSound:Destroy() end
    VzNamGui:Destroy()
    BlackScreenGui:Destroy()
end)

local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Position, ResizeBtn.Size, ResizeBtn.BackgroundColor3, ResizeBtn.BackgroundTransparency, ResizeBtn.Text, ResizeBtn.Font, ResizeBtn.TextSize, ResizeBtn.ZIndex = UDim2.new(1, -20, 1, -20), UDim2.new(0, 20, 0, 20), Color3.fromRGB(150, 150, 150), 0.5, "◢", Enum.Font.SourceSansBold, 11, 10
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0, 4)
ApplyBlackTextWhiteOutline(ResizeBtn)

local resizing, resizeStart, startSize
ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing, resizeStart, startSize = true, input.Position, MainFrame.AbsoluteSize
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and resizing then
        local delta = input.Position - resizeStart
        local newWidth = math.clamp(startSize.X + delta.X, 320, 600)
        local newHeight = math.clamp(startSize.Y + delta.Y, 260, 500)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

local TabBarLeftScroll = Instance.new("ScrollingFrame", MainFrame)
TabBarLeftScroll.Position, TabBarLeftScroll.Size, TabBarLeftScroll.BackgroundTransparency, TabBarLeftScroll.CanvasSize, TabBarLeftScroll.ScrollBarThickness, TabBarLeftScroll.ZIndex = UDim2.new(0, 8, 0, 48), UDim2.new(0, 100, 1, -56), 1, UDim2.new(0, 0, 0, 340), 3, 6
local LeftLayout = Instance.new("UIListLayout", TabBarLeftScroll) LeftLayout.Padding = UDim.new(0, 8)

local function CreateCategoryContainer(visible)
    local frame = Instance.new("Frame", MainFrame) frame.Position, frame.Size, frame.BackgroundTransparency, frame.Visible, frame.ZIndex = UDim2.new(0, 114, 0, 48), UDim2.new(1, -122, 1, -56), 1, visible, 6
    local subBar = Instance.new("Frame", frame) subBar.Size, subBar.BackgroundTransparency, subBar.ZIndex = UDim2.new(1, 0, 0, 28), 1, 7
    local subLayout = Instance.new("UIListLayout", subBar) subLayout.FillDirection, subLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)
    
    local noKeyBtn = Instance.new("TextButton", subBar) noKeyBtn.Size, noKeyBtn.BackgroundColor3, noKeyBtn.BackgroundTransparency, noKeyBtn.Text, noKeyBtn.Font, noKeyBtn.TextSize, noKeyBtn.ZIndex = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(0, 0, 0), 0.3, "no key", Enum.Font.SourceSansBold, 12, 8
    Instance.new("UICorner", noKeyBtn).CornerRadius = UDim.new(0, 6)
    local nkStroke = Instance.new("UIStroke", noKeyBtn) nkStroke.Color, nkStroke.Thickness = Color3.fromRGB(255, 50, 50), 2
    ApplyBlackTextWhiteOutline(noKeyBtn)
    
    local hasKeyBtn = Instance.new("TextButton", subBar) hasKeyBtn.Size, hasKeyBtn.BackgroundColor3, hasKeyBtn.BackgroundTransparency, hasKeyBtn.Text, hasKeyBtn.Font, hasKeyBtn.TextSize, hasKeyBtn.ZIndex = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(0, 0, 0), 0.7, "có key", Enum.Font.SourceSansBold, 12, 8
    Instance.new("UICorner", hasKeyBtn).CornerRadius = UDim.new(0, 6)
    local hkStroke = Instance.new("UIStroke", hasKeyBtn) hkStroke.Color, hkStroke.Thickness = Color3.fromRGB(255, 255, 255), 1
    ApplyBlackTextWhiteOutline(hasKeyBtn)
    
    local scrollNoKey = Instance.new("ScrollingFrame", frame) scrollNoKey.Position, scrollNoKey.Size, scrollNoKey.BackgroundTransparency, scrollNoKey.CanvasSize, scrollNoKey.ScrollBarThickness, scrollNoKey.Visible, scrollNoKey.ZIndex = UDim2.new(0, 0, 0, 34), UDim2.new(1, 0, 1, -34), 1, UDim2.new(0, 0, 0, 2000), 4, true, 7
    Instance.new("UIListLayout", scrollNoKey).Padding = UDim.new(0, 8)
    
    local scrollHasKey = Instance.new("ScrollingFrame", frame) scrollHasKey.Position, scrollHasKey.Size, scrollHasKey.BackgroundTransparency, scrollHasKey.CanvasSize, scrollHasKey.ScrollBarThickness, scrollHasKey.Visible, scrollHasKey.ZIndex = UDim2.new(0, 0, 0, 34), UDim2.new(1, 0, 1, -34), 1, UDim2.new(0, 0, 0, 2000), 4, false, 7
    Instance.new("UIListLayout", scrollHasKey).Padding = UDim.new(0, 8)
    
    noKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible, scrollHasKey.Visible = true, false
        noKeyBtn.BackgroundTransparency, nkStroke.Color, nkStroke.Thickness = 0.3, Color3.fromRGB(255, 50, 50), 2
        hasKeyBtn.BackgroundTransparency, hkStroke.Color, hkStroke.Thickness = 0.7, Color3.fromRGB(255, 255, 255), 1
    end)
    hasKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible, scrollHasKey.Visible = false, true
        hasKeyBtn.BackgroundTransparency, hkStroke.Color, hkStroke.Thickness = 0.3, Color3.fromRGB(255, 50, 50), 2
        noKeyBtn.BackgroundTransparency, nkStroke.Color, nkStroke.Thickness = 0.7, Color3.fromRGB(255, 255, 255), 1
    end)
    return frame, scrollNoKey, scrollHasKey
end

local function CreateCustomContainer(visible)
    local frame = Instance.new("Frame", MainFrame) 
    frame.Position, frame.Size, frame.BackgroundTransparency, frame.Visible, frame.ZIndex, frame.ClipsDescendants = UDim2.new(0, 114, 0, 48), UDim2.new(1, -122, 1, -56), 1, visible, 6, true
    local scroll = Instance.new("ScrollingFrame", frame) 
    scroll.Position, scroll.Size, scroll.BackgroundTransparency, scroll.ScrollBarThickness, scroll.ZIndex, scroll.ClipsDescendants = UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), 1, 4, 7, true
    scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
    local scrollLayout = Instance.new("UIListLayout", scroll)
    scrollLayout.Padding = UDim.new(0, 8)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    return frame, scroll
end

local tabContainers, mainTabButtons = {}, {}
local tabNames = {"🌸STEAL AN EGG🌸", "🌸BLOX FRUIT🌸", "🌸BREAK AN STEAL AN EGG🌸", "Tab 4", "Tab 5", "👾KHÁC👾"}

for i = 1, 6 do
    local isFirst = (i == 1)
    if i == 6 then
        local frame, scroll = CreateCustomContainer(false)
        tabContainers[i] = {Container = frame, Scroll = scroll}
    else
        local container, noKeyScroll, hasKeyScroll = CreateCategoryContainer(isFirst)
        tabContainers[i] = {Container = container, NoKeyScroll = noKeyScroll, HasKeyScroll = hasKeyScroll}
    end
    
    local btn = Instance.new("TextButton", TabBarLeftScroll)
    btn.Size, btn.BackgroundColor3, btn.BackgroundTransparency, btn.Text, btn.Font, btn.TextSize, btn.TextWrapped, btn.ZIndex = UDim2.new(1, 0, 0, 38), Color3.fromRGB(0, 0, 0), isFirst and 0.3 or 0.7, tabNames[i], Enum.Font.SourceSansBold, 12, true, 7
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn) stroke.Color, stroke.Thickness = isFirst and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255), isFirst and 2 or 1
    ApplyBlackTextWhiteOutline(btn)
    mainTabButtons[i] = {Button = btn, Stroke = stroke}
    
    btn.MouseButton1Click:Connect(function()
        for j = 1, 6 do
            local active = (i == j)
            tabContainers[j].Container.Visible = active
            mainTabButtons[j].Button.BackgroundTransparency = active and 0.3 or 0.7
            mainTabButtons[j].Stroke.Color, mainTabButtons[j].Stroke.Thickness = active and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255), active and 2 or 1
        end
    end)
end

local function AddScriptButton(scrollParent, Name, Callback)
    local Btn = Instance.new("TextButton", scrollParent)
    Btn.Size, Btn.BackgroundColor3, Btn.BackgroundTransparency, Btn.Text, Btn.Font, Btn.TextSize, Btn.ZIndex = UDim2.new(1, 0, 0, 38), Color3.fromRGB(255, 255, 255), 0.25, Name, Enum.Font.SourceSansSemibold, 14, 8
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local BtnStroke = Instance.new("UIStroke", Btn) BtnStroke.Color, BtnStroke.Thickness = Color3.fromRGB(255, 255, 255), 1
    ApplyBlackTextWhiteOutline(Btn)
    
    Btn.MouseButton1Click:Connect(function()
        if LastSelectedScriptStroke then LastSelectedScriptStroke.Color, LastSelectedScriptStroke.Thickness = Color3.fromRGB(255, 255, 255), 1 end
        BtnStroke.Color, BtnStroke.Thickness = Color3.fromRGB(255, 50, 50), 2.5
        LastSelectedScriptBtn, LastSelectedScriptStroke = Btn, BtnStroke
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
AddScriptButton(tabContainers[3].HasKeyScroll, "1. Tên Script Có Key (Tab 3)", function() end)

-- TAB 4
AddScriptButton(tabContainers[4].NoKeyScroll, "1. Tên Script No Key (Tab 4)", function() end)
AddScriptButton(tabContainers[4].HasKeyScroll, "1. Tên Script Có Key (Tab 4)", function() end)

-- TAB 5
AddScriptButton(tabContainers[5].NoKeyScroll, "1. Tên Script No Key (Tab 5)", function() end)
AddScriptButton(tabContainers[5].HasKeyScroll, "1. Tên Script Có Key (Tab 5)", function() end)
local t6 = tabContainers[6].Scroll
t6.ClipsDescendants = true
local selScript, isAuto = nil, false

local dropBtn = Instance.new("TextButton", t6)
dropBtn.LayoutOrder = 1
dropBtn.Size, dropBtn.BackgroundColor3, dropBtn.Text, dropBtn.Font, dropBtn.TextSize, dropBtn.TextXAlignment, dropBtn.ZIndex = UDim2.new(1,0,0,34), Color3.fromRGB(240,240,240), " 📜 Chọn Script Auto Load...", Enum.Font.SourceSansSemibold, 13, Enum.TextXAlignment.Left, 10
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
local dropStroke = Instance.new("UIStroke", dropBtn) dropStroke.Color = Color3.fromRGB(200,200,200)
ApplyBlackTextWhiteOutline(dropBtn)

local dropFrame = Instance.new("ScrollingFrame", t6)
dropFrame.LayoutOrder = 2
dropFrame.Size, dropFrame.BackgroundColor3, dropFrame.CanvasSize, dropFrame.ScrollBarThickness, dropFrame.Visible, dropFrame.ZIndex = UDim2.new(1,0,0,90), Color3.fromRGB(250,250,250), UDim2.new(0,0,0,0), 3, false, 20
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIListLayout", dropFrame).Padding = UDim.new(0, 4)

local clearBtn = Instance.new("TextButton", t6)
clearBtn.LayoutOrder = 3
clearBtn.Size, clearBtn.BackgroundColor3, clearBtn.Text, clearBtn.Font, clearBtn.TextSize, clearBtn.ZIndex = UDim2.new(1,0,0,28), Color3.fromRGB(150,150,150), "🚫 Hủy chọn Script ❌", Enum.Font.SourceSansBold, 12, 8
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(clearBtn)

local toggleAuto = Instance.new("TextButton", t6)
toggleAuto.LayoutOrder = 4
toggleAuto.Size, toggleAuto.BackgroundColor3, toggleAuto.Text, toggleAuto.Font, toggleAuto.TextSize, toggleAuto.ZIndex = UDim2.new(1,0,0,32), Color3.fromRGB(200,50,50), "Auto Load Script Chạy: TẮT ❌", Enum.Font.SourceSansBold, 12, 8
Instance.new("UICorner", toggleAuto).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(toggleAuto)

local colorList = {
    {Name = "🌈 Màu Cầu Vồng (Gốc)", Color = nil},
    {Name = "🌸 Hồng Kẹo Đắng", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "🔴 Đỏ Đậm", Color = Color3.fromRGB(220, 20, 60)},
    {Name = "🔵 Xanh Dương Neon", Color = Color3.fromRGB(0, 191, 255)},
    {Name = "🟢 Xanh Lá Cây", Color = Color3.fromRGB(50, 205, 50)},
    {Name = "🟡 Vàng Nổi Bật", Color = Color3.fromRGB(255, 215, 0)},
    {Name = "🟣 Tím Mộng Mơ", Color = Color3.fromRGB(138, 43, 226)},
    {Name = "⬛ Xám Tối Elegant", Color = Color3.fromRGB(50, 50, 50)}
}
local selectedColorObj = colorList[1]
local isColorApplied = false

local colorDropBtn = Instance.new("TextButton", t6)
colorDropBtn.LayoutOrder = 5
colorDropBtn.Size, colorDropBtn.BackgroundColor3, colorDropBtn.Text, colorDropBtn.Font, colorDropBtn.TextSize, colorDropBtn.TextXAlignment, colorDropBtn.ZIndex = UDim2.new(1,0,0,34), Color3.fromRGB(240,240,240), " 🎨 Chọn Màu Menu...", Enum.Font.SourceSansSemibold, 13, Enum.TextXAlignment.Left, 10
Instance.new("UICorner", colorDropBtn).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(colorDropBtn)

local colorDropFrame = Instance.new("ScrollingFrame", t6)
colorDropFrame.LayoutOrder = 6
colorDropFrame.Size, colorDropFrame.BackgroundColor3, colorDropFrame.CanvasSize, colorDropFrame.ScrollBarThickness, colorDropFrame.Visible, colorDropFrame.ZIndex = UDim2.new(1,0,0,100), Color3.fromRGB(250,250,250), UDim2.new(0,0,0,0), 3, false, 20
Instance.new("UICorner", colorDropFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIListLayout", colorDropFrame).Padding = UDim.new(0, 4)

local toggleColorBtn = Instance.new("TextButton", t6)
toggleColorBtn.LayoutOrder = 7
toggleColorBtn.Size, toggleColorBtn.BackgroundColor3, toggleColorBtn.Text, toggleColorBtn.Font, toggleColorBtn.TextSize, toggleColorBtn.ZIndex = UDim2.new(1,0,0,32), Color3.fromRGB(200,50,50), "Màu Menu Tùy Chỉnh: TẮT ❌", Enum.Font.SourceSansBold, 12, 8
Instance.new("UICorner", toggleColorBtn).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(toggleColorBtn)

local isFpsModeOn = false
local toggleFpsBtn = Instance.new("TextButton", t6)
toggleFpsBtn.LayoutOrder = 8
toggleFpsBtn.Size, toggleFpsBtn.BackgroundColor3, toggleFpsBtn.Text, toggleFpsBtn.Font, toggleFpsBtn.TextSize, toggleFpsBtn.ZIndex = UDim2.new(1,0,0,32), Color3.fromRGB(200,50,50), "Màn Hình Đen Giảm FPS: TẮT ❌", Enum.Font.SourceSansBold, 12, 8
Instance.new("UICorner", toggleFpsBtn).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(toggleFpsBtn)

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
local currentSoundId = presetMusics[1].Id

local customIdBox = Instance.new("TextBox", t6)
customIdBox.LayoutOrder = 9
customIdBox.Size, customIdBox.BackgroundColor3, customIdBox.PlaceholderText, customIdBox.Text, customIdBox.Font, customIdBox.TextSize, customIdBox.ZIndex = UDim2.new(1,0,0,30), Color3.fromRGB(240,240,240), "Nhập Sound ID tùy chỉnh...", "", Enum.Font.SourceSansSemibold, 12, 8
Instance.new("UICorner", customIdBox).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(customIdBox)

local musicDropBtn = Instance.new("TextButton", t6)
musicDropBtn.LayoutOrder = 10
musicDropBtn.Size, musicDropBtn.BackgroundColor3, musicDropBtn.Text, musicDropBtn.Font, musicDropBtn.TextSize, musicDropBtn.TextXAlignment, musicDropBtn.ZIndex = UDim2.new(1,0,0,34), Color3.fromRGB(240,240,240), " 🎵 Chọn Nhạc Nền...", Enum.Font.SourceSansSemibold, 13, Enum.TextXAlignment.Left, 10
Instance.new("UICorner", musicDropBtn).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(musicDropBtn)

local musicDropFrame = Instance.new("ScrollingFrame", t6)
musicDropFrame.LayoutOrder = 11
musicDropFrame.Size, musicDropFrame.BackgroundColor3, musicDropFrame.CanvasSize, musicDropFrame.ScrollBarThickness, musicDropFrame.Visible, musicDropFrame.ZIndex = UDim2.new(1,0,0,130), Color3.fromRGB(250,250,250), UDim2.new(0,0,0,0), 3, false, 20
Instance.new("UICorner", musicDropFrame).CornerRadius = UDim.new(0, 6)
local musicLayout = Instance.new("UIListLayout", musicDropFrame)
musicLayout.Padding = UDim.new(0, 4)
musicLayout.SortOrder = Enum.SortOrder.LayoutOrder

local volumeContainer = Instance.new("Frame", t6)
volumeContainer.LayoutOrder = 12
volumeContainer.Size, volumeContainer.BackgroundColor3, volumeContainer.BackgroundTransparency, volumeContainer.ZIndex = UDim2.new(1, 0, 0, 32), Color3.fromRGB(240, 240, 240), 0, 8
Instance.new("UICorner", volumeContainer).CornerRadius = UDim.new(0, 6)

local volLabel = Instance.new("TextLabel", volumeContainer)
volLabel.Size, volLabel.Position, volLabel.BackgroundTransparency, volLabel.Text, volLabel.Font, volLabel.TextSize, volLabel.TextXAlignment, volLabel.ZIndex = UDim2.new(0, 130, 1, 0), UDim2.new(0, 10, 0, 0), 1, "🔊 Âm lượng: 50%", Enum.Font.SourceSansSemibold, 12, Enum.TextXAlignment.Left, 9
ApplyBlackTextWhiteOutline(volLabel)

local sliderBar = Instance.new("Frame", volumeContainer)
sliderBar.Size, sliderBar.Position, sliderBar.BackgroundColor3, sliderBar.ZIndex = UDim2.new(1, -150, 0, 8), UDim2.new(0, 135, 0.5, -4), Color3.fromRGB(200, 200, 200), 9
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame", sliderBar)
sliderFill.Size, sliderFill.BackgroundColor3, sliderFill.ZIndex = UDim2.new(0.5, 0, 1, 0), Color3.fromRGB(50, 200, 50), 10
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local sliding = false
local function updateVolume(input)
    local pos = input.Position.X
    local absPos = sliderBar.AbsolutePosition.X
    local absSize = sliderBar.AbsoluteSize.X
    if absSize > 0 then
        local val = math.clamp((pos - absPos) / absSize, 0, 1)
        sliderFill.Size = UDim2.new(val, 0, 1, 0)
        local percent = math.floor(val * 100)
        volLabel.Text = "🔊 Âm lượng: " .. percent .. "%"
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
toggleMusicBtn.LayoutOrder = 13
toggleMusicBtn.Size, toggleMusicBtn.BackgroundColor3, toggleMusicBtn.Text, toggleMusicBtn.Font, toggleMusicBtn.TextSize, toggleMusicBtn.ZIndex = UDim2.new(1,0,0,32), Color3.fromRGB(200,50,50), "Phát Nhạc Background: TẮT ❌", Enum.Font.SourceSansBold, 12, 8
Instance.new("UICorner", toggleMusicBtn).CornerRadius = UDim.new(0, 6)
ApplyBlackTextWhiteOutline(toggleMusicBtn)

dropBtn.MouseButton1Click:Connect(function() 
    dropFrame.Visible = not dropFrame.Visible 
    colorDropFrame.Visible = false
    musicDropFrame.Visible = false
end)

local h = 0
for _, scr in ipairs(RegisteredScripts) do
    local item = Instance.new("TextButton", dropFrame)
    item.Size, item.BackgroundColor3, item.Text, item.Font, item.TextSize, item.TextXAlignment, item.ZIndex = UDim2.new(1,0,0,28), Color3.fromRGB(255,255,255), "  ▶ " .. scr.Name, Enum.Font.SourceSansSemibold, 12, Enum.TextXAlignment.Left, 21
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 4)
    ApplyBlackTextWhiteOutline(item)
    item.MouseButton1Click:Connect(function()
        selScript = scr
        dropBtn.Text = " 📜 Đã chọn: " .. scr.Name
        dropFrame.Visible = false
        dropStroke.Color = Color3.fromRGB(255,50,50)
    end)
    h = h + 32
end
dropFrame.CanvasSize = UDim2.new(0,0,0,h)

clearBtn.MouseButton1Click:Connect(function()
    selScript = nil
    dropBtn.Text = " 📜 Chọn Script Auto Load..."
    dropStroke.Color = Color3.fromRGB(200,200,200)
    if isAuto then
        isAuto = false
        toggleAuto.BackgroundColor3 = Color3.fromRGB(200,50,50)
        toggleAuto.Text = "Auto Load Script Chạy: TẮT ❌"
    end
end)

toggleAuto.MouseButton1Click:Connect(function()
    if not selScript then dropBtn.Text = " ⚠️ Bạn chưa chọn script!" return end
    isAuto = not isAuto
    if isAuto then
        toggleAuto.BackgroundColor3 = Color3.fromRGB(50,200,50)
        toggleAuto.Text = "Auto Load Script Chạy: BẬT ✅"
        pcall(selScript.Callback)
    else
        toggleAuto.BackgroundColor3 = Color3.fromRGB(200,50,50)
        toggleAuto.Text = "Auto Load Script Chạy: TẮT ❌"
    end
end)

colorDropBtn.MouseButton1Click:Connect(function() 
    colorDropFrame.Visible = not colorDropFrame.Visible 
    dropFrame.Visible = false
    musicDropFrame.Visible = false
end)

local ch = 0
for _, cItem in ipairs(colorList) do
    local cBtn = Instance.new("TextButton", colorDropFrame)
    cBtn.Size, cBtn.BackgroundColor3, cBtn.Text, cBtn.Font, cBtn.TextSize, cBtn.TextXAlignment, cBtn.ZIndex = UDim2.new(1,0,0,26), Color3.fromRGB(255,255,255), " " .. cItem.Name, Enum.Font.SourceSansSemibold, 12, Enum.TextXAlignment.Left, 21
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    ApplyBlackTextWhiteOutline(cBtn)
    cBtn.MouseButton1Click:Connect(function()
        selectedColorObj = cItem
        colorDropBtn.Text = " 🎨 Đã chọn: " .. cItem.Name
        colorDropFrame.Visible = false
    end)
    ch = ch + 30
end
colorDropFrame.CanvasSize = UDim2.new(0,0,0,ch)

toggleColorBtn.MouseButton1Click:Connect(function()
    isColorApplied = not isColorApplied
    if isColorApplied then
        toggleColorBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
        toggleColorBtn.Text = "Màu Menu Tùy Chỉnh: BẬT ✅"
        if selectedColorObj.Color then
            RainbowGradient.Enabled = false
            MainFrame.BackgroundColor3 = selectedColorObj.Color
        else
            RainbowGradient.Enabled = true
            MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    else
        toggleColorBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        toggleColorBtn.Text = "Màu Menu Tùy Chỉnh: TẮT ❌"
        RainbowGradient.Enabled = true
        MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

toggleFpsBtn.MouseButton1Click:Connect(function()
    isFpsModeOn = not isFpsModeOn
    if isFpsModeOn then
        toggleFpsBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
        toggleFpsBtn.Text = "Màn Hình Đen Giảm FPS: BẬT ✅"
        BlackScreenGui.Enabled = true
    else
        toggleFpsBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        toggleFpsBtn.Text = "Màn Hình Đen Giảm FPS: TẮT ❌"
        BlackScreenGui.Enabled = false
    end
end)

musicDropBtn.MouseButton1Click:Connect(function() 
    musicDropFrame.Visible = not musicDropFrame.Visible 
    dropFrame.Visible = false
    colorDropFrame.Visible = false
end)

local mh = 0
for i, mItem in ipairs(presetMusics) do
    local mBtn = Instance.new("TextButton", musicDropFrame)
    mBtn.LayoutOrder = i
    mBtn.Size, mBtn.BackgroundColor3, mBtn.Text, mBtn.Font, mBtn.TextSize, mBtn.TextXAlignment, mBtn.ZIndex = UDim2.new(1,0,0,26), Color3.fromRGB(255,255,255), " " .. mItem.Name, Enum.Font.SourceSansSemibold, 12, Enum.TextXAlignment.Left, 21
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 4)
    ApplyBlackTextWhiteOutline(mBtn)
    mBtn.MouseButton1Click:Connect(function(id)
        currentSoundId = mItem.Id
        musicDropBtn.Text = " 🎵 Đã chọn: " .. mItem.Name
        musicDropFrame.Visible = false
        if HubSound.IsPlaying then
            HubSound.SoundId = "rbxassetid://" .. currentSoundId
            HubSound:Play()
        end
    end)
    mh = mh + 30
end
musicDropFrame.CanvasSize = UDim2.new(0,0,0,mh)

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

toggleMusicBtn.MouseButton1Click:Connect(function()
    isMusicPlaying = not isMusicPlaying
    if isMusicPlaying then
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
        toggleMusicBtn.Text = "Phát Nhạc Background: BẬT ✅"
        HubSound.SoundId = "rbxassetid://" .. currentSoundId
        HubSound:Play()
    else
        toggleMusicBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        toggleMusicBtn.Text = "Phát Nhạc Background: TẮT ❌"
        HubSound:Stop()
    end
end)

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
