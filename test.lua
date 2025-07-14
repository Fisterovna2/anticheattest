local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Предположим, у тебя есть такие RemoteEvents
local spendGemsEvent = ReplicatedStorage:WaitForChild("SpendGems")
local spendTrophiesEvent = ReplicatedStorage:WaitForChild("SpendTrophies")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 230, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

createButton("Потратить 100 гемов", 10, function()
    spendGemsEvent:FireServer(100)
end)

createButton("Потратить 50 трофеев", 60, function()
    spendTrophiesEvent:FireServer(50)
end)
