local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TestCheatGUI"

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

createButton("Добавить 10000 гемов", 10, function()
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local gems = ls:FindFirstChild("Gems")
        if gems then
            gems.Value = gems.Value + 10000
        end
    end
end)

createButton("Добавить 5000 трофеев", 60, function()
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local trophies = ls:FindFirstChild("Trophies")
        if trophies then
            trophies.Value = trophies.Value + 5000
        end
    end
end)
