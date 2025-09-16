--// Ghost Hub Final Unificado
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ghost Hub",
    LoadingTitle = "GhostHub.",
    LoadingSubtitle = "by thalles456u",
    Theme = "Black",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "Aura Hub"},
    Discord = {Enabled = false, Invite = "JF2F2RANud", RememberJoins = true},
    KeySystem = false
})

-- Abas
local MenuTab = Window:CreateTab("Menu", 4483362458)
local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458)
local FunTab = Window:CreateTab("Fun", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)
local OutrosTab = Window:CreateTab("Outros", 4483362458)

-- =========================
-- MENU
-- =========================
local MenuSection = MenuTab:CreateSection("Funções Menu")

-- Speed
MenuTab:CreateInput({
    Name = "Speed",
    PlaceholderText = "Digite a velocidade",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local speed = tonumber(Value)
        local player = game.Players.LocalPlayer
        if speed and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speed
        end
    end
})

-- Infinity Jump
local InfinityJumpEnabled = false
MenuTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Callback = function(Value)
        InfinityJumpEnabled = Value
    end
})
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfinityJumpEnabled then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =========================
-- LOCALPLAYER
-- =========================
local LPSection = LocalPlayerTab:CreateSection("Funções LocalPlayer")

-- Noclip
local NoclipEnabled = false
LocalPlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
    end
})
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled then
        local player = game.Players.LocalPlayer
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fullbring
local FullbringEnabled = false
LocalPlayerTab:CreateToggle({
    Name = "Fullbring",
    CurrentValue = false,
    Callback = function(Value)
        FullbringEnabled = Value
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if Value then
                player.Character.Humanoid.WalkSpeed = 30
                player.Character.Humanoid.JumpPower = 70
                if not player.Character:FindFirstChild("FullbringEffect") then
                    local effect = Instance.new("ParticleEmitter")
                    effect.Name = "FullbringEffect"
                    effect.Parent = player.Character.HumanoidRootPart
                    effect.Rate = 50
                    effect.Lifetime = NumberRange.new(0.5)
                    effect.Speed = NumberRange.new(5)
                end
            else
                player.Character.Humanoid.WalkSpeed = 16
                player.Character.Humanoid.JumpPower = 50
                if player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChild("FullbringEffect") then
                    player.Character.HumanoidRootPart.FullbringEffect:Destroy()
                end
            end
        end
    end
})

-- Copiar Skin/Roupas por Nick
LocalPlayerTab:CreateInput({
    Name = "Copiar Skin (Nick)",
    PlaceholderText = "Digite o Nick do jogador",
    RemoveTextAfterFocusLost = false,
    Callback = function(Nick)
        local target = game.Players:FindFirstChild(Nick)
        local player = game.Players.LocalPlayer
        if target and target.Character and player.Character then
            local success, err = pcall(function()
                -- Shirt
                if target.Character:FindFirstChildOfClass("Shirt") then
                    local s = target.Character:FindFirstChildOfClass("Shirt"):Clone()
                    s.Parent = player.Character
                end
                -- Pants
                if target.Character:FindFirstChildOfClass("Pants") then
                    local p = target.Character:FindFirstChildOfClass("Pants"):Clone()
                    p.Parent = player.Character
                end
                -- Accessories/Hats
                for _, acc in pairs(target.Character:GetChildren()) do
                    if acc:IsA("Accessory") then
                        local clone = acc:Clone()
                        clone.Parent = player.Character
                    end
                end
            end)
            if not success then
                warn("Não foi possível copiar roupas: "..err)
            end
        else
            warn("Jogador não encontrado ou sem personagem")
        end
    end
})

-- =========================
-- FUN
-- =========================
local FlySection = FunTab:CreateSection("Funções Fly")
local FlyEnabled = false
local FlySpeed = 50
local FlyBodyVelocity
local FlyConnection

FunTab:CreateToggle({
    Name = "Fly (PC & Mobile)",
    CurrentValue = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not hrp then return end

        FlyEnabled = Value

        if FlyEnabled then
            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            FlyBodyVelocity.Velocity = Vector3.new(0,0,0)
            FlyBodyVelocity.Parent = hrp

            FlyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if not FlyEnabled then return end
                local dir = Vector3.new(0,0,0)
                local UIS = game:GetService("UserInputService")
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end

                if dir.Magnitude > 0 then
                    FlyBodyVelocity.Velocity = dir.Unit * FlySpeed
                else
                    FlyBodyVelocity.Velocity = Vector3.new(0,0,0)
                end
            end)
        else
            if FlyConnection then FlyConnection:Disconnect() end
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        end
    end
})

-- =========================
-- ESP
-- =========================
local ESPSection = ESPTab:CreateSection("ESP Players")
local ESPEnabled = false
local ESPBoxes = {}
local ESPConnections = {}

ESPTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value

        -- Desliga ESP antigo
        for _, gui in pairs(ESPBoxes) do
            gui:Destroy()
        end
        ESPBoxes = {}
        for _, conn in pairs(ESPConnections) do
            conn:Disconnect()
        end
        ESPConnections = {}

        if ESPEnabled then
            local function AddESP(p)
                if p == game.Players.LocalPlayer then return end
                if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end

                local bill = Instance.new("BillboardGui")
                bill.Name = "ESP"
                bill.Adornee = p.Character.HumanoidRootPart
                bill.Size = UDim2.new(0,100,0,50)
                bill.AlwaysOnTop = true
                bill.Parent = p.Character

                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1,0,1,0)
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.fromRGB(255,0,0)
                text.TextStrokeTransparency = 0
                text.TextScaled = true
                text.Text = p.Name
                text.Parent = bill

                ESPBoxes[p] = bill
            end

            for _, p in pairs(game.Players:GetPlayers()) do
                AddESP(p)
            end

            local conn = game.Players.PlayerAdded:Connect(AddESP)
            table.insert(ESPConnections, conn)
        end
    end
})

-- =========================
-- OUTROS
-- =========================
local OutrosSection = OutrosTab:CreateSection("Funções Extras")

-- Teleporte
OutrosTab:CreateInput({
    Name = "Teleporte por Nick",
    PlaceholderText = "Digite o Nick do jogador",
    RemoveTextAfterFocusLost = false,
    Callback = function(Nick)
        local target = game.Players:FindFirstChild(Nick)
        local player = game.Players.LocalPlayer
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
        else
            warn("Jogador não encontrado ou sem personagem")
        end
    end
})

-- Spectar
OutrosTab:CreateInput({
    Name = "Spectar por Nick",
    PlaceholderText = "Digite o Nick do jogador",
    RemoveTextAfterFocusLost = false,
    Callback = function(Nick)
        local target = game.Players:FindFirstChild(Nick)
        local cam = workspace.CurrentCamera
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            cam.CameraSubject = target.Character.Humanoid
        else
            warn("Jogador não encontrado ou sem personagem")
        end
    end
})