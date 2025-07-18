loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonUniversal/Dragon-Menu-/refs/heads/main/Library.lua"))()



MakeWindow({

    Hub = {

        Title = "Dragon Menu I Magnata Da Guerra - v3.5",

        Animation = "by : VictorScript"

    },

    

    Key = {

        KeySystem = false,

        Title = "Sistema de Chave",

        Description = "Digite a chave correta para continuar.",

        KeyLink = "https://seusite.com/chave",

        Keys = {"1234", "28922"},

        Notifi = {

            Notifications = true,

            CorrectKey = "Chave correta! Iniciando script...",

            Incorrectkey = "Chave incorreta, tente novamente.",

            CopyKeyLink = "Link copiado!"

        }

    }

})



MinimizeButton({

    Image = "rbxassetid://137903795082783",

    Size = {40, 40},

    Color = Color3.fromRGB(10, 10, 10),

    Corner = true,

    CornerRadius = UDim.new(0.5, 0),

    Stroke = true,  -- Ativa a borda

    StrokeColor = Color3.fromRGB(255, 0, 0)

})



-- Criação da aba principal
local Main = MakeTab({Name = "Main"})
local Player = MakeTab({Name = "Player"})
local Visuais = MakeTab({Name = "Visuals"})
local Teleport = MakeTab({Name = "Teleport"})
local Config = MakeTab({Name = "Settings"})


AddButton(Main, {
    Name = "Fly GUI v4",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonUniversal/Fly-v4/refs/heads/main/main.lua"))()
        end)
    end
})

-- Noclip
local noclipConnection

function toggleNoclip(enable)
    if enable then
        if not noclipConnection then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Toggle para ativar/desativar colisão
AddToggle(Main, {
    Name = "Atravessar Paredes", 
    Default = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
})

-- Infinite Jump
local jumpConnection
local function toggleInfiniteJump(enable)
    if enable then
        if not jumpConnection then
            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end

-- Toggle para ativar/desativar pulo infinito
local Toggle = AddToggle(Main, {
    Name = "Pulos infinito",
    Default = false,
    Callback = function(Value)
        toggleInfiniteJump(Value)
    end
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local velocidadeAtivada = false
local velocidadeValor = 25
local armaEquipada = false

-- Atualiza a velocidade se condições forem atendidas
local function atualizarVelocidade()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if velocidadeAtivada and armaEquipada then
            humanoid.WalkSpeed = velocidadeValor
        else
            humanoid.WalkSpeed = 16 -- velocidade padrão
        end
    end
end

-- Verifica quando uma Tool (arma) é equipada
local function monitorarArmas(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            armaEquipada = true
            atualizarVelocidade()
        end
    end)

    character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            armaEquipada = false
            atualizarVelocidade()
        end
    end)
end

-- Slider de Velocidade
AddSlider(Main, {
    Name = "Velocidade",
    MinValue = 16,
    MaxValue = 250,
    Default = 25,
    Increase = 1,
    Callback = function(Value)
        velocidadeValor = Value
        atualizarVelocidade()
    end
})

-- Toggle para ativar/desativar a velocidade
AddToggle(Main, {
    Name = "Velocidade",
    Default = false,
    Callback = function(Value)
        velocidadeAtivada = Value
        atualizarVelocidade()
    end
})

-- Monitorar personagem atual e futuros
if LocalPlayer.Character then
    monitorarArmas(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    armaEquipada = false
    monitorarArmas(character)
end)



local jumpAtivado = false
local jumpPowerSelecionado = 25
local jumpPowerPadrao = 50  -- Valor padrão do JumpPower do Roblox

-- Função para aplicar ou restaurar altura do pulo
local function aplicarJumpPower()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        if jumpAtivado then
            humanoid.JumpPower = jumpPowerSelecionado
        else
            humanoid.JumpPower = jumpPowerPadrao
        end
    end
end

-- Slider de Altura do Pulo
AddSlider(Main, {
    Name = "Super Pulo",
    MinValue = 10,
    MaxValue = 900,
    Default = 40,
    Increase = 1,
    Callback = function(Value)
        jumpPowerSelecionado = Value
        if jumpAtivado then
            aplicarJumpPower()
        end
    end
})

-- Toggle para ativar/desativar altura do pulo
AddToggle(Main, {
    Name = "Super Pulo",
    Default = false,
    Callback = function(Value)
        jumpAtivado = Value
        aplicarJumpPower()
    end
})

local gravidadeAtivada = false
local gravidadeSelecionada = 196.2 -- valor padrão
local gravidadePadrao = 196.2

-- Slider para ajustar a gravidade
AddSlider(Main, {
    Name = "Gravidade",
    MinValue = 0,
    MaxValue = 500,
    Default = 196.2,
    Increase = 1,
    Callback = function(Value)
        gravidadeSelecionada = Value
        if gravidadeAtivada then
            workspace.Gravity = gravidadeSelecionada
        end
    end
})

-- Toggle para ativar/desativar o controle de gravidade
AddToggle(Main, {
    Name = "Gravidade",
    Default = false,
    Callback = function(Value)
        gravidadeAtivada = Value
        if gravidadeAtivada then
            workspace.Gravity = gravidadeSelecionada
        else
            workspace.Gravity = gravidadePadrao
        end
    end
})



local Players = game:GetService("Players") 

local LocalPlayer = Players.LocalPlayer

local RunService = game:GetService("RunService")

local playerName = ""
local jogadorSelecionado = nil
local observando = false
local observarConnection = nil
local dropdownRef = nil

-- Função para encontrar jogador pelo nome digitado (busca parcial)
local function encontrarJogador(nome)
	local lowerName = nome:lower()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Name:lower():sub(1, #lowerName) == lowerName then
			return player
		end
	end
	return nil
end

-- Caixa de texto para digitar nome do jogador
AddTextBox(Player, {
	Name = "Digita nome do jogador",
	Default = "",
	Placeholder = "Nome do jogador aqui...",
	Callback = function(text)
		playerName = text
		jogadorSelecionado = encontrarJogador(playerName)
	end
})

-- Parar observação
local function pararObservar()
	if observarConnection then
		observarConnection:Disconnect()
		observarConnection = nil
	end
	observando = false
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
	end
	print("Observação desativada.")
end

-- Iniciar observação
local function iniciarObservar(jogador)
	if not jogador or jogador == LocalPlayer then
		warn("Jogador inválido para observar.")
		return
	end

	observando = true

	if not jogador.Character or not jogador.Character:FindFirstChild("Humanoid") then
		warn("Personagem do jogador não está disponível.")
		return
	end

	workspace.CurrentCamera.CameraSubject = jogador.Character.Humanoid
	print("Observando " .. jogador.Name)

	observarConnection = jogador.CharacterAdded:Connect(function()
		wait(1)
		if observando then
			if jogador.Character and jogador.Character:FindFirstChild("Humanoid") then
				workspace.CurrentCamera.CameraSubject = jogador.Character.Humanoid
				print("Continuando observação após respawn.")
			end
		end
	end)
end

-- Toggle para observar
AddToggle(Player, {
	Name = "Observar",
	Default = false,
	Callback = function(Value)
		jogadorSelecionado = encontrarJogador(playerName)
		if Value then
			if jogadorSelecionado then
				iniciarObservar(jogadorSelecionado)
			else
				warn("Jogador não encontrado para observar.")
			end
		else
			pararObservar()
		end
	end
})

-- Botão de teleporte único
AddButton(Player, {
	Name = "Teleporte",
	Callback = function()
		local jogador = encontrarJogador(playerName)
		if jogador and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
			local localChar = LocalPlayer.Character
			if localChar and localChar:FindFirstChild("HumanoidRootPart") then
				localChar.HumanoidRootPart.CFrame = jogador.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 3)
				print("Teletransportado para " .. jogador.Name)
			else
				warn("Seu personagem não está disponível.")
			end
		else
			warn("Jogador inválido ou personagem não carregado.")
		end
	end
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espNomeAtivado = false
local espDistAtivado = false
local connections = {}

local function criarESP(player)
    if player == LocalPlayer then return end

    task.spawn(function()
        while (espNomeAtivado or espDistAtivado) and player and player.Character do
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local rightFoot = char:FindFirstChild("RightFoot")
            local humanoid = char:FindFirstChild("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local cor = Color3.fromRGB(255, 255, 255)

                -- ESP NOME
                if espNomeAtivado and head and not head:FindFirstChild("ESP_Name") then
                    local espNome = Instance.new("BillboardGui")
                    espNome.Name = "ESP_Name"
                    espNome.Adornee = head
                    espNome.Size = UDim2.new(0, 100, 0, 18)
                    espNome.StudsOffset = Vector3.new(0, 1.5, 0)
                    espNome.AlwaysOnTop = true

                    local texto = Instance.new("TextLabel")
                    texto.Size = UDim2.new(1, 0, 1, 0)
                    texto.BackgroundTransparency = 1
                    texto.TextColor3 = cor
                    texto.TextStrokeTransparency = 0.4
                    texto.TextStrokeColor3 = Color3.new(0, 0, 0)
                    texto.Font = Enum.Font.Gotham
                    texto.TextSize = 10
                    texto.Text = player.Name
                    texto.Parent = espNome

                    espNome.Parent = head

                    humanoid.Died:Connect(function()
                        espNome:Destroy()
                    end)
                end

                -- ESP DISTÂNCIA
                if espDistAtivado and rightFoot and not rightFoot:FindFirstChild("ESP_Distancia") then
                    local espDist = Instance.new("BillboardGui")
                    espDist.Name = "ESP_Distancia"
                    espDist.Adornee = rightFoot
                    espDist.Size = UDim2.new(0, 100, 0, 18)
                    espDist.StudsOffset = Vector3.new(1.5, 0, 0)
                    espDist.AlwaysOnTop = true

                    local textoDist = Instance.new("TextLabel")
                    textoDist.Size = UDim2.new(1, 0, 1, 0)
                    textoDist.BackgroundTransparency = 1
                    textoDist.TextColor3 = cor
                    textoDist.TextStrokeTransparency = 0.4
                    textoDist.TextStrokeColor3 = Color3.new(0, 0, 0)
                    textoDist.Font = Enum.Font.Gotham
                    textoDist.TextSize = 10
                    textoDist.Name = "Texto"
                    textoDist.Text = ""
                    textoDist.Parent = espDist

                    espDist.Parent = rightFoot

                    humanoid.Died:Connect(function()
                        espDist:Destroy()
                    end)
                end

                -- Atualizar texto da distância
                if espDistAtivado and rightFoot and rightFoot:FindFirstChild("ESP_Distancia") then
                    local textoDist = rightFoot.ESP_Distancia:FindFirstChild("Texto")
                    if textoDist and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                        local distancia = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        textoDist.Text = math.floor(distancia) .. "m"
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

local function monitorarPlayer(player)
    if connections[player] then
        connections[player]:Disconnect()
    end

    connections[player] = player.CharacterAdded:Connect(function()
        task.wait(1)
        if espNomeAtivado or espDistAtivado then
            criarESP(player)
        end
    end)

    if player.Character then
        criarESP(player)
    end
end

local function limparESP()
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char then
            local head = char:FindFirstChild("Head")
            local foot = char:FindFirstChild("RightFoot")
            if head and head:FindFirstChild("ESP_Name") then
                head.ESP_Name:Destroy()
            end
            if foot and foot:FindFirstChild("ESP_Distancia") then
                foot.ESP_Distancia:Destroy()
            end
        end
    end
end

-- ESP NOME
AddToggle(Visuais, {
    Name = "ESP Name",
    Default = false,
    Callback = function(Value)
        espNomeAtivado = Value

        if espNomeAtivado then
            for _, player in ipairs(Players:GetPlayers()) do
                monitorarPlayer(player)
            end
            if not connections["PlayerAdded"] then
                connections["PlayerAdded"] = Players.PlayerAdded:Connect(monitorarPlayer)
            end
        else
            limparESP()
        end
    end
})

-- ESP DISTÂNCIA
AddToggle(Visuais, {
    Name = "ESP Distance",
    Default = false,
    Callback = function(Value)
        espDistAtivado = Value

        if espDistAtivado then
            for _, player in ipairs(Players:GetPlayers()) do
                monitorarPlayer(player)
            end
            if not connections["PlayerAdded"] then
                connections["PlayerAdded"] = Players.PlayerAdded:Connect(monitorarPlayer)
            end
        else
            limparESP()
        end
    end
})


-- Variável global para controlar o estado do ESP
local espAtivado = false

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Aplica o Highlight ao personagem
local function aplicarHighlight(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if character and not character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 1
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    end
end

-- Remove o Highlight
local function removerHighlight(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Atualiza todos os jogadores
local function atualizarESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if espAtivado then
            aplicarHighlight(player)
        else
            removerHighlight(player)
        end
    end
end

-- Listener para novos jogadores e respawn
local function monitorarPlayer(player)
    if player == LocalPlayer then return end

    player.CharacterAdded:Connect(function()
        if espAtivado then
            aplicarHighlight(player)
        end
    end)
end

-- Inicia monitoramento de todos os jogadores
for _, player in ipairs(Players:GetPlayers()) do
    monitorarPlayer(player)
end

Players.PlayerAdded:Connect(monitorarPlayer)

-- Loop contínuo 
RunService.RenderStepped:Connect(function()
    if espAtivado then
        atualizarESP()
    end
end)

-- Toggle para ativar/desativar o ESP
AddToggle(Visuais, {
    Name = "ESP Box",
    Default = false,
    Callback = function(Value)
        espAtivado = Value
        atualizarESP()
    end
})


AddButton(Teleport, {
    Name = "Bandeira",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-659.4813842773438, 186.2876434326172, -1258.3475341796875)
        end)
    end
})

AddButton(Teleport, {
    Name = "Prédio 1",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-730.6873168945312, 301.83740234375, -937.3375244140625)
        end)
    end
})

AddButton(Teleport, {
    Name = "Prédio de heliponto",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-239.97340393066406, 447.56982421875, -1485.5546875)
        end)
    end
})

AddButton(Teleport, {
    Name = "Barril De Petróleo 1",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(668.4365844726562, 121.2524185180664, 783.4068603515625)
        end)
    end
})

AddButton(Teleport, {
    Name = "Barril De Petróleo 2",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1214.93896484375, 67.0999755859375, -1881.4852294921875)
        end)
    end
})

AddButton(Teleport, {
    Name = "Barril De Petróleo 3",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1683.255859375, 121.25241088867188, -3525.08740234375)
        end)
    end
})


AddButton(Teleport, {
    Name = "Barril De Petróleo 4",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-971.543945, 69.552948, -809.066467))
        end)
    end
})


-- Variável para guardar a posição salva
local savedCFrame = nil

-- Botão: salvar posição
AddButton(Teleport, {
    Name = "Salvar Posição",
    Callback = function()
        print("Botão foi clicado! Salvando posição...")
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            savedCFrame = hrp.CFrame
            print("Posição salva:", tostring(savedCFrame))
        end)
    end
})

-- Botão: Teleportar para a posição salva
AddButton(Teleport, {
    Name = "Teleportar para posição salva",
    Callback = function()
        print("Botão foi clicado! Teleportando...")
        pcall(function()
            if savedCFrame then
                local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = savedCFrame
                print("Teleportado com sucesso.")
            else
                warn("Nenhuma posição salva ainda!")
            end
        end)
    end
})


-- Serviços

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis do Aimbot
local AimbotEnabled = false
local AimbotConnection = nil
local FOVRadius = 100
local AimbotTargetPart = "Head"
local ChangeMode = false

-- Desenha o círculo de FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = FOVRadius

-- Correção do centro
local FOV_OffsetX = 5
local FOV_OffsetY = 0

-- Atualiza posição do círculo de FOV
RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    FOVCircle.Position = Vector2.new((screenSize.X / 2) + FOV_OffsetX, (screenSize.Y / 2) + FOV_OffsetY)
end)

-- Alterna entre Head e Neck automaticamente
local function toggleTargetPart()
    AimbotTargetPart = (AimbotTargetPart == "Head") and "Neck" or "Head"
end

-- Encontra o jogador mais próximo do FOV
local function getClosestPlayerToFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local part = otherPlayer.Character:FindFirstChild(AimbotTargetPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
                    if dist < FOVCircle.Radius and dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Toggle do Aimbot
AddToggle(Config, {
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
        FOVCircle.Visible = Value

        if Value and not AimbotConnection then
            AimbotConnection = RunService.RenderStepped:Connect(function()
                if ChangeMode then toggleTargetPart() end
                local target = getClosestPlayerToFOV()
                if target and target.Character then
                    local part = target.Character:FindFirstChild(AimbotTargetPart)
                    if part then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                    end
                end
            end)
        elseif not Value and AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
    end
})

-- Slider para controlar o tamanho do FOV
AddSlider(Config, {
    Name = "Tamanho do FOV",
    MinValue = 19,
    MaxValue = 190,
    Default = FOVRadius,
    Increase = 1,
    Callback = function(Value)
        FOVRadius = Value
        FOVCircle.Radius = FOVRadius
    end
})


-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Variáveis do Silent Aim
local SilentAimEnabled = false
local FOVRadius = 100
local SilentAimTargetPart = "Head"

-- Criação do círculo FOV
local SilentAimCircle = Drawing.new("Circle")
SilentAimCircle.Color = Color3.fromRGB(0, 255, 0)
SilentAimCircle.Thickness = 1.5
SilentAimCircle.Filled = false
SilentAimCircle.Visible = false
SilentAimCircle.Radius = FOVRadius

-- Offset para posicionamento visual (ajuste conforme necessário)
local FOV_OffsetX = 30
local FOV_OffsetY = 0

-- Atualiza a posição do FOV no RenderStepped
RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    SilentAimCircle.Position = Vector2.new((screenSize.X / 2) + FOV_OffsetX, (screenSize.Y / 2) + FOV_OffsetY)
end)

-- Função para encontrar o alvo mais próximo
local function getClosestToFOV()
    local closest = nil
    local shortestDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(SilentAimTargetPart) then
            local part = player.Character[SilentAimTargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - SilentAimCircle.Position).Magnitude
                if dist < FOVRadius and dist < shortestDist then
                    shortestDist = dist
                    closest = part
                end
            end
        end
    end

    return closest
end

-- Hook de raycast para "redirecionar" disparos
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if SilentAimEnabled and method == "FireServer" and tostring(self):lower():find("shoot") then
        local targetPart = getClosestToFOV()
        if targetPart then
            -- Substitui a posição de tiro pelo alvo encontrado
            for i, v in ipairs(args) do
                if typeof(v) == "Vector3" then
                    args[i] = targetPart.Position + (targetPart.Velocity * 0.05)
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, ...)
end)

-- Toggle para ativar/desativar Silent Aim
AddToggle(Config, {
    Name = "Silent Aim",
    Default = false,
    Callback = function(Value)
        SilentAimEnabled = Value
        SilentAimCircle.Visible = Value
    end
})

-- Slider de ajuste de FOV
AddSlider(Config, {
    Name = "Silent FOV",
    MinValue = 16,
    MaxValue = 100,
    Default = FOVRadius,
    Increase = 1,
    Callback = function(Value)
        FOVRadius = Value
        SilentAimCircle.Radius = Value
    end
})
