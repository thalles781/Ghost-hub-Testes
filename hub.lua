-- UI
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
  Title = "Talos Hub : Universal",
  SubTitle = "by thalles456u",
  SaveFolder = "TalosHub | RedzLib.lua"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://71014873973869", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- ================== ABA MENU ==================
local TabMenu = Window:MakeTab({"Menu", "cherry"})

TabMenu:AddDiscordInvite({
    Name = "Talos Hub | Community",
    Description = "Entrar no servidor",
    Logo = "rbxassetid://18751483361",
    Invite = "Link discord invite",
})

local Section = TabMenu:AddSection({"Section"})
local Paragraph = TabMenu:AddParagraph({"AVISO!", "Essa é apenas uma Beta Teste do Hub do Talos então não espere muitas coisas."})

-- ================== SPEED ==================
local player = game.Players.LocalPlayer
local SpeedActive = false
local SpeedValue = 16 -- valor padrão

TabMenu:AddButton({"Ativar/Desativar Speed", function()
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    SpeedActive = not SpeedActive
    if SpeedActive then
        player.Character.Humanoid.WalkSpeed = SpeedValue
    else
        player.Character.Humanoid.WalkSpeed = 16
    end
end})

TabMenu:AddSlider({
  Name = "Speed",
  Min = 1,
  Max = 100,
  Increase = 1,
  Default = 16,
  Callback = function(Value)
      SpeedValue = Value
      if SpeedActive and player.Character and player.Character:FindFirstChild("Humanoid") then
          player.Character.Humanoid.WalkSpeed = Value
      end
  end
})

-- ================== INFINITY JUMP ==================
TabMenu:AddToggle({
    Name = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local UserInputService = game:GetService("UserInputService")
        if state then
            _G.InfJump = true
            UserInputService.JumpRequest:Connect(function()
                if _G.InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        else
            _G.InfJump = false
        end
    end
})

-- ================== Toggle Exemplo ==================
local Toggle1 = TabMenu:AddToggle({
  Name = "Exemplo Toggle",
  Description = "Exemplo de toggle",
  Default = false 
})
Toggle1:Callback(function(Value) 
    print("Toggle 1:", Value)
end)

-- ================== ABA CASA ==================
local TabCasa = Window:MakeTab({"Casa", "house"})
local RunService = game:GetService("RunService")
local noclipActive = false
local ESPActive = false

-- ================== Noclip ==================
TabCasa:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        noclipActive = state
        if state then
            RunService.Stepped:Connect(function()
                if noclipActive and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

-- ================== Fullbring ==================
TabCasa:AddButton({"Fullbring", function()
    local char = player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 0, 255)
                part.Reflectance = 0.3
            end
        end
    end
end})

-- ================== ESP Players ==================
local function CreateESP(plr)
    if plr.Character and not plr.Character:FindFirstChild("ESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.Adornee = plr.Character
        highlight.FillColor = Color3.fromRGB(0,255,0)
        highlight.OutlineColor = Color3.fromRGB(0,0,0)
        highlight.Parent = plr.Character
    end
end

TabCasa:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(state)
        ESPActive = state
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                if state then
                    CreateESP(plr)
                else
                    if plr.Character and plr.Character:FindFirstChild("ESP") then
                        plr.Character.ESP:Destroy()
                    end
                end
            end
        end
    end
})

game.Players.PlayerAdded:Connect(function(plr)
    if ESPActive then
        plr.CharacterAdded:Connect(function()
            CreateESP(plr)
        end)
    end
end)

-- ================== ABA OUTROS ==================
local TabOutros = Window:MakeTab({"Outros", "fire"})
local camera = workspace.CurrentCamera
local spectateTarget
local RenderStepped = game:GetService("RunService").RenderStepped

-- ================== Teleport por Nick ==================
TabOutros:AddTextBox({
    Name = "Teleport por Nick",
    Description = "Digite o nick do player",
    PlaceholderText = "Nick do player",
    Callback = function(Value)
        local target = game.Players:FindFirstChild(Value)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:MoveTo(target.Character.HumanoidRootPart.Position)
            end
        end
    end
})

-- ================== Spectar por Nick ==================
local spectating = false
local connection

TabOutros:AddTextBox({
    Name = "Spectar por Nick",
    Description = "Digite o nick do player",
    PlaceholderText = "Nick do player",
    Callback = function(Value)
        local target = game.Players:FindFirstChild(Value)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            spectateTarget = target
            camera.CameraType = Enum.CameraType.Scriptable
            spectating = true

            -- Se já tiver conexão, desconecta para evitar duplicação
            if connection then connection:Disconnect() end

            connection = RenderStepped:Connect(function()
                if spectating and spectateTarget and spectateTarget.Character and spectateTarget.Character:FindFirstChild("HumanoidRootPart") then
                    -- Câmera atrás e acima do player
                    local hrp = spectateTarget.Character.HumanoidRootPart
                    camera.CFrame = hrp.CFrame * CFrame.new(0, 5, 10)
                end
            end)
        end
    end
})

-- ================== Parar de Spectar ==================
TabOutros:AddButton({"Parar Spectar", function()
    spectating = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
    camera.CameraType = Enum.CameraType.Custom
end})

redzlib:SetTheme("Purple")
Window:SelectTab(TabMenu)