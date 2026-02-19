--[[ 
    NYEMEK HUB | CDID SEASONAL EVENT AUTO QUEST
    Fokus: Auto Teleport & Auto Collect Angpao (1-77)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Folder Path sesuai gambar Explorer kamu
local folder = workspace:WaitForChild("Event"):WaitForChild("AngpaoFolder")

-- UI Sederhana (Tema Nyemek Hub)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 160)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 0); Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45); Title.Text = "🧧 CDID AUTO ANGPAO"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Font = "GothamBold"; Title.TextSize = 16; Title.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30); Status.Position = UDim2.new(0, 0, 0, 50); Status.Text = "Status: Menunggu..."; Status.TextColor3 = Color3.new(1, 1, 1); Status.Font = "Gotham"; Status.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 240, 0, 45); StartBtn.Position = UDim2.new(0.5, -120, 0, 90); StartBtn.Text = "MULAI AUTO TELEPORT"; StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); StartBtn.TextColor3 = Color3.new(1, 1, 1); StartBtn.Font = "GothamBold"; Instance.new("UICorner", StartBtn)

-- Fungsi Dragging
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- FUNGSI INTI: TELEPORT & COLLECT
local function StartQuest()
    StartBtn.Active = false
    StartBtn.Text = "SEDANG BERJALAN..."
    StartBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    for i = 1, 77 do
        local modelName = "Angpao" .. i
        local angpaoModel = folder:FindFirstChild(modelName)
        
        if angpaoModel then
            -- Jalur: Model -> MeshPart (nama sama) -> Collect (sesuai gambar terakhir)
            local meshPart = angpaoModel:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                Status.Text = "📍 Teleport ke: " .. modelName
                
                -- LANGSUNG KE TITIK ANGPAO
                root.CFrame = collectPart.CFrame
                
                -- AUTO COLLECT (Sinyal Sentuhan)
                task.wait(0.3) -- Jeda agar teleport stabil
                if firetouchinterest then
                    firetouchinterest(root, collectPart, 0) -- Touch Start
                    task.wait(0.1)
                    firetouchinterest(root, collectPart, 1) -- Touch End
                end
                
                task.wait(1.2) -- Delay aman anti-kick CDID
            end
        end
    end
    
    Status.Text = "✅ SEMUA SELESAI!"
    StartBtn.Active = true
    StartBtn.Text = "MULAI AUTO TELEPORT"
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end

StartBtn.MouseButton1Click:Connect(function()
    task.spawn(StartQuest)
end)
