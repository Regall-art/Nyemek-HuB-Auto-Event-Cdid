--[[ 
    NYEMEK HUB | CDID DIRECT HARD-TELEPORT
    - Bypass Rubberband System
    - Direct PivotTo() Method
    - Auto Collect FireTouch
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- UI Sederhana (Gaya Nyemek Hub)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 160)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 0); Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "🧧 CDID HARD-TELEPORT"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30); Status.Position = UDim2.new(0, 0, 0, 50); Status.Text = "Status: Siap!"; Status.TextColor3 = Color3.new(1,1,1); Status.Font = "Gotham"; Status.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 240, 0, 45); StartBtn.Position = UDim2.new(0.5, -120, 0, 95); StartBtn.Text = "MULAI AUTO QUEST"; StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); StartBtn.TextColor3 = Color3.new(1,1,1); StartBtn.Font = "GothamBold"; Instance.new("UICorner", StartBtn)

-- Logic
local isFarming = false

local function TeleportInstan(targetPart)
    local char = player.Character
    if char and targetPart then
        -- METODE TERKUAT: PivotTo langsung ke CFrame target
        char:PivotTo(targetPart.CFrame)
        
        -- Mematikan velocity agar tidak mental balik
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0,0,0)
            root.RotVelocity = Vector3.new(0,0,0)
        end
    end
end

local function StartQuest()
    local folder = workspace:FindFirstChild("Event") and workspace.Event:FindFirstChild("AngpaoFolder")
    if not folder then Status.Text = "❌ Folder Tidak Ditemukan!"; return end
    
    isFarming = true
    StartBtn.Text = "STOP"
    StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

    for i = 1, 77 do
        if not isFarming then break end
        
        local modelName = "Angpao" .. i
        local model = folder:FindFirstChild(modelName)
        
        if model then
            -- Jalur: Model -> MeshPart -> Collect (Sesuai Gambar Kamu)
            local meshPart = model:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                Status.Text = "🚀 " .. modelName
                
                -- Teleport Langsung
                TeleportInstan(collectPart)
                
                -- Collect Sinyal
                task.wait(0.2)
                if firetouchinterest then
                    firetouchinterest(player.Character.HumanoidRootPart, collectPart, 0)
                    task.wait(0.1)
                    firetouchinterest(player.Character.HumanoidRootPart, collectPart, 1)
                end
                
                task.wait(1.3) -- Delay aman CDID agar tidak kick
            end
        end
    end
    
    isFarming = false
    Status.Text = "✅ Selesai!"
    StartBtn.Text = "MULAI AUTO QUEST"
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end

StartBtn.MouseButton1Click:Connect(function()
    if not isFarming then
        task.spawn(StartQuest)
    else
        isFarming = false
    end
end)

-- Drag UI
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
