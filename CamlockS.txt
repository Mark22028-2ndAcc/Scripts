local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local defaultConfig = {
wallCheck = false,
friendCheck = false,
aliveCheck = false,
npcCheck = true,
healthCheck = false,
cooldownCheck = true,
fovCircle = false,
fovRadius = 50,
fovTransparency = 50,
espTarget = false,
espTargetName = false,
espHiddenPlayers = false,
espHiddenPlayersName = false,
lockMode = "Camlock",
lockStyle = "Legit",
aimPart = "Torso",
keybind = "L",
maxDistance = 10000
}
local config = {}
for k, v in pairs(defaultConfig) do
config[k] = v
end
local function saveConfig()
if writefile then
writefile("config.json", HttpService:JSONEncode(config))
end
end
local function loadConfig()
if isfile and readfile then
if isfile("config.json") then
local loaded = HttpService:JSONDecode(readfile("config.json"))
for k, v in pairs(loaded) do
config[k] = v
end
end
end
end
loadConfig()
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer.PlayerGui
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
local mainToggle = Instance.new("TextButton")
mainToggle.Parent = screenGui
mainToggle.Size = UDim2.new(0, 150, 0, 50)
mainToggle.Position = UDim2.new(0.5, -75, 0.9, -25)
mainToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainToggle.BorderSizePixel = 0
mainToggle.Text = ""
mainToggle.AutoButtonColor = false
local mainUICorner = Instance.new("UICorner")
mainUICorner.Parent = mainToggle
mainUICorner.CornerRadius = UDim.new(0, 18)
local mainUIGradient = Instance.new("UIGradient")
mainUIGradient.Parent = mainToggle
mainUIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
mainUIGradient.Rotation = 0
local mainToggleLabel = Instance.new("TextLabel")
mainToggleLabel.Parent = mainToggle
mainToggleLabel.Size = UDim2.new(1, 0, 1, 0)
mainToggleLabel.BackgroundTransparency = 1
mainToggleLabel.Text = config.lockMode .. ": Off"
mainToggleLabel.Font = Enum.Font.ArialBold
mainToggleLabel.TextSize = 20
mainToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
mainToggleLabel.TextStrokeTransparency = 0.5
local mainUIStroke = Instance.new("UIStroke")
mainUIStroke.Parent = mainToggle
mainUIStroke.Color = Color3.fromRGB(0, 0, 0)
mainUIStroke.Thickness = 1
mainUIStroke.Transparency = 0.2
local settingsButton = Instance.new("TextButton")
settingsButton.Parent = screenGui
settingsButton.Size = UDim2.new(0, 50, 0, 50)
settingsButton.Position = UDim2.new(0.5, 100, 0.9, -25)
settingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.BorderSizePixel = 0
settingsButton.Text = "⚙️"
settingsButton.Font = Enum.Font.SourceSans
settingsButton.TextSize = 30
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.AutoButtonColor = false
local settingsUICorner = Instance.new("UICorner")
settingsUICorner.Parent = settingsButton
settingsUICorner.CornerRadius = UDim.new(1, 0)
local settingsUIGradient = Instance.new("UIGradient")
settingsUIGradient.Parent = settingsButton
settingsUIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
settingsUIGradient.Rotation = 0
local settingsUIStroke = Instance.new("UIStroke")
settingsUIStroke.Parent = settingsButton
settingsUIStroke.Color = Color3.fromRGB(0, 0, 0)
settingsUIStroke.Thickness = 1
settingsUIStroke.Transparency = 0.2
local settingsFrame = Instance.new("Frame")
settingsFrame.Parent = screenGui
settingsFrame.Size = UDim2.new(0, 400, 0, 500)
settingsFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
settingsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
local settingsUIScale = Instance.new("UIScale")
settingsUIScale.Parent = settingsFrame
settingsUIScale.Scale = 1
local settingsFrameUICorner = Instance.new("UICorner")
settingsFrameUICorner.Parent = settingsFrame
settingsFrameUICorner.CornerRadius = UDim.new(0, 18)
local settingsFrameUIGradient = Instance.new("UIGradient")
settingsFrameUIGradient.Parent = settingsFrame
settingsFrameUIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
settingsFrameUIGradient.Rotation = 0
local settingsFrameUIStroke = Instance.new("UIStroke")
settingsFrameUIStroke.Parent = settingsFrame
settingsFrameUIStroke.Color = Color3.fromRGB(0, 0, 0)
settingsFrameUIStroke.Thickness = 1
settingsFrameUIStroke.Transparency = 0.2
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = settingsFrame
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
local fovCircle = Instance.new("Frame")
fovCircle.Parent = screenGui
fovCircle.Size = UDim2.new(0, config.fovRadius * 2, 0, config.fovRadius * 2)
fovCircle.Position = UDim2.new(0.5, -config.fovRadius, 0.5, -config.fovRadius)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BackgroundTransparency = config.fovTransparency / 100
fovCircle.BorderSizePixel = 0
fovCircle.Visible = config.fovCircle
local fovUICorner = Instance.new("UICorner")
fovUICorner.Parent = fovCircle
fovUICorner.CornerRadius = UDim.new(1, 0)
local fovUIStroke = Instance.new("UIStroke")
fovUIStroke.Parent = fovCircle
fovUIStroke.Color = Color3.fromRGB(0, 0, 0)
fovUIStroke.Thickness = 1
fovUIStroke.Transparency = 0.5
local isOn = false
local targetPlayer = nil
local targetChar = nil
local targetModel = nil
local lastLockTime = 0
local cooldownTime = 0.5
local lockConnection = nil
local espHiddenHighlights = {}
local espHiddenNames = {}
local targetHighlight = nil
local targetNameGui = nil
local function updateMainLabel()
mainToggleLabel.Text = config.lockMode .. ": " .. (isOn and "On" or "Off")
end
local function animateGradient(gradient)
local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tween = TweenService:Create(gradient, tweenInfo, {Rotation = gradient.Rotation + 180})
tween:Play()
end
local function animateButton(button)
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tween = TweenService:Create(button, tweenInfo, {Size = button.Size + UDim2.new(0, 5, 0, 5)})
tween:Play()
tween.Completed:Wait()
local tweenBack = TweenService:Create(button, tweenInfo, {Size = button.Size - UDim2.new(0, 5, 0, 5)})
tweenBack:Play()
end
local function findTarget()
local center = Camera.ViewportSize / 2
local bestDist = config.fovRadius
local bestTarget = nil
local potentialTargets = {}
for _, child in ipairs(Workspace:GetChildren()) do
if child:IsA("Model") then
local humanoid = child:FindFirstChildOfClass("Humanoid")
if humanoid then
local player = Players:GetPlayerFromCharacter(child)
if player or not config.npcCheck then
if config.aliveCheck and humanoid.Health <= 0 then
else
if config.healthCheck and humanoid.Health >= humanoid.MaxHealth then
else
table.insert(potentialTargets, {Model = child, Player = player, Humanoid = humanoid})
end
end
end
end
end
end
for _, t in ipairs(potentialTargets) do
local model = t.Model
local player = t.Player
local humanoid = t.Humanoid
local aimPartName = config.aimPart
if aimPartName == "Random" then
local parts = {"Head", "Torso", "HumanoidRootPart"}
aimPartName = parts[math.random(1, #parts)]
end
local aimPart = model:FindFirstChild(aimPartName) or model:FindFirstChild("HumanoidRootPart")
if aimPart then
local dist3D = (aimPart.Position - Camera.CFrame.Position).Magnitude
if dist3D <= config.maxDistance then
local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
if onScreen then
local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
if dist2D <= bestDist then
local skip = false
if player then
if config.friendCheck then
if LocalPlayer:IsFriendsWith(player.UserId) then
skip = true
end
end
end
if not skip then
if config.wallCheck then
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()}
local rayResult = Workspace:Raycast(Camera.CFrame.Position, (aimPart.Position - Camera.CFrame.Position).Unit * dist3D, rayParams)
if rayResult then
if not rayResult.Instance:IsDescendantOf(model) then
skip = true
end
end
end
if not skip then
bestDist = dist2D
bestTarget = t
end
end
end
end
end
end
end
end
if bestTarget then
targetPlayer = bestTarget.Player
targetModel = bestTarget.Model
targetChar = bestTarget.Model
if targetPlayer then
targetPlayer.CharacterAdded:Connect(function(newChar)
targetChar = newChar
end)
end
end
end
local function lockFunction()
if not isOn then
return
end
if not targetChar then
return
end
local aimPartName = config.aimPart
if aimPartName == "Random" then
local parts = {"Head", "Torso", "HumanoidRootPart"}
aimPartName = parts[math.random(1, #parts)]
end
local aimPart = targetChar:FindFirstChild(aimPartName) or targetChar:FindFirstChild("HumanoidRootPart")
if not aimPart then
return
end
local lookAt = CFrame.lookAt(Camera.CFrame.Position, aimPart.Position)
local alpha = 0
if config.lockStyle == "Legit" then
alpha = 0.1
elseif config.lockStyle = "Fast" then
alpha = 0.5
elseif config.lockStyle = "Rage" then
alpha = 1
end
if config.lockMode == "Camlock" then
Camera.CFrame = Camera.CFrame:Lerp(lookAt, alpha)
elseif config.lockMode == "Charlock" then
local char = LocalPlayer.Character
if char then
local hrp = char:FindFirstChild("HumanoidRootPart")
if hrp then
local charLookAt = CFrame.new(hrp.Position, aimPart.Position)
hrp.CFrame = hrp.CFrame:Lerp(charLookAt, alpha)
end
end
end
end
local function toggleLock()
isOn = not isOn
updateMainLabel()
animateGradient(mainUIGradient)
animateButton(mainToggle)
if isOn then
if config.cooldownCheck then
if os.clock() - lastLockTime < cooldownTime then
isOn = false
updateMainLabel()
return
end
end
lastLockTime = os.clock()
findTarget()
if lockConnection then
lockConnection:Disconnect()
end
lockConnection = RunService.RenderStepped:Connect(lockFunction)
if targetChar then
if config.espTarget then
targetHighlight = Instance.new("Highlight")
targetHighlight.Parent = targetChar
targetHighlight.FillTransparency = 0.5
targetHighlight.OutlineTransparency = 0
targetHighlight.FillColor = Color3.fromRGB(255, 0, 0)
targetHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
end
if config.espTargetName then
targetNameGui = Instance.new("BillboardGui")
targetNameGui.Parent = targetChar:FindFirstChild("Head")
targetNameGui.Size = UDim2.new(0, 200, 0, 50)
targetNameGui.StudsOffset = Vector3.new(0, 3, 0)
targetNameGui.AlwaysOnTop = true
local nameLabel = Instance.new("TextLabel")
nameLabel.Parent = targetNameGui
nameLabel.Size = UDim2.new(1, 0, 1, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = targetPlayer and targetPlayer.Name or "NPC"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 16
nameLabel.Font = Enum.Font.ArialBold
nameLabel.TextStrokeTransparency = 0.5
end
end
else
if lockConnection then
lockConnection:Disconnect()
lockConnection = nil
end
targetPlayer = nil
targetChar = nil
targetModel = nil
if targetHighlight then
targetHighlight:Destroy()
targetHighlight = nil
end
if targetNameGui then
targetNameGui:Destroy()
targetNameGui = nil
end
end
saveConfig()
end
mainToggle.MouseButton1Click:Connect(toggleLock)
UserInputService.InputBegan:Connect(function(input, gpe)
if gpe then
return
end
if input.KeyCode == Enum.KeyCode[config.keybind] then
toggleLock()
end
end)
settingsButton.MouseButton1Click:Connect(function()
settingsFrame.Visible = not settingsFrame.Visible
animateGradient(settingsUIGradient)
animateButton(settingsButton)
if settingsFrame.Visible then
settingsUIScale.Scale = 0.5
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tween = TweenService:Create(settingsUIScale, tweenInfo, {Scale = 1})
tween:Play()
else
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local tween = TweenService:Create(settingsUIScale, tweenInfo, {Scale = 0.5})
tween:Play()
tween.Completed:Connect(function()
settingsFrame.Visible = false
end)
end
end)
local mainDragging = false
local mainDragStart = Vector2.new(0, 0)
local mainStartPos = UDim2.new(0, 0, 0, 0)
mainToggle.MouseButton1Down:Connect(function()
mainDragging = true
mainDragStart = UserInputService:GetMouseLocation()
mainStartPos = mainToggle.Position
end)
UserInputService.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement and mainDragging then
local delta = UserInputService:GetMouseLocation() - mainDragStart
mainToggle.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
mainDragging = false
end
end)
local settingsBDragging = false
local settingsBDragStart = Vector2.new(0, 0)
local settingsBStartPos = UDim2.new(0, 0, 0, 0)
settingsButton.MouseButton1Down:Connect(function()
settingsBDragging = true
settingsBDragStart = UserInputService:GetMouseLocation()
settingsBStartPos = settingsButton.Position
end)
UserInputService.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement and settingsBDragging then
local delta = UserInputService:GetMouseLocation() - settingsBDragStart
settingsButton.Position = UDim2.new(settingsBStartPos.X.Scale, settingsBStartPos.X.Offset + delta.X, settingsBStartPos.Y.Scale, settingsBStartPos.Y.Offset + delta.Y)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
settingsBDragging = false
end
end)
local settingsDragging = false
local settingsDragStart = Vector2.new(0, 0)
local settingsStartPos = UDim2.new(0, 0, 0, 0)
settingsFrame.MouseButton1Down:Connect(function()
settingsDragging = true
settingsDragStart = UserInputService:GetMouseLocation()
settingsStartPos = settingsFrame.Position
end)
UserInputService.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement and settingsDragging then
local delta = UserInputService:GetMouseLocation() - settingsDragStart
settingsFrame.Position = UDim2.new(settingsStartPos.X.Scale, settingsStartPos.X.Offset + delta.X, settingsStartPos.Y.Scale, settingsStartPos.Y.Offset + delta.Y)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
settingsDragging = false
end
end)
local toggle1Frame = Instance.new("Frame")
toggle1Frame.Parent = scrollingFrame
toggle1Frame.Size = UDim2.new(1, 0, 0, 60)
toggle1Frame.BackgroundTransparency = 1
local toggle1Button = Instance.new("TextButton")
toggle1Button.Parent = toggle1Frame
toggle1Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle1Button.Position = UDim2.new(0, 10, 0, 0)
toggle1Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle1Button.BorderSizePixel = 0
toggle1Button.Text = "WallCheck: " .. (config.wallCheck and "On" or "Off")
toggle1Button.Font = Enum.Font.ArialBold
toggle1Button.TextSize = 16
toggle1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle1Button.AutoButtonColor = false
local toggle1UICorner = Instance.new("UICorner")
toggle1UICorner.Parent = toggle1Button
toggle1UICorner.CornerRadius = UDim.new(0, 18)
local toggle1UIGradient = Instance.new("UIGradient")
toggle1UIGradient.Parent = toggle1Button
toggle1UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle1UIGradient.Rotation = 0
local toggle1UIStroke = Instance.new("UIStroke")
toggle1UIStroke.Parent = toggle1Button
toggle1UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle1UIStroke.Thickness = 1
toggle1UIStroke.Transparency = 0.2
local toggle1Description = Instance.new("TextLabel")
toggle1Description.Parent = toggle1Frame
toggle1Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle1Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle1Description.BackgroundTransparency = 1
toggle1Description.Text = "Only targets players who are visible (ignores players behind walls)."
toggle1Description.TextWrapped = true
toggle1Description.Font = Enum.Font.Arial
toggle1Description.TextSize = 14
toggle1Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle1Description.TextXAlignment = Enum.TextXAlignment.Left
toggle1Button.MouseButton1Click:Connect(function()
config.wallCheck = not config.wallCheck
toggle1Button.Text = "WallCheck: " .. (config.wallCheck and "On" or "Off")
animateGradient(toggle1UIGradient)
animateButton(toggle1Button)
saveConfig()
end)
toggle1Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle1Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle1Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle1Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle2Frame = Instance.new("Frame")
toggle2Frame.Parent = scrollingFrame
toggle2Frame.Size = UDim2.new(1, 0, 0, 60)
toggle2Frame.BackgroundTransparency = 1
local toggle2Button = Instance.new("TextButton")
toggle2Button.Parent = toggle2Frame
toggle2Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle2Button.Position = UDim2.new(0, 10, 0, 0)
toggle2Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle2Button.BorderSizePixel = 0
toggle2Button.Text = "Friend Check: " .. (config.friendCheck and "On" or "Off")
toggle2Button.Font = Enum.Font.ArialBold
toggle2Button.TextSize = 16
toggle2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle2Button.AutoButtonColor = false
local toggle2UICorner = Instance.new("UICorner")
toggle2UICorner.Parent = toggle2Button
toggle2UICorner.CornerRadius = UDim.new(0, 18)
local toggle2UIGradient = Instance.new("UIGradient")
toggle2UIGradient.Parent = toggle2Button
toggle2UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle2UIGradient.Rotation = 0
local toggle2UIStroke = Instance.new("UIStroke")
toggle2UIStroke.Parent = toggle2Button
toggle2UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle2UIStroke.Thickness = 1
toggle2UIStroke.Transparency = 0.2
local toggle2Description = Instance.new("TextLabel")
toggle2Description.Parent = toggle2Frame
toggle2Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle2Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle2Description.BackgroundTransparency = 1
toggle2Description.Text = "Detects friends/connections in the game and ignores them."
toggle2Description.TextWrapped = true
toggle2Description.Font = Enum.Font.Arial
toggle2Description.TextSize = 14
toggle2Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle2Description.TextXAlignment = Enum.TextXAlignment.Left
toggle2Button.MouseButton1Click:Connect(function()
config.friendCheck = not config.friendCheck
toggle2Button.Text = "Friend Check: " .. (config.friendCheck and "On" or "Off")
animateGradient(toggle2UIGradient)
animateButton(toggle2Button)
saveConfig()
end)
toggle2Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle2Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle2Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle2Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle3Frame = Instance.new("Frame")
toggle3Frame.Parent = scrollingFrame
toggle3Frame.Size = UDim2.new(1, 0, 0, 60)
toggle3Frame.BackgroundTransparency = 1
local toggle3Button = Instance.new("TextButton")
toggle3Button.Parent = toggle3Frame
toggle3Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle3Button.Position = UDim2.new(0, 10, 0, 0)
toggle3Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle3Button.BorderSizePixel = 0
toggle3Button.Text = "AliveCheck: " .. (config.aliveCheck and "On" or "Off")
toggle3Button.Font = Enum.Font.ArialBold
toggle3Button.TextSize = 16
toggle3Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle3Button.AutoButtonColor = false
local toggle3UICorner = Instance.new("UICorner")
toggle3UICorner.Parent = toggle3Button
toggle3UICorner.CornerRadius = UDim.new(0, 18)
local toggle3UIGradient = Instance.new("UIGradient")
toggle3UIGradient.Parent = toggle3Button
toggle3UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle3UIGradient.Rotation = 0
local toggle3UIStroke = Instance.new("UIStroke")
toggle3UIStroke.Parent = toggle3Button
toggle3UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle3UIStroke.Thickness = 1
toggle3UIStroke.Transparency = 0.2
local toggle3Description = Instance.new("TextLabel")
toggle3Description.Parent = toggle3Frame
toggle3Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle3Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle3Description.BackgroundTransparency = 1
toggle3Description.Text = "Only targets living players."
toggle3Description.TextWrapped = true
toggle3Description.Font = Enum.Font.Arial
toggle3Description.TextSize = 14
toggle3Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle3Description.TextXAlignment = Enum.TextXAlignment.Left
toggle3Button.MouseButton1Click:Connect(function()
config.aliveCheck = not config.aliveCheck
toggle3Button.Text = "AliveCheck: " .. (config.aliveCheck and "On" or "Off")
animateGradient(toggle3UIGradient)
animateButton(toggle3Button)
saveConfig()
end)
toggle3Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle3Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle3Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle3Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle4Frame = Instance.new("Frame")
toggle4Frame.Parent = scrollingFrame
toggle4Frame.Size = UDim2.new(1, 0, 0, 60)
toggle4Frame.BackgroundTransparency = 1
local toggle4Button = Instance.new("TextButton")
toggle4Button.Parent = toggle4Frame
toggle4Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle4Button.Position = UDim2.new(0, 10, 0, 0)
toggle4Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle4Button.BorderSizePixel = 0
toggle4Button.Text = "NPCCheck: " .. (config.npcCheck and "On" or "Off")
toggle4Button.Font = Enum.Font.ArialBold
toggle4Button.TextSize = 16
toggle4Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle4Button.AutoButtonColor = false
local toggle4UICorner = Instance.new("UICorner")
toggle4UICorner.Parent = toggle4Button
toggle4UICorner.CornerRadius = UDim.new(0, 18)
local toggle4UIGradient = Instance.new("UIGradient")
toggle4UIGradient.Parent = toggle4Button
toggle4UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle4UIGradient.Rotation = 0
local toggle4UIStroke = Instance.new("UIStroke")
toggle4UIStroke.Parent = toggle4Button
toggle4UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle4UIStroke.Thickness = 1
toggle4UIStroke.Transparency = 0.2
local toggle4Description = Instance.new("TextLabel")
toggle4Description.Parent = toggle4Frame
toggle4Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle4Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle4Description.BackgroundTransparency = 1
toggle4Description.Text = "Ignores NPCs. If Off, NPCs can be camlocked."
toggle4Description.TextWrapped = true
toggle4Description.Font = Enum.Font.Arial
toggle4Description.TextSize = 14
toggle4Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle4Description.TextXAlignment = Enum.TextXAlignment.Left
toggle4Button.MouseButton1Click:Connect(function()
config.npcCheck = not config.npcCheck
toggle4Button.Text = "NPCCheck: " .. (config.npcCheck and "On" or "Off")
animateGradient(toggle4UIGradient)
animateButton(toggle4Button)
saveConfig()
end)
toggle4Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle4Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle4Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle4Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle5Frame = Instance.new("Frame")
toggle5Frame.Parent = scrollingFrame
toggle5Frame.Size = UDim2.new(1, 0, 0, 60)
toggle5Frame.BackgroundTransparency = 1
local toggle5Button = Instance.new("TextButton")
toggle5Button.Parent = toggle5Frame
toggle5Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle5Button.Position = UDim2.new(0, 10, 0, 0)
toggle5Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle5Button.BorderSizePixel = 0
toggle5Button.Text = "HealthCheck: " .. (config.healthCheck and "On" or "Off")
toggle5Button.Font = Enum.Font.ArialBold
toggle5Button.TextSize = 16
toggle5Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle5Button.AutoButtonColor = false
local toggle5UICorner = Instance.new("UICorner")
toggle5UICorner.Parent = toggle5Button
toggle5UICorner.CornerRadius = UDim.new(0, 18)
local toggle5UIGradient = Instance.new("UIGradient")
toggle5UIGradient.Parent = toggle5Button
toggle5UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle5UIGradient.Rotation = 0
local toggle5UIStroke = Instance.new("UIStroke")
toggle5UIStroke.Parent = toggle5Button
toggle5UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle5UIStroke.Thickness = 1
toggle5UIStroke.Transparency = 0.2
local toggle5Description = Instance.new("TextLabel")
toggle5Description.Parent = toggle5Frame
toggle5Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle5Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle5Description.BackgroundTransparency = 1
toggle5Description.Text = "Only targets players with low HP; ignores players with full HP."
toggle5Description.TextWrapped = true
toggle5Description.Font = Enum.Font.Arial
toggle5Description.TextSize = 14
toggle5Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle5Description.TextXAlignment = Enum.TextXAlignment.Left
toggle5Button.MouseButton1Click:Connect(function()
config.healthCheck = not config.healthCheck
toggle5Button.Text = "HealthCheck: " .. (config.healthCheck and "On" or "Off")
animateGradient(toggle5UIGradient)
animateButton(toggle5Button)
saveConfig()
end)
toggle5Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle5Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle5Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle5Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle6Frame = Instance.new("Frame")
toggle6Frame.Parent = scrollingFrame
toggle6Frame.Size = UDim2.new(1, 0, 0, 60)
toggle6Frame.BackgroundTransparency = 1
local toggle6Button = Instance.new("TextButton")
toggle6Button.Parent = toggle6Frame
toggle6Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle6Button.Position = UDim2.new(0, 10, 0, 0)
toggle6Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle6Button.BorderSizePixel = 0
toggle6Button.Text = "CooldownCheck: " .. (config.cooldownCheck and "On" or "Off")
toggle6Button.Font = Enum.Font.ArialBold
toggle6Button.TextSize = 16
toggle6Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle6Button.AutoButtonColor = false
local toggle6UICorner = Instance.new("UICorner")
toggle6UICorner.Parent = toggle6Button
toggle6UICorner.CornerRadius = UDim.new(0, 18)
local toggle6UIGradient = Instance.new("UIGradient")
toggle6UIGradient.Parent = toggle6Button
toggle6UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle6UIGradient.Rotation = 0
local toggle6UIStroke = Instance.new("UIStroke")
toggle6UIStroke.Parent = toggle6Button
toggle6UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle6UIStroke.Thickness = 1
toggle6UIStroke.Transparency = 0.2
local toggle6Description = Instance.new("TextLabel")
toggle6Description.Parent = toggle6Frame
toggle6Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle6Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle6Description.BackgroundTransparency = 1
toggle6Description.Text = "Prevents re-locking to the same target too quickly."
toggle6Description.TextWrapped = true
toggle6Description.Font = Enum.Font.Arial
toggle6Description.TextSize = 14
toggle6Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle6Description.TextXAlignment = Enum.TextXAlignment.Left
toggle6Button.MouseButton1Click:Connect(function()
config.cooldownCheck = not config.cooldownCheck
toggle6Button.Text = "CooldownCheck: " .. (config.cooldownCheck and "On" or "Off")
animateGradient(toggle6UIGradient)
animateButton(toggle6Button)
saveConfig()
end)
toggle6Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle6Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle6Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle6Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle7Frame = Instance.new("Frame")
toggle7Frame.Parent = scrollingFrame
toggle7Frame.Size = UDim2.new(1, 0, 0, 60)
toggle7Frame.BackgroundTransparency = 1
local toggle7Button = Instance.new("TextButton")
toggle7Button.Parent = toggle7Frame
toggle7Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle7Button.Position = UDim2.new(0, 10, 0, 0)
toggle7Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle7Button.BorderSizePixel = 0
toggle7Button.Text = "FOV Circle: " .. (config.fovCircle and "On" or "Off")
toggle7Button.Font = Enum.Font.ArialBold
toggle7Button.TextSize = 16
toggle7Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle7Button.AutoButtonColor = false
local toggle7UICorner = Instance.new("UICorner")
toggle7UICorner.Parent = toggle7Button
toggle7UICorner.CornerRadius = UDim.new(0, 18)
local toggle7UIGradient = Instance.new("UIGradient")
toggle7UIGradient.Parent = toggle7Button
toggle7UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle7UIGradient.Rotation = 0
local toggle7UIStroke = Instance.new("UIStroke")
toggle7UIStroke.Parent = toggle7Button
toggle7UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle7UIStroke.Thickness = 1
toggle7UIStroke.Transparency = 0.2
toggle7Button.MouseButton1Click:Connect(function()
config.fovCircle = not config.fovCircle
toggle7Button.Text = "FOV Circle: " .. (config.fovCircle and "On" or "Off")
fovCircle.Visible = config.fovCircle
animateGradient(toggle7UIGradient)
animateButton(toggle7Button)
saveConfig()
end)
toggle7Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle7Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle7Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle7Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local slider1Frame = Instance.new("Frame")
slider1Frame.Parent = scrollingFrame
slider1Frame.Size = UDim2.new(1, 0, 0, 60)
slider1Frame.BackgroundTransparency = 1
local slider1Label = Instance.new("TextLabel")
slider1Label.Parent = slider1Frame
slider1Label.Size = UDim2.new(0.4, 0, 1, 0)
slider1Label.Position = UDim2.new(0, 10, 0, 0)
slider1Label.BackgroundTransparency = 1
slider1Label.Text = "FOV Radius: " .. config.fovRadius
slider1Label.Font = Enum.Font.ArialBold
slider1Label.TextSize = 16
slider1Label.TextColor3 = Color3.fromRGB(255, 255, 255)
local slider1Bar = Instance.new("Frame")
slider1Bar.Parent = slider1Frame
slider1Bar.Size = UDim2.new(0.55, 0, 0.3, 0)
slider1Bar.Position = UDim2.new(0.45, 0, 0.35, 0)
slider1Bar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
local slider1BarUICorner = Instance.new("UICorner")
slider1BarUICorner.Parent = slider1Bar
slider1BarUICorner.CornerRadius = UDim.new(0, 5)
local slider1Fill = Instance.new("Frame")
slider1Fill.Parent = slider1Bar
slider1Fill.Size = UDim2.new((config.fovRadius - 1) / 99, 0, 1, 0)
slider1Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
local slider1FillUICorner = Instance.new("UICorner")
slider1FillUICorner.Parent = slider1Fill
slider1FillUICorner.CornerRadius = UDim.new(0, 5)
local slider1Knob = Instance.new("Frame")
slider1Knob.Parent = slider1Bar
slider1Knob.Size = UDim2.new(0, 20, 0, 20)
slider1Knob.Position = UDim2.new((config.fovRadius - 1) / 99, -10, 0.5, -10)
slider1Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local slider1KnobUICorner = Instance.new("UICorner")
slider1KnobUICorner.Parent = slider1Knob
slider1KnobUICorner.CornerRadius = UDim.new(1, 0)
local slider1Dragging = false
slider1Knob.MouseButton1Down:Connect(function()
slider1Dragging = true
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
slider1Dragging = false
end
end)
RunService.RenderStepped:Connect(function()
if slider1Dragging then
local mouse = UserInputService:GetMouseLocation()
local barPos = slider1Bar.AbsolutePosition.X
local barSize = slider1Bar.AbsoluteSize.X
local rel = math.clamp((mouse.X - barPos) / barSize, 0, 1)
local value = math.round(1 + rel * 99)
config.fovRadius = value
slider1Label.Text = "FOV Radius: " .. value
slider1Fill.Size = UDim2.new(rel, 0, 1, 0)
slider1Knob.Position = UDim2.new(rel, -10, 0.5, -10)
fovCircle.Size = UDim2.new(0, value * 2, 0, value * 2)
fovCircle.Position = UDim2.new(0.5, -value, 0.5, -value)
saveConfig()
end
end)
local slider2Frame = Instance.new("Frame")
slider2Frame.Parent = scrollingFrame
slider2Frame.Size = UDim2.new(1, 0, 0, 60)
slider2Frame.BackgroundTransparency = 1
local slider2Label = Instance.new("TextLabel")
slider2Label.Parent = slider2Frame
slider2Label.Size = UDim2.new(0.4, 0, 1, 0)
slider2Label.Position = UDim2.new(0, 10, 0, 0)
slider2Label.BackgroundTransparency = 1
slider2Label.Text = "FOV Transparency: " .. config.fovTransparency
slider2Label.Font = Enum.Font.ArialBold
slider2Label.TextSize = 16
slider2Label.TextColor3 = Color3.fromRGB(255, 255, 255)
local slider2Bar = Instance.new("Frame")
slider2Bar.Parent = slider2Frame
slider2Bar.Size = UDim2.new(0.55, 0, 0.3, 0)
slider2Bar.Position = UDim2.new(0.45, 0, 0.35, 0)
slider2Bar.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
local slider2BarUICorner = Instance.new("UICorner")
slider2BarUICorner.Parent = slider2Bar
slider2BarUICorner.CornerRadius = UDim.new(0, 5)
local slider2Fill = Instance.new("Frame")
slider2Fill.Parent = slider2Bar
slider2Fill.Size = UDim2.new((config.fovTransparency - 1) / 99, 0, 1, 0)
slider2Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
local slider2FillUICorner = Instance.new("UICorner")
slider2FillUICorner.Parent = slider2Fill
slider2FillUICorner.CornerRadius = UDim.new(0, 5)
local slider2Knob = Instance.new("Frame")
slider2Knob.Parent = slider2Bar
slider2Knob.Size = UDim2.new(0, 20, 0, 20)
slider2Knob.Position = UDim2.new((config.fovTransparency - 1) / 99, -10, 0.5, -10)
slider2Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local slider2KnobUICorner = Instance.new("UICorner")
slider2KnobUICorner.Parent = slider2Knob
slider2KnobUICorner.CornerRadius = UDim.new(1, 0)
local slider2Dragging = false
slider2Knob.MouseButton1Down:Connect(function()
slider2Dragging = true
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
slider2Dragging = false
end
end)
RunService.RenderStepped:Connect(function()
if slider2Dragging then
local mouse = UserInputService:GetMouseLocation()
local barPos = slider2Bar.AbsolutePosition.X
local barSize = slider2Bar.AbsoluteSize.X
local rel = math.clamp((mouse.X - barPos) / barSize, 0, 1)
local value = math.round(1 + rel * 99)
config.fovTransparency = value
slider2Label.Text = "FOV Transparency: " .. value
slider2Fill.Size = UDim2.new(rel, 0, 1, 0)
slider2Knob.Position = UDim2.new(rel, -10, 0.5, -10)
fovCircle.BackgroundTransparency = value / 100
saveConfig()
end
end)
local toggle8Frame = Instance.new("Frame")
toggle8Frame.Parent = scrollingFrame
toggle8Frame.Size = UDim2.new(1, 0, 0, 60)
toggle8Frame.BackgroundTransparency = 1
local toggle8Button = Instance.new("TextButton")
toggle8Button.Parent = toggle8Frame
toggle8Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle8Button.Position = UDim2.new(0, 10, 0, 0)
toggle8Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle8Button.BorderSizePixel = 0
toggle8Button.Text = "ESP Target: " .. (config.espTarget and "On" or "Off")
toggle8Button.Font = Enum.Font.ArialBold
toggle8Button.TextSize = 16
toggle8Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle8Button.AutoButtonColor = false
local toggle8UICorner = Instance.new("UICorner")
toggle8UICorner.Parent = toggle8Button
toggle8UICorner.CornerRadius = UDim.new(0, 18)
local toggle8UIGradient = Instance.new("UIGradient")
toggle8UIGradient.Parent = toggle8Button
toggle8UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle8UIGradient.Rotation = 0
local toggle8UIStroke = Instance.new("UIStroke")
toggle8UIStroke.Parent = toggle8Button
toggle8UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle8UIStroke.Thickness = 1
toggle8UIStroke.Transparency = 0.2
local toggle8Description = Instance.new("TextLabel")
toggle8Description.Parent = toggle8Frame
toggle8Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle8Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle8Description.BackgroundTransparency = 1
toggle8Description.Text = "ESP the target’s whole body (not a box ESP). Does not ESP other players."
toggle8Description.TextWrapped = true
toggle8Description.Font = Enum.Font.Arial
toggle8Description.TextSize = 14
toggle8Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle8Description.TextXAlignment = Enum.TextXAlignment.Left
toggle8Button.MouseButton1Click:Connect(function()
config.espTarget = not config.espTarget
toggle8Button.Text = "ESP Target: " .. (config.espTarget and "On" or "Off")
animateGradient(toggle8UIGradient)
animateButton(toggle8Button)
saveConfig()
end)
toggle8Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle8Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle8Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle8Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle9Frame = Instance.new("Frame")
toggle9Frame.Parent = scrollingFrame
toggle9Frame.Size = UDim2.new(1, 0, 0, 60)
toggle9Frame.BackgroundTransparency = 1
local toggle9Button = Instance.new("TextButton")
toggle9Button.Parent = toggle9Frame
toggle9Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle9Button.Position = UDim2.new(0, 10, 0, 0)
toggle9Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle9Button.BorderSizePixel = 0
toggle9Button.Text = "ESP Target Name: " .. (config.espTargetName and "On" or "Off")
toggle9Button.Font = Enum.Font.ArialBold
toggle9Button.TextSize = 16
toggle9Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle9Button.AutoButtonColor = false
local toggle9UICorner = Instance.new("UICorner")
toggle9UICorner.Parent = toggle9Button
toggle9UICorner.CornerRadius = UDim.new(0, 18)
local toggle9UIGradient = Instance.new("UIGradient")
toggle9UIGradient.Parent = toggle9Button
toggle9UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle9UIGradient.Rotation = 0
local toggle9UIStroke = Instance.new("UIStroke")
toggle9UIStroke.Parent = toggle9Button
toggle9UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle9UIStroke.Thickness = 1
toggle9UIStroke.Transparency = 0.2
local toggle9Description = Instance.new("TextLabel")
toggle9Description.Parent = toggle9Frame
toggle9Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle9Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle9Description.BackgroundTransparency = 1
toggle9Description.Text = "Displays the target’s username above their head (only for the current target)."
toggle9Description.TextWrapped = true
toggle9Description.Font = Enum.Font.Arial
toggle9Description.TextSize = 14
toggle9Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle9Description.TextXAlignment = Enum.TextXAlignment.Left
toggle9Button.MouseButton1Click:Connect(function()
config.espTargetName = not config.espTargetName
toggle9Button.Text = "ESP Target Name: " .. (config.espTargetName and "On" or "Off")
animateGradient(toggle9UIGradient)
animateButton(toggle9Button)
saveConfig()
end)
toggle9Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle9Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle9Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle9Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle10Frame = Instance.new("Frame")
toggle10Frame.Parent = scrollingFrame
toggle10Frame.Size = UDim2.new(1, 0, 0, 60)
toggle10Frame.BackgroundTransparency = 1
local toggle10Button = Instance.new("TextButton")
toggle10Button.Parent = toggle10Frame
toggle10Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle10Button.Position = UDim2.new(0, 10, 0, 0)
toggle10Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle10Button.BorderSizePixel = 0
toggle10Button.Text = "ESPHiddenPlayers: " .. (config.espHiddenPlayers and "On" or "Off")
toggle10Button.Font = Enum.Font.ArialBold
toggle10Button.TextSize = 16
toggle10Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle10Button.AutoButtonColor = false
local toggle10UICorner = Instance.new("UICorner")
toggle10UICorner.Parent = toggle10Button
toggle10UICorner.CornerRadius = UDim.new(0, 18)
local toggle10UIGradient = Instance.new("UIGradient")
toggle10UIGradient.Parent = toggle10Button
toggle10UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle10UIGradient.Rotation = 0
local toggle10UIStroke = Instance.new("UIStroke")
toggle10UIStroke.Parent = toggle10Button
toggle10UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle10UIStroke.Thickness = 1
toggle10UIStroke.Transparency = 0.2
local toggle10Description = Instance.new("TextLabel")
toggle10Description.Parent = toggle10Frame
toggle10Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle10Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle10Description.BackgroundTransparency = 1
toggle10Description.Text = "ESPs all players who are behind walls. Players who are visible (not behind walls) will NOT be ESP’d."
toggle10Description.TextWrapped = true
toggle10Description.Font = Enum.Font.Arial
toggle10Description.TextSize = 14
toggle10Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle10Description.TextXAlignment = Enum.TextXAlignment.Left
toggle10Button.MouseButton1Click:Connect(function()
config.espHiddenPlayers = not config.espHiddenPlayers
toggle10Button.Text = "ESPHiddenPlayers: " .. (config.espHiddenPlayers and "On" or "Off")
animateGradient(toggle10UIGradient)
animateButton(toggle10Button)
saveConfig()
end)
toggle10Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle10Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle10Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle10Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local toggle11Frame = Instance.new("Frame")
toggle11Frame.Parent = scrollingFrame
toggle11Frame.Size = UDim2.new(1, 0, 0, 60)
toggle11Frame.BackgroundTransparency = 1
local toggle11Button = Instance.new("TextButton")
toggle11Button.Parent = toggle11Frame
toggle11Button.Size = UDim2.new(0.4, 0, 1, 0)
toggle11Button.Position = UDim2.new(0, 10, 0, 0)
toggle11Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle11Button.BorderSizePixel = 0
toggle11Button.Text = "ESPHiddenPlayersName: " .. (config.espHiddenPlayersName and "On" or "Off")
toggle11Button.Font = Enum.Font.ArialBold
toggle11Button.TextSize = 16
toggle11Button.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle11Button.AutoButtonColor = false
local toggle11UICorner = Instance.new("UICorner")
toggle11UICorner.Parent = toggle11Button
toggle11UICorner.CornerRadius = UDim.new(0, 18)
local toggle11UIGradient = Instance.new("UIGradient")
toggle11UIGradient.Parent = toggle11Button
toggle11UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
toggle11UIGradient.Rotation = 0
local toggle11UIStroke = Instance.new("UIStroke")
toggle11UIStroke.Parent = toggle11Button
toggle11UIStroke.Color = Color3.fromRGB(0, 0, 0)
toggle11UIStroke.Thickness = 1
toggle11UIStroke.Transparency = 0.2
local toggle11Description = Instance.new("TextLabel")
toggle11Description.Parent = toggle11Frame
toggle11Description.Size = UDim2.new(0.55, 0, 1, 0)
toggle11Description.Position = UDim2.new(0.45, 0, 0, 0)
toggle11Description.BackgroundTransparency = 1
toggle11Description.Text = "ESPs the usernames of all hidden players (only players behind walls)."
toggle11Description.TextWrapped = true
toggle11Description.Font = Enum.Font.Arial
toggle11Description.TextSize = 14
toggle11Description.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle11Description.TextXAlignment = Enum.TextXAlignment.Left
toggle11Button.MouseButton1Click:Connect(function()
config.espHiddenPlayersName = not config.espHiddenPlayersName
toggle11Button.Text = "ESPHiddenPlayersName: " .. (config.espHiddenPlayersName and "On" or "Off")
animateGradient(toggle11UIGradient)
animateButton(toggle11Button)
saveConfig()
end)
toggle11Button.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle11Button, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
toggle11Button.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(toggle11Button, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
local dropdown1Frame = Instance.new("Frame")
dropdown1Frame.Parent = scrollingFrame
dropdown1Frame.Size = UDim2.new(1, 0, 0, 60)
dropdown1Frame.BackgroundTransparency = 1
local dropdown1Button = Instance.new("TextButton")
dropdown1Button.Parent = dropdown1Frame
dropdown1Button.Size = UDim2.new(0.4, 0, 1, 0)
dropdown1Button.Position = UDim2.new(0, 10, 0, 0)
dropdown1Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdown1Button.BorderSizePixel = 0
dropdown1Button.Text = "Lock Mode: " .. config.lockMode
dropdown1Button.Font = Enum.Font.ArialBold
dropdown1Button.TextSize = 16
dropdown1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown1Button.AutoButtonColor = false
local dropdown1UICorner = Instance.new("UICorner")
dropdown1UICorner.Parent = dropdown1Button
dropdown1UICorner.CornerRadius = UDim.new(0, 18)
local dropdown1UIGradient = Instance.new("UIGradient")
dropdown1UIGradient.Parent = dropdown1Button
dropdown1UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
dropdown1UIGradient.Rotation = 0
local dropdown1UIStroke = Instance.new("UIStroke")
dropdown1UIStroke.Parent = dropdown1Button
dropdown1UIStroke.Color = Color3.fromRGB(0, 0, 0)
dropdown1UIStroke.Thickness = 1
dropdown1UIStroke.Transparency = 0.2
local dropdown1List = Instance.new("Frame")
dropdown1List.Parent = dropdown1Frame
dropdown1List.Size = UDim2.new(0.4, 0, 0, 120)
dropdown1List.Position = UDim2.new(0, 10, 1, 0)
dropdown1List.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown1List.Visible = false
local dropdown1ListUICorner = Instance.new("UICorner")
dropdown1ListUICorner.Parent = dropdown1List
dropdown1ListUICorner.CornerRadius = UDim.new(0, 18)
local dropdown1ListLayout = Instance.new("UIListLayout")
dropdown1ListLayout.Parent = dropdown1List
dropdown1ListLayout.Padding = UDim.new(0, 5)
dropdown1ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
local dropdown1Option1 = Instance.new("TextButton")
dropdown1Option1.Parent = dropdown1List
dropdown1Option1.Size = UDim2.new(1, 0, 0, 50)
dropdown1Option1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown1Option1.Text = "Camlock"
dropdown1Option1.Font = Enum.Font.ArialBold
dropdown1Option1.TextSize = 16
dropdown1Option1.TextColor3 = Color3.fromRGB(255, 255, 255)
local option1UICorner = Instance.new("UICorner")
option1UICorner.Parent = dropdown1Option1
option1UICorner.CornerRadius = UDim.new(0, 18)
dropdown1Option1.MouseButton1Click:Connect(function()
config.lockMode = "Camlock"
dropdown1Button.Text = "Lock Mode: Camlock"
dropdown1List.Visible = false
updateMainLabel()
saveConfig()
end)
local dropdown1Option2 = Instance.new("TextButton")
dropdown1Option2.Parent = dropdown1List
dropdown1Option2.Size = UDim2.new(1, 0, 0, 50)
dropdown1Option2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown1Option2.Text = "CharLock"
dropdown1Option2.Font = Enum.Font.ArialBold
dropdown1Option2.TextSize = 16
dropdown1Option2.TextColor3 = Color3.fromRGB(255, 255, 255)
local option2UICorner = Instance.new("UICorner")
option2UICorner.Parent = dropdown1Option2
option2UICorner.CornerRadius = UDim.new(0, 18)
dropdown1Option2.MouseButton1Click:Connect(function()
config.lockMode = "CharLock"
dropdown1Button.Text = "Lock Mode: CharLock"
dropdown1List.Visible = false
updateMainLabel()
saveConfig()
end)
local dropdown1Description = Instance.new("TextLabel")
dropdown1Description.Parent = dropdown1Frame
dropdown1Description.Size = UDim2.new(0.55, 0, 1, 0)
dropdown1Description.Position = UDim2.new(0.45, 0, 0, 0)
dropdown1Description.BackgroundTransparency = 1
dropdown1Description.Text = "Options: Camlock — Uses the camera for locking/aiming targets. CharLock — Uses the character to aim at targets and changes the main toggle label to \"Charlock: Off/On\"."
dropdown1Description.TextWrapped = true
dropdown1Description.Font = Enum.Font.Arial
dropdown1Description.TextSize = 14
dropdown1Description.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown1Description.TextXAlignment = Enum.TextXAlignment.Left
dropdown1Button.MouseButton1Click:Connect(function()
dropdown1List.Visible = not dropdown1List.Visible
animateGradient(dropdown1UIGradient)
animateButton(dropdown1Button)
end)
local dropdown2Frame = Instance.new("Frame")
dropdown2Frame.Parent = scrollingFrame
dropdown2Frame.Size = UDim2.new(1, 0, 0, 60)
dropdown2Frame.BackgroundTransparency = 1
local dropdown2Button = Instance.new("TextButton")
dropdown2Button.Parent = dropdown2Frame
dropdown2Button.Size = UDim2.new(0.4, 0, 1, 0)
dropdown2Button.Position = UDim2.new(0, 10, 0, 0)
dropdown2Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdown2Button.BorderSizePixel = 0
dropdown2Button.Text = "LockStyle: " .. config.lockStyle
dropdown2Button.Font = Enum.Font.ArialBold
dropdown2Button.TextSize = 16
dropdown2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown2Button.AutoButtonColor = false
local dropdown2UICorner = Instance.new("UICorner")
dropdown2UICorner.Parent = dropdown2Button
dropdown2UICorner.CornerRadius = UDim.new(0, 18)
local dropdown2UIGradient = Instance.new("UIGradient")
dropdown2UIGradient.Parent = dropdown2Button
dropdown2UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
dropdown2UIGradient.Rotation = 0
local dropdown2UIStroke = Instance.new("UIStroke")
dropdown2UIStroke.Parent = dropdown2Button
dropdown2UIStroke.Color = Color3.fromRGB(0, 0, 0)
dropdown2UIStroke.Thickness = 1
dropdown2UIStroke.Transparency = 0.2
local dropdown2List = Instance.new("Frame")
dropdown2List.Parent = dropdown2Frame
dropdown2List.Size = UDim2.new(0.4, 0, 0, 180)
dropdown2List.Position = UDim2.new(0, 10, 1, 0)
dropdown2List.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown2List.Visible = false
local dropdown2ListUICorner = Instance.new("UICorner")
dropdown2ListUICorner.Parent = dropdown2List
dropdown2ListUICorner.CornerRadius = UDim.new(0, 18)
local dropdown2ListLayout = Instance.new("UIListLayout")
dropdown2ListLayout.Parent = dropdown2List
dropdown2ListLayout.Padding = UDim.new(0, 5)
dropdown2ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
local dropdown2Option1 = Instance.new("TextButton")
dropdown2Option1.Parent = dropdown2List
dropdown2Option1.Size = UDim2.new(1, 0, 0, 50)
dropdown2Option1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown2Option1.Text = "Legit"
dropdown2Option1.Font = Enum.Font.ArialBold
dropdown2Option1.TextSize = 16
dropdown2Option1.TextColor3 = Color3.fromRGB(255, 255, 255)
local option21UICorner = Instance.new("UICorner")
option21UICorner.Parent = dropdown2Option1
option21UICorner.CornerRadius = UDim.new(0, 18)
dropdown2Option1.MouseButton1Click:Connect(function()
config.lockStyle = "Legit"
dropdown2Button.Text = "LockStyle: Legit"
dropdown2List.Visible = false
saveConfig()
end)
local dropdown2Option2 = Instance.new("TextButton")
dropdown2Option2.Parent = dropdown2List
dropdown2Option2.Size = UDim2.new(1, 0, 0, 50)
dropdown2Option2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown2Option2.Text = "Fast"
dropdown2Option2.Font = Enum.Font.ArialBold
dropdown2Option2.TextSize = 16
dropdown2Option2.TextColor3 = Color3.fromRGB(255, 255, 255)
local option22UICorner = Instance.new("UICorner")
option22UICorner.Parent = dropdown2Option2
option22UICorner.CornerRadius = UDim.new(0, 18)
dropdown2Option2.MouseButton1Click:Connect(function()
config.lockStyle = "Fast"
dropdown2Button.Text = "LockStyle: Fast"
dropdown2List.Visible = false
saveConfig()
end)
local dropdown2Option3 = Instance.new("TextButton")
dropdown2Option3.Parent = dropdown2List
dropdown2Option3.Size = UDim2.new(1, 0, 0, 50)
dropdown2Option3.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown2Option3.Text = "Rage"
dropdown2Option3.Font = Enum.Font.ArialBold
dropdown2Option3.TextSize = 16
dropdown2Option3.TextColor3 = Color3.fromRGB(255, 255, 255)
local option23UICorner = Instance.new("UICorner")
option23UICorner.Parent = dropdown2Option3
option23UICorner.CornerRadius = UDim.new(0, 18)
dropdown2Option3.MouseButton1Click:Connect(function()
config.lockStyle = "Rage"
dropdown2Button.Text = "LockStyle: Rage"
dropdown2List.Visible = false
saveConfig()
end)
local dropdown2Description = Instance.new("TextLabel")
dropdown2Description.Parent = dropdown2Frame
dropdown2Description.Size = UDim2.new(0.55, 0, 1, 0)
dropdown2Description.Position = UDim2.new(0.45, 0, 0, 0)
dropdown2Description.BackgroundTransparency = 1
dropdown2Description.Text = "Options: Legit — Smooth, human-like camera/character snap when the target or I move. Fast — Faster camera/character snap when the target or I move. Rage — Instant camera/character snap when the target or I move."
dropdown2Description.TextWrapped = true
dropdown2Description.Font = Enum.Font.Arial
dropdown2Description.TextSize = 14
dropdown2Description.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown2Description.TextXAlignment = Enum.TextXAlignment.Left
dropdown2Button.MouseButton1Click:Connect(function()
dropdown2List.Visible = not dropdown2List.Visible
animateGradient(dropdown2UIGradient)
animateButton(dropdown2Button)
end)
local dropdown3Frame = Instance.new("Frame")
dropdown3Frame.Parent = scrollingFrame
dropdown3Frame.Size = UDim2.new(1, 0, 0, 60)
dropdown3Frame.BackgroundTransparency = 1
local dropdown3Button = Instance.new("TextButton")
dropdown3Button.Parent = dropdown3Frame
dropdown3Button.Size = UDim2.new(0.4, 0, 1, 0)
dropdown3Button.Position = UDim2.new(0, 10, 0, 0)
dropdown3Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdown3Button.BorderSizePixel = 0
dropdown3Button.Text = "AimPart: " .. config.aimPart
dropdown3Button.Font = Enum.Font.ArialBold
dropdown3Button.TextSize = 16
dropdown3Button.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown3Button.AutoButtonColor = false
local dropdown3UICorner = Instance.new("UICorner")
dropdown3UICorner.Parent = dropdown3Button
dropdown3UICorner.CornerRadius = UDim.new(0, 18)
local dropdown3UIGradient = Instance.new("UIGradient")
dropdown3UIGradient.Parent = dropdown3Button
dropdown3UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
dropdown3UIGradient.Rotation = 0
local dropdown3UIStroke = Instance.new("UIStroke")
dropdown3UIStroke.Parent = dropdown3Button
dropdown3UIStroke.Color = Color3.fromRGB(0, 0, 0)
dropdown3UIStroke.Thickness = 1
dropdown3UIStroke.Transparency = 0.2
local dropdown3List = Instance.new("Frame")
dropdown3List.Parent = dropdown3Frame
dropdown3List.Size = UDim2.new(0.4, 0, 0, 240)
dropdown3List.Position = UDim2.new(0, 10, 1, 0)
dropdown3List.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown3List.Visible = false
local dropdown3ListUICorner = Instance.new("UICorner")
dropdown3ListUICorner.Parent = dropdown3List
dropdown3ListUICorner.CornerRadius = UDim.new(0, 18)
local dropdown3ListLayout = Instance.new("UIListLayout")
dropdown3ListLayout.Parent = dropdown3List
dropdown3ListLayout.Padding = UDim.new(0, 5)
dropdown3ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
local dropdown3Option1 = Instance.new("TextButton")
dropdown3Option1.Parent = dropdown3List
dropdown3Option1.Size = UDim2.new(1, 0, 0, 50)
dropdown3Option1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown3Option1.Text = "Head"
dropdown3Option1.Font = Enum.Font.ArialBold
dropdown3Option1.TextSize = 16
dropdown3Option1.TextColor3 = Color3.fromRGB(255, 255, 255)
local option31UICorner = Instance.new("UICorner")
option31UICorner.Parent = dropdown3Option1
option31UICorner.CornerRadius = UDim.new(0, 18)
dropdown3Option1.MouseButton1Click:Connect(function()
config.aimPart = "Head"
dropdown3Button.Text = "AimPart: Head"
dropdown3List.Visible = false
saveConfig()
end)
local dropdown3Option2 = Instance.new("TextButton")
dropdown3Option2.Parent = dropdown3List
dropdown3Option2.Size = UDim2.new(1, 0, 0, 50)
dropdown3Option2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown3Option2.Text = "Torso"
dropdown3Option2.Font = Enum.Font.ArialBold
dropdown3Option2.TextSize = 16
dropdown3Option2.TextColor3 = Color3.fromRGB(255, 255, 255)
local option32UICorner = Instance.new("UICorner")
option32UICorner.Parent = dropdown3Option2
option32UICorner.CornerRadius = UDim.new(0, 18)
dropdown3Option2.MouseButton1Click:Connect(function()
config.aimPart = "Torso"
dropdown3Button.Text = "AimPart: Torso"
dropdown3List.Visible = false
saveConfig()
end)
local dropdown3Option3 = Instance.new("TextButton")
dropdown3Option3.Parent = dropdown3List
dropdown3Option3.Size = UDim2.new(1, 0, 0, 50)
dropdown3Option3.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown3Option3.Text = "HumanoidRootPart"
dropdown3Option3.Font = Enum.Font.ArialBold
dropdown3Option3.TextSize = 16
dropdown3Option3.TextColor3 = Color3.fromRGB(255, 255, 255)
local option33UICorner = Instance.new("UICorner")
option33UICorner.Parent = dropdown3Option3
option33UICorner.CornerRadius = UDim.new(0, 18)
dropdown3Option3.MouseButton1Click:Connect(function()
config.aimPart = "HumanoidRootPart"
dropdown3Button.Text = "AimPart: HumanoidRootPart"
dropdown3List.Visible = false
saveConfig()
end)
local dropdown3Option4 = Instance.new("TextButton")
dropdown3Option4.Parent = dropdown3List
dropdown3Option4.Size = UDim2.new(1, 0, 0, 50)
dropdown3Option4.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dropdown3Option4.Text = "Random"
dropdown3Option4.Font = Enum.Font.ArialBold
dropdown3Option4.TextSize = 16
dropdown3Option4.TextColor3 = Color3.fromRGB(255, 255, 255)
local option34UICorner = Instance.new("UICorner")
option34UICorner.Parent = dropdown3Option4
option34UICorner.CornerRadius = UDim.new(0, 18)
dropdown3Option4.MouseButton1Click:Connect(function()
config.aimPart = "Random"
dropdown3Button.Text = "AimPart: Random"
dropdown3List.Visible = false
saveConfig()
end)
local dropdown3Description = Instance.new("TextLabel")
dropdown3Description.Parent = dropdown3Frame
dropdown3Description.Size = UDim2.new(0.55, 0, 1, 0)
dropdown3Description.Position = UDim2.new(0.45, 0, 0, 0)
dropdown3Description.BackgroundTransparency = 1
dropdown3Description.Text = "Options: Head / Torso / HumanoidRootPart / Random"
dropdown3Description.TextWrapped = true
dropdown3Description.Font = Enum.Font.Arial
dropdown3Description.TextSize = 14
dropdown3Description.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown3Description.TextXAlignment = Enum.TextXAlignment.Left
dropdown3Button.MouseButton1Click:Connect(function()
dropdown3List.Visible = not dropdown3List.Visible
animateGradient(dropdown3UIGradient)
animateButton(dropdown3Button)
end)
local textbox1Frame = Instance.new("Frame")
textbox1Frame.Parent = scrollingFrame
textbox1Frame.Size = UDim2.new(1, 0, 0, 60)
textbox1Frame.BackgroundTransparency = 1
local textbox1 = Instance.new("TextBox")
textbox1.Parent = textbox1Frame
textbox1.Size = UDim2.new(0.4, 0, 1, 0)
textbox1.Position = UDim2.new(0, 10, 0, 0)
textbox1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textbox1.BorderSizePixel = 0
textbox1.Text = config.keybind
textbox1.Font = Enum.Font.ArialBold
textbox1.TextSize = 16
textbox1.TextColor3 = Color3.fromRGB(0, 0, 0)
local textbox1UICorner = Instance.new("UICorner")
textbox1UICorner.Parent = textbox1
textbox1UICorner.CornerRadius = UDim.new(0, 18)
local textbox1UIStroke = Instance.new("UIStroke")
textbox1UIStroke.Parent = textbox1
textbox1UIStroke.Color = Color3.fromRGB(0, 0, 0)
textbox1UIStroke.Thickness = 1
textbox1UIStroke.Transparency = 0.2
local textbox1Description = Instance.new("TextLabel")
textbox1Description.Parent = textbox1Frame
textbox1Description.Size = UDim2.new(0.55, 0, 1, 0)
textbox1Description.Position = UDim2.new(0.45, 0, 0, 0)
textbox1Description.BackgroundTransparency = 1
textbox1Description.Text = "Choose the activation key for the Camlock or Charlock toggle."
textbox1Description.TextWrapped = true
textbox1Description.Font = Enum.Font.Arial
textbox1Description.TextSize = 14
textbox1Description.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox1Description.TextXAlignment = Enum.TextXAlignment.Left
textbox1.FocusLost:Connect(function()
config.keybind = textbox1.Text:upper()
textbox1.Text = config.keybind
saveConfig()
end)
local textbox2Frame = Instance.new("Frame")
textbox2Frame.Parent = scrollingFrame
textbox2Frame.Size = UDim2.new(1, 0, 0, 60)
textbox2Frame.BackgroundTransparency = 1
local textbox2 = Instance.new("TextBox")
textbox2.Parent = textbox2Frame
textbox2.Size = UDim2.new(0.4, 0, 1, 0)
textbox2.Position = UDim2.new(0, 10, 0, 0)
textbox2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textbox2.BorderSizePixel = 0
textbox2.Text = tostring(config.maxDistance)
textbox2.Font = Enum.Font.ArialBold
textbox2.TextSize = 16
textbox2.TextColor3 = Color3.fromRGB(0, 0, 0)
local textbox2UICorner = Instance.new("UICorner")
textbox2UICorner.Parent = textbox2
textbox2UICorner.CornerRadius = UDim.new(0, 18)
local textbox2UIStroke = Instance.new("UIStroke")
textbox2UIStroke.Parent = textbox2
textbox2UIStroke.Color = Color3.fromRGB(0, 0, 0)
textbox2UIStroke.Thickness = 1
textbox2UIStroke.Transparency = 0.2
local textbox2Description = Instance.new("TextLabel")
textbox2Description.Parent = textbox2Frame
textbox2Description.Size = UDim2.new(0.55, 0, 1, 0)
textbox2Description.Position = UDim2.new(0.45, 0, 0, 0)
textbox2Description.BackgroundTransparency = 1
textbox2Description.Text = "Maximum distance for locking onto players."
textbox2Description.TextWrapped = true
textbox2Description.Font = Enum.Font.Arial
textbox2Description.TextSize = 14
textbox2Description.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox2Description.TextXAlignment = Enum.TextXAlignment.Left
textbox2.FocusLost:Connect(function()
config.maxDistance = tonumber(textbox2.Text) or 10000
textbox2.Text = tostring(config.maxDistance)
saveConfig()
end)
local button1Frame = Instance.new("Frame")
button1Frame.Parent = scrollingFrame
button1Frame.Size = UDim2.new(1, 0, 0, 60)
button1Frame.BackgroundTransparency = 1
local button1 = Instance.new("TextButton")
button1.Parent = button1Frame
button1.Size = UDim2.new(0.4, 0, 1, 0)
button1.Position = UDim2.new(0, 10, 0, 0)
button1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button1.BorderSizePixel = 0
button1.Text = "Reset to Default"
button1.Font = Enum.Font.ArialBold
button1.TextSize = 16
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.AutoButtonColor = false
local button1UICorner = Instance.new("UICorner")
button1UICorner.Parent = button1
button1UICorner.CornerRadius = UDim.new(0, 18)
local button1UIGradient = Instance.new("UIGradient")
button1UIGradient.Parent = button1
button1UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 50, 50)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
button1UIGradient.Rotation = 0
local button1UIStroke = Instance.new("UIStroke")
button1UIStroke.Parent = button1
button1UIStroke.Color = Color3.fromRGB(0, 0, 0)
button1UIStroke.Thickness = 1
button1UIStroke.Transparency = 0.2
local button1Description = Instance.new("TextLabel")
button1Description.Parent = button1Frame
button1Description.Size = UDim2.new(0.55, 0, 1, 0)
button1Description.Position = UDim2.new(0.45, 0, 0, 0)
button1Description.BackgroundTransparency = 1
button1Description.Text = "Resets all settings to their default values."
button1Description.TextWrapped = true
button1Description.Font = Enum.Font.Arial
button1Description.TextSize = 14
button1Description.TextColor3 = Color3.fromRGB(255, 255, 255)
button1Description.TextXAlignment = Enum.TextXAlignment.Left
button1.MouseButton1Click:Connect(function()
for k, v in pairs(defaultConfig) do
config[k] = v
end
toggle1Button.Text = "WallCheck: " .. (config.wallCheck and "On" or "Off")
toggle2Button.Text = "Friend Check: " .. (config.friendCheck and "On" or "Off")
toggle3Button.Text = "AliveCheck: " .. (config.aliveCheck and "On" or "Off")
toggle4Button.Text = "NPCCheck: " .. (config.npcCheck and "On" or "Off")
toggle5Button.Text = "HealthCheck: " .. (config.healthCheck and "On" or "Off")
toggle6Button.Text = "CooldownCheck: " .. (config.cooldownCheck and "On" or "Off")
toggle7Button.Text = "FOV Circle: " .. (config.fovCircle and "On" or "Off")
fovCircle.Visible = config.fovCircle
slider1Label.Text = "FOV Radius: " .. config.fovRadius
slider1Fill.Size = UDim2.new((config.fovRadius - 1) / 99, 0, 1, 0)
slider1Knob.Position = UDim2.new((config.fovRadius - 1) / 99, -10, 0.5, -10)
fovCircle.Size = UDim2.new(0, config.fovRadius * 2, 0, config.fovRadius * 2)
fovCircle.Position = UDim2.new(0.5, -config.fovRadius, 0.5, -config.fovRadius)
slider2Label.Text = "FOV Transparency: " .. config.fovTransparency
slider2Fill.Size = UDim2.new((config.fovTransparency - 1) / 99, 0, 1, 0)
slider2Knob.Position = UDim2.new((config.fovTransparency - 1) / 99, -10, 0.5, -10)
fovCircle.BackgroundTransparency = config.fovTransparency / 100
toggle8Button.Text = "ESP Target: " .. (config.espTarget and "On" or "Off")
toggle9Button.Text = "ESP Target Name: " .. (config.espTargetName and "On" or "Off")
toggle10Button.Text = "ESPHiddenPlayers: " .. (config.espHiddenPlayers and "On" or "Off")
toggle11Button.Text = "ESPHiddenPlayersName: " .. (config.espHiddenPlayersName and "On" or "Off")
dropdown1Button.Text = "Lock Mode: " .. config.lockMode
updateMainLabel()
dropdown2Button.Text = "LockStyle: " .. config.lockStyle
dropdown3Button.Text = "AimPart: " .. config.aimPart
textbox1.Text = config.keybind
textbox2.Text = tostring(config.maxDistance)
animateGradient(button1UIGradient)
animateButton(button1)
saveConfig()
end)
button1.MouseEnter:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(button1, tweenInfo, {BackgroundTransparency = 0.1}):Play()
end)
button1.MouseLeave:Connect(function()
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(button1, tweenInfo, {BackgroundTransparency = 0}):Play()
end)
uiListLayout.Changed:Connect(function(prop)
if prop == "AbsoluteContentSize" then
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
end
end)
RunService.Heartbeat:Connect(function()
for _, player in ipairs(Players:GetPlayers()) do
if player == LocalPlayer then
continue
end
local char = player.Character
if not char then
if espHiddenHighlights[player] then
espHiddenHighlights[player]:Destroy()
espHiddenHighlights[player] = nil
end
continue
end
local part = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
if not part then
continue
end
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait(), Camera}
local direction = (part.Position - Camera.CFrame.Position)
local rayResult = Workspace:Raycast(Camera.CFrame.Position, direction, rayParams)
local isHidden = true
if rayResult then
if rayResult.Instance:IsDescendantOf(char) then
isHidden = false
end
end
if config.espHiddenPlayers then
if isHidden then
if not espHiddenHighlights[player] then
espHiddenHighlights[player] = Instance.new("Highlight")
espHiddenHighlights[player].Parent = char
espHiddenHighlights[player].FillTransparency = 0.5
espHiddenHighlights[player].OutlineTransparency = 0
espHiddenHighlights[player].FillColor = Color3.fromRGB(0, 255, 0)
espHiddenHighlights[player].OutlineColor = Color3.fromRGB(255, 255, 255)
end
else
if espHiddenHighlights[player] then
espHiddenHighlights[player]:Destroy()
espHiddenHighlights[player] = nil
end
end
else
if espHiddenHighlights[player] then
espHiddenHighlights[player]:Destroy()
espHiddenHighlights[player] = nil
end
end
if config.espHiddenPlayersName then
if isHidden then
local head = char:FindFirstChild("Head")
if head then
if not head:FindFirstChild("HiddenNameESP") then
local bg = Instance.new("BillboardGui")
bg.Name = "HiddenNameESP"
bg.Parent = head
bg.Size = UDim2.new(0, 200, 0, 50)
bg.StudsOffset = Vector3.new(0, 3, 0)
bg.AlwaysOnTop = true
local tl = Instance.new("TextLabel")
tl.Parent = bg
tl.Size = UDim2.new(1, 0, 1, 0)
tl.BackgroundTransparency = 1
tl.Text = player.Name
tl.TextColor3 = Color3.fromRGB(255, 255, 255)
tl.TextSize = 16
tl.Font = Enum.Font.ArialBold
tl.TextStrokeTransparency = 0.5
end
end
else
local head = char:FindFirstChild("Head")
if head and head:FindFirstChild("HiddenNameESP") then
head.HiddenNameESP:Destroy()
end
end
else
local head = char:FindFirstChild("Head")
if head and head:FindFirstChild("HiddenNameESP") then
head.HiddenNameESP:Destroy()
end
end
end
end)
LocalPlayer.CharacterAdded:Connect(function(newChar)
wait(0.5)
if isOn then
if targetPlayer then
targetChar = targetPlayer.Character
end
end
end)
updateMainLabel()