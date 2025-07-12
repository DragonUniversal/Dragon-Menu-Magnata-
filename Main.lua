loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonUniversal/Dragon-Menu-/refs/heads/main/Library.lua"))()

-- Cria a janela principal
MakeWindow({
    Hub = {
        Title = "Dragon Menu I Magnata Da Guerra - v2",
        Animation = "by : Vitor Developer"
    },
    
   Key = {
        KeySystem = false, -- Ativa o sistema de Key
        Title = "Sistema de Chave",
        Description = "Digite a chave correta para continuar.",
        KeyLink = "https://seusite.com/chave", -- Link para obter a chave (opcional)
        Keys = {"1234", "chave-extra"},
        Notifi = {
            Notifications = true,
            CorrectKey = "Chave correta! Iniciando script...",
            Incorrectkey = "Chave incorreta, tente novamente.",
            CopyKeyLink = "Link copiado!"
        }
    }
})


-- Botão de minimizar

MinimizeButton({

    Image = "rbxassetid://137903795082783",
    Size = {40, 40},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

-- Criação da aba principal


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


-- Variáveis de controle
local espAtivado = false
local connections = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Função para criar ESP
local function criarESP(player)
    if player == LocalPlayer then return end

    task.spawn(function()
        while espAtivado do
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")

            if char and root and humanoid and humanoid.Health > 0 then
                local esp = root:FindFirstChild("ESP")
                if not esp then
                    esp = Instance.new("BillboardGui")
                    esp.Name = "ESP"
                    esp.Adornee = root
                    esp.Size = UDim2.new(0, 70, 0, 18)
                    esp.StudsOffset = Vector3.new(0, -3, 0)
                    esp.AlwaysOnTop = true

                    local text = Instance.new("TextLabel")
                    text.Name = "Texto"
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextSize = 10
                    text.TextScaled = false
                    text.Font = Enum.Font.Gotham
                    text.TextStrokeTransparency = 0.4
                    text.TextStrokeColor3 = Color3.new(0, 0, 0)
                    text.Parent = esp

                    esp.Parent = root

                    humanoid.Died:Connect(function()
                        if esp then esp:Destroy() end
                    end)
                end

                local texto = esp:FindFirstChild("Texto")
                if texto and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distancia = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    texto.Text = player.Name .. " - " .. math.floor(distancia) .. ""
                end
            end
            wait(0.3)
        end
    end)
end

-- Monitorar jogadores
local function monitorarPlayer(player)
    if connections[player] then
        connections[player]:Disconnect()
    end

    connections[player] = player.CharacterAdded:Connect(function()
        wait(1)
        if espAtivado then
            criarESP(player)
        end
    end)

    criarESP(player)
end

-- Toggle para ativar/desativar o ESP
AddToggle(Visuais, {
    Name = "ESP Nome",
    Default = false,
    Callback = function(Value)
        espAtivado = Value

        if espAtivado then
            for _, player in ipairs(Players:GetPlayers()) do
                monitorarPlayer(player)
            end

            connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
                monitorarPlayer(player)
            end)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                local char = player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local esp = root:FindFirstChild("ESP")
                        if esp then
                            esp:Destroy()
                        end
                    end
                end
                if connections[player] then
                    connections[player]:Disconnect()
                    connections[player] = nil
                end
            end

            if connections["PlayerAdded"] then
                connections["PlayerAdded"]:Disconnect()
                connections["PlayerAdded"] = nil
            end
        end
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
local AimbotTargetPart = "Head" -- Padrão
local ChangeMode = false

-- Desenha o círculo de FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = FOVRadius

local FOV_OffsetX = 30
local FOV_OffsetY = 0

-- Atualiza posição do círculo de FOV
RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    FOVCircle.Position = Vector2.new((screenSize.X / 2) + FOV_OffsetX, (screenSize.Y / 2) + FOV_OffsetY)
end)

-- Alterna automaticamente entre Head e Neck
local function toggleTargetPart()
    AimbotTargetPart = (AimbotTargetPart == "Head") and "Neck" or "Head"
end

-- Encontra jogador mais próximo dentro do FOV
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
    Name = "FOV",
    MinValue = 16,
    MaxValue = 250,
    Default = FOVRadius,
    Increase = 1,
    Callback = function(Value)
        FOVRadius = Value
        FOVCircle.Radius = FOVRadius
    end
})


