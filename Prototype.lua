-- v1.09
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local ScreenGui = LocalPlayer.PlayerGui:FindFirstChild('Window')

if ScreenGui then return end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lukankerhub/Deepsploit/main/DeepsploitGUI.lua?token=GHSAT0AAAAAAB7NC4CTWOE3CL3CQKALHGXQY76VSHA"))()

local Window = Library.New()
local DeepsploitSection = Window:NewSection('Deepsploit')
local CharacterSection = Window:NewSection('Character')
local LocalSection = Window:NewSection('Local')

local DiscordTab = DeepsploitSection:CreateTab('Discord')
local MovementTab = CharacterSection:CreateTab('Movement')
local CharacterMiscTab = CharacterSection:CreateTab('Misc')
local ESPTab = LocalSection:CreateTab('ESP')
local LocalMiscTab = LocalSection:CreateTab('Misc')

local UIS = game:GetService('UserInputService')
local SoundService = game:GetService('SoundService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')

local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Fly = false
local FlySpeed = 150

local Speed = false
local SpeedValue = 200

local ESP = false
local MobESP = false
local NPCESP = false
local ESPOptions = {
	Box = true,
	Name = true,
	HealthBar = true,
	Line = false
}
local ESPDistance = 2000

local NoClip = false
local KnockedOwnership = true
local NoFall = true
local ModAlert = true
local StreamerMode = true

local SelectedItem

local DeepID = 5212858
local FartID = 4809574295
local ModSoundID = 12564298961

local Controls = {
	['w'] = 0,
	['a'] = 0,
	['s'] = 0,
	['d'] = 0
}

function fly()
	if Fly then
		Character.HumanoidRootPart.Anchored = false

		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.Parent = Character.HumanoidRootPart
		BodyVelocity.MaxForce = Vector3.new(4000000, 4000000, 4000000)
		BodyVelocity.Name = "fuhly"
		BodyVelocity.Velocity = ((Camera.CoordinateFrame.lookVector * (Controls['w'] + -Controls['s'])) +
			((Camera.CoordinateFrame *
				CFrame.new(-Controls['a'] + Controls['d'],
					(Controls['w'] + -Controls['s']) * .2, 0).Position) -
					Camera.CoordinateFrame.p)) * FlySpeed / 1.5
	end
end

function speed()
	if Speed then
		Character.HumanoidRootPart.Anchored = false

		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.Parent = Character.HumanoidRootPart
		BodyVelocity.MaxForce = Vector3.new(4000000, 0, 4000000)
		BodyVelocity.Name = "suhpeed"
		BodyVelocity.Velocity = ((Camera.CoordinateFrame.lookVector * (Controls['w'] + -Controls['s'])) +
			((Camera.CoordinateFrame *
				CFrame.new(-Controls['a'] + Controls['d'],
					(Controls['w'] + -Controls['s']) * .2, 0).Position) -
					Camera.CoordinateFrame.p)) * SpeedValue / 1.5
	end
end

function noclip()
	if NoClip then
		for i, Part in pairs(Character:GetDescendants()) do
			if Part:IsA("BasePart") then
				Part.CanCollide = false
			end
		end
	else
		Character.Head.CanCollide = true
		Character.Torso.CanCollide = true
		Character["Left Leg"].CanCollide = false
		Character["Right Leg"].CanCollide = false
	end
end

function nofall()
	local WorldClient = LocalPlayer.PlayerGui.WorldClient
	local senv = getsenv(WorldClient)
	local fall = senv.fall

	local OldHook
	OldHook = hookfunction(fall, function(Event, ...)
		if NoFall then
			return nil
		else
			return OldHook(Event, ...)
		end
	end)
end

function knockedowernship()
	if Character.Humanoid.PlatformStand and KnockedOwnership and Character.Humanoid.Health < 4 then
		Character.Humanoid:EquipTool(SelectedItem)
		wait(0.05)
		Character.Humanoid:UnequipTools()
	end
end

function streamermode()
	local CharacterInfo = LocalPlayer.PlayerGui.WorldInfo.InfoFrame.CharacterInfo
	local Playerlist = LocalPlayer.PlayerGui.LeaderboardGui.MainFrame.ScrollingFrame:GetChildren()
	local CharacterName = CharacterInfo.Character.Text
	if StreamerMode then
		CharacterInfo.Visible = false
		for i, PlayerFrame in pairs(Playerlist) do
			local PlayerName = PlayerFrame:FindFirstChild('Player')
			if PlayerName then
				if PlayerName.Text == CharacterName then
					PlayerFrame.Visible = false
				end
			end
		end
	else
		CharacterInfo.Visible = true
		for i, PlayerFrame in pairs(Playerlist) do
			local PlayerName = PlayerFrame:FindFirstChild('Player')
			if PlayerName then
				if PlayerName.Text == CharacterName then
					PlayerFrame.Visible = true
				end
			end
		end
	end
end

function AssignSelectedItem()
	if KnockedOwnership then
		SelectedItem = nil
		for i, Child in pairs(LocalPlayer.Backpack:GetDescendants()) do
			if Child.Name == 'Ingredient' or Child.Name == 'Training' then
				local Item = Child.Parent
				SelectedItem = Item
				break
			end
		end
	end
end

function playLocalSound(soundId)
	local sound = Instance.new("Sound")
	sound.SoundId = 'rbxassetid://' .. soundId
	sound.Parent = Character.HumanoidRootPart
	sound:Play()
	sound.Ended:Wait()
	sound:Destroy()
end

function modalert(Player)
	if Player:IsInGroup(DeepID) and ModAlert then
		playLocalSound(ModSoundID)
		print("Player is ranked as '", Player:GetRoleInGroup(DeepID))
	end
end

function CreateEsp(Player)
	local EnemyCharacter = Player.Character

	if EnemyCharacter then

		local Box = Drawing.new("Square")
		Box.Visible = false
		Box.Thickness = 1

		local HealthBar = Drawing.new("Square")
		HealthBar.Visible = false
		HealthBar.Thickness = 1
		HealthBar.Filled = true

		local Line = Drawing.new("Line")
		Line.Visible = false
		Line.Thickness = 1

		local Name = Drawing.new("Text")
		Name.Visible = false
		Name.Text = '[' .. EnemyCharacter.Name .. ']'
		Name.Center = true
		Name.Size = 25

		local Connection
		Connection = RunService.RenderStepped:Connect(function()
			UpdateEsp(EnemyCharacter, Box, HealthBar, Name, Line, Connection, ESP)
		end)

		local function RemoveEsp()
			Box:Remove()
			HealthBar:Remove()
			Line:Remove()
			Name:Remove()
			Connection:Disconnect()
		end

		EnemyCharacter:FindFirstChild('Humanoid').Died:Connect(function()
			RemoveEsp()
		end)

		Player.CharacterRemoving:Connect(function()
			RemoveEsp()
		end)

		Character:FindFirstChild('Humanoid').Died:Connect(function()
			RemoveEsp()
		end)

		LocalPlayer.CharacterRemoving:Connect(function ()
			RemoveEsp()
		end)
	end
end

function CreateMobEsp(Mob)
	if Mob:FindFirstChild('Humanoid') then

		local Box = Drawing.new("Square")
		Box.Visible = false
		Box.Thickness = 1

		local HealthBar = Drawing.new("Square")
		HealthBar.Visible = false
		HealthBar.Thickness = 1
		HealthBar.Filled = true

		local Line = Drawing.new("Line")
		Line.Visible = false
		Line.Thickness = 1

		local Name = Drawing.new("Text")
		Name.Visible = false
		Name.Text = '[' .. Mob.Name .. ']'
		Name.Center = true
		Name.Size = 25

		local Connection
		Connection = RunService.RenderStepped:Connect(function()
			UpdateEsp(Mob, Box, HealthBar, Name, Line, Connection, MobESP)
		end)

		local function RemoveEsp()
			Box:Remove()
			HealthBar:Remove()
			Line:Remove()
			Name:Remove()
			Connection:Disconnect()
		end

		Mob:FindFirstChild('Humanoid').Died:Connect(function()
			RemoveEsp()
		end)

		Character:FindFirstChild('Humanoid').Died:Connect(function()
			RemoveEsp()
		end)

		LocalPlayer.CharacterRemoving:Connect(function ()
			RemoveEsp()
		end)
	end
end

function CreateNPCEsp(NPC)
	if NPC.PrimaryPart then

		local Name = Drawing.new("Text")
		Name.Visible = false
		Name.Text = '[' .. NPC.Name .. ']'
		Name.Center = true
		Name.Size = 25

		print('MADE NPC ESP')

		local Connection
		Connection = RunService.RenderStepped:Connect(function()
			UpdateNPCEsp(NPC.PrimaryPart, Name, Connection)
		end)

		local function RemoveEsp()
			Name:Remove()
			Connection:Disconnect()
		end

		Character:FindFirstChild('Humanoid').Died:Connect(function()
			RemoveEsp()
		end)

		LocalPlayer.CharacterRemoving:Connect(function ()
			RemoveEsp()
		end)
	end
end

function UpdateEsp(Enemy, Box, HealthBar, Name, Line, Connection, Boolean)
	if not Boolean then
		Box:Remove()
		HealthBar:Remove()
		Line:Remove()
		Name:Remove()
		Connection:Disconnect()
	end

	local Head = Enemy.Head
	local EnemyHrp = Enemy.HumanoidRootPart

	local Pos = Camera:WorldToViewportPoint(EnemyHrp.Position)
	local Pos2 = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

	local HeadPosition = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 2, 0))
	local LegPosition = Camera:WorldToViewportPoint(EnemyHrp.Position - Vector3.new(0, 2, 0))
	local Distance = getMag(EnemyHrp.Position, Character.HumanoidRootPart.Position)

	if OnScreen(Camera, EnemyHrp) and Boolean and Distance <= ESPDistance and Enemy:FindFirstChild('Humanoid').Health > 0 and Enemy and
		Enemy:FindFirstChild('HumanoidRootPart') then
		Box.Visible = ESPOptions.Box
		HealthBar.Visible = ESPOptions.HealthBar
		Name.Visible = ESPOptions.Name
		Line.Visible = ESPOptions.Line

		Name.Position = Vector2.new(HeadPosition.X, HeadPosition.Y)

		Line.From = Vector2.new(Pos2.x, Pos2.y)
		Line.To = Vector2.new(Pos.x, Pos.y)

		Box.Size = Vector2.new(2500 / Pos.Z, HeadPosition.Y - LegPosition.Y)
		Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)

		HealthBar.Size = Vector2.new(2, (HeadPosition.Y - LegPosition.Y) /
			(Enemy.Humanoid.MaxHealth / math.clamp(Enemy.Humanoid.Health, 0, Enemy.Humanoid.MaxHealth)))
		HealthBar.Position = Vector2.new(Box.Position.X - 6, Box.Position.Y + (1 / HealthBar.Size.Y))
		HealthBar.Color = Color3.fromRGB(255 - 255 / (Enemy.Humanoid.MaxHealth / Enemy.Humanoid.Health),
			255 / (Enemy.Humanoid.MaxHealth / Enemy.Humanoid.Health), 0)
	else
		Box.Visible = false
		HealthBar.Visible = false
		Name.Visible = false
		Line.Visible = false
	end

	if Character:WaitForChild('Humanoid').Health <= 0 or not Enemy.HumanoidRootPart or not Enemy then
		Box:Remove()
		HealthBar:Remove()
		Line:Remove()
		Name:Remove()
		Connection:Disconnect()
	end
end

function UpdateNPCEsp(PrimaryPart, Name, Connection)
	if not NPCESP then
		Name:Remove()
		Connection:Disconnect()
	end

	local Distance = getMag(PrimaryPart.Position, Character.HumanoidRootPart.Position)
	local Pos = Camera:WorldToViewportPoint(PrimaryPart.Position)

	if OnScreen(Camera, PrimaryPart) and NPCESP and Distance <= ESPDistance then
		Name.Visible = true
		Name.Position = Vector2.new(Pos.X, Pos.Y)
	else
		Name.Visible = false
	end
end

function getMag(FirstPos, SecondPos)
	return (FirstPos - SecondPos).Magnitude
end

function OnScreen(camera, part)
	-- 1. get all eight points in 3D space for the part

	local pos, front, right, up = part.Position, part.CFrame.LookVector, part.CFrame.RightVector, part.CFrame.UpVector
	local hx, hy, hz = part.Size.X / 2, part.Size.Y / 2, part.Size.Z / 2

	local points = {pos - front * hz - right * hx - up * hy, pos - front * hz - right * hx + up * hy,
		pos - front * hz + right * hx - up * hy, pos - front * hz + right * hx + up * hy,
		pos + front * hz - right * hx - up * hy, pos + front * hz - right * hx + up * hy,
		pos + front * hz + right * hx - up * hy, pos + front * hz + right * hx + up * hy}

	-- 2. compute AABB of the part's bounds on screen

	local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge

	for i = 1, 8 do
		local screenPoint = camera:WorldToViewportPoint(points[i])
		local x, y = screenPoint.X, screenPoint.Y

		if screenPoint.Z > 0 then
			if x < minX then
				minX = x
			end
			if x > maxX then
				maxX = x
			end
			if y < minY then
				minY = y
			end
			if y > maxY then
				maxY = y
			end
		end
	end

	-- 3. AABB collision with screen rect

	local w, h = camera.ViewportSize.X, camera.ViewportSize.Y

	return minX < w and maxX > 0 and minY < h and maxY > 0
end

Players.PlayerAdded:Connect(function(Player)
	modalert(Player)
end)

RunService.RenderStepped:Connect(function()
	fly()
	speed()
	noclip()
	knockedowernship()
end)

Character.Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	AssignSelectedItem()
end)

Mouse.KeyUp:Connect(function(key)
	if Controls[key:lower()] then
		Controls[key:lower()] = 0
	end
end)

Mouse.KeyDown:Connect(function(key)
	if Controls[key:lower()] then
		Controls[key:lower()] = 1
	end
end)

MovementTab:CreateToggle('Fly', Fly, 'F1', function(State)
	Fly = State
end)

MovementTab:CreateSlider(FlySpeed, 200, function(Value)
	FlySpeed = Value
end)

MovementTab:CreateToggle('Speed', Speed, 'F2', function(State)
	Speed = State
end)

MovementTab:CreateSlider(SpeedValue, 200, function(Value)
	SpeedValue = Value
end)

MovementTab:CreateToggle('No fall', NoFall, nil, function(State)
	NoFall = State
	nofall()
end)

MovementTab:CreateToggle('No clip', NoClip, 'F3', function(State)
	NoClip = State
end)

CharacterMiscTab:CreateUseButton('Reset', nil, function ()
	Character:WaitForChild('HumanoidRootPart'):Destroy()
end)


ESPTab:CreateToggle('ESP', ESP, 'Z', function(State)
	ESP = State

	if State then
		for i, Player in pairs(Players:GetChildren()) do
			modalert(Player)

			if Player ~= LocalPlayer and Player.Character then
				CreateEsp(Player)
			end
		end
	end
end)

ESPTab:CreateSlider(ESPDistance, 5000, function(Value)
	ESPDistance = Value
end)

ESPTab:CreateToggle('Mob ESP', MobESP, 'Z', function(State)
	MobESP = State

	if State then
		for i, Mob in pairs(workspace.Live:GetChildren()) do
			if not Players:GetPlayerFromCharacter(Mob) then
				CreateMobEsp(Mob)
			end
		end
	end
end)

ESPTab:CreateToggle('NPC ESP', NPCESP, 'Z', function(State)
	NPCESP = State

	if State then
		for i, NPC in pairs(workspace.NPCs:GetChildren()) do
			CreateNPCEsp(NPC)
		end
	end
end)

ESPTab:CreateToggle('Box', ESPOptions.Box, nil, function(State)
	ESPOptions.Box = State
end)

ESPTab:CreateToggle('Name', ESPOptions.Name, nil, function(State)
	ESPOptions.Name = State
end)

ESPTab:CreateToggle('Healthbar', ESPOptions.HealthBar, nil, function(State)
	ESPOptions.HealthBar = State
end)

ESPTab:CreateToggle('Tracers', ESPOptions.Line, nil, function(State)
	ESPOptions.Line = State
end)

LocalMiscTab:CreateToggle('Mod alert', ModAlert, nil, function(State)
	ModAlert = State
end)

LocalMiscTab:CreateToggle('Knocked ownership', KnockedOwnership, nil, function(State)
	KnockedOwnership = State
end)

LocalMiscTab:CreateToggle('Streamermode', StreamerMode, nil, function(State)
	StreamerMode = State
	streamermode()
end)

UIS.InputBegan:Connect(function(Input, IsTyping)
	if IsTyping then
		return
	end

	if Input.KeyCode == Enum.KeyCode.LeftAlt then
		ScreenGui = LocalPlayer.PlayerGui:WaitForChild('Window')
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

for i, Player in pairs(Players:GetChildren()) do
	modalert(Player)
end

Players.PlayerAdded:Connect(function (Player)
	modalert(Player)
	Player.CharacterAdded:Connect(function ()
		if Player ~= LocalPlayer and Player.Character then
			CreateEsp(Player)
		end
	end)
end)

workspace.Live.ChildAdded:Connect(function(Child)
	wait(1)
	if not Players:GetPlayerFromCharacter(Child) then
		CreateMobEsp(Child)
	end
end)

local PlayerList: ScrollingFrame = LocalPlayer.PlayerGui.LeaderboardGui.MainFrame.ScrollingFrame

function ChangeCamSubject(EnemyCharacter: Model)
	if EnemyCharacter and EnemyCharacter:WaitForChild('Humanoid') ~= Camera.CameraSubject then
		Camera.CameraSubject = EnemyCharacter.Humanoid
		warn("CameraSubject="..EnemyCharacter.Name)
	else
		Camera.CameraSubject = LocalPlayer.Character.Humanoid
		warn("CameraSubject="..LocalPlayer.Name)
	end
end

function InitPlayerFrame(PlayerFrame: Frame)
	if PlayerFrame:IsA('Frame') then 
		local CharacterName = PlayerFrame.Player.Text
		for j, Player in pairs(game.Players:GetPlayers()) do
			local EnemyCharacter = Player.Character

			if EnemyCharacter then
				local CharaterNameCheck = EnemyCharacter.Humanoid:GetAttribute('CharacterName')
				if CharaterNameCheck == CharacterName then
					PlayerFrame.InputBegan:Connect(function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
							ChangeCamSubject(EnemyCharacter)
							print('Observing: '..CharaterNameCheck)
						end
					end)
				end
			end
		end
	end
end

PlayerList.ChildAdded:Connect(function(PlayerFrame)
	InitPlayerFrame(PlayerFrame)
end)

for i, PlayerFrame in pairs(PlayerList:GetChildren()) do
	InitPlayerFrame(PlayerFrame)
end

local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
	local Args = {...}
	local method = getnamecallmethod()

	if not checkcaller() and method == 'HasTag' and Args[2] == 'ForcedSubject' then
		return true
	end
	return OldNameCall(Self, ...)
end)
