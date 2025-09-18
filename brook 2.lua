--// Brookhaven Hub com Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Moon Hub | Brookhaven RP",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "Aguarde alguns segundos...",
    Theme = "Ocean",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "BrookhavenHub",
       FileName = "Config"
    },
    KeySystem = false,
})

--// Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Variáveis do Menu
local WalkspeedEnabled = false
local JumpEnabled = false
local WalkSpeedValue = 16
local JumpValue = 50

--// Aba Menu
local MenuTab = Window:CreateTab("Menu", 4483362458)

-- WalkSpeed Toggle
MenuTab:CreateToggle({
    Name = "Ativar Walkspeed",
    CurrentValue = false,
    Flag = "WalkspeedToggle",
    Callback = function(Value)
        WalkspeedEnabled = Value
        if WalkspeedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end,
})

-- WalkSpeed Slider
MenuTab:CreateSlider({
    Name = "Walkspeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkspeedSlider",
    Callback = function(Value)
        WalkSpeedValue = Value
        if WalkspeedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- Jump Toggle
MenuTab:CreateToggle({
    Name = "Ativar JumpPower",
    CurrentValue = false,
    Flag = "JumpToggle",
    Callback = function(Value)
        JumpEnabled = Value
        if JumpEnabled then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = JumpValue
        else
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end,
})

-- Jump Slider
MenuTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(Value)
        JumpValue = Value
        if JumpEnabled then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end,
})

--// Aba Casa
local CasaTab = Window:CreateTab("Casa", 4483362458)

CasaTab:CreateParagraph({Title = "Em breve...", Content = "Funções para casas serão adicionadas futuramente!"})

--// Variáveis Teleport/Spectar
local function GetPlayerList()
    local Names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(Names, plr.Name)
        end
    end
    return Names
end

local TeleportDropdown
local SpectateDropdown
local SpectateTarget

-- Aba Teleport
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportDropdown = TeleportTab:CreateDropdown({
    Name = "Escolher Player para Teleportar",
    Options = GetPlayerList(), -- lista inicial
    CurrentOption = "",
    Callback = function(Option)
        local Target = Players:FindFirstChild(Option)
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(Target.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🔄 Atualizar Lista",
    Callback = function()
        TeleportDropdown:Set(GetPlayerList())
        Rayfield:Notify({Title = "Lista Atualizada", Content = "Jogadores carregados com sucesso!"})
    end,
})

-- Aba Spectar
local SpectateTab = Window:CreateTab("Spectar", 6022668898)

SpectateDropdown = SpectateTab:CreateDropdown({
    Name = "Escolher Player para Spectar",
    Options = GetPlayerList(),
    CurrentOption = "",
    Callback = function(Option)
        SpectateTarget = Players:FindFirstChild(Option)
        if SpectateTarget and SpectateTarget.Character then
            workspace.CurrentCamera.CameraSubject = SpectateTarget.Character:FindFirstChildWhichIsA("Humanoid")
        end
    end,
})

SpectateTab:CreateButton({
    Name = "Parar Spectar",
    Callback = function()
        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        SpectateTarget = nil
    end,
})

SpectateTab:CreateButton({
    Name = "🔄 Atualizar Lista",
    Callback = function()
        SpectateDropdown:Set(GetPlayerList())
        Rayfield:Notify({Title = "Lista Atualizada", Content = "Jogadores carregados com sucesso!"})
    end,
})

--// Aba ESP
local ESPTab = Window:CreateTab("ESP", 4483362458)

local ESPEnabled = false
local ESPConnections = {}

local function CreateESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "ESP_Tag"
        Billboard.Size = UDim2.new(0, 200, 0, 50)
        Billboard.AlwaysOnTop = true
        Billboard.Adornee = player.Character:FindFirstChild("HumanoidRootPart")

        local Label = Instance.new("TextLabel")
        Label.Parent = Billboard
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = player.Name
        Label.TextColor3 = Color3.fromRGB(255, 0, 0)
        Label.TextStrokeTransparency = 0
        Label.Font = Enum.Font.SourceSansBold
        Label.TextScaled = true

        Billboard.Parent = player.Character:FindFirstChild("HumanoidRootPart")
    end
end

local function RemoveESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local Billboard = player.Character.HumanoidRootPart:FindFirstChild("ESP_Tag")
        if Billboard then
            Billboard:Destroy()
        end
    end
end

local function ToggleESP(state)
    ESPEnabled = state
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                CreateESP(plr)
            end
        end
        ESPConnections["Added"] = Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                if ESPEnabled then
                    CreateESP(plr)
                end
            end)
        end)
        ESPConnections["Removed"] = Players.PlayerRemoving:Connect(function(plr)
            RemoveESP(plr)
        end)
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                RemoveESP(plr)
            end
        end
        for _, con in pairs(ESPConnections) do
            con:Disconnect()
        end
        ESPConnections = {}
    end
end

ESPTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        ToggleESP(Value)
    end,
})

--// Aba Outros
local OutrosTab = Window:CreateTab("Outros", 4483362458)

-- Noclip
local NoclipEnabled = false
OutrosTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        NoclipEnabled = Value
    end,
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump
local InfJumpEnabled = false
OutrosTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        InfJumpEnabled = Value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

--// Aba Créditos
local CreditosTab = Window:CreateTab("Créditos", 4483362458)

CreditosTab:CreateParagraph({
    Title = "Créditos",
    Content = [[
Script Brookhaven Hub
Desenvolvido por: thalles456u
Interface por: Rayfield
Modificações e melhorias: thalles456u
Obrigado por usar o hub!
    ]]
})

CreditosTab:CreateButton({
  Name = "Clique aqui para copiar o discord do Hub!",
  Callback = function()
    setclipboard("https://discord.gg/WAGqyEfGJe")
  end
})

--// Notificação de carregamento
Rayfield:Notify({
    Title = "Brookhaven Hub",
    Content = "Script carregado com sucesso!",
    Duration = 5,
})

--// Garantir que as funções do Menu atualizem constantemente
game:GetService("RunService").Heartbeat:Connect(function()
    if WalkspeedEnabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
    end
    if JumpEnabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.JumpPower = JumpValue
    end
end)

--// Atualizar lista de players ao entrar no jogo
Players.PlayerAdded:Connect(function()
    if TeleportDropdown then
        TeleportDropdown:Set(GetPlayerList())
    end
    if SpectateDropdown then
        SpectateDropdown:Set(GetPlayerList())
    end
end)

Players.PlayerRemoving:Connect(function()
    if TeleportDropdown then
        TeleportDropdown:Set(GetPlayerList())
    end
    if SpectateDropdown then
        SpectateDropdown:Set(GetPlayerList())
    end
end)

local UpdatesTab = Window:CreateTab("Updates", 4483362458)

UpdatesTab:CreateParagraph({
  Title = "Novidades do Hub!",
  Content = [[
 - Aba da Casa:
 As funções dessa aba ainda estão sendo feitas, em breve serão lançadas!
 
 - Aba Menu
 Novo JumpForce funcional!
 
 - Aba Teleport Spectar:
 Nova funcionalidade de escolher players por uma lista! (Dropdown para os mais intimos ;-;)
  
  - Aba ESP
  ...
  
  - Créditos
  Novo botão para dopiar o dicord do Hub!
  
Novas atualizações embreve...
  
]]
})