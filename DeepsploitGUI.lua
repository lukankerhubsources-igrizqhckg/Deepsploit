local ModuleVersion = 'v1.14'

local lukanker = {}

local UIS = game:GetService('UserInputService')

local Player = game.Players.LocalPlayer

local Window
local Sections = {}

local DragMousePosition
local FramePosition
local Dragging = false

function lukanker.New()
	Window = CreateWindowUI()
	local Menu = Window.Menu

	Menu.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true

			DragMousePosition = Vector2.new(Input.Position.X, Input.Position.Y)
			FramePosition = Vector2.new(Menu.Position.X.Offset, Menu.Position.Y.Offset)
		end
	end)

	Menu.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(Input)
		if Dragging then
			local NewPosition = FramePosition + ((Vector2.new(Input.Position.X, Input.Position.Y) - DragMousePosition))
			Menu.Position = UDim2.new(0, NewPosition.X, 0, NewPosition.Y)
		end
	end)

	return lukanker
end

function lukanker:NewSection(Name)
	if not Window then return end

	local Sections = {}

	local Section = CreateSectionUI(Name)
	local SectionButton = CreateSectionButtonUI(Name)

	SectionButton.MouseButton1Click:Connect(function()
		for i, SectionObject in pairs(Window.Menu.Sections:GetChildren()) do
			SectionObject.Visible = false
			Section.Visible = true
		end
	end)


	table.insert(Sections, Section)

	function Sections:CreateTab(Name)
		local Tabs = {}

		local Tab = CreateTabUI(Section, Name)

		table.insert(Tabs, Tab)

		function Tabs:CreateToggle(Name, DefaultValue, Key, callback)
			local Toggle = CreateToggleButtonUI(Tab, Name)
			local State = DefaultValue

			if State then
				Toggle.BackgroundColor3 = Color3.new(0.560784, 0.835294, 0.745098)
			else
				Toggle.BackgroundColor3 = Color3.new(0.34902, 0.47451, 0.466667)
			end

			callback(State)

			Toggle.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					State = not State

					if State then
						Toggle.BackgroundColor3 = Color3.new(0.560784, 0.835294, 0.745098)
					else
						Toggle.BackgroundColor3 = Color3.new(0.34902, 0.47451, 0.466667)
					end
					print('CLICKED ', Name)
					callback(State)
				end
			end)

			UIS.InputBegan:Connect(function(Input, IsTyping)
				if IsTyping then return end
				if Input.KeyCode == Enum.KeyCode[Key] and Key then
					State = not State

					if State then
						Toggle.BackgroundColor3 = Color3.new(0.560784, 0.835294, 0.745098)
					else
						Toggle.BackgroundColor3 = Color3.new(0.34902, 0.47451, 0.466667)
					end

					print('KEYBIND CLICK ', Name)
					callback(State)
				end
			end)
		end
		
		function Tabs:CreateUseButton(Name, Key, callback)
			local UseButton = CreateUseButtonUI(Tab, Name)

			UseButton.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					print('CLICKED ', Name)
					callback()
				end
			end)
			
			UIS.InputBegan:Connect(function(Input, IsTyping)
				if IsTyping then return end
				if Input.KeyCode == Enum.KeyCode[Key] and Key then
					print('KEYBIND CLICK ', Name)
					callback()
				end
			end)
		end

		function Tabs:CreateSlider(DefaultValue, Max, callback)
			local Cursor = CreateSliderUI(Tab)
			local Slider = Cursor.Parent
			local TextLabel = Slider.Number
			local DraggingSlider = false

			TextLabel.Text = DefaultValue
			Cursor.Position = UDim2.new(DefaultValue / Max, 0, Cursor.Position.Y.Scale, Cursor.Position.Y.Offset)

			callback(DefaultValue)

			Cursor.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					DraggingSlider = true
				end
			end)

			Cursor.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					DraggingSlider = false
				end
			end)

			UIS.InputChanged:Connect(function(Input)
				if DraggingSlider then
					local MousePos = UIS:GetMouseLocation().X
					local Position = Snap((MousePos - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 1 / Max)
					local Percentage = math.clamp(Position, 0, 1)
					local Value = math.round(Percentage * Max)

					TextLabel.Text = Value
					Cursor.Position = UDim2.new(Percentage, 0, Cursor.Position.Y.Scale, Cursor.Position.Y.Offset)

					callback(Value)
				end
			end)
		end

		return Tabs
	end


	return Sections
end

function CreateWindowUI()
	Window = Instance.new("ScreenGui")
	Window.Parent = game.Players.LocalPlayer.PlayerGui
	Window.Name = "Window"
	Window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Menu = Instance.new("Frame")
	Menu.Parent = Window
	Menu.AnchorPoint = Vector2.new(0.5, 0.5)
	Menu.BackgroundColor3 = Color3.new(1, 1, 1)
	Menu.BackgroundTransparency = 1
	Menu.Name = "Menu"
	Menu.Position = UDim2.new(0, 500, 0, 500)
	Menu.Size = UDim2.new(1, 0, 0.400000006, 0)

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = Menu
	UIAspectRatioConstraint.AspectRatio = 1.2000000476837158
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height

	local UISizeConstraint = Instance.new("UISizeConstraint")
	UISizeConstraint.Parent = Menu
	UISizeConstraint.MinSize = Vector2.new(500, 500)

	local Pipe = Instance.new("ImageLabel")
	Pipe.Parent = Menu
	Pipe.BackgroundColor3 = Color3.new(1, 1, 1)
	Pipe.BackgroundTransparency = 1
	Pipe.BorderSizePixel = 0
	Pipe.Image = "http://www.roblox.com/asset/?id=5035647017"
	Pipe.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Pipe.Name = "Pipe"
	Pipe.Position = UDim2.new(0, 0, 0, 30)
	Pipe.Size = UDim2.new(1, 0, 0, 5)

	local Overlay = Instance.new("ImageLabel")
	Overlay.Parent = Menu
	Overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay.BackgroundTransparency = 1
	Overlay.BorderSizePixel = 0
	Overlay.Image = "http://www.roblox.com/asset/?id=4280422108"
	Overlay.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay.Name = "Overlay"
	Overlay.Position = UDim2.new(0, -3, 0, -3)
	Overlay.ScaleType = Enum.ScaleType.Slice
	Overlay.Size = UDim2.new(1, 6, 1, 6)
	Overlay.SliceCenter = Rect.new(14, 14, 18, 18)
	Overlay.ZIndex = 2

	local SectionsFolder = Instance.new('Folder')
	SectionsFolder.Parent = Menu
	SectionsFolder.Name = 'Sections'

	local TabFrame = Instance.new("Frame")
	TabFrame.Parent = Menu
	TabFrame.BackgroundColor3 = Color3.new(0.266667, 0.286275, 0.301961)
	TabFrame.BorderSizePixel = 0
	TabFrame.Name = "TabFrame"
	TabFrame.Size = UDim2.new(1, 0, 0, 32)
	TabFrame.ZIndex = 0

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = TabFrame
	UIPadding.PaddingBottom = UDim.new(0, 4)
	UIPadding.PaddingLeft = UDim.new(0, 4)
	UIPadding.PaddingRight = UDim.new(0, 4)
	UIPadding.PaddingTop = UDim.new(0, 4)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = TabFrame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	return Window
end

function CreateSectionUI(Name)
	local Section = Instance.new("Frame")
	Section.Parent = Window.Menu.Sections
	Section.AnchorPoint = Vector2.new(0.5, 1)
	Section.BackgroundColor3 = Color3.new(0.231373, 0.243137, 0.262745)
	Section.BackgroundTransparency = 0.10000000149011612
	Section.BorderSizePixel = 0
	Section.LayoutOrder = 5
	Section.Name = Name
	Section.Position = UDim2.new(0.5, 0, 1, 0)
	Section.Size = UDim2.new(1, 0, 1, -34)
	Section.ZIndex = 0

	local Background = Instance.new("ImageLabel")
	Background.Parent = Section
	Background.BackgroundColor3 = Color3.new(1, 1, 1)
	Background.BackgroundTransparency = 1
	Background.BorderColor3 = Color3.new(0, 0, 0)
	Background.BorderSizePixel = 0
	Background.Image = "http://www.roblox.com/asset/?id=4280494932"
	Background.ImageColor3 = Color3.new(0.0156863, 0.0196078, 0.0235294)
	Background.ImageTransparency = 0.8700000047683716
	Background.Name = "Background"
	Background.ScaleType = Enum.ScaleType.Tile
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.TileSize = UDim2.new(0, 32, 0, 32)
	Background.ZIndex = 0

	local Settings = Instance.new("ScrollingFrame")
	Settings.Parent = Section
	Settings.Active = true
	Settings.BackgroundColor3 = Color3.new(0.588235, 0.576471, 0.517647)
	Settings.Name = "Settings"
	Settings.Position = UDim2.new(0, 0, 0, -1)
	Settings.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	Settings.ScrollBarImageTransparency = 1
	Settings.ScrollBarThickness = 0
	Settings.ScrollingDirection = Enum.ScrollingDirection.Y
	Settings.Size = UDim2.new(1, 0, 1, 2)

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = Settings
	UIPadding.PaddingBottom = UDim.new(0, 8)
	UIPadding.PaddingLeft = UDim.new(0, 8)
	UIPadding.PaddingRight = UDim.new(0, 8)
	UIPadding.PaddingTop = UDim.new(0, 8)

	local UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.Parent = Settings
	UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
	UIGridLayout.CellSize = UDim2.new(0.33, -4, 0.33, 0)
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	return Section
end

function CreateSectionButtonUI(Name)
	local Button = Instance.new("TextButton")
	Button.Parent = Window.Menu.TabFrame
	Button.AutoButtonColor = false
	Button.BackgroundColor3 = Color3.new(0.34902, 0.47451, 0.466667)
	Button.BorderSizePixel = 0
	Button.LayoutOrder = 1
	Button.Name = Name
	Button.Position = UDim2.new(0, 58, 0, 4)
	Button.Size = UDim2.new(0, 70, 0, 24)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.TextSize = 8
	Button.Text = Name
	Button.TextStrokeTransparency = 0.6000000238418579
	Button.TextWrapped = true
	Button.Font = Enum.Font.Legacy

	local Overlay = Instance.new("ImageLabel")
	Overlay.Parent = Button
	Overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay.BackgroundTransparency = 1
	Overlay.BorderSizePixel = 0
	Overlay.Image = "http://www.roblox.com/asset/?id=4645592841"
	Overlay.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay.Name = "Overlay"
	Overlay.Position = UDim2.new(0, -1, 0, -1)
	Overlay.ScaleType = Enum.ScaleType.Slice
	Overlay.Size = UDim2.new(1, 2, 1, 2)
	Overlay.SliceCenter = Rect.new(8, 8, 8, 8)

	return Button
end

function CreateTabUI(Section, Name)
	local Tab = Instance.new("Frame")
	Tab.Parent = Section.Settings
	Tab.BackgroundColor3 = Color3.new(0.898039, 0.878431, 0.792157)
	Tab.BorderSizePixel = 0
	Tab.LayoutOrder = 3
	Tab.Name = Name
	Tab.Size = UDim2.new(0.5, -5, 0, 150)

	local Title = Instance.new("TextLabel")
	Title.Parent = Tab
	Title.BackgroundColor3 = Color3.new(1, 1, 1)
	Title.BackgroundTransparency = 1
	Title.Name = "Title"
	Title.Position = UDim2.new(0, 10, 0, 5)
	Title.Size = UDim2.new(1, -20, 0, 20)
	Title.Text = Name
	Title.TextColor3 = Color3.new(0.109804, 0.141176, 0.137255)
	Title.TextSize = 10
	Title.TextStrokeColor3 = Color3.new(0.133333, 0.133333, 0.14902)
	Title.TextTransparency = 0.1
	Title.TextWrapped = true
	Title.Font = Enum.Font.Legacy
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 2

	local Overlay = Instance.new("ImageLabel")
	Overlay.Parent = Tab
	Overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay.BackgroundTransparency = 1
	Overlay.BorderSizePixel = 0
	Overlay.ClipsDescendants = true
	Overlay.Image = "http://www.roblox.com/asset/?id=4317984371"
	Overlay.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay.Name = "Overlay"
	Overlay.Position = UDim2.new(0, -3, 0, -3)
	Overlay.ScaleType = Enum.ScaleType.Slice
	Overlay.Size = UDim2.new(1, 6, 1, 6)
	Overlay.SliceCenter = Rect.new(10, 10, 14, 14)
	Overlay.ZIndex = 3

	local ScrollingFrame = Instance.new("ScrollingFrame")
	ScrollingFrame.Parent = Tab
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
	ScrollingFrame.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	ScrollingFrame.ScrollBarImageTransparency = 1
	ScrollingFrame.ScrollBarThickness = 0
	ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = ScrollingFrame
	UIListLayout.Padding = UDim.new(0, 2)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	return Tab
end

function CreateToggleButtonUI(Tab, Name)
	local Toggle = Instance.new("Frame")
	Toggle.Parent = Tab.ScrollingFrame
	Toggle.AnchorPoint = Vector2.new(0.5, 0.5)
	Toggle.BackgroundColor3 = Color3.new(1, 1, 1)
	Toggle.BackgroundTransparency = 1
	Toggle.Name = "Toggle"
	Toggle.Position = UDim2.new(0.5, 0, 0.349999994, 0)
	Toggle.Size = UDim2.new(0, 285, 0, 30)

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = Toggle
	TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.Legacy
	TextLabel.Position = UDim2.new(0, 35, 0, 0)
	TextLabel.Size = UDim2.new(0, 285, 0, 30)
	TextLabel.Text = Name
	TextLabel.TextColor3 = Color3.new(0, 0, 0)
	TextLabel.TextTransparency = 0.1
	TextLabel.TextSize = 10
	TextLabel.TextWrapped = true
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Parent = Toggle
	ToggleButton.AutoButtonColor = false
	ToggleButton.BackgroundColor3 = Color3.new(0.34902, 0.47451, 0.466667)
	ToggleButton.BorderSizePixel = 0
	ToggleButton.LayoutOrder = 1
	ToggleButton.Name = "Toggle"
	ToggleButton.Position = UDim2.new(0, 10, 0, 5)
	ToggleButton.Size = UDim2.new(0, 18, 0, 18)
	ToggleButton.Text = ""
	ToggleButton.TextColor3 = Color3.new(1, 1, 1)
	ToggleButton.TextSize = 14
	ToggleButton.TextStrokeTransparency = 0.6000000238418579
	ToggleButton.TextWrapped = true

	local Overlay = Instance.new("ImageLabel")
	Overlay.Parent = ToggleButton
	Overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay.BackgroundTransparency = 1
	Overlay.BorderSizePixel = 0
	Overlay.Image = "http://www.roblox.com/asset/?id=4645592841"
	Overlay.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay.Name = "Overlay"
	Overlay.Position = UDim2.new(0, -1, 0, -1)
	Overlay.ScaleType = Enum.ScaleType.Slice
	Overlay.Size = UDim2.new(1, 2, 1, 2)
	Overlay.SliceCenter = Rect.new(8, 8, 8, 8)

	return ToggleButton
end

function CreateSliderUI(Tab)
	local Slider = Instance.new("Frame")
	Slider.Parent = Tab.ScrollingFrame
	Slider.AnchorPoint = Vector2.new(0.5, 0.5)
	Slider.BackgroundColor3 = Color3.new(1, 1, 1)
	Slider.BackgroundTransparency = 1
	Slider.Name = "Slider"
	Slider.Position = UDim2.new(0.5, 0, 0.349999994, 0)
	Slider.Size = UDim2.new(1, 0, 0, 20)

	local SliderFrame = Instance.new("Frame")
	SliderFrame.Parent = Slider
	SliderFrame.AnchorPoint = Vector2.new(0, 0.5)
	SliderFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	SliderFrame.BackgroundTransparency = 0.5
	SliderFrame.BorderColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	SliderFrame.BorderSizePixel = 0
	SliderFrame.Name = "SliderFrame"
	SliderFrame.Position = UDim2.new(0, 12, 0, 2)
	SliderFrame.Size = UDim2.new(1, -80, 0, 4)

	local Overlay = Instance.new("ImageLabel")
	Overlay.Parent = SliderFrame
	Overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay.BackgroundTransparency = 1
	Overlay.BorderSizePixel = 0
	Overlay.Image = "rbxassetid://7070634111"
	Overlay.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay.Name = "Overlay"
	Overlay.Position = UDim2.new(0, -3, 0, -3)
	Overlay.ScaleType = Enum.ScaleType.Slice
	Overlay.Size = UDim2.new(1, 6, 1, 6)
	Overlay.SliceCenter = Rect.new(5, 5, 5, 5)

	local Cursor = Instance.new("TextButton")
	Cursor.Parent = SliderFrame
	Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
	Cursor.BackgroundColor3 = Color3.new(0.25098, 0.313726, 0.298039)
	Cursor.BorderSizePixel = 0
	Cursor.Name = "Cursor"
	Cursor.Position = UDim2.new(0, 0, 0.5, 0)
	Cursor.Size = UDim2.new(0, 13, 0, 13)
	Cursor.Text = ""
	Cursor.TextColor3 = Color3.new(1, 1, 1)
	Cursor.TextSize = 14
	Cursor.TextStrokeTransparency = 0.6000000238418579
	Cursor.TextWrapped = true
	Cursor.ZIndex = 2

	local Overlay1 = Instance.new("ImageLabel")
	Overlay1.Parent = Cursor
	Overlay1.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay1.BackgroundTransparency = 1
	Overlay1.BorderSizePixel = 0
	Overlay1.Image = "rbxassetid://7070585107"
	Overlay1.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay1.Name = "Overlay"
	Overlay1.Position = UDim2.new(0, -2, 0, -2)
	Overlay1.ScaleType = Enum.ScaleType.Slice
	Overlay1.Size = UDim2.new(1, 4, 1, 4)
	Overlay1.SliceCenter = Rect.new(8, 8, 8, 8)
	Overlay1.ZIndex = 2

	local Number = Instance.new("TextLabel")
	Number.Parent = SliderFrame
	Number.Active = true
	Number.AnchorPoint = Vector2.new(0.5, 1)
	Number.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
	Number.BackgroundTransparency = 1
	Number.Name = "Number"
	Number.Position = UDim2.new(1, 32, 0, 12)
	Number.Selectable = true
	Number.Size = UDim2.new(0, 40, 0, 20)
	Number.Text = "1"
	Number.TextSize = 10
	Number.TextStrokeColor3 = Color3.new(0.203922, 0.243137, 0.258824)
	Number.TextTransparency = 0.1
	Number.Font = Enum.Font.Legacy
	Number.TextXAlignment = Enum.TextXAlignment.Center
	Number.ZIndex = 2

	local Overlay2 = Instance.new("ImageLabel")
	Overlay2.Parent = Number
	Overlay2.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay2.BackgroundTransparency = 1
	Overlay2.BorderSizePixel = 0
	Overlay2.Image = "http://www.roblox.com/asset/?id=4645592841"
	Overlay2.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay2.Name = "Overlay"
	Overlay2.Position = UDim2.new(0, -1, 0, -1)
	Overlay2.ScaleType = Enum.ScaleType.Slice
	Overlay2.Size = UDim2.new(1, 2, 1, 2)
	Overlay2.SliceCenter = Rect.new(8, 8, 8, 8)

	return Cursor
end

function CreateUseButtonUI(Tab, Name)
	local Use = Instance.new("Frame")
	Use.Parent = Tab.ScrollingFrame
	Use.AnchorPoint = Vector2.new(0.5, 0.5)
	Use.BackgroundColor3 = Color3.new(1, 1, 1)
	Use.BackgroundTransparency = 1
	Use.Name = "Use"
	Use.Position = UDim2.new(0.5, 0, 0.349999994, 0)
	Use.Size = UDim2.new(0, 285, 0, 30)

	local TextButton = Instance.new("TextButton")
	TextButton.Parent = Use
	TextButton.AutoButtonColor = false
	TextButton.BackgroundColor3 = Color3.new(0.34902, 0.47451, 0.466667)
	TextButton.BorderSizePixel = 0
	TextButton.LayoutOrder = 1
	TextButton.Name = Name
	TextButton.Position = UDim2.new(0, 10, 0, 5)
	TextButton.Size = UDim2.new(0, 70, 0, 24)
	TextButton.Text = Name
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.TextStrokeTransparency = 0.6000000238418579
	TextButton.TextWrapped = true

	local Overlay = Instance.new("ImageLabel")
	Overlay.Parent = TextButton
	Overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	Overlay.BackgroundTransparency = 1
	Overlay.BorderSizePixel = 0
	Overlay.Image = "http://www.roblox.com/asset/?id=4645592841"
	Overlay.ImageColor3 = Color3.new(0.717647, 0.772549, 0.827451)
	Overlay.Name = "Overlay"
	Overlay.Position = UDim2.new(0, -1, 0, -1)
	Overlay.ScaleType = Enum.ScaleType.Slice
	Overlay.Size = UDim2.new(1, 2, 1, 2)
	Overlay.SliceCenter = Rect.new(8, 8, 8, 8)
	
	return TextButton
end

function Snap(number, factor)
	if factor == 0 then
		return number
	else
		return math.floor(number/factor + 0.5) * factor
	end
end

return lukanker
