--[[ 
    NYEMEK HUB | CDID SEASONAL EVENT
    FULL SCRIPT: AUTO TELEPORT & COLLECT ANGPAO
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Folder Path dari Explorer Anda
local eventFolder = workspace:WaitForChild("Event")
local angpaoFolder = eventFolder:WaitForChild("AngpaoFolder")

local isFarming = false

-- FUNGSI HARD TELEPORT (Agar pasti pindah)
local function ForceTeleport(targetPart)
    if not root or not targetPart then return end
    
    -- Kunci posisi sementara agar tidak rubberband/mental balik
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root
    
    -- Paksa CFrame berkali-kali dalam sekejap
    for i = 1, 10 do
        root.CFrame = targetPart.CFrame
        RunService.Heartbeat:Wait()
    end
    
    task.wait(0.2)
    bv:Destroy()
end

-- LOGIKA AUTO COLLECT
local function StartQuest(statusLabel, btn)
    isFarming = true
    btn.Text = "SEDANG BERJALAN..."
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    for i = 1, 77 do
        if not isFarming then break end
        
        local modelName = "Angpao" .. i
        local model = angpaoFolder:FindFirstChild(modelName)
        
        if model then
            -- Jalur sesuai gambar: Model -> MeshPart -> Collect
            local meshPart = model:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                statusLabel.Text = "📍 Teleport: " .. modelName
                
                -- Pindah ke lokasi
                ForceTeleport(collectPart)
                
                -- Ambil Angpao (FireTouch)
                task.wait(0.3)
                if firetouchinterest then
                    firetouchinterest(root, collectPart, 0)
                    task.wait(0.1)
                    firetouchinterest(root, collectPart, 1)
                end
                
                task.wait(1.5) -- Delay aman agar tidak di-kick
            end
        end
    end
    
    isFarming = false
    statusLabel.Text = "✅ SEMUA ANGPAO DIAMBIL!"
    btn.Text = "MULAI AUTO QUEST"
    btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
end

-- PEMBUATAN UI (Flux UI Style)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 200)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 0); Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "🧧 NYEMEK HUB: AUTO ANGPAO"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40); Status.Position = UDim2.new(0, 0, 0, 60); Status.Text = "Status: Siap"; Status.TextColor3 = Color3.fromRGB(200, 200, 200); Status.Font = "Gotham"; Status.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 280, 0, 50); StartBtn.Position = UDim2.new(0.5, -140, 0, 110); StartBtn.Text = "MULAI AUTO QUEST"; StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0); StartBtn.TextColor3 = Color3.new(1, 1, 1); StartBtn.Font = "GothamBold"; Instance.new("UICorner", StartBtn)

StartBtn.MouseButton1Click:Connect(function()
    if not isFarming then
        task.spawn(function() StartQuest(Status, StartBtn) end)
    end
end)

-- Draggable Logic
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
