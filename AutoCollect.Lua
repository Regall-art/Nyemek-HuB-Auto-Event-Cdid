--[[
    NYEMEK HUB | CDID ULTIMATE EDITION
    - Auto Render Map (Streaming Bypass)
    - Full Map SaveInstance
    - Auto Quest Angpao (1-77)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- UI Settings & Themes
local Theme = {
    Main = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 255, 0),
    Text = Color3.fromRGB(240, 240, 240)
}

-- 1. FUNGSI AUTO RENDER & SAVE
local function StartFullSave(radius, statusLabel)
    local originalPos = root.CFrame
    root.Anchored = true
    
    local step = 800
    for x = -radius, radius, step do
        for z = -radius, radius, step do
            statusLabel.Text = "🌀 Rendering Map: ["..x..", "..z.."]"
            root.CFrame = CFrame.new(x, 500, z)
            task.wait(0.15)
        end
    end
    
    root.CFrame = originalPos
    root.Anchored = false
    statusLabel.Text = "⏳ Saving... Jangan Close Roblox!"
    
    task.wait(1)
    local success, err = pcall(function()
        saveinstance({RepoID = 1, Decompile = true, Timeout = 1200})
    end)
    statusLabel.Text = success and "✅ Saved to Workspace!" or "❌ Error: "..tostring(err)
end

-- 2. FUNGSI AUTO QUEST ANGPAO (Berdasarkan Gambar Folder Event)
local function StartAngpaoQuest(statusLabel)
    local folder = workspace:FindFirstChild("Event") and workspace.Event:FindFirstChild("AngpaoFolder")
    if not folder then statusLabel.Text = "❌ Folder Angpao Tidak Ditemukan!" return end

    for i = 1, 77 do
        local name = "Angpao"..i
        local model = folder:FindFirstChild(name)
        if model then
            statusLabel.Text = "🧧 Collecting: "..name
            -- Navigasi sesuai struktur MeshPart -> Collect di gambar kamu
            local mesh = model:FindFirstChild(name)
            local collectPart = mesh and mesh:FindFirstChild("Collect")
            
            if collectPart then
                root.CFrame = collectPart.CFrame * CFrame.new(0, 2, 0)
                task.wait(0.3)
                if firetouchinterest then
                    firetouchinterest(root, collectPart, 0)
                    task.wait(0.1)
                    firetouchinterest(root, collectPart, 1)
                end
            end
            task.wait(1.2) -- Delay aman CDID
        end
    end
    statusLabel.Text = "✅ Semua Angpao Terkumpul!"
end

-- [ Bagian Pembuatan UI Nyemek Hub Disini ]
-- (Script UI tetap menggunakan desain original yang kamu sukai)
print("Nyemek Hub CDID Edition Loaded via Loadstring!")
