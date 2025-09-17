--// 99 Nights in the Forest Script com Moon Hub GUI //--

-- Carrega Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Serviços principais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
    Name = "Moon Hub | 99 Noites",
    LoadingTitle = "Moon Hub: Scripts",
    LoadingSubtitle = "dev. thalles456u",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "99NightsHub",
        FileName = "Config"
    },
    KeySystem = false
})

-- 🔔 Notificação inicial
Rayfield:Notify({
    Title = "Aviso!",
    Content = "Seu script Moon Hub foi executado com sucesso! Seja bem vindo ao Moon Hub! " .. LocalPlayer.Name,
    Duration = 6,
    Image = 4483362458
})

-- =========================
-- Menu Tab
-- =========================
local MenuTab = Window:CreateTab("Menu", 4483362458)

MenuTab:CreateButton({
    Name = "Teleport para Campfire",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:PivotTo(CFrame.new(0,10,0))
        end
    end
})

MenuTab:CreateButton({
    Name = "Teleport para Grinder",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:PivotTo(CFrame.new(16.1,4,-4.6))
        end
    end
})

-- Toggle Item ESP
MenuTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Callback = function(value)
        espEnabled = value
        Rayfield:Notify({
            Title = "Item ESP",
            Content = value and "Ativado" or "Desativado",
            Duration = 4,
            Image = 4483362458
        })
    end
})

-- Toggle NPC ESP (BETA)
MenuTab:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(value)
        toggleNPCESP(value)
        Rayfield:Notify({
            Title = "Npc ESP [BETA]",
            Content = value and "Ativado" or "Desativado",
            Duration = 4,
            Image = 4483362458
        })
    end
})
-- =========================
-- Fun Tab
-- =========================
local FunTab = Window:CreateTab("Fun", 4483362458)

-- =========================
-- Infinity Jump
-- =========================
local infJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

FunTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Callback = function(value)
        infJumpEnabled = value
        Rayfield:Notify({
            Title = "Infinity Jump",
            Content = value and "Ativado" or "Desativado",
            Duration = 4,
            Image = 4483362458,
        })
    end
})

-- =========================
-- Fullbring (Mapa Iluminado)
-- =========================
local fullbringEnabled = false
local lightsFolder = workspace:FindFirstChild("Fullbring_Lights") or Instance.new("Folder", workspace)
lightsFolder.Name = "Fullbring_Lights"

local function enableFullbring()
    for _, l in pairs(lightsFolder:GetChildren()) do l:Destroy() end
    for x = -1000, 1000, 200 do
        for z = -1000, 1000, 200 do
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 1
            part.Size = Vector3.new(1,1,1)
            part.Position = Vector3.new(x, 50, z)
            part.Parent = lightsFolder

            local light = Instance.new("PointLight")
            light.Brightness = 5
            light.Range = 120
            light.Color = Color3.fromRGB(255, 255, 200)
            light.Parent = part
        end
    end
end

local function disableFullbring()
    for _, l in pairs(lightsFolder:GetChildren()) do l:Destroy() end
end

FunTab:CreateToggle({
    Name = "Fullbring (Mapa Iluminado)",
    CurrentValue = false,
    Callback = function(value)
        fullbringEnabled = value
        if value then
            enableFullbring()
            Rayfield:Notify({
                Title = "Fullbring",
                Content = "Mapa Iluminado com sucesso!",
                Duration = 5,
                Image = 4483362458,
            })
        else
            disableFullbring()
            Rayfield:Notify({
                Title = "Fullbring",
                Content = "Iluminação Removida.",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end
})

-- =========================
-- Fly & Fly Speed
-- =========================
local flying = false
local flySpeed = 60
local flyConnection

local function startFlying()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bodyGyro = Instance.new("BodyGyro", hrp)
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)

    flyConnection = RunService.RenderStepped:Connect(function()
        local moveVec = Vector3.zero
        local camCF = camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += camCF.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= camCF.UpVector end
        bodyVelocity.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * flySpeed or Vector3.zero
        bodyGyro.CFrame = camCF
    end)
end

local function stopFlying()
    if flyConnection then flyConnection:Disconnect() end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

FunTab:CreateToggle({
    Name = "Fly (WASD + Space + Shift)",
    CurrentValue = false,
    Callback = function(value)
        flying = value
        if flying then startFlying() else stopFlying() end
        Rayfield:Notify({
            Title = "Fly",
            Content = value and "Ativado" or "Desativado",
            Duration = 4,
            Image = 4483362458
        })
    end
})

FunTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = " Speed",
    CurrentValue = 60,
    Callback = function(value)
        flySpeed = value
    end
})
-- =========================
-- Teleport Tab
-- =========================
local TeleTab = Window:CreateTab("Teleport", 4483362458)

local teleportTargets = {
    "Alien", "Alien Chest", "Alien Shelf", "Alpha Wolf", "Alpha Wolf Pelt", "Anvil Base",
    "Apple", "Bandage", "Bear", "Berry", "Bolt", "Broken Fan", "Broken Microwave",
    "Bunny", "Bunny Foot", "Cake", "Carrot", "Chest", "Chilli", "Coal", "Coin Stack",
    "Crossbow Cultist", "Cultist", "Cultist Gem", "Deer", "Fuel Canister", "Giant Sack",
    "Good Axe", "Iron Body", "Item Chest", "Laser Sword", "Leather Body", "Log", "Lost Child",
    "Medkit", "Meat? Sandwich", "Morsel", "Old Car Engine", "Old Flashlight", "Old Radio",
    "Oil Barrel", "Raygun", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo", "Riot Shield",
    "Sapling", "Seed Box", "Sheet Metal", "Spear", "Steak", "Stronghold Diamond Chest",
    "Tyre", "UFO Component", "UFO Junk", "Washing Machine", "Wolf", "Wolf Corpse", "Wolf Pelt"
}

for _, itemName in ipairs(teleportTargets) do
    TeleTab:CreateButton({
        Name = "Teleport para "..itemName,
        Callback = function()
            local closest, shortest = nil, math.huge
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == itemName and obj:IsA("Model") then
                    local cf
                    if pcall(function() cf = obj:GetPivot() end) then
                    else
                        local part = obj:FindFirstChildWhichIsA("BasePart")
                        if part then cf = part.CFrame end
                    end
                    if cf then
                        local dist = (cf.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist < shortest then
                            closest = cf
                            shortest = dist
                        end
                    end
                end
            end
            if closest then
                LocalPlayer.Character:PivotTo(closest + Vector3.new(0,5,0))
            else
                Rayfield:Notify({
                    Title = "Teleport Falhou",
                    Content = itemName.." não encontrado",
                    Duration = 4,
                    Image = 4483362458
                })
            end
        end
    })
end

-- =========================
-- Auto Tree Farm
-- =========================
local AutoTreeFarmEnabled = false
local badTrees = {}

task.spawn(function()
    while true do
        if AutoTreeFarmEnabled then
            local trees = {}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Trunk" and obj.Parent and obj.Parent.Name == "Small Tree" then
                    if not badTrees[obj:GetFullName()] then
                        table.insert(trees, obj)
                    end
                end
            end

            table.sort(trees, function(a,b)
                return (a.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <
                       (b.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            end)

            for _, trunk in ipairs(trees) do
                if not AutoTreeFarmEnabled then break end
                LocalPlayer.Character:PivotTo(trunk.CFrame + Vector3.new(0,3,0))
                task.wait(0.2)
                local startTime = tick()
                while AutoTreeFarmEnabled and trunk and trunk.Parent and trunk.Parent.Name == "Small Tree" do
                    local VirtualInputManager = game:GetService("VirtualInputManager")
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
                    task.wait(0.2)
                    if tick() - startTime > 12 then
                        badTrees[trunk:GetFullName()] = true
                        break
                    end
                end
                task.wait(0.3)
            end
        end
        task.wait(1.5)
    end
end)

FunTab:CreateToggle({
    Name = "Auto Tree Farm",
    CurrentValue = false,
    Callback = function(value)
        AutoTreeFarmEnabled = value
        Rayfield:Notify({
            Title = "Auto Tree Farm",
            Content = value and "Ativado" or "Desativado",
            Duration = 4,
            Image = 4483362458
        })
    end
})

-- =========================
-- Credits Tab
-- =========================
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateLabel("Feito por: thalles456u")
CreditsTab:CreateLabel("Interface por: Rayfield")
CreditsTab:CreateLabel("Alguma dúvida? Entre no nosso discord! Apenas clique na mensagem abaixo!")

CreditsTab:CreateButton({
    Name = "Clique aqui para copiar o link do Discord!",
    Callback = function()
        setclipboard("LinkDoDiscordAqui")
    end
})