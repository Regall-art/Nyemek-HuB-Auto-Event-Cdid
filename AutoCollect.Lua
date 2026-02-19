-- NYEMEK HUB | CDID BYPASS TELEPORT
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- FUNGSI BYPASS: Mematikan deteksi jatuh & tabrakan
local function BypassPhysics(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- FUNGSI TWEEN BYPASS (Agar tidak rubberband)
local function BypassTeleport(targetPart)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end

    -- Matikan Gravitasi agar tidak ditarik server saat pindah
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root

    -- Tween Speed: Makin besar angkanya, makin cepat (Speed 600 stud/detik)
    local distance = (root.Position - targetPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 600, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetPart.CFrame})
    
    -- Jalankan Noclip selama bergerak
    local connection = RunService.Stepped:Connect(function()
        BypassPhysics(char)
    end)

    tween:Play()
    tween.Completed:Wait()
    
    connection:Disconnect()
    bv:Destroy()
end

-- LOGIKA UTAMA
local function StartQuest()
    local folder = workspace:FindFirstChild("Event") and workspace.Event:FindFirstChild("AngpaoFolder")
    if not folder then return end

    for i = 1, 77 do
        local modelName = "Angpao" .. i
        local model = folder:FindFirstChild(modelName)
        
        if model then
            local meshPart = model:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                -- Langkah 1: Bypass Teleport ke Lokasi
                BypassTeleport(collectPart)
                
                -- Langkah 2: Auto Collect Instan
                task.wait(0.1)
                if firetouchinterest then
                    firetouchinterest(player.Character.HumanoidRootPart, collectPart, 0)
                    task.wait(0.05)
                    firetouchinterest(player.Character.HumanoidRootPart, collectPart, 1)
                end
                
                -- Delay singkat antar Angpao (0.5 detik agar cepat seperti di video)
                task.wait(0.5) 
            end
        end
    end
end

-- UI Tombol Sederhana
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Btn = Instance.new("TextButton", ScreenGui)
Btn.Size = UDim2.new(0, 200, 0, 50)
Btn.Position = UDim2.new(0.5, -100, 0.1, 0)
Btn.Text = "START BYPASS QUEST (5 MINS)"
Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
Btn.TextColor3 = Color3.new(1,1,1)

Btn.MouseButton1Click:Connect(function()
    Btn.Text = "RUNNING..."
    task.spawn(StartQuest)
end)
