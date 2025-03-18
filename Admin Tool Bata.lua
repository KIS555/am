repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

getgenv().Settings = {
    WalkSpeedToggle = false,
    WalkSpeedInput = 16,
    JumpPowerToggle = false,
    JumpPowerInput = 50,
    FlyToggle = false,
    FlySpeedInput = 50,
    Noclip = false,
    SelectPlayer = false,
    Spectating = false,
    StoppedSpectating = false,
    TeleporttoSelectedPlayer = false,
    ClickTeleportToggle = false,
    Settings = false
}

-------------------------------------------------------[[ Ui ]]-----------------------------------------------------------------

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Admin | Tool | [Available on all servers]",
    SubTitle = "by Punx",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Derker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-------------------------------------------------------[[ Tab ]]-----------------------------------------------------------

local Tabs = {
    pageMain = Window:AddTab({ Title = "Main", Icon = "align-left" }),
    pageEsp = Window:AddTab({ Title = "Esp", Icon = "eye" }),
    pageOP = Window:AddTab({ Title = "OP", Icon = "align-left" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    pageSettings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

-------------------------------------------------------[[ Tab short ]]-----------------------------------------------------

local SpeedTitle = Tabs.pageMain:AddSection("Function")

-------------------------------------------------------[[ WalkSpeed ]]-----------------------------------------------------

local WalkSpeedToggle = Tabs.pageMain:AddToggle("WalkSpeedToggle", {Title = "Toggle WalkSpeed", Default = getgenv().Settings.WalkSpeedToggle })
local WalkSpeedInput = Tabs.pageMain:AddInput("WalkSpeedInput", {Title = "WalkSpeed Input", Default = getgenv().Settings.WalkSpeedInput, Numeric = true})

WalkSpeedToggle:OnChanged(function(Value)
    getgenv().Settings.WalkSpeedToggle = Value
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value and getgenv().Settings.WalkSpeedInput or 16
end)

WalkSpeedInput:OnChanged(function(Value)
    getgenv().Settings.WalkSpeedInput = Value
    if WalkSpeedToggle.Value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)

-------------------------------------------------------[[ JumpPower ]]-------------------------------------------------------

local JumpPowerToggle = Tabs.pageMain:AddToggle("JumpPowerToggle", {Title = "Toggle JumpPower", Default = getgenv().Settings.JumpPowerToggle })
local JumpPowerInput = Tabs.pageMain:AddInput("JumpPowerInput", {Title = "JumpPower Input", Default = getgenv().Settings.JumpPowerInput, Numeric = true})

JumpPowerToggle:OnChanged(function(Value)
    getgenv().Settings.JumpPowerToggle = Value
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value and getgenv().Settings.JumpPowerInput or 50
end)

JumpPowerInput:OnChanged(function(Value)
    getgenv().Settings.JumpPowerInput = Value
    if JumpPowerToggle.Value then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
end)

-------------------------------------------------------[[ Tab short ]]-----------------------------------------------------

local SpeedTitle = Tabs.pageMain:AddSection("Function")

-------------------------------------------------------[[ Fly ]]------------------------------------------------------------

local FlyToggle = Tabs.pageMain:AddToggle("FlyToggle", { Title = "Toggle Fly", Default = getgenv().Settings.FlyToggle or false })
local FlySpeedInput = Tabs.pageMain:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = getgenv().Settings.FlySpeedInput or 50,
    Numeric = true,
    Finished = false,
})

getgenv().FlySpeed = getgenv().Settings.FlySpeedInput or 50
getgenv().Flying = getgenv().Settings.FlyToggle or false

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Controls = { W = 0, A = 0, S = 0, D = 0, Space = 0, Ctrl = 0 }

-- ฟังก์ชันอัพเดต HRP
local function SetupCharacter()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")

    local function UpdateVelocity()
        if not getgenv().Flying then return end
        local MoveDir = Vector3.new(Controls.D - Controls.A, Controls.Space - Controls.Ctrl, Controls.S - Controls.W)  -- เปลี่ยนการควบคุม Space เป็นขึ้น, Ctrl เป็นลง
        HRP.AssemblyLinearVelocity = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(MoveDir)) * getgenv().FlySpeed
    end

    -- ฟังก์ชันคอยอัพเดตความเร็วการบิน
    RunService.RenderStepped:Connect(UpdateVelocity)

    -- รีเซ็ตค่าหากปิดฟังก์ชัน Fly
    FlyToggle:OnChanged(function(Value)
        getgenv().Settings.FlyToggle = Value
        getgenv().Flying = Value
        if not Value then
            HRP.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

-- เรียกใช้การตั้งค่า character เมื่อเริ่มต้นหรือ respawn
SetupCharacter()

-- เชื่อมต่อการ respawn ของตัวละคร
Player.CharacterAdded:Connect(SetupCharacter)

FlySpeedInput:OnChanged(function(Value)
    getgenv().Settings.FlySpeedInput = Value
    getgenv().FlySpeed = Value
end)

-- การควบคุมการกดปุ่ม
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local Key = input.KeyCode
    if Key == Enum.KeyCode.W then Controls.W = 1 end
    if Key == Enum.KeyCode.A then Controls.A = 1 end
    if Key == Enum.KeyCode.S then Controls.S = 1 end
    if Key == Enum.KeyCode.D then Controls.D = 1 end
    if Key == Enum.KeyCode.LeftControl then Controls.Ctrl = 1 end  -- Ctrl ลง
    if Key == Enum.KeyCode.Space then Controls.Space = 1 end  -- Space ขึ้น
end)

UIS.InputEnded:Connect(function(input)
    local Key = input.KeyCode
    if Key == Enum.KeyCode.W then Controls.W = 0 end
    if Key == Enum.KeyCode.A then Controls.A = 0 end
    if Key == Enum.KeyCode.S then Controls.S = 0 end
    if Key == Enum.KeyCode.D then Controls.D = 0 end
    if Key == Enum.KeyCode.LeftControl then Controls.Ctrl = 0 end
    if Key == Enum.KeyCode.Space then Controls.Space = 0 end
end)

-------------------------------------------------------[[ Tab short ]]-----------------------------------------------------

local SpeedTitle = Tabs.pageOP:AddSection("Function")

-------------------------------------------------------[[ Noclip ]]-------------------------------------------------------

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Plr = Players.LocalPlayer
local Clipon = false
local Stepped

local Toggle = Tabs.pageOP:AddToggle("NoclipToggle", {Title = "Enable Noclip", Default = false })

Toggle:OnChanged(function()
    Clipon = Toggle.Value
    if Clipon then
        Stepped = game:GetService("RunService").Stepped:Connect(function()
            for _, v in pairs(Plr.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if Stepped then
            Stepped:Disconnect()
        end
        for _, v in pairs(Plr.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end)

-------------------------------------------------------[[ Tab short ]]-----------------------------------------------------

local SpeedTitle = Tabs.pageTeleport:AddSection("Function")

-------------------------------------------------------[[ Teleport ]]-------------------------------------------------------

local Players = game:GetService("Players")
local SelectedPlayer = nil
local Spectating = false

local function populatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

local PlayerDropdown = Tabs.pageTeleport:AddDropdown("SelectPlayer", {
    Title = "Select a Player",
    Values = populatePlayerList(),
    Multi = false,
    Default = 1,
})

Players.PlayerAdded:Connect(function()
    PlayerDropdown:SetValues(populatePlayerList())
end)

Players.PlayerRemoving:Connect(function()
    PlayerDropdown:SetValues(populatePlayerList())
end)

local function startSpectating(targetPlayer)
    local camera = game.Workspace.CurrentCamera
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = targetPlayer.Character.Humanoid
        Fluent:Notify({
            Title = "Spectating",
            Content = "Now spectating " .. targetPlayer.Name,
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Spectate Error",
            Content = "Invalid player or no character found.",
            Duration = 3
        })
    end
end

local function stopSpectating()
    local localPlayer = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    camera.CameraSubject = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") or localPlayer
    Fluent:Notify({
        Title = "Stopped Spectating",
        Content = "You are now controlling yourself.",
        Duration = 3
    })
end

Tabs.pageTeleport:AddButton({
    Title = "Teleport to Selected Player",
    Description = "Click to teleport to the selected player.",
    Callback = function()
        local selectedPlayerName = PlayerDropdown.Value
        if selectedPlayerName and selectedPlayerName ~= "" then
            local selectedPlayer = game.Players:FindFirstChild(selectedPlayerName)
            if selectedPlayer then
                local character = game.Players.LocalPlayer.Character
                if character and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
                else
                    Fluent:Notify({
                        Title = "Teleport Error",
                        Content = "Selected player does not have a valid character.",
                        Duration = 3
                    })
                end
            else
                Fluent:Notify({
                    Title = "Teleport Error",
                    Content = "Player not found.",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "Teleport Error",
                Content = "No player selected.",
                Duration = 3
            })
        end
    end
})

Tabs.pageTeleport:AddButton({
    Title = "Spectate Selected Player",
    Description = "Click to spectate the selected player.",
    Callback = function()
        local selectedPlayerName = PlayerDropdown.Value
        if selectedPlayerName and selectedPlayerName ~= "" then
            local selectedPlayer = game.Players:FindFirstChild(selectedPlayerName)
            if selectedPlayer then
                startSpectating(selectedPlayer)
            else
                Fluent:Notify({
                    Title = "Spectate Error",
                    Content = "Player not found.",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "Spectate Error",
                Content = "No player selected.",
                Duration = 3
            })
        end
    end
})

Tabs.pageTeleport:AddButton({
    Title = "Stop Spectating",
    Description = "Click to stop spectating and return to your character.",
    Callback = function()
        stopSpectating()
    end
})

-------------------------------------------------------[[ Tab short ]]-----------------------------------------------------

local SpeedTitle = Tabs.pageTeleport:AddSection("Function")

-------------------------------------------------------[[ ClickTeleport ]]------------------------------------------------------------

local ClickTeleportToggle = Tabs.pageTeleport:AddToggle("ClickTeleportToggle", {Title = "Toggle ClickTeleport", Default = getgenv().Settings.ClickTeleportToggle })
ClickTeleportToggle:OnChanged(function(Value)
    getgenv().Settings.ClickTeleportToggle = Value
end)

local function onClickTeleport(input, gameProcessed)
    if gameProcessed or not getgenv().Settings.ClickTeleportToggle then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local mouse = game.Players.LocalPlayer:GetMouse()
            character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(onClickTeleport)

-------------------------------------------------------[[ Tab short ]]-----------------------------------------------------

local SpeedTitle = Tabs.pageEsp:AddSection("Function")

-------------------------------------------------------[[ ESP ]]-------------------------------------------------------

local function createESP(player)
    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local head = character:WaitForChild("Head")

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = character

    local nameTag = Instance.new("TextLabel")
    nameTag.BackgroundTransparency = 1
    nameTag.Size = UDim2.new(1, 0, 1, 0)
    nameTag.Text = player.Name
    nameTag.TextSize = 20
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTag.TextStrokeTransparency = 0.5
    nameTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameTag.Parent = billboardGui

    game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Head") then
            billboardGui.Adornee = player.Character.Head
        end
    end)
end

local function removeESP(player)
    if player.Character then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("BillboardGui") then
                v:Destroy()
            end
        end
    end
end

local function toggleESP(visible)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            if visible then
                createESP(player)
            else
                removeESP(player)
            end
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if getgenv().Settings.EspPlayerToggle then
            createESP(player)
        end
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

local EspPlayerToggle = Tabs.pageEsp:AddToggle("EspPlayerToggle", {
    Title = "Toggle EspPlayer",
    Default = getgenv().Settings.EspPlayerToggle or false
})

EspPlayerToggle:OnChanged(function(value)
    getgenv().Settings.EspPlayerToggle = value
    toggleESP(value)
end)

-------------------------------------------------------[[ Toggle Main ]]-------------------------------------------------------



-------------------------------------------------------[[ Settings ]]-------------------------------------------------------

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.pageSettings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Admin Tool",
    Content = "The script has been loaded.",
    Duration = 8
})
