local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Ghost Hub",
   Icon = nil, -- ou assetId válido em string
   LoadingTitle = "GhostHub.",
   LoadingSubtitle = "by thalles456u",
   Theme = "Black",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Aura Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "JF2F2RANud",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Ghost Key",
      Subtitle = "Key System",
      Note = "Para conseguir a key, entre no vídeo mais recente do Talos!",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"keybind_adm", "Ore", "AuraHub"}
   }
})

local AuraHub = Window:CreateTab("Menu", 4483362458)
local Farm = Window:CreateTab("LocalPlayer", 4483362458)
local Farm2 = Window:CreateTab("Fun", 4483362458)
local Farm3 = Window:CreateTab("ESP", 4483362458)
local Farm4 = Window:CreateTab("Outros", 4483362458)

local SectionMain = AuraHub:CreateSection("Funções Principais")

local function MatarJogador()
   local player = game.Players.LocalPlayer
   if player and player.Character and player.Character:FindFirstChild("Humanoid") then
      player.Character.Humanoid.Health = 0
   end
end

local ButtonKill = Farm:CreateButton({
   Name = "Matar Jogador",
   Callback = MatarJogador
})

local ToggleFlash = AuraHub:CreateToggle({
   Name = "Flash",
   CurrentValue = false,
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player and player.Character and player.Character:FindFirstChild("Humanoid") then
         if Value then
            player.Character.Humanoid.WalkSpeed = 50
         else
            player.Character.Humanoid.WalkSpeed = 16
         end
      end
   end
})

local SliderJump = Farm:CreateSlider({
   Name = "Pulo (JumpPower)",
   Range = {0, 100},
   Increment = 1,
   Suffix = "", -- sem '%'
   CurrentValue = 50,
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player and player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.JumpPower = Value
      end
   end
})

local SectionNPC = Farm:CreateSection("NPCs")

local InputNPC = Farm:CreateInput({
   Name = "Nome do NPC",
   PlaceholderText = "Digite um NPC...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      -- aqui você pode adicionar ação para o texto digitado
   end
})

local DropdownNPC = Farm:CreateDropdown({
   Name = "Selecionar NPC",
   Options = {"Npc 1", "Npc 2", "Npc 3"},
   CurrentOption = "Npc 1",
   Callback = function(Option)
      -- ação para opção selecionada
   end
})

local SectionExtra = Farm:CreateSection("Extras")

local KeybindExample = Farm:CreateKeybind({
   Name = "Atalho de Teclado",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Callback = function(Key)
      -- ação ao pressionar a tecla
   end
})

local ParagraphCreator = Farm:CreateParagraph({
   Title = "Criador",
   Content = "Aura Hub by Aura"
})

Rayfield:LoadConfiguration()
