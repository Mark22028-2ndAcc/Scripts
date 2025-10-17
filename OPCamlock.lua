-- Clean up previous instance
if getgenv and getgenv().CamlockDisconnect then
	pcall(function()
		getgenv().CamlockDisconnect()
	end)
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local SPECIAL_GAME_ID = 10449761463
local isSpecialGame = game.PlaceId == SPECIAL_GAME_ID

-- Character update on respawn
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	wait(1)
	if getgenv().CamlockUI then
		getgenv().CamlockUI.Parent = player:WaitForChild("PlayerGui")
		getgenv().CamlockUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
	end
end)

-- State
local camLocked = false
local lockedTarget = nil
local silentAim = false
local keybind = Enum.KeyCode.C
local aimSpeed = 0.67
local lockingMode = "Fast"
local customMode = false

-- Locking mode configurations
local lockingModes = {
	Legit = {speed = 0.25, instant = false, name = "Legit"},
	Fast = {speed = 0.67, instant = false, name = "Fast"},
	Rage = {speed = 6.7, instant = true, name = "Rage"},
	Custom = {speed = 0.45, instant = false, name = "Custom"}
}

-- Drag vars
local isDragging = false
local dragging = false
local dragStart, startPos
local dragTween = nil

-- Cleanup UI if exists
if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("CamlockUI") then
	player.PlayerGui.CamlockUI:Destroy()
end

-- UI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CamlockUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = player:WaitForChild("PlayerGui")
getgenv().CamlockUI = screenGui

local camlockButton = Instance.new("TextButton")
camlockButton.Size = UDim2.new(0, 160, 0, 50)
camlockButton.Position = UDim2.new(0.5, -80, 0, -100)
camlockButton.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
camlockButton.TextColor3 = Color3.new(1, 1, 1)
camlockButton.Text = "Camlock: Off"
camlockButton.Font = Enum.Font.GothamBold
camlockButton.TextSize = 18
camlockButton.BorderSizePixel = 0
camlockButton.AutoButtonColor = true
camlockButton.ZIndex = 10
camlockButton.Parent = screenGui

local gradient = Instance.new("UIGradient", camlockButton)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 150, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(143, 0, 255)),
})
gradient.Rotation = 45

local corner = Instance.new("UICorner", camlockButton)
corner.CornerRadius = UDim.new(0, 12)

-- Credit label
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(0, 300, 0, 40)
creditLabel.Position = UDim2.new(0.5, -150, 0, 20)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.fromRGB(143, 0, 255)
creditLabel.Text = "By Mark22028"
creditLabel.Font = Enum.Font.GothamBold
creditLabel.TextSize = 28
creditLabel.TextTransparency = 1
creditLabel.TextStrokeTransparency = 1
creditLabel.TextStrokeColor3 = Color3.fromRGB(200, 150, 255)
creditLabel.ZIndex = 10
creditLabel.Parent = screenGui

local creditGradient = gradient:Clone()
creditGradient.Parent = creditLabel

-- V4 label
local v4Label = Instance.new("TextLabel")
v4Label.Size = UDim2.new(0, 300, 0, 35)
v4Label.Position = UDim2.new(0.5, -150, 0, 65)
v4Label.BackgroundTransparency = 1
v4Label.TextColor3 = Color3.fromRGB(143, 0, 255)
v4Label.Text = "V4"
v4Label.Font = Enum.Font.GothamBold
v4Label.TextSize = 24
v4Label.TextTransparency = 1
v4Label.TextStrokeTransparency = 1
v4Label.TextStrokeColor3 = Color3.fromRGB(200, 150, 255)
v4Label.ZIndex = 10
v4Label.Parent = screenGui

local v4Gradient = gradient:Clone()
v4Gradient.Parent = v4Label

-- Minimize/Maximize arrow for keybind
local keybindArrow = Instance.new("TextButton")
keybindArrow.Size = UDim2.new(0, 20, 0, 20)
keybindArrow.Position = UDim2.new(0.5, -10, 0, -60)
keybindArrow.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
keybindArrow.TextColor3 = Color3.new(1, 1, 1)
keybindArrow.Text = "^"
keybindArrow.Font = Enum.Font.GothamBold
keybindArrow.TextSize = 16
keybindArrow.BorderSizePixel = 0
keybindArrow.AutoButtonColor = false
keybindArrow.ZIndex = 10
keybindArrow.Parent = camlockButton

local keybindArrowCorner = Instance.new("UICorner", keybindArrow)
keybindArrowCorner.CornerRadius = UDim.new(1, 0)

local keybindArrowGrad = gradient:Clone()
keybindArrowGrad.Parent = keybindArrow

-- Dropdown arrow button
local dropdownArrow = Instance.new("TextButton")
dropdownArrow.Size = UDim2.new(0, 24, 0, 24)
dropdownArrow.Position = UDim2.new(0, -29, 0, 0)
dropdownArrow.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
dropdownArrow.TextColor3 = Color3.new(1, 1, 1)
dropdownArrow.Text = "▼"
dropdownArrow.Font = Enum.Font.GothamBold
dropdownArrow.TextSize = 14
dropdownArrow.BorderSizePixel = 0
dropdownArrow.AutoButtonColor = false
dropdownArrow.ZIndex = 10
dropdownArrow.Parent = camlockButton

local dropdownCorner = Instance.new("UICorner", dropdownArrow)
dropdownCorner.CornerRadius = UDim.new(1, 0)

local dropdownArrowGrad = gradient:Clone()
dropdownArrowGrad.Parent = dropdownArrow

-- Dropdown menu frame
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0, 160, 0, 0)
dropdownFrame.Position = UDim2.new(0, -29, 0, -5)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false
dropdownFrame.ClipsDescendants = true
dropdownFrame.ZIndex = 11
dropdownFrame.Parent = camlockButton

local dropdownFrameCorner = Instance.new("UICorner", dropdownFrame)
dropdownFrameCorner.CornerRadius = UDim.new(0, 12)

local dropdownGradient = gradient:Clone()
dropdownGradient.Parent = dropdownFrame

-- Custom speed textbox
local customSpeedBox = Instance.new("TextBox")
customSpeedBox.Size = UDim2.new(0, 20, 0, 20)
customSpeedBox.Position = UDim2.new(0, -27, 0, 27)
customSpeedBox.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
customSpeedBox.TextColor3 = Color3.new(1, 1, 1)
customSpeedBox.PlaceholderText = "0.45"
customSpeedBox.Text = "0.45"
customSpeedBox.Font = Enum.Font.GothamBold
customSpeedBox.TextSize = 11
customSpeedBox.BorderSizePixel = 0
customSpeedBox.ClearTextOnFocus = true
customSpeedBox.Visible = false
customSpeedBox.ZIndex = 10
customSpeedBox.Parent = camlockButton

local customSpeedGradient = gradient:Clone()
customSpeedGradient.Parent = customSpeedBox

local customSpeedCorner = Instance.new("UICorner", customSpeedBox)
customSpeedCorner.CornerRadius = UDim.new(0, 8)

-- Dropdown options
local function createOption(name, position, isSelected)
	local option = Instance.new("TextButton")
	option.Size = UDim2.new(1, -10, 0, 35)
	option.Position = UDim2.new(0, 5, 0, position)
	option.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
	option.TextColor3 = Color3.new(1, 1, 1)
	option.Text = name
	option.Font = Enum.Font.GothamBold
	option.TextSize = 14
	option.BorderSizePixel = 0
	option.AutoButtonColor = false
	option.ZIndex = 12
	option.Parent = dropdownFrame
	
	local optionCorner = Instance.new("UICorner", option)
	optionCorner.CornerRadius = UDim.new(0, 8)
	
	local optionGrad = gradient:Clone()
	optionGrad.Parent = option
	
	if isSelected then
		option.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
	end
	
	return option
end

local customOption = createOption("Custom", 5, false)
local legitOption = createOption("Smooth", 45, false)
local fastOption = createOption("Fast", 85, true)
local rageOption = createOption("Instant", 125, false)

-- Function to update selected option
local function updateSelectedOption(selected)
	if selected == "Custom" then
		customOption.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
		legitOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		fastOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		rageOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		customMode = true
		customSpeedBox.Visible = true
	elseif selected == "Legit" then
		customOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		legitOption.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
		fastOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		rageOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		customMode = false
		customSpeedBox.Visible = false
	elseif selected == "Fast" then
		customOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		legitOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		fastOption.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
		rageOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		customMode = false
		customSpeedBox.Visible = false
	elseif selected == "Rage" then
		customOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		legitOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		fastOption.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
		rageOption.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
		customMode = false
		customSpeedBox.Visible = false
	end
	
	lockingMode = selected
	local config = lockingModes[selected]
	aimSpeed = config.speed
	aimSpeedBox.Text = tostring(config.speed)
end

-- Custom option click handler
customOption.MouseButton1Click:Connect(function()
	updateSelectedOption("Custom")
	
	TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 160, 0, 0),
		Position = UDim2.new(0, -29, 0, -5)
	}):Play()
	
	TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, -29, 0, 0)
	}):Play()
	
	dropdownOpen = false
	wait(0.3)
	dropdownFrame.Visible = false
	dropdownArrow.Text = "▼"
end)

-- Option click handlers
legitOption.MouseButton1Click:Connect(function()
	updateSelectedOption("Legit")
	
	TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 160, 0, 0),
		Position = UDim2.new(0, -29, 0, -5)
	}):Play()
	
	TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, -29, 0, 0)
	}):Play()
	
	dropdownOpen = false
	wait(0.3)
	dropdownFrame.Visible = false
	dropdownArrow.Text = "▼"
end)

fastOption.MouseButton1Click:Connect(function()
	updateSelectedOption("Fast")
	
	TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 160, 0, 0),
		Position = UDim2.new(0, -29, 0, -5)
	}):Play()
	
	TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, -29, 0, 0)
	}):Play()
	
	dropdownOpen = false
	wait(0.3)
	dropdownFrame.Visible = false
	dropdownArrow.Text = "▼"
end)

rageOption.MouseButton1Click:Connect(function()
	updateSelectedOption("Rage")
	
	TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 160, 0, 0),
		Position = UDim2.new(0, -29, 0, -5)
	}):Play()
	
	TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, -29, 0, 0)
	}):Play()
	
	dropdownOpen = false
	wait(0.3)
	dropdownFrame.Visible = false
	dropdownArrow.Text = "▼"
end)

-- Custom speed box handler
customSpeedBox.FocusLost:Connect(function()
	local val = tonumber(customSpeedBox.Text)
	if val then
		lockingModes.Custom.speed = val
		aimSpeed = val
	else
		customSpeedBox.Text = tostring(lockingModes.Custom.speed)
	end
end)

-- Dropdown toggle
local dropdownOpen = false
dropdownArrow.MouseButton1Click:Connect(function()
	dropdownOpen = not dropdownOpen
	dropdownArrow.Text = dropdownOpen and "▲" or "▼"
	
	if dropdownOpen then
		dropdownFrame.Visible = true
		
		TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 160, 0, 160),
			Position = UDim2.new(0, -29, 0, -165)
		}):Play()
		
		TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, -29, 0, -190)
		}):Play()
	else
		TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 160, 0, 0),
			Position = UDim2.new(0, -29, 0, -5)
		}):Play()
		
		TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, -29, 0, 0)
		}):Play()
		
		wait(0.3)
		dropdownFrame.Visible = false
	end
end)

-- Arrow toggle for Silent Aim
local arrowBox = Instance.new("TextButton")
arrowBox.Size = UDim2.new(0, 24, 0, 24)
arrowBox.Position = UDim2.new(1, 5, 0.5, -12)
arrowBox.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
arrowBox.TextColor3 = Color3.new(1, 1, 1)
arrowBox.Text = "⇋"
arrowBox.Font = Enum.Font.GothamBold
arrowBox.TextSize = 16
arrowBox.BorderSizePixel = 0
arrowBox.AutoButtonColor = false
arrowBox.ZIndex = 10
arrowBox.Parent = camlockButton

local arrowCorner = Instance.new("UICorner", arrowBox)
arrowCorner.CornerRadius = UDim.new(1, 0)

-- Aim Speed TextBox
local aimSpeedBox = Instance.new("TextBox")
aimSpeedBox.Size = UDim2.new(0, 85, 0, 30)
aimSpeedBox.Position = UDim2.new(0.5, -42, 1, 5)
aimSpeedBox.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
aimSpeedBox.TextColor3 = Color3.new(1, 1, 1)
aimSpeedBox.PlaceholderText = "0.65"
aimSpeedBox.Text = "0.65"
aimSpeedBox.Font = Enum.Font.GothamBold
aimSpeedBox.TextSize = 14
aimSpeedBox.BorderSizePixel = 0
aimSpeedBox.ClearTextOnFocus = true
aimSpeedBox.Visible = false
aimSpeedBox.ZIndex = 10
aimSpeedBox.Parent = camlockButton

local aimGradient = gradient:Clone()
aimGradient.Parent = aimSpeedBox

local aimCorner = Instance.new("UICorner", aimSpeedBox)
aimCorner.CornerRadius = UDim.new(0, 18)

-- Keybind TextBox
local keybindBox = Instance.new("TextBox")
keybindBox.Size = UDim2.new(0, 85, 0, 30)
keybindBox.Position = UDim2.new(0.5, -42, 0, -35)
keybindBox.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
keybindBox.TextColor3 = Color3.new(1, 1, 1)
keybindBox.PlaceholderText = "Keybind"
keybindBox.Text = "C"
keybindBox.Font = Enum.Font.GothamBold
keybindBox.TextSize = 14
keybindBox.BorderSizePixel = 0
keybindBox.ClearTextOnFocus = false
keybindBox.ZIndex = 10
keybindBox.Parent = camlockButton

local keybindGradient = gradient:Clone()
keybindGradient.Parent = keybindBox

local keybindCorner = Instance.new("UICorner", keybindBox)
keybindCorner.CornerRadius = UDim.new(0, 18)

-- Keybind minimize state
local keybindMinimized = false

-- Keybind arrow toggle with smooth animation
keybindArrow.MouseButton1Click:Connect(function()
	keybindMinimized = not keybindMinimized
	keybindArrow.Text = keybindMinimized and "v" or "^"
	
	local arrowGoal = {
		Position = keybindMinimized and UDim2.new(0.5, -10, 0, -25) or UDim2.new(0.5, -10, 0, -60)
	}
	
	if keybindMinimized then
		TweenService:Create(keybindBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -42, 0, 10)}):Play()
		wait(0.15)
		keybindBox.Visible = false
	else
		keybindBox.Visible = true
		keybindBox.Position = UDim2.new(0.5, -42, 0, 10)
		TweenService:Create(keybindBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -42, 0, -35)}):Play()
	end
	
	TweenService:Create(keybindArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), arrowGoal):Play()
end)

-- Keybind change handler
keybindBox.FocusLost:Connect(function(enterPressed)
	local text = keybindBox.Text:upper()
	
	if text:len() == 1 and text:match("%a") then
		local keyCode = Enum.KeyCode[text]
		if keyCode then
			keybind = keyCode
			keybindBox.Text = text
		else
			keybindBox.Text = "C"
			keybind = Enum.KeyCode.C
		end
	else
		keybindBox.Text = "C"
		keybind = Enum.KeyCode.C
	end
end)

-- Expand/Minimize toggle button
local toggleArrow = Instance.new("TextButton")
toggleArrow.Size = UDim2.new(0, 20, 0, 20)
toggleArrow.Position = UDim2.new(0.5, -10, 1, 40)
toggleArrow.BackgroundColor3 = Color3.fromRGB(143, 0, 255)
toggleArrow.TextColor3 = Color3.new(1, 1, 1)
toggleArrow.Text = "^"
toggleArrow.Font = Enum.Font.GothamBold
toggleArrow.TextSize = 16
toggleArrow.BorderSizePixel = 0
toggleArrow.Visible = false
toggleArrow.ZIndex = 10
toggleArrow.Parent = camlockButton

local arrowGrad = gradient:Clone()
arrowGrad.Parent = toggleArrow

local toggleCorner = Instance.new("UICorner", toggleArrow)
toggleCorner.CornerRadius = UDim.new(1, 0)

local minimized = false

toggleArrow.MouseButton1Click:Connect(function()
	minimized = not minimized
	toggleArrow.Text = minimized and "v" or "^"
	
	local arrowGoal = {
		Position = minimized and UDim2.new(0.5, -10, 1, 5) or UDim2.new(0.5, -10, 1, 40)
	}
	
	if minimized then
		TweenService:Create(aimSpeedBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -42, 1, -30)}):Play()
		wait(0.15)
		aimSpeedBox.Visible = false
	else
		aimSpeedBox.Visible = true
		aimSpeedBox.Position = UDim2.new(0.5, -42, 1, -30)
		TweenService:Create(aimSpeedBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -42, 1, 5)}):Play()
	end
	
	TweenService:Create(toggleArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), arrowGoal):Play()
end)

-- Validate speed input
aimSpeedBox.FocusLost:Connect(function()
	local val = tonumber(aimSpeedBox.Text)
	if val then
		aimSpeed = val
		lockingModes[lockingMode].speed = val
	else
		aimSpeedBox.Text = tostring(lockingModes[lockingMode].speed)
		aimSpeed = lockingModes[lockingMode].speed
	end
end)

-- Drag logic with tween (fixed for mobile)
local dragInputConnection = nil
local dragInput = nil

camlockButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
		dragging = true
		dragInput = input
		dragStart = input.Position
		startPos = camlockButton.Position
		
		if dragTween then
			dragTween:Cancel()
		end
		
		if dragInputConnection then
			dragInputConnection:Disconnect()
		end
		
		dragInputConnection = UserInputService.InputChanged:Connect(function(input2)
			-- For touch: check if it's the same input. For mouse: just check movement type
			local isSameTouch = (input.UserInputType == Enum.UserInputType.Touch and input2 == dragInput)
			local isMouseMovement = (input.UserInputType == Enum.UserInputType.MouseButton1 and input2.UserInputType == Enum.UserInputType.MouseMovement)
			
			if dragging and (isSameTouch or isMouseMovement) then
				isDragging = true
				local delta = input2.Position - dragStart
				local newPos = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
				
				if dragTween then
					dragTween:Cancel()
				end
				dragTween = TweenService:Create(camlockButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = newPos
				})
				dragTween:Play()
			end
		end)
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				if dragging and input == dragInput then
					dragging = false
					dragInput = nil
					if dragInputConnection then
						dragInputConnection:Disconnect()
						dragInputConnection = nil
					end
				end
			end
		end)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if dragging and input == dragInput then
			dragging = false
			dragInput = nil
			if dragInputConnection then
				dragInputConnection:Disconnect()
				dragInputConnection = nil
			end
		end
	end
end)

-- Initial animation
local introPlaying = true

spawn(function()
	TweenService:Create(camlockButton, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -80, 0.5, -25)
	}):Play()

	wait(0.6)

	TweenService:Create(creditLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0,
		TextStrokeTransparency = 0.5
	}):Play()

	wait(1)

	TweenService:Create(v4Label, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0,
		TextStrokeTransparency = 0.5
	}):Play()

	wait(8)

	TweenService:Create(v4Label, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -80, 0, 10),
		Size = UDim2.new(0, 60, 0, 20),
		TextSize = 14
	}):Play()

	wait(1)

	TweenService:Create(creditLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 1, TextStrokeTransparency = 1
	}):Play()
	
	wait(0.5)
	introPlaying = false
end)

-- Forgiving lock-on system
local function getClosestOnScreenTarget()
	local minDistance = 300
	local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	local closestTarget = nil

	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = targetPlayer.Character.HumanoidRootPart
			local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
			if onScreen then
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
				if distance < minDistance then
					minDistance = distance
					closestTarget = targetPlayer.Character
				end
			end
		end
	end

	if isSpecialGame then
		local weakestDummy = Workspace.Live:FindFirstChild("Weakest Dummy")
		if weakestDummy and weakestDummy:FindFirstChild("HumanoidRootPart") and weakestDummy:FindFirstChildOfClass("Humanoid") then
			local hrp = weakestDummy.HumanoidRootPart
			local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
			if onScreen then
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
				if distance < minDistance then
					minDistance = distance
					closestTarget = weakestDummy
				end
			end
		end
	else
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj:IsA("Model") and obj ~= character and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") then
				local hrp = obj.HumanoidRootPart
				local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
				if onScreen then
					local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
					if distance < minDistance then
						minDistance = distance
						closestTarget = obj
					end
				end
			end
		end
	end

	return closestTarget
end

-- Highlight logic
local currentHighlightTarget = nil
local currentHighlight = nil

local function updateHighlight(target)
	if target ~= currentHighlightTarget then
		if currentHighlight then
			currentHighlight:Destroy()
			currentHighlight = nil
		end
		currentHighlightTarget = target
		if target and target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") then
			local highlight = Instance.new("Highlight")
			highlight.Adornee = target
			highlight.Parent = target
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.FillColor = Color3.fromRGB(200, 150, 255)
			highlight.OutlineColor = Color3.fromRGB(143, 0, 255)
			highlight.FillTransparency = 0.7
			highlight.OutlineTransparency = 0.6
			currentHighlight = highlight
		end
	elseif not target then
		if currentHighlight then
			currentHighlight:Destroy()
			currentHighlight = nil
		end
		currentHighlightTarget = nil
	end
end

-- Toggle camlock function
local function toggleCamlock()
	if not introPlaying then
		camLocked = not camLocked
		if silentAim then
			camlockButton.Text = camLocked and "Aim: On" or "Aim: Off"
		else
			camlockButton.Text = camLocked and "Camlock: On" or "Camlock: Off"
		end
		if not camLocked then
			lockedTarget = nil
			updateHighlight(nil)
		end
	end
end

camlockButton.MouseButton1Click:Connect(function()
	if not isDragging and not introPlaying then
		toggleCamlock()
	end
end)

arrowBox.MouseButton1Click:Connect(function()
	if not introPlaying then
		silentAim = not silentAim
		local goal = {}
		if silentAim then
			goal.Position = UDim2.new(0, -29, 0.5, -12)
			
			TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 0, 0, 0)
			}):Play()
			
			if customMode then
				customSpeedBox.Visible = false
			end
			
			if dropdownOpen then
				TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 160, 0, 0),
					Position = UDim2.new(0, -29, 0, -5)
				}):Play()
				wait(0.3)
				dropdownFrame.Visible = false
			end
			
			wait(0.15)
			dropdownArrow.Visible = false
			
			aimSpeedBox.Visible = true
			aimSpeedBox.Position = UDim2.new(0.5, -42, 1, 40)
			TweenService:Create(aimSpeedBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, -42, 1, 5)
			}):Play()
			
			toggleArrow.Visible = true
			toggleArrow.Position = UDim2.new(0.5, -10, 1, 70)
			TweenService:Create(toggleArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, -10, 1, 40)
			}):Play()
			
		else
			goal.Position = UDim2.new(1, 5, 0.5, -12)
			
			if not minimized then
				TweenService:Create(aimSpeedBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, -42, 1, 40)
				}):Play()
			end
			
			TweenService:Create(toggleArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, -10, 1, 70)
			}):Play()
			
			wait(0.3)
			aimSpeedBox.Visible = false
			toggleArrow.Visible = false
			
			dropdownArrow.Visible = true
			dropdownArrow.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(dropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 24, 0, 24)
			}):Play()
			
			if customMode then
				customSpeedBox.Visible = true
			end
			
			if dropdownOpen then
				dropdownFrame.Visible = true
				dropdownFrame.Size = UDim2.new(0, 160, 0, 0)
				dropdownFrame.Position = UDim2.new(0, -29, 0, -5)
				TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 160, 0, 160),
					Position = UDim2.new(0, -29, 0, -165)
				}):Play()
			end
		end
		
		TweenService:Create(arrowBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
		camlockButton.Text = camLocked and (silentAim and "Aim: On" or "Camlock: On") or (silentAim and "Aim: Off" or "Camlock: Off")
	end
end)

-- Keybind to toggle Camlock
getgenv().CamlockKeyConn = UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == keybind and not introPlaying then
		toggleCamlock()
	end
end)

-- Keybind setter
getgenv().CamlockSetKeybind = function(newKey)
	if typeof(newKey) == "string" then
		local key = Enum.KeyCode[newKey:upper()]
		if key then
			keybind = key
			keybindBox.Text = key.Name
		end
	elseif typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
		keybind = newKey
		keybindBox.Text = newKey.Name
	end
end

-- Main Camlock loop
RunService:BindToRenderStep("CamlockStep", Enum.RenderPriority.Camera.Value + 1, function()
	if camLocked then
		if not lockedTarget then
			lockedTarget = getClosestOnScreenTarget()
		end

		if lockedTarget and lockedTarget:FindFirstChild("HumanoidRootPart") then
			updateHighlight(lockedTarget)
			local hrp = lockedTarget.HumanoidRootPart
			local config = lockingModes[lockingMode]

			if silentAim then
				local charHRP = character and character:FindFirstChild("HumanoidRootPart")
				if charHRP and character ~= lockedTarget then
					local lookPos = hrp.Position
					local charPos = charHRP.Position
					local direction = (lookPos - charPos)
					local targetCFrame = CFrame.new(charPos, charPos + Vector3.new(direction.X, 0, direction.Z))
					
					if config.instant then
						charHRP.CFrame = targetCFrame
					else
						charHRP.CFrame = charHRP.CFrame:Lerp(targetCFrame, config.speed)
					end
				end
			else
				if character ~= lockedTarget then
					local targetCFrame = CFrame.lookAt(camera.CFrame.Position, hrp.Position)
					
					if config.instant then
						camera.CFrame = targetCFrame
					else
						camera.CFrame = camera.CFrame:Lerp(targetCFrame, config.speed)
					end
				end
			end
		else
			lockedTarget = nil
			updateHighlight(nil)
		end
	else
		updateHighlight(nil)
	end
end)

-- Disconnect cleanup
getgenv().CamlockDisconnect = function()
	pcall(function()
		RunService:UnbindFromRenderStep("CamlockStep")
	end)
	pcall(function()
		if getgenv().CamlockKeyConn then
			getgenv().CamlockKeyConn:Disconnect()
			getgenv().CamlockKeyConn = nil
		end
	end)
	pcall(function()
		if dragInputConnection then
			dragInputConnection:Disconnect()
			dragInputConnection = nil
		end
	end)
	pcall(function()
		if getgenv().CamlockUI then
			getgenv().CamlockUI:Destroy()
			getgenv().CamlockUI = nil
		end
	end)
	updateHighlight(nil)
end