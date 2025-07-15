-- 🔥 Full Remote Hook + Manual Replay by Fisterovna2

local lastRemote = nil
local lastMethod = nil
local lastArgs = {}

-- Хук __namecall
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" or method == "InvokeServer" then
        if typeof(self) == "Instance" then
            print("=== Remote вызван ===")
            print("Тип:", self.ClassName)
            print("Имя:", self:GetFullName())
            print("Метод:", method)
            print("Аргументы:")
            for i, v in pairs(args) do
                print("["..i.."]: ", v)
            end
            print("=====================")

            -- Запоминаем последний вызов
            lastRemote = self
            lastMethod = method
            lastArgs = args
        end
    end

    return oldNamecall(self, ...)
end)

-- 🔍 Мини GUI для повторного вызова

local player = game.Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "RemoteReplayGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Text = "🔥 Remote Replay"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BorderSizePixel = 0

local ArgsBox = Instance.new("TextBox", Frame)
ArgsBox.Size = UDim2.new(0, 280, 0, 30)
ArgsBox.Position = UDim2.new(0, 10, 0, 40)
ArgsBox.PlaceholderText = "Аргументы через запятую"
ArgsBox.Text = ""
ArgsBox.ClearTextOnFocus = false
ArgsBox.TextColor3 = Color3.new(1, 1, 1)
ArgsBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ArgsBox.Font = Enum.Font.SourceSans
ArgsBox.TextSize = 14
ArgsBox.BorderSizePixel = 0

local ReplayBtn = Instance.new("TextButton", Frame)
ReplayBtn.Size = UDim2.new(0, 280, 0, 40)
ReplayBtn.Position = UDim2.new(0, 10, 0, 80)
ReplayBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ReplayBtn.TextColor3 = Color3.new(1, 1, 1)
ReplayBtn.Font = Enum.Font.SourceSansBold
ReplayBtn.TextSize = 16
ReplayBtn.BorderSizePixel = 0
ReplayBtn.Text = "🔁 Повторить последний вызов"

ReplayBtn.MouseButton1Click:Connect(function()
    if not lastRemote then
        warn("Нет последнего Remote!")
        return
    end

    -- Разбираем новые аргументы, если введены
    local args = {}
    if ArgsBox.Text ~= "" then
        for arg in string.gmatch(ArgsBox.Text, '([^,]+)') do
            arg = arg:match("^%s*(.-)%s*$")
            local num = tonumber(arg)
            if num then
                table.insert(args, num)
            elseif arg:lower() == "true" then
                table.insert(args, true)
            elseif arg:lower() == "false" then
                table.insert(args, false)
            else
                table.insert(args, arg)
            end
        end
    else
        args = lastArgs -- Если пусто — используем оригинал
    end

    local success, err = pcall(function()
        if lastMethod == "FireServer" then
            lastRemote:FireServer(unpack(args))
        elseif lastMethod == "InvokeServer" then
            lastRemote:InvokeServer(unpack(args))
        end
    end)

    if success then
        print("✅ Вызван:", lastRemote:GetFullName(), " с аргументами:", unpack(args))
    else
        warn("❌ Ошибка при вызове:", err)
    end
end)

local InfoLabel = Instance.new("TextLabel", Frame)
InfoLabel.Size = UDim2.new(0, 280, 0, 25)
InfoLabel.Position = UDim2.new(0, 10, 0, 125)
InfoLabel.Text = "Найди вызов => Измени => Повтори"
InfoLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InfoLabel.TextColor3 = Color3.new(1, 1, 1)
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.TextSize = 14
InfoLabel.BorderSizePixel = 0
