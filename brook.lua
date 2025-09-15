--// Rayfield Base
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Ghost Hub",
   Icon = nil,
   LoadingTitle = "GhostHub.",
   LoadingSubtitle = "by thalles456u",
   Theme = "Black",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "Ghost Hub"},
   Discord = {Enabled = false, Invite = "JF2F2RANud", RememberJoins = true},
   KeySystem = false
})

-- Abas
local MenuTab = Window:CreateTab("Menu", 4483362458)
local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458)
local FunTab = Window:CreateTab("Fun", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)
local OutrosTab = Window:CreateTab("Outros", 4483362458)

-- Seção Menu
local MenuSection = MenuTab:CreateSection("Funções Menu")

-- Speed por Texto
local SpeedInput = MenuTab:CreateInput({
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
local InfinityJumpToggle = MenuTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if Value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})
-- Seção LocalPlayer
local LocalPlayerSection = LocalPlayerTab:CreateSection("Funções LocalPlayer")

-- Copiar Skin por Nick
local CopySkinInput = LocalPlayerTab:CreateInput({
    Name = "Copiar Skin (Nick)",
    PlaceholderText = "Digite o Nick do jogador",
    RemoveTextAfterFocusLost = false,
    Callback = function(Nick)
        local targetPlayer = game.Players:FindFirstChild(Nick)
        local player = game.Players.LocalPlayer
        if targetPlayer and targetPlayer.Character and player.Character then
            -- Tenta copiar a aparência do jogador
            local success, err = pcall(function()
                for i, v in pairs(targetPlayer.Character:GetChildren()) do
                    if v:IsA("Accessory") then
                        local clone = v:Clone()
                        clone.Parent = player.Character
                    elseif v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") then
                        local clone = v:Clone()
                        clone.Parent = player.Character
                    end
                end
            end)
            if not success then
                warn("Não foi possível copiar a skin: "..err)
            end
        end
    end
})

-- Fullbring funcional
local FullbringToggle = LocalPlayerTab:CreateToggle({
    Name = "Fullbring",
    CurrentValue = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if Value then
            -- Exemplo de efeito de Fullbring: aumenta dano e velocidade
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 30
                player.Character.Humanoid.JumpPower = 70
            end
        else
            -- Reset para valores normais
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
                player.Character.Humanoid.JumpPower = 50
            end
        end
    end
})
-- Seção Fun
local FunSection = FunTab:CreateSection("Funções Fun")

-- Fly
local FlyToggle = FunTab:CreateToggle({
    Name = "Fly (PC & Mobile)",
    CurrentValue = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera

        if Value then
            local flying = true
            local speed = 50
            local UIS = game:GetService("UserInputService")
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.Parent = hrp

            local function updateVelocity()
                local moveDir = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
                bodyVelocity.Velocity = moveDir.Unit * speed
            end

            local flyConnection
            flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if flying then
                    updateVelocity()
                else
                    flyConnection:Disconnect()
                    bodyVelocity:Destroy()
                end
            end)

            -- Para desligar o Fly
            FlyToggle.Callback = function(NewValue)
                flying = NewValue
                if not flying then
                    bodyVelocity:Destroy()
                end
            end
        end
    end
})
-- Seção ESP
local ESPSection = ESPTab:CreateSection("ESP Players")

-- Toggle ESP
local ESPToggle = ESPTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local RunService = game:GetService("RunService")
        local ESPBoxes = {}

        if Value then
            -- Função para criar ESP em cada jogador
            local function AddESP(target)
                if target == player then return end
                if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end

                local BillboardGui = Instance.new("BillboardGui")
                BillboardGui.Name = "ESP"
                BillboardGui.Adornee = target.Character.HumanoidRootPart
                BillboardGui.Size = UDim2.new(0,100,0,50)
                BillboardGui.AlwaysOnTop = true
                BillboardGui.Parent = target.Character

                local TextLabel = Instance.new("TextLabel")
                TextLabel.Size = UDim2.new(1,0,1,0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextColor3 = Color3.fromRGB(255,0,0)
                TextLabel.TextStrokeTransparency = 0
                TextLabel.TextScaled = true
                TextLabel.Text = target.Name
                TextLabel.Parent = BillboardGui

                ESPBoxes[target] = BillboardGui
            end

            -- Adiciona ESP para jogadores já no jogo
            for i, p in pairs(game.Players:GetPlayers()) do
                AddESP(p)
            end

            -- ESP para novos jogadores que entrarem
            local PlayerAddedConnection
            PlayerAddedConnection = game.Players.PlayerAdded:Connect(function(p)
                AddESP(p)
            end)

            -- Armazena conexão para desligar depois
            ESPToggle.PlayerAddedConnection = PlayerAddedConnection
        else
            -- Desliga ESP
            for p, gui in pairs(ESPBoxes) do
                if gui then gui:Destroy() end
            end
            ESPBoxes = {}
            if ESPToggle.PlayerAddedConnection then
                ESPToggle.PlayerAddedConnection:Disconnect()
            end
        end
    end
})
-- Seção Outros
local OutrosSection = OutrosTab:CreateSection("Funções Extras")

-- Teleporte por Nick
local TeleportInput = OutrosTab:CreateInput({
    Name = "Teleporte por Nick",
    PlaceholderText = "Digite o Nick do jogador",
    RemoveTextAfterFocusLost = false,
    Callback = function(Nick)
        local targetPlayer = game.Players:FindFirstChild(Nick)
        local player = game.Players.LocalPlayer
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
        else
            warn("Jogador não encontrado ou sem personagem.")
        end
    end
})

-- Spectar por Nick
local SpectateInput = OutrosTab:CreateInput({
    Name = "Spectar por Nick",
    PlaceholderText = "Digite o Nick do jogador",
    RemoveTextAfterFocusLost = false,
    Callback = function(Nick)
        local targetPlayer = game.Players:FindFirstChild(Nick)
        local player = game.Players.LocalPlayer
        local cam = workspace.CurrentCamera
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            cam.CameraSubject = targetPlayer.Character.Humanoid
        else
            warn("Jogador não encontrado ou sem personagem.")
        end
    end
})