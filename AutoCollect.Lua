-- NYEMEK HUB | CDID AUTO COLLECT ANGPAO
-- Optimized for Seasonal Event Map

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Folder Path sesuai gambar yang kamu kirim
local AngpaoFolder = workspace:WaitForChild("Event"):WaitForChild("AngpaoFolder")

local function collectAngpao(id)
    local modelName = "Angpao" .. tostring(id)
    local angpaoModel = AngpaoFolder:FindFirstChild(modelName)
    
    if angpaoModel then
        -- Mencari part "Collect" sesuai struktur di gambar terakhirmu
        -- Folder AngpaoFolder -> Model AngpaoX -> MeshPart AngpaoX -> Part Collect
        local meshPart = angpaoModel:FindFirstChild(modelName)
        if meshPart then
            local collectPart = meshPart:FindFirstChild("Collect")
            
            if collectPart and collectPart:IsA("BasePart") then
                print("⚡ Menuju " .. modelName)
                
                -- Teleport ke lokasi Angpao (ketinggian sedikit di atas agar tidak stuck)
                rootPart.CFrame = collectPart.CFrame * CFrame.new(0, 2, 0)
                
                -- Simulasi sentuhan (Auto Collect)
                task.wait(0.3) -- Jeda sebentar agar engine mendeteksi posisi
                firetouchinterest(rootPart, collectPart, 0) -- Mulai sentuhan
                task.wait(0.1)
                firetouchinterest(rootPart, collectPart, 1) -- Akhiri sentuhan
                
                return true
            end
        end
    end
    return false
end

-- Menjalankan Loop untuk 77 Angpao (sesuai list gambar)
task.spawn(function()
    print("🚀 Memulai Auto Quest Angpao...")
    
    for i = 1, 77 do
        local success = collectAngpao(i)
        if success then
            task.wait(1.5) -- Jeda antar angpau agar tidak terdeteksi cheat/kick
        else
            print("❌ " .. "Angpao" .. i .. " tidak ditemukan atau sudah diambil.")
        end
    end
    
    print("✅ Semua Angpao selesai diproses!")
    -- Kembali ke posisi awal (opsional)
end)
