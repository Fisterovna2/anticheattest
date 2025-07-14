-- Clash Royale but Roblox - Test Cheat by Fisterovna2

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestCheatGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Parent = ScreenGui

local function CreateButton(name, posY, callback)
    local Button = Instance.new("TextButton")
    Button.Text = name
    Button.Size = UDim2.new(0, 280, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, posY)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = Frame
    Button.MouseButton1Click:Connect(callback)
end

CreateButton("Добавить 10000 гемов", 10, function()
    local player = game.Players.LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local gems = leaderstats:FindFirstChild("Gems")
        if gems then
            gems.Value = gems.Value + 10000
        end
    end
end)

CreateButton("Добавить 5000 трофеев", 55, function()
    local player = game.Players.LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local trophies = leaderstats:FindFirstChild("Trophies")
        if trophies then
            trophies.Value = trophies.Value + 5000
        end
    end
end)

CreateButton("Бесконечный эликсир", 100, function()
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack")
    local elixir = backpack:FindFirstChild("Elixir")
    if elixir then
        elixir.Value = 999
    end
end)

CreateButton("Вкл/Выкл Автоспавн PEKKA", 145, function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Remote = ReplicatedStorage:FindFirstChild("SpawnCard")
    if not Remote then return end

    if _G.Spawning then
        _G.Spawning = false
    else
        _G.Spawning = true
        while _G.Spawning do
            Remote:FireServer("Pekka")
            wait(1)
        end
    end
end)
