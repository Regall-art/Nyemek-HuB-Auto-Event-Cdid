--[[ 
    NYEMEK HUB | CDID ULTIMATE BYPASS
    - Hard Pivot Teleport (Memaksa Perpindahan)
    - Anti-Anchor Character (Mencegah Karakter Stuck)
    - Auto Collect FireTouch
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Folder Path
local eventFolder = workspace:FindFirstChild("Event")
local angpaoFolder = eventFolder and eventFolder:FindFirstChild("AngpaoFolder")

local isFarming = false

-- FUNGSI TELEPORT PALING KERAS (FORCE PIVOT)
local function ForceTeleport(target)
    if not character or not target then return end
    
    -- Memastikan karakter tidak ter-anchor (dikunci game)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then v.Anchored = false end
    end
    
    -- Memindahkan karakter tepat ke posisi Angpao
    character:PivotTo(target.CFrame * CFrame.new(0, 2, 0))
    
    -- Menghilangkan kecepatan agar tidak terpental balik
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)
end

-- LOGIKA AUTO QUEST
local function StartQuest(statusLabel, btn)
    if not angpaoFolder then
        statusLabel.Text = "❌ Folder Angpao Tidak Ditemukan!"
        return
    end

    isFarming = true
    btn.Text = "BERHENTIKAN"
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

    for i = 1, 77 do
        if not isFarming then break end
        
        local modelName = "Angpao" .. i
        local model = angpaoFolder:FindFirstChild(modelName)
        
        if model then
            -- Jalur: Model -> MeshPart -> Collect
            local meshPart = model:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                statusLabel.Text = "📍 Memaksa Ke: " .. modelName
                
                -- Teleport Paksa
                ForceTeleport(collectPart)
                
                -- Auto Collect
                task.wait(0.3)
                if firetouchinterest then
                    firetouchinterest(root, collectPart, 0)
                    task.wait(0.1)
                    firetouchinterest(root, collectPart, 1)
                end
                
                task.wait(1.2) -- Jeda aman agar tidak kick
            end
        else
            -- Jika angpao belum ter-load (StreamingEnabled), kita tunggu sebentar
            statusLabel.Text = "⏳ Menunggu Angpao " .. i .. " Muncul..."
            task.wait(0.5)
        end
    end
    
    isFarming = false
    statusLabel.Text = "✅ SELESAI!"
    btn.Text = "MULAI AUTO QUEST"
    btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
end

-- UI SEDERHANA
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 150); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 0); Stroke.Thickness = 2

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 50); Status.Position = UDim2.new(0, 0, 0, 30)
Status.Text = "Status: Siap!"; Status.TextColor3 = Color3.new(1,1,1); Status.Font = "GothamBold"; Status.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 240, 0, 40); StartBtn.Position = UDim2.new(0.5, -120, 0, 90)
StartBtn.Text = "MULAI AUTO QUEST"; StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0); StartBtn.TextColor3 = Color3.new(1,1,1); StartBtn.Font = "GothamBold"; Instance.new("UICorner", StartBtn)

StartBtn.MouseButton1Click:Connect(function()
    if not isFarming then
        task.spawn(function() StartQuest(Status, StartBtn) end)
    else
        isFarming = false
    end
end)
