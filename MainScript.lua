-- Animation GUI（優先順位ドロップダウン付き / KRNL対応 / 最小化&削除ボタン / 修正版）

-- GUIの親をCoreGuiに設定
local CoreGui = game:GetService("CoreGui")
local guiName = "AnimationGUI"

-- 再実行時は削除
local old = CoreGui:FindFirstChild(guiName)
if old then old:Destroy() end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getCharacter()
	local char = player.Character
	if not char or not char:FindFirstChild("Humanoid") then
		player.CharacterAdded:Wait()
		char = player.Character
	end
	return char
end

local character = getCharacter()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

-- GUI作成
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(1, -260, 0, 10)
frame.AnchorPoint = Vector2.new(1, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- タイトル
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Animation GUI"
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left

-- 最小化ボタン
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -55, 0, 2)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextScaled = true
local miniCorner = Instance.new("UICorner", minimizeButton)
miniCorner.CornerRadius = UDim.new(0, 4)

-- 削除ボタン
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -28, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 4)

-- TextBox
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 35)
input.PlaceholderText = "アニメーションID"
input.Text = ""
input.TextScaled = true
input.Font = Enum.Font.SourceSans
input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
input.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

-- 優先順位ドロップダウン
local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 25)
dropdown.Position = UDim2.new(0, 10, 0, 70)
dropdown.Text = "優先順位: Action4"
dropdown.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
dropdown.TextColor3 = Color3.new(0, 0, 0)
dropdown.TextScaled = true
dropdown.Font = Enum.Font.SourceSans
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local priorityOrder = {
	"Core", "Idle", "Movement", "Action", "Action2", "Action3", "Action4"
}
local currentPriority = Enum.AnimationPriority.Action4
local priorityMap = {
	Core = Enum.AnimationPriority.Core,
	Idle = Enum.AnimationPriority.Idle,
	Movement = Enum.AnimationPriority.Movement,
	Action = Enum.AnimationPriority.Action,
	Action2 = Enum.AnimationPriority.Action2,
	Action3 = Enum.AnimationPriority.Action3,
	Action4 = Enum.AnimationPriority.Action4
}

local dropdownFrame = Instance.new("Frame", frame)
dropdownFrame.Size = UDim2.new(0, 100, 0, 25 * #priorityOrder)
dropdownFrame.Position = UDim2.new(0, 10 + dropdown.AbsoluteSize.X + 10, 0, 70)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
dropdownFrame.Visible = false
dropdownFrame.ClipsDescendants = true
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 6)

for i, name in ipairs(priorityOrder) do
	local option = Instance.new("TextButton", dropdownFrame)
	option.Size = UDim2.new(1, 0, 0, 25)
	option.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
	option.Text = name
	option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	option.TextColor3 = Color3.new(0, 0, 0)
	option.TextScaled = true
	option.Font = Enum.Font.SourceSans
	option.MouseButton1Click:Connect(function()
		currentPriority = priorityMap[name]
		dropdown.Text = "優先順位: " .. name
		dropdownFrame.Visible = false
	end)
end

dropdown.MouseButton1Click:Connect(function()
	dropdownFrame.Position = UDim2.new(0, dropdown.AbsolutePosition.X - frame.AbsolutePosition.X + dropdown.AbsoluteSize.X + 10, 0, 70)
	dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- 再生ボタン
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 100, 0, 30)
button.Position = UDim2.new(0.5, -50, 1, -35)
button.Text = "再生"
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

local playingAnim

button.MouseButton1Click:Connect(function()
	local id = tonumber(input.Text)
	if not id then
		warn("無効なIDが入力されました")
		return
	end

	if playingAnim then
		playingAnim:Stop()
		playingAnim = nil
		button.Text = "再生"
	else
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. id
		local success, animationTrack = pcall(function()
			return animator:LoadAnimation(anim)
		end)
		if success and animationTrack then
			animationTrack.Priority = currentPriority
			playingAnim = animationTrack
			playingAnim:Play()
			button.Text = "停止"
		else
			warn("アニメーションの読み込みに失敗しました")
		end
	end
end)

-- ボタンアニメーション
button.MouseButton1Down:Connect(function()
	button:TweenSize(UDim2.new(0, 90, 0, 27), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
end)
button.MouseButton1Up:Connect(function()
	button:TweenSize(UDim2.new(0, 100, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
end)

-- 最小化処理
local TweenService = game:GetService("TweenService")
local isMinimized = false
local originalSize = frame.Size

minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	minimizeButton.Text = isMinimized and "+" or "-"

	local targetSize = isMinimized and UDim2.new(0, 250, 0, 35) or originalSize
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = targetSize }):Play()

	input.Visible = not isMinimized
	dropdown.Visible = not isMinimized
	dropdownFrame.Visible = false
	button.Visible = not isMinimized
end)

-- 削除処理
closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- キャラクターがリスポーンしたときの処理
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	humanoid = char:FindFirstChild("Humanoid")
	animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

	-- アニメーション再生中なら停止
	if playingAnim then
		playingAnim:Stop()
		playingAnim = nil
		button.Text = "再生"
	end
end)
