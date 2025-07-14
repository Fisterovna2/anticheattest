local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаём GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "RemoteEventTesterGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Text = "RemoteEvent Tester"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BorderSizePixel = 0

-- Список RemoteEvents
local ListFrame = Instance.new("ScrollingFrame", Frame)
ListFrame.Size = UDim2.new(0, 180, 1, -60)
ListFrame.Position = UDim2.new(0, 10, 0, 40)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.ScrollBarThickness = 8
ListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ListFrame.BorderSizePixel = 0

-- Список кнопок для RemoteEvents
local UIListLayout = Instance.new("UIListLayout", ListFrame)
UIListLayout.Padding = UDim.new(0, 5)

local RemoteEvents = {}

-- Функция для сбора RemoteEvents из ReplicatedStorage
local function CollectRemoteEvents()
    for _, obj in pairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("RemoteEvent") then
            table.insert(RemoteEvents, obj)
        end
    end
end

CollectRemoteEvents()

-- Считаем кнопки для списка
local function UpdateCanvasSize()
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- Переменная для выбранного RemoteEvent
local selectedRemote = nil

-- Создаем кнопки для всех RemoteEvents
for i, remote in ipairs(RemoteEvents) do
    local btn = Instance.new("TextButton", ListFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = remote.Name
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.BorderSizePixel = 0

    btn.MouseButton1Click:Connect(function()
        selectedRemote = remote
        SelectedLabel.Text = "Выбран: " .. remote.Name
    end)
end

UpdateCanvasSize()

-- Метка для выбранного RemoteEvent
local SelectedLabel = Instance.new("TextLabel", Frame)
SelectedLabel.Size = UDim2.new(0, 200, 0, 25)
SelectedLabel.Position = UDim2.new(0, 200, 0, 50)
SelectedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SelectedLabel.TextColor3 = Color3.new(1, 1, 1)
SelectedLabel.Text = "Выбран: Нет"
SelectedLabel.Font = Enum.Font.SourceSansItalic
SelectedLabel.TextSize = 14
SelectedLabel.BorderSizePixel = 0
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Текстбокс для аргументов (через запятую)
local ArgsBox = Instance.new("TextBox", Frame)
ArgsBox.Size = UDim2.new(0, 180, 0, 25)
ArgsBox.Position = UDim2.new(0, 200, 0, 80)
ArgsBox.PlaceholderText = "Аргументы через запятую"
ArgsBox.ClearTextOnFocus = false
ArgsBox.Text = ""
ArgsBox.TextColor3 = Color3.new(1, 1, 1)
ArgsBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ArgsBox.Font = Enum.Font.SourceSans
ArgsBox.TextSize = 14
ArgsBox.BorderSizePixel = 0

-- Кнопка вызова RemoteEvent
local CallBtn = Instance.new("TextButton", Frame)
CallBtn.Size = UDim2.new(0, 180, 0, 35)
CallBtn.Position = UDim2.new(0, 200, 0, 115)
CallBtn.Text = "Вызвать событие"
CallBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CallBtn.TextColor3 = Color3.new(1, 1, 1)
CallBtn.Font = Enum.Font.SourceSansBold
CallBtn.TextSize = 16
CallBtn.BorderSizePixel = 0

CallBtn.MouseButton1Click:Connect(function()
    if not selectedRemote then
        warn("RemoteEvent не выбран")
        return
    end

    local argsText = ArgsBox.Text
    local args = {}

    if argsText ~= "" then
        for arg in string.gmatch(argsText, '([^,]+)') do
            arg = arg:match("^%s*(.-)%s*$") -- убрать пробелы

            -- Пытаемся привести к числу, если возможно
            local num = tonumber(arg)
            if num then
                table.insert(args, num)
            elseif arg:lower() == "true" then
                table.insert(args, true)
            elseif arg:lower() == "false" then
                table.insert(args, false)
            else
                table.insert(args, arg) -- строка
            end
        end
    end

    -- Попытка вызвать событие
    local success, err = pcall(function()
        selectedRemote:FireServer(unpack(args))
    end)

    if success then
        print("RemoteEvent "..selectedRemote.Name.." вызван с аргументами:", unpack(args))
    else
        warn("Ошибка при вызове:", err)
    end
end)
