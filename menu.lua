--=============================================================
--  Roblox Aimbot + ESP  |  横向 UI
--  左侧 = 功能大类，右侧 = 该类下的可调节项
--=============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

-- 兼容不同版本的射线过滤枚举
local RAY_EXCLUDE
pcall(function() RAY_EXCLUDE = Enum.RaycastFilterType.Exclude end)
if not RAY_EXCLUDE then RAY_EXCLUDE = Enum.RaycastFilterType.Blacklist end

--=============================================================
--  配置
--=============================================================
local Config = {
    Aimbot = {
        Enabled    = false,
        Smoothness = 0.50,                       -- 0 = 瞬间吸附, 1 = 最慢
        Range      = 500,                        -- 世界单位
        FOV        = 150,                        -- 屏幕像素半径
        FOVColor   = Color3.fromRGB(255,255,255),-- 默认白色
        TeamCheck  = true,
        WallCheck  = true,
    },
    ESP = {
        Enabled   = false,
        TeamCheck = true,
    },
}

--=============================================================
--  工具函数
--=============================================================
local function addCorner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = inst
    return c
end

local function addStroke(inst, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color        = color or Color3.fromRGB(50,50,58)
    s.Thickness    = thickness or 1
    s.Transparency = transparency or 0
    s.Parent       = inst
    return s
end

local function safeParent(gui)
    local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not ok or not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

--=============================================================
--  FOV 圆圈（独立 GUI，保证不被主窗口拖动影响）
--=============================================================
local fovGui = Instance.new("ScreenGui")
fovGui.Name         = "FovCircleGui"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParent(fovGui)

local fovCircle = Instance.new("Frame")
fovCircle.Name                = "FovCircle"
fovCircle.AnchorPoint         = Vector2.new(0.5, 0.5)   -- 关键：锚点居中
fovCircle.Position            = UDim2.new(0.5, 0, 0.5, 0) -- 关键：绝对屏幕中心
fovCircle.Size                = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
fovCircle.BackgroundTransparency = 1                     -- 空心
fovCircle.BorderSizePixel     = 0
fovCircle.Active              = false
fovCircle.Parent              = fovGui
addCorner(fovCircle, 9999) -- 圆角拉满 = 正圆

local fovStroke = Instance.new("UIStroke")
fovStroke.Color        = Config.Aimbot.FOVColor
fovStroke.Thickness    = 1.5
fovStroke.Transparency = 0.15
fovStroke.Parent       = fovCircle

local function updateFovCircle()
    fovCircle.Size    = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
    fovStroke.Color   = Config.Aimbot.FOVColor
    fovCircle.Visible = Config.Aimbot.Enabled
end
updateFovCircle()

--=============================================================
--  主窗口
--=============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name         = "CheatUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParent(screenGui)

local main = Instance.new("Frame")
main.Name             = "Main"
main.Size             = UDim2.new(0, 520, 0, 340)
main.Position         = UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel  = 0
main.Active           = true
main.Parent           = screenGui
addCorner(main, 10)
addStroke(main, Color3.fromRGB(45, 45, 54), 1, 0.2)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size                = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundTransparency = 1
titleBar.Parent              = titleBar.Parent or main

local titleText = Instance.new("TextLabel")
titleText.Size             = UDim2.new(1, -90, 1, 0)
titleText.Position         = UDim2.new(0, 16, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text             = "AIMBOT  •  ESP"
titleText.TextColor3       = Color3.fromRGB(235, 235, 242)
titleText.Font             = Enum.Font.GothamBold
titleText.TextSize         = 13
titleText.TextXAlignment   = Enum.TextXAlignment.Left
titleText.Parent           = titleBar

local function makeTitleBtn(text, offsetX, onClick)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0, 24, 0, 24)
    b.Position         = UDim2.new(1, offsetX, 0, 7)
    b.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    b.Text             = text
    b.TextColor3       = Color3.fromRGB(200, 200, 210)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 14
    b.AutoButtonColor  = false
    b.Parent           = titleBar
    addCorner(b, 6)
    b.MouseButton1Click:Connect(onClick)
    return b
end

local minBtn = makeTitleBtn("—", -66, function()
    main.Visible = false
    restoreBtn.Visible = true
end)

local closeBtn = makeTitleBtn("✕", -36, function()
    screenGui:Destroy()
    fovGui:Destroy()
end)

-- 最小化后的还原按钮
local restoreBtn = Instance.new("TextButton")
restoreBtn.Size             = UDim2.new(0, 130, 0, 32)
restoreBtn.Position         = UDim2.new(0, 20, 0, 20)
restoreBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
restoreBtn.Text             = "AIMBOT  •  ESP"
restoreBtn.TextColor3       = Color3.fromRGB(235, 235, 242)
restoreBtn.Font             = Enum.Font.GothamBold
restoreBtn.TextSize         = 12
restoreBtn.AutoButtonColor  = false
restoreBtn.Visible          = false
restoreBtn.Parent           = screenGui
addCorner(restoreBtn, 8)
addStroke(restoreBtn, Color3.fromRGB(45, 45, 54), 1, 0.2)

restoreBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    restoreBtn.Visible = false
end)

-- 窗口拖动
do
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- 主体：左导航 + 右内容
local body = Instance.new("Frame")
body.Size                = UDim2.new(1, -20, 1, -54)
body.Position            = UDim2.new(0, 10, 0, 46)
body.BackgroundTransparency = 1
body.Parent              = main

local sidebar = Instance.new("Frame")
sidebar.Size             = UDim2.new(0, 128, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(23, 23, 28)
sidebar.BorderSizePixel  = 0
sidebar.Parent           = body
addCorner(sidebar, 8)

local content = Instance.new("Frame")
content.Size                = UDim2.new(1, -140, 1, 0)
content.Position            = UDim2.new(0, 140, 0, 0)
content.BackgroundTransparency = 1
content.Parent              = body

--=============================================================
--  控件工厂：滑块 / 开关
--=============================================================
local function createSlider(parent, label, min, max, default, step, callback)
    local row = Instance.new("Frame")
    row.Size                = UDim2.new(1, 0, 0, 46)
    row.BackgroundTransparency = 1
    row.Parent              = parent

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size                = UDim2.new(0.65, 0, 0, 16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text                = label
    nameLabel.TextColor3          = Color3.fromRGB(200, 200, 212)
    nameLabel.Font                = Enum.Font.GothamMedium
    nameLabel.TextSize            = 12
    nameLabel.TextXAlignment      = Enum.TextXAlignment.Left
    nameLabel.Parent              = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size                = UDim2.new(0.35, 0, 0, 16)
    valueLabel.Position            = UDim2.new(0.65, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text                = tostring(default)
    valueLabel.TextColor3          = Color3.fromRGB(255, 255, 255)
    valueLabel.Font                = Enum.Font.GothamBold
    valueLabel.TextSize            = 12
    valueLabel.TextXAlignment      = Enum.TextXAlignment.Right
    valueLabel.Parent              = row

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, 0, 0, 6)
    track.Position         = UDim2.new(0, 0, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
    track.BorderSizePixel  = 0
    track.Parent           = row
    addCorner(track, 99)

    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel  = 0
    fill.Parent           = track
    addCorner(fill, 99)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 14, 0, 14)
  
