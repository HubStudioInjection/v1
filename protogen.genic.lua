loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Aimbot.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Wall%20Hack.lua"))()
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/HubStudioInjection/ui-lib/refs/heads/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/HubStudioInjection/themes/refs/heads/main/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/HubStudioInjection/savem/refs/heads/main/SaveManager.lua'))()

getgenv().Tracer = "T"
getgenv().Circle = "B"

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local circleEnabled = false -- Початковий стан кола (вимкнено)
local followCircle

-- Створення кола
local function createFollowCircle()
    followCircle = Drawing.new("Circle")
    followCircle.Radius = 50 -- Радіус кола
    followCircle.Color = Color3.new(75, 108, 178) -- Зелений колір
    followCircle.Thickness = 2
    followCircle.Transparency = 1
    followCircle.Visible = false -- Спочатку невидиме
end

-- Функція для перемикання кола
local function toggleCircle()
    circleEnabled = not circleEnabled
    followCircle.Visible = circleEnabled
end

-- Обробник натискання клавіші для перемикання кола
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.B and not gameProcessed then -- Клавіша "B" для перемикання кола
        toggleCircle()
    end
end)

-- Оновлення позиції кола на кожному кадрі
runService.RenderStepped:Connect(function()
    if circleEnabled then
        followCircle.Position = Vector2.new(userInputService:GetMouseLocation().X, userInputService:GetMouseLocation().Y)
    end
end)

-- Створення кола при запуску скрипту
createFollowCircle()

script.Parent = game.StarterPlayer.StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Налаштування кольорів трасерів
local AllyColor = Color3.fromRGB(255, 255, 255) -- Білий для союзників
local EnemyColor = Color3.fromRGB(255, 0, 0) -- Червоний для ворогів

-- Змінна для зберігання стану трасерів
local tracersEnabled = false
local tracers = {}  -- Таблиця для зберігання трасерів
local connections = {} -- Таблиця для зберігання з'єднань

-- Функція створення лінії для гравця
local function createTracer(player)
    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Transparency = 1
    tracer.Visible = false  -- Спочатку робимо трасер невидимим
    tracers[player] = tracer

    -- Повертаємо функцію оновлення положення для цього трасера
    return function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPosition, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)

            -- Визначаємо колір трасера в залежності від команди
            tracer.Color = (player.Team == LocalPlayer.Team) and AllyColor or EnemyColor

            if onScreen then
                tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- Початкова точка трасера (низ екрану)
                tracer.To = Vector2.new(rootPosition.X, rootPosition.Y) -- Кінцева точка (позиція гравця)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end
end

-- Функція для ввімкнення та відключення трасерів
local function toggleTracers()
    tracersEnabled = not tracersEnabled

    if tracersEnabled then
        -- Підключаємо оновлення трасерів тільки коли увімкнено
        for player, tracer in pairs(tracers) do
            if not connections[player] then
                local updateTracer = createTracer(player)
                connections[player] = RunService.RenderStepped:Connect(updateTracer)
            end
        end
    else
        -- Вимикаємо всі трасери і розриваємо з'єднання
        for player, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
                connections[player] = nil
            end
        end

        for _, tracer in pairs(tracers) do
            tracer.Visible = false
        end
    end
end

-- Створюємо трасери для всіх гравців у грі
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        tracers[player] = createTracer(player)
    end
end

-- Оновлюємо трасери для нових гравців
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        tracers[player] = createTracer(player)
        if tracersEnabled and not connections[player] then
            connections[player] = RunService.RenderStepped:Connect(tracers[player])
        end
    end
end)

-- Видаляємо трасер при виході гравця
Players.PlayerRemoving:Connect(function(player)
    if tracers[player] then
        tracers[player]:Remove() -- Видалення лінії трасера
        tracers[player] = nil
    end
    if connections[player] then
        connections[player]:Disconnect() -- Видаляємо з'єднання
        connections[player] = nil
    end
end)

-- Перемикаємо трасери на клавішу "T"
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        toggleTracers()
    end
end)

tracers.Parent = game.StarterPlayer.StarterPlayerScripts

local Window = Library:CreateWindow({
	Title = 'Protegen.Genic|Universal|Welcome',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = false,
	TabPadding = 0,
	MenuFadeTime = 0.2
})

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	Library:SetWatermark(('Protegen.Genic | %s fps | %s ms'):format(
		math.floor(FPS),
		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
	));
end);

local Tabs = {
	-- Creates a new tab titled Main
	Main = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Unloaded!')
	Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
task.spawn(function()
	while true do
		wait(1)

		-- example for checking if a keybind is being pressed
		local state = Options.KeyPicker:GetState()
		if state then
			print('KeyPicker is being held down')
		end

		if Library.Unloaded then break end
	end
end)
local Vis = Tabs.Main:AddLeftTabbox() -- Add Tabbox on right side

-- Anything we can do in a Groupbox, we can do in a Tabbox tab (AddToggle, AddSlider, AddLabel, etc etc...)
local ESP = 	Vis:AddTab('{=>ESP<=}')

	ESP:AddToggle('ESp', {
	Text = 'Enable ESP',
	Default = false, -- Default value (true / false)
	Tooltip = 'Enable ESP', -- Information shown when you hover over the toggle

	Callback = function(Value)
getgenv().enabled = Value --Toggle on/off
getgenv().filluseteamcolor = true
getgenv().outlineuseteamcolor = true  --Toggle outline color using player team color on/off
getgenv().fillcolor = Color3.new(211,211, 211) --Change fill color, no need to edit if using team color
getgenv().outlinecolor = Color3.new(1, 1, 1) --Change outline color, no need to edit if using team color
getgenv().Espv = Value --Change fill transparency
getgenv().Espo = Value --Change outline transparency
loadstring(game:HttpGet("https://raw.githubusercontent.com/HubStudioInjection/esp/refs/heads/main/source.lua"))()
	end
})

	ESP:AddDivider()
ESP:AddSlider('Espv', {
	Text = 'ESP Fill Transparency',
	Default = 0.8,
	Min = 0,
	Max = 1,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		getgenv().filltrans = Value
	end
})

ESP:AddSlider('Espo', {
	Text = 'ESP Outline Transparency',
	Default = 0,
	Min = 0,
	Max = 1,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		getgenv().outlinetrans = Value
	end
})

ESP:AddDivider()

ESP:AddToggle('Et', {
	Text = 'Enable Tracers',
	Default = false, -- Default value (true / false)
	Tooltip = 'Enable Tracers', -- Information shown when you hover over the toggle

	Callback = function(Value)
game:GetService("VirtualInputManager"):SendKeyEvent(true,getgenv().Tracer,false,game);
	end
})

local Aim = 	Vis:AddTab('{=>Aiming<=}')

	Aim:AddToggle('Aim', {
	Text = 'Enable Aiming Circle',
	Default = false, -- Default value (true / false)
	Tooltip = 'Enable Aiming Circle', -- Information shown when you hover over the toggle

	Callback = function(Value)
game:GetService("VirtualInputManager"):SendKeyEvent(true,getgenv().Circle,false,game);
end
})

--[[local Player = Tabs.Main:AddRightTabbox() -- Add Tabbox on right side

-- Anything we can do in a Groupbox, we can do in a Tabbox tab (AddToggle, AddSlider, AddLabel, etc etc...)

local Plr = Player:AddTab('{=>Player<=}')

Plr:AddSlider('Walk Speed', {
	Text = 'Walk Speed',
	Default = 16,
	Min = 16,
	Max = 150,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end
})

Plr:AddSlider('Jump Power', {
	Text = 'Jump Power',
	Default = 50,
	Min = 50,
	Max = 200,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end
})

Plr:AddSlider('Gravity', {
	Text = 'Gravity',
	Default = 196.2,
	Min = 0,
	Max = 196.2,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		game.Workspace.Gravity = Value
	end
})


local Noclipping = nil
local speaker = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

Plr:AddDivider()

Plr:AddSlider('fov', {
	Text = 'Field Of View',
	Default = 70,
	Min = 70,
	Max = 120,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
	workspace.CurrentCamera.FieldOfView	 = Value
	end
})

Plr:AddDivider()

Plr:AddToggle('Noclip', {
	Text = 'Noclip',
	Default = false, 
	Tooltip = 'Noclip',
	Callback = function(Value)
		if Value then
        Clip = false
        local function NoclipLoop()
            if Clip == false and speaker.Character ~= nil then
                for _, child in pairs(speaker.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                        child.CanCollide = false
                    end
                end
            end
        end
        Noclipping = RunService.Stepped:Connect(NoclipLoop)
    else
        if Noclipping then
            Noclipping:Disconnect()
        end
        Clip = true
    end
end
})
speeds = 1
 
local speaker = game:GetService("Players").LocalPlayer
 
local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
 
nowe = false

local Fly = Plr:AddButton({
	Text = 'Toggle Fly',
	Func = function()
if nowe == true then
  nowe = false
 
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
  speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
 else 
  nowe = true
 
  for i = 1, speeds do
   spawn(function()
 
    local hb = game:GetService("RunService").Heartbeat 
 
 
    tpwalking = true
    local chr = game.Players.LocalPlayer.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
     if hum.MoveDirection.Magnitude > 0 then
      chr:TranslateBy(hum.MoveDirection)
     end
    end
 
   end)
  end
  game.Players.LocalPlayer.Character.Animate.Disabled = true
  local Char = game.Players.LocalPlayer.Character
  local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
 
  for i,v in next, Hum:GetPlayingAnimationTracks() do
   v:AdjustSpeed(0)
  end
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
  speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
  speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
 end
 
 if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then

local plr = game.Players.LocalPlayer
  local torso = plr.Character.Torso
  local flying = true
  local deb = true
  local ctrl = {f = 0, b = 0, l = 0, r = 0}
  local lastctrl = {f = 0, b = 0, l = 0, r = 0}
  local maxspeed = 50
  local speed = 0
  local bg = Instance.new("BodyGyro", torso)
  bg.P = 9e4
  bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
  bg.cframe = torso.CFrame
  local bv = Instance.new("BodyVelocity", torso)
  bv.velocity = Vector3.new(0,0.1,0)
  bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
  if nowe == true then
   plr.Character.Humanoid.PlatformStand = true
  end
  while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
   game:GetService("RunService").RenderStepped:Wait()
 
   if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
    speed = speed+.5+(speed/maxspeed)
    if speed > maxspeed then
     speed = maxspeed
    end
   elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
    speed = speed-1
    if speed < 0 then
     speed = 0
    end
   end
   if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
   elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
   else
    bv.velocity = Vector3.new(0,0,0)
   end
   -- game.Players.LocalPlayer.Character.Animate.Disabled = true
   bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
  end
  ctrl = {f = 0, b = 0, l = 0, r = 0}
  lastctrl = {f = 0, b = 0, l = 0, r = 0}
  speed = 0
  bg:Destroy()
  bv:Destroy()
  plr.Character.Humanoid.PlatformStand = false
  game.Players.LocalPlayer.Character.Animate.Disabled = false
  tpwalking = false
 else
  local plr = game.Players.LocalPlayer
  local UpperTorso = plr.Character.UpperTorso
  local flying = true
  local deb = true
  local ctrl = {f = 0, b = 0, l = 0, r = 0}
  local lastctrl = {f = 0, b = 0, l = 0, r = 0}
  local maxspeed = 50
  local speed = 0
 
 
  local bg = Instance.new("BodyGyro", UpperTorso)
  bg.P = 9e4
  bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
  bg.cframe = UpperTorso.CFrame
  local bv = Instance.new("BodyVelocity", UpperTorso)
  bv.velocity = Vector3.new(0,0.1,0)
  bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
  if nowe == true then
   plr.Character.Humanoid.PlatformStand = true
  end
  while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
   wait()
 
   if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
    speed = speed+.5+(speed/maxspeed)
    if speed > maxspeed then
     speed = maxspeed
    end
   elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
    speed = speed-1
    if speed < 0 then
     speed = 0
    end
   end
   if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
   elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed

else
    bv.velocity = Vector3.new(0,0,0)
   end
 
   bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
  end
  ctrl = {f = 0, b = 0, l = 0, r = 0}
  lastctrl = {f = 0, b = 0, l = 0, r = 0}
  speed = 0
  bg:Destroy()
  bv:Destroy()
  plr.Character.Humanoid.PlatformStand = false
  game.Players.LocalPlayer.Character.Animate.Disabled = false
  tpwalking = false
 end
	end,
	DoubleClick = false,
	Tooltip = 'Toggle Fly'
})

Plr:AddSlider('fs', {
	Text = 'Fly Speed',
	Default = 1,
	Min = 1,
	Max = 6,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		 speeds = Value
	if nowe == true then
		tpwalking = false
		for i = 1, speeds do
			spawn(function()
				local hb = game:GetService("RunService").Heartbeat
 
				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
	end
	end
})

local Lo = Player:AddTab('{=>Loop<=}')

Lo:AddSlider('Walk Speed', {
	Text = 'Loop Walk Speed',
	Default = 16,
	Min = 16,
	Max = 150,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
while wait() do
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end
	end
})

Lo:AddSlider('Jump Power', {
	Text = 'Loop Jump Power',
	Default = 50,
	Min = 50,
	Max = 200,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
while wait() do
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end
	end
})]]--

local loool = Tabs.Main:AddRightTabbox() -- Add Tabbox on right side

-- Anything we can do in a Groupbox, we can do in a Tabbox tab (AddToggle, AddSlider, AddLabel, etc etc...)
local ll = 	loool:AddTab('{=>More<=}')

local Ds = ll:AddButton({
	Text = 'Join Discord',
	Func = function()
		
	end,
	DoubleClick = false,
	Tooltip = 'Join Discord'
})
