--[[
    NYEMEK HUB | SEASONAL AUTO FARM (BETA)
    Inspirasi UI: AzarineHub
    Target: Auto Collect Angpao 1-77
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local Container = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local ToggleDot = Instance.new("Frame")

-- Setup UI (Gaya Modern Dark)
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🧧 Seasonal Autofarm"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 20, 0, 50)
StatusLabel.Size = UDim2.new(1, -40, 0, 30)
StatusLabel.Text = "Status: Menunggu..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = "Left"
StatusLabel.BackgroundTransparency = 1

-- Button Toggle (Mirip Video AzarineHub)
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0, 20, 0, 90)
ToggleBtn.Size = UDim2.new(0, 310, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBtn.Text = "Mulai Auto Quest"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn)

-- Logic Auto Collect (Berdasarkan Struktur Explorer)
local isFarming = false
local function StartQuest()
    local folder = workspace:WaitForChild("Event"):WaitForChild("AngpaoFolder")
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    
    for i = 1, 77 do
        if not isFarming then break end
        
        local modelName = "Angpao" .. i
        local model = folder:FindFirstChild(modelName)
        
        if model then
            -- Jalur: Model -> MeshPart -> Collect
            local meshPart = model:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                StatusLabel.Text = "📍 Teleport ke: " .. modelName
                root.CFrame = collectPart.CFrame -- Langsung Teleport
                
                task.wait(0.3)
                if firetouchinterest then
                    firetouchinterest(root, collectPart, 0) -- Auto Collect
                    task.wait(0.1)
                    firetouchinterest(root, collectPart, 1)
                end
                task.wait(1.2) -- Jeda Aman
            end
        end
    end
    isFarming = false
    StatusLabel.Text = "✅ Selesai!"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end

ToggleBtn.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    if isFarming then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        task.spawn(StartQuest)
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        StatusLabel.Text = "Status: Berhenti"
    end
end)

-- Dragging Logic
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
