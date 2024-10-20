local teleportFunc = queueonteleport or queue_on_teleport or syn and syn.queue_on_teleport
if teleportFunc then
    teleportFunc([[

if not game:IsLoaded() then
    game.Loaded:Wait()
end
wait(3.25)
loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptPhantom/SlapBattles/refs/heads/main/autofarmcandy.lua))()

                ]])
end

if workspace:FindFirstChild("SafeBox") == nil then
    local S = Instance.new("Part")
    S.Name = "SafeBox"
    S.Anchored = true
    S.CanCollide = true
    S.Transparency = .5
    S.Position = Vector3.new(-16500, -15000, -15000)  -- Увеличено расстояние в 3 раза
    S.Size = Vector3.new(21, 5, 21)
    S.Parent = workspace

    local S1 = Instance.new("Part")
    S1.Name = "S1"
    S1.Anchored = true
    S1.CanCollide = true
    S1.Transparency = .5
    S1.Position = Vector3.new(-16499.91, -14991.5, -14967.27)  -- Увеличено расстояние в 3 раза
    S1.Size = Vector3.new(20, 13, 2)
    S1.Parent = workspace:FindFirstChild("SafeBox")

    local S2 = Instance.new("Part")
    S2.Name = "S2"
    S2.Anchored = true
    S2.CanCollide = true
    S2.Transparency = .5
    S2.Position = Vector3.new(-16510.27979, -14991.5, -15000.08984)  -- Увеличено расстояние в 3 раза
    S2.Size = Vector3.new(21, 14, 2)
    S2.Rotation = Vector3.new(0, -90, 0)
    S2.Parent = workspace:FindFirstChild("SafeBox")

    local S3 = Instance.new("Part")
    S3.Name = "S3"
    S3.Anchored = true
    S3.CanCollide = true
    S3.Transparency = .5
    S3.Position = Vector3.new(-16499.3, -14991.5, -15033.36)  -- Увеличено расстояние в 3 раза
    S3.Size = Vector3.new(21, 13, 2)
    S3.Parent = workspace:FindFirstChild("SafeBox")

    local S4 = Instance.new("Part")
    S4.Name = "S4"
    S4.Anchored = true
    S4.CanCollide = true
    S4.Transparency = .5
    S4.Position = Vector3.new(-16489.97559, -14991.5, -15009.52637)  -- Увеличено расстояние в 3 раза
    S4.Size = Vector3.new(22, 13, 2)
    S4.Rotation = Vector3.new(0, -90, 0)
    S4.Parent = workspace:FindFirstChild("SafeBox")

    local S5 = Instance.new("Part")
    S5.Name = "S5"
    S5.Anchored = true
    S5.CanCollide = true
    S5.Transparency = .5
    S5.Position = Vector3.new(-16499.39, -14984, -15000.21)  -- Увеличено расстояние в 3 раза
    S5.Size = Vector3.new(24, 3, 24)
    S5.Parent = workspace:FindFirstChild("SafeBox")
end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local safeBoxPosition = workspace.SafeBox.S5.Position
local collectedParts = {}
local collectedCount = 0 -- Счётчик собранных конфеток
local maxCollects = 50 -- Максимум перед перезаходом

local TeleportService = game:GetService("TeleportService")

local function teleportTo(part)
    character:SetPrimaryPartCFrame(part.CFrame)
    wait(0.01)
    character:SetPrimaryPartCFrame(CFrame.new(safeBoxPosition))
end

local function rejoinServer()
    print("Перезаход на сервер...")
    TeleportService:Teleport(game.PlaceId, player)
end

local function setupCandyCollection()
    -- Очищаем таблицу собранных частей
    collectedParts = {}
    collectedCount = 0
    
    -- Подключаем обработку событий для сбора конфет
    workspace.CandyCorns.ChildAdded:Connect(function(part)
        if part:IsA("Part") and not collectedParts[part] then
            teleportTo(part)

            collectedParts[part] = true
            collectedCount = collectedCount + 1


            -- Если собрано 50 конфеток, перезаходим на сервер
            if collectedCount >= maxCollects then
                rejoinServer()
            end
        end
    end)
end

-- Функция проверки конфеток в GUI
local function checkCandyCount()
    local textLabel = game:GetService("Players").LocalPlayer.PlayerGui.CandyCount.ImageLabel.TextLabel
    local candyText = textLabel.Text

    -- Парсим текст "X/2000"
    local currentCount = tonumber(candyText:match("^(%d+) / 2000"))

    if currentCount then
    end

    -- Проверяем, достигли ли 2000 конфет
    if currentCount and currentCount >= 2000 then
        game:Shutdown() -- Завершение игры
    end
end

-- Запускаем сбор конфет
setupCandyCollection()

-- Проверка каждые 5 секунд
while true do
    checkCandyCount()
    wait(1)
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer == player then
        -- Когда игрок перезаходит на сервер, перезапускаем сбор конфет
        character = player.Character or player.CharacterAdded:Wait()
        setupCandyCollection()
    end
end)

game:GetService("TeleportService").TeleportInitFailed:Connect(function()
    -- Если телепортация не удалась, продолжаем сбор
    setupCandyCollection()
end)
