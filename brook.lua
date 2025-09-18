--// Brookhaven Hub Script //--

-- Carrega Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Variáveis
local WalkEnabled = false
local JumpEnabled = false
local WalkSpeedValue = 16
local JumpValue = 50

-- Criação da Janela
local Window = Rayfield:CreateWindow({
   Name = "Moon Hub | Brookhaven",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "Aguarde alguns segundos...",
   Theme = "Ocean",
   DisableRayfieldPrompts = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrookhavenHub",
      FileName = "Config"
   }
})

--// ABA MENU
local MenuTab = Window:CreateTab("Menu", 4483362458) -- Ícone opcional

-- WalkSpeed
MenuTab:CreateToggle({
   Name = "Ativar WalkSpeed",
   CurrentValue = false,
   Flag = "WalkToggle",
   Callback = function(Value)
      WalkEnabled = Value
   end,
})

MenuTab:CreateSlider({
   Name = "Velocidade",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSlider",
   Callback = function(Value)
      WalkSpeedValue = Value
   end,
})

-- JumpPower
MenuTab:CreateToggle({
   Name = "Ativar JumpForce",
   CurrentValue = false,
   Flag = "JumpToggle",
   Callback = function(Value)
      JumpEnabled = Value
   end,
})

MenuTab:CreateSlider({
   Name = "Força do Pulo",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      JumpValue = Value
   end,
})

-- Atualização constante
RunService.RenderStepped:Connect(function()
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      if WalkEnabled then
         LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
      else
         LocalPlayer.Character.Humanoid.WalkSpeed = 16
      end

      if JumpEnabled then
         LocalPlayer.Character.Humanoid.JumpPower = JumpValue
      else
         LocalPlayer.Character.Humanoid.JumpPower = 50
      end
   end
end)
--// ABA CASA
local CasaTab = Window:CreateTab("Casa", 4483362458)

CasaTab:CreateParagraph({Title = "Aviso", Content = "Em breve novas funções para Casa!"})


--// ABA TELEPORTS
local TeleportTab = Window:CreateTab("Teleports", 4483362458)

-- Lista de jogadores
local PlayerList = {}
local SelectedPlayer = nil

-- Função para atualizar lista
local function UpdatePlayerList()
    PlayerList = {}
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(PlayerList, plr.Name)
        end
    end
end

-- Dropdown com jogadores
local PlayerDropdown = TeleportTab:CreateDropdown({
   Name = "Escolher Player",
   Options = PlayerList,
   CurrentOption = "",
   Flag = "TeleportDropdown",
   Callback = function(Value)
      SelectedPlayer = Value
   end,
})

-- Botão atualizar lista
TeleportTab:CreateButton({
   Name = "Atualizar Lista",
   Callback = function()
      UpdatePlayerList()
      PlayerDropdown:Set(PlayerList)
   end,
})

-- Botão teleportar
TeleportTab:CreateButton({
   Name = "Teleportar para Player",
   Callback = function()
      if SelectedPlayer then
         local Target = Players:FindFirstChild(SelectedPlayer)
         if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(Target.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
         end
      end
   end,
})

-- Inicializa a lista
UpdatePlayerList()
PlayerDropdown:Set(PlayerList)
--// ABA ESP
local ESPTab = Window:CreateTab("ESP", 4483362458)

local ESPEnabled = false
local ESPObjects = {}

-- Criar ESP em um player
local function CreateESP(plr)
    if plr.Character and plr.Character:FindFirstChild("Head") then
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "ESP_"..plr.Name
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0,100,0,30)
        Billboard.Adornee = plr.Character.Head

        local Label = Instance.new("TextLabel", Billboard)
        Label.Size = UDim2.new(1,0,1,0)
        Label.Text = plr.Name
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(255, 0, 0)
        Label.TextScaled = true

        Billboard.Parent = plr.Character.Head
        ESPObjects[plr.Name] = Billboard
    end
end

-- Remover ESP
local function RemoveESP(plr)
    if ESPObjects[plr.Name] then
        ESPObjects[plr.Name]:Destroy()
        ESPObjects[plr.Name] = nil
    end
end

-- Monitorar players
local function EnableESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreateESP(plr)
        end
    end
    Players.PlayerAdded:Connect(function(plr)
        if ESPEnabled then
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                CreateESP(plr)
            end)
        end
    end)
    Players.PlayerRemoving:Connect(function(plr)
        RemoveESP(plr)
    end)
end

ESPTab:CreateToggle({
   Name = "Ativar ESP Players",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      ESPEnabled = Value
      if ESPEnabled then
         EnableESP()
      else
         for _,esp in pairs(ESPObjects) do
            esp:Destroy()
         end
         ESPObjects = {}
      end
   end,
})
--// ABA OUTROS
local OutrosTab = Window:CreateTab("Outros", 4483362458)

local SpectateTarget = nil
local Spectating = false
local SpectateList = {}

-- Atualizar lista de jogadores
local function UpdateSpectateList()
    SpectateList = {}
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(SpectateList, plr.Name)
        end
    end
end

-- Dropdown Spectar
local SpectateDropdown = OutrosTab:CreateDropdown({
   Name = "Escolher Player para Spectar",
   Options = SpectateList,
   CurrentOption = "",
   Flag = "SpectateDropdown",
   Callback = function(Value)
      SpectateTarget = Value
   end,
})

-- Botão Atualizar Lista
OutrosTab:CreateButton({
   Name = "Atualizar Lista",
   Callback = function()
      UpdateSpectateList()
      SpectateDropdown:Set(SpectateList)
   end,
})

-- Toggle Spectar
OutrosTab:CreateToggle({
   Name = "Spectar Jogador",
   CurrentValue = false,
   Flag = "SpectateToggle",
   Callback = function(Value)
      Spectating = Value
      if Spectating and SpectateTarget then
         local Target = Players:FindFirstChild(SpectateTarget)
         if Target and Target.Character then
            Camera.CameraSubject = Target.Character:FindFirstChild("Humanoid")
         end
      else
         Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
      end
   end,
})

-- Inicializa lista
UpdateSpectateList()
SpectateDropdown:Set(SpectateList)

--// ABA CRÉDITOS
local CreditosTab = Window:CreateTab("Créditos", 4483362458)

CreditosTab:CreateParagraph({
   Title = "Créditos",
   Content = [[
Script feito por: thalles456u
Interface: Rayfield
Alguma duvida sobre o Hub? Entre no discord link estará logo abaixo!
   ]]
})   
   
   CreditosTab:CreateButton({
       Name = "Link Discord",
       Callback = function()
      setclipboard("https://discord.gg/WAGqyEfGJe")
      end
})