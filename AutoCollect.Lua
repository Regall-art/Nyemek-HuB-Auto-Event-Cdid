--[[ 
    NYEMEK HUB | CDID DIRECT TELEPORT
    Fokus: Langsung Teleport ke Part Collect & Auto Collect
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Folder Path sesuai data Explorer
local folder = workspace:WaitForChild("Event"):WaitForChild("AngpaoFolder")

local isFarming = false

-- FUNGSI TELEPORT INSTAN KE PART
local function DirectTeleport(targetPart)
    if not root or not targetPart then return end
    
    -- Mematikan gravitasi & mengunci kecepatan agar teleport lancar
    local velocityRemover = Instance.new("BodyVelocity")
    velocityRemover.Velocity = Vector3.new(0, 0, 0)
    velocityRemover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    velocityRemover.Parent = root
    
    -- Force Teleport ke CFrame Part "Collect"
    root.CFrame = targetPart.CFrame
    task.wait(0.1)
    root.CFrame = targetPart.CFrame -- Reposisi ulang untuk akurasi
    
    task.wait(0.2)
    velocityRemover:Destroy()
end

-- LOGIKA QUEST
local function StartQuest(statusLabel, startBtn)
    isFarming = true
    startBtn.Text = "STOP QUEST"
    startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

    for i = 1, 77 do
        if not isFarming then break end
        
        local modelName = "Angpao" .. i
        local model = folder:FindFirstChild(modelName)
        
        if model then
            -- Jalur: Model -> MeshPart -> Collect (Sesuai Gambar Explorer)
            local meshPart = model:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                statusLabel.Text = "🚀 Teleport: " .. modelName
                
                -- Teleport Langsung
                DirectTeleport(collectPart)
                
                -- Auto Collect (FireTouchInterest)
                if firetouchinterest then
                    firetouchinterest(root, collectPart, 0)
                    task.wait(0.1)
                    firetouchinterest(root, collectPart, 1)
                end
                
                task.wait(1.5) -- Delay wajib CDID
            end
        end
    end
    
    isFarming = false
    statusLabel.Text = "✅ Selesai!"
    startBtn.Text = "MULAI AUTO QUEST"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
end

-- UI SEDERHANA
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 150); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 0); Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "CDID AUTO ANGPAO"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30); Status.Position = UDim2.new(0, 0, 0, 50); Status.Text = "Status: Ready"; Status.TextColor3 = Color3.fromRGB(200, 200, 200); Status.Font = "Gotham"; Status.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 240, 0, 40); StartBtn.Position = UDim2.new(0.5, -120, 0, 90); StartBtn.Text = "MULAI AUTO QUEST"; StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0); StartBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", StartBtn)

StartBtn.MouseButton1Click:Connect(function()
    if not isFarming then
        task.spawn(function() StartQuest(Status, StartBtn) end)
    else
        isFarming = false
    end
end)

-- Dragging UI
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
