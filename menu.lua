

本地保存速度 = 50

本地函数 GUI（）
本地玩家 = 游戏：GetService（“玩家”）
local RunService = game：GetService（“RunService”）
local UserInputService = game：GetService（“UserInputService”）
本地玩家 = Players.LocalPlayer
局部特征 = 玩家。角色还是玩家。角色新增：等待（）
本地类人生物 = 角色：WaitForChild（“类人生物”）
本地HRP = character：WaitForChild（“HumanoidRootPart”）
本地摄像头=工作空间。CurrentCamera

本地BaseSpeed = savedSpeed
本地飞行速度 = 基速
本地飞行 = 假
局部前置保持 = 0
局部输入Flags = { forward = false，back = false，left = false，right = false，up = false，down = false }

local bodyVelocity = Instance.new（“BodyVelocity”）
bodyVelocity.MaxForce = Vector3.new（1e5， 1e5， 1e5）

local bodyGyro = Instance.new（“BodyGyro”）
bodyGyro.MaxTorque = Vector3.new（1e5， 1e5， 1e5）

本地 screenGui = Instance.new（“ScreenGui”）
screenGui.Name = “FlyScreenGui”
screenGui.ResetOnSpawn = false
screenGui.Parent = player：WaitForChild（“PlayerGui”）

local toggleButton = Instance.new（“TextButton”）
toggleButton.Name = “切换飞按钮”
toggleButton.Text = “飞离”
toggleButton.Size = UDim2.new（0， 100， 0， 50）
toggleButton.Position = UDim2.new（1， -220， 0， 10）
toggleButton.BackgroundColor3 = Color3.fromRGB（40， 40， 40）
toggleButton.TextColor3 = Color3.fromRGB（255， 255， 255）
toggleButton.Font = Enum.Font.GothamBold（粗体）
toggleButton.TextScaled = true
toggleButton.BackgroundTransparency = 0.2
toggleButton.Parent = screenGui

本地速度盒 = 实例.new（“TextBox”）
speedBox.Name = “SpeedBox”
speedBox.Text = tostring（baseSpeed）
speedBox.Size = UDim2.new（0， 100， 0， 50）
speedBox.Position = UDim2.new（1， -110， 0， 10）
speedBox.BackgroundColor3 = Color3.fromRGB（40， 40， 40）
speedBox.TextColor3 = Color3.fromRGB（255， 255， 255）
speedBox.Font = Enum.Font.GothamBold。
speedBox.TextScaled = true
speedBox.BackgroundTransparency = 0.2
speedBox.Parent = screenGui

本地函数 newAnim（id）
本地动画 = Instance.new（“动画”）
anim。AnimationId = “rbxassetid://” ..身份证
回归动画
结束

局部动画 = {
forward = newAnim（90872539），
up = newAnim（90872539），
right1 = newAnim（136801964），
right2 = newAnim（142495255），
left1 = newAnim（136801964），
left2 = newAnim（142495255），
flyLow1 = newAnim（97169019），
flyLow2 = newAnim（282574440），
flyFast = newAnim（282574440），
back1 = newAnim（136801964），
back2 = newAnim（106772613），
back3 = newAnim（42070810），
back4 = newAnim（214744412），
down = newAnim（233322916），
idle1 = newAnim（97171309）
    }

本地轨道 = {}
名字是 Anim in pairs（animations）
tracks[name] = humanoid：LoadAnimation（anim）
结束

局部函数 stopAll（）
对于_，轨道成对（tracks） do
轨道：停止（）
结束
结束

本地函数 startFlying（）
飞行 = 真
前进保持 = 0
飞速 = 基速
bodyVelocity。父节点 = HRP
bodyGyro。父 = HRP
类人生物。PlatformStand = 真
结束

本地函数 stopFlying（）
飞行 = 假
身体速度。父 = 零
bodyGyro.Parent = 零
类人生物。PlatformStand = false
stopAll（）
结束

toggleButton.MouseButton1Click：Connect（function（）
如果在飞行，则
停止飞行（）
toggleButton.Text = “飞离”
否则
startFlying（）
toggleButton.Text = “Fly ON”
结束
结束）

speedBox.FocusLost：Connect（function（）
local num = tonumber（speedBox.Text）
如果 NUM 和 NUM > 0，则
baseSpeed = 数值
savedSpeed = num
如果正在飞行，则飞速 = 基速 结束
否则
speedBox.Text = tostring（baseSpeed）
结束
结束）

UserInputService.InputBegan：Connect（function（input， gameProcessed）
如果gameProcessed，则返回结束
如果输入。KeyCode == Enum.KeyCode.W 然后 inputFlags.forward = true end
如果输入。KeyCode == Enum.KeyCode.S 然后 inputFlags.back = true end
如果输入。KeyCode == Enum.KeyCode.A 然后 inputFlags.left = true end
如果输入。KeyCode == Enum.KeyCode.D 然后 inputFlags.right = true end
如果输入。KeyCode == Enum.KeyCode.E then inputFlags.up = true end
如果输入。KeyCode == Enum.KeyCode.Q 然后 inputFlags.down = true end
结束）

UserInputService.InputEnded：Connect（function（input）
如果输入。KeyCode == Enum.KeyCode.W 然后 inputFlags.forward = false end
如果输入。KeyCode == Enum.KeyCode.S 然后 inputFlags.back = false end
如果输入。KeyCode == Enum.KeyCode.A 然后 inputFlags.left = false end
如果输入。KeyCode == Enum.KeyCode.D 然后 inputFlags.right = false end
如果输入。KeyCode == Enum.KeyCode.E 然后 inputFlags.up = false end
如果输入。KeyCode == Enum.KeyCode.Q 然后 inputFlags.down = false end
结束）

RunService.RenderStepped：Connect（function（dt）
如果不能飞行，就返回 结束

如果不是 inputFlags.forward，则 forwardHold = 0，结束

局部dir = 向量3.0
本地摄像头CF = 摄像头。CFrame

如果 inputFlags.forward 则 dir += camCF.LookVector 结束
if inputFlags.back then dir -= camCF.LookVector 结束
如果 inputFlags.left 则 dir -= camCF.RightVector 结束
如果inputFlags.right，则dir += camCF.RightVector结束
如果 inputFlags.up 则 dir += Vector3.yAxis 结束
如果 inputFlags.down 则 dir -= 向量3.y轴结束

如果星级>0，则dir = dir。单位终结

身体速度。速度 = dir * 飞速
bodyGyro.CFrame = camCF

—— 动画逻辑
如果inputFlags.up，则
如果不是tracks.up.IsPlaying，则stopAll（）;tracks.up：Play（） 结束
elseif inputFlags.down 则
如果不是tracks.down.IsPlaying，则stopAll（）;tracks.down：Play（） 结束
elseif inputFlags.left 则
如果不是tracks.left1.IsPlaying
stopAll（）
tracks.left1：Play（）;轨道左侧1.时间位置 = 2.0;tracks.left1：调整速度（0）
tracks.left2：Play（）;轨道左侧2.时间位置 = 0.5;tracks.left2：调整速度（0）
结束
elseif inputFlags.right 则
如果不是，轨迹。右1.正在播放，那么
stopAll（）
tracks.right1：Play（）;轨道右侧1.时间位置 = 1.1;tracks.right1：调整速度（0）
tracks.right2：Play（）;轨道.右2.时间位置 = 0.5;tracks.right2：调整速度（0）
结束
elseif inputFlags.当年
如果不是，则 tracks.back1.正在播放
stopAll（）
tracks.back1：Play（）;轨道。后退1.时间位置 = 5.3;tracks.back1：调整速度（0）
tracks.back2：Play（）;tracks.back2：调整速度（0）
tracks.back3：Play（）;tracks.back3.时间位置 = 0.8;tracks.back3：调整速度（0）
tracks.back4：Play（）;tracks.back4.TimePosition = 1;tracks.back4：调整速度（0）
结束
elseif inputFlags.forward 则
前进保持 += dt
如果 forward 保持 >= 3，则
如果不是tracks.flyFast.IsPlaying
stopAll（）
飞速 = 基速 * 1.3
tracks.flyFast：Play（）;tracks.flyFast：AdjustSpeed（0.05）
结束
否则
如果不是tracks.flyLow1.IsPlaying
stopAll（）
飞速 = 基速
tracks.flyLow1：Play（）
tracks.flyLow2：Play（）
结束
结束
否则
如果不是tracks.idle1.IsPlaying
stopAll（）
tracks.idle1：Play（）;tracks.idle1：调整速度（0）
结束
结束
结束）
结束

GUI（）
