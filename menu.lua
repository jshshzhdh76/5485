-- 纯 UI 设置菜单（无任何作弊功能）
local UIS = game:GetService("UserInputService")
local P = game.Players.LocalPlayer
local PG = P:WaitForChild("PlayerGui")

if PG:FindFirstChild("SettingsMenu") then PG.SettingsMenu:Destroy() end

local sg = Instance.new("ScreenGui", PG)
sg.Name = "SettingsMenu"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local panel = Instance.new("Frame", sg)
panel.Size = UDim2.fromOffset(420, 280)
panel.Position = UDim2.new(0, 40, 0, 90)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
panel.BorderSizePixel = 0
panel.Active = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

local tb = Instance.new("Frame", panel)
tb.Size = UDim2.new(1, 0, 0, 34)
tb.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
tb.BorderSizePixel = 0
Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 10)

local tl = Instance.new("TextLabel", tb)
tl.Size = UDim2.new(1, -80, 1, 0)
tl.Position = UDim2.new(0, 14, 0, 0)
tl.BackgroundTransparency = 1
tl.Text = "设置菜单"
tl.TextColor3 = Color3.new(1, 1, 1)
tl.Font = Enum.Font.GothamBold
tl.TextSize = 15
tl.TextXAlignment = Enum.TextXAlignment.Left

local cb = Instance.new("TextButton", tb)
cb.Size = UDim2.fromOffset(26, 26)
cb.Position = UDim2.new(1, -34, 0, 4)
cb.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
cb.BorderSizePixel = 0
cb.Text = "✕"
cb.TextColor3 = Color3.new(1, 1, 1)
cb.Font = Enum.Font.GothamBold
cb.TextSize = 14
Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 6)
cb.MouseButton1Click:Connect(function() sg:Destroy() end)

local lb = Instance.new("Frame", panel)
lb.Size = UDim2.new(0, 110, 1, -34)
lb.Position = UDim2.new(0, 0, 0, 34)
lb.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
lb.BorderSizePixel = 0
Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 10)
local ll = Instance.new("UIListLayout", lb)
ll.Padding = UDim.new(0, 6)
local lp = Instance.new("UIPadding", lb)
lp.PaddingTop = UDim.new(0, 10)
lp.PaddingLeft = UDim.new(0, 8)
lp.PaddingRight = UDim.new(0, 8)

local rc = Instance.new("Frame", panel)
rc.Size = UDim2.new(1, -110, 1, -34)
rc.Position = UDim2.new(0, 110, 0, 34)
rc.BackgroundTransparency = 1
rc.ClipsDescendants = true
local sc = Instance.new("ScrollingFrame", rc)
sc.Size = UDim2.new(1, 0, 1, 0)
sc.BackgroundTransparency = 1
sc.BorderSizePixel = 0
sc.ScrollBarThickness = 5
sc.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
sc.CanvasSize = UDim2.new(0, 0, 0, 0)
local sl = Instance.new("UIListLayout", sc)
sl.Padding = UDim.new(0, 8)
local sp = Instance.new("UIPadding", sc)
sp.PaddingTop = UDim.new(0, 10)
sp.PaddingLeft = UDim.new(0, 10)
sp.PaddingRight = UDim.new(0, 14)
sp.PaddingBottom = UDim.new(0, 10)

local function slider(par, txt, mn, mx, dv, cb2)
    local f = Instance.new("Frame", par)
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -16, 0, 18)
    l.Position = UDim2.new(0, 10, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = txt .. ": " .. dv
    l.TextColor3 = Color3.fromRGB(230, 230, 230)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    local b = Instance.new("Frame", f)
    b.Size = UDim2.new(1, -20, 0, 6)
    b.Position = UDim2.new(0, 10, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local fl = Instance.new("Frame", b)
    fl.Size = UDim2.new((dv - mn) / (mx - mn), 0, 1, 0)
    fl.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fl.BorderSizePixel = 0
    Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
    local k = Instance.new("Frame", b)
    k.Size = UDim2.fromOffset(12, 12)
    k.AnchorPoint = Vector2.new(0.5, 0.5)
    k.Position = UDim2.new(fl.Size.X.Scale, 0, 0.5, 0)
    k.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)
    local dg = false
    local function set(x)
        local r = math.clamp((x - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
        local v = math.floor(mn + (mx - mn) * r + 0.5)
        l.Text = txt .. ": " .. v
        fl.Size = UDim2.new(r, 0, 1, 0)
        k.Position = UDim2.new(r, 0, 0.5, 0)
        cb2(v)
    end
    b.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = true; set(i.Position.X) end end)
    k.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = true end end)
    UIS.InputChanged:Connect(function(i) if dg and i.UserInputType == Enum.UserInputType.MouseMovement then set(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end end)
end

local function toggle(par, txt, dv, cb2)
    local b = Instance.new("TextButton", par)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = dv and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    b.BorderSizePixel = 0
    b.Text = txt .. ": " .. (dv and "开" or "关")
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local s = dv
    b.MouseButton1Click:Connect(function()
        s = not s
        b.Text = txt .. ": " .. (s and "开" or "关")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
        cb2(s)
    end)
end

local pg = Instance.new("Frame", sc)
pg.Size = UDim2.new(1, 0, 0, 0)
pg.AutomaticSize = Enum.AutomaticSize.Y
pg.BackgroundTransparency = 1
local pl = Instance.new("UIListLayout", pg)
pl.Padding = UDim.new(0, 8)

toggle(pg, "音效", true, function(v) print("音效:", v) end)
slider(pg, "音量", 0, 100, 50, function(v) print("音量:", v) end)
slider(pg, "视野", 60, 120, 90, function(v) print("视野:", v) end)

local cat = Instance.new("TextButton", lb)
cat.Size = UDim2.new(1, 0, 0, 32)
cat.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
cat.BorderSizePixel = 0
cat.Text = "通用"
cat.TextColor3 = Color3.fromRGB(220, 220, 220)
cat.Font = Enum.Font.Gotham
cat.TextSize = 13
Instance.new("UICorner", cat).CornerRadius = UDim.new(0, 6)

local dg = false
local ds, sp2
tb.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dg = true
        ds = i.Position
        sp2 = panel.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dg and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        panel.Position = UDim2.new(sp2.X.Scale, sp2.X.Offset + d.X, sp2.Y.Scale, sp2.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end
end)

print("设置菜单已加载")
