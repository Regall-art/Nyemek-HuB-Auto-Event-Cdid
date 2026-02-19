-- NYEMEK HUB | CDID AUTO QUEST ANGPAO ONLY
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- UI Sederhana
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 150)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 0); Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "CDID AUTO ANGPAO"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40); Status.Position = UDim2.new(0, 0, 0, 50); Status.Text = "Status: Ready"; Status.TextColor3 = Color3.new(1,1,1); Status.Font = "Gotham"; Status.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 200, 0, 40); StartBtn.Position = UDim2.new(0.5, -100, 0, 95); StartBtn.Text = "MULAI AUTO QUEST"; StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); StartBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", StartBtn)

-- Fungsi Drag UI
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- LOGIK AUTO COLLECT
local function StartQuest()
    local folder = workspace:FindFirstChild("Event") and workspace.Event:FindFirstChild("AngpaoFolder")
    if not folder then Status.Text = "Status: Folder Tidak Ditemukan!"; return end

    StartBtn.Active = false
    StartBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    for i = 1, 77 do
        local modelName = "Angpao" .. i
        local angpaoModel = folder:FindFirstChild(modelName)
        
        if angpaoModel then
            -- Jalur: Model -> MeshPart (nama sama) -> Collect
            local meshPart = angpaoModel:FindFirstChild(modelName)
            local collectPart = meshPart and meshPart:FindFirstChild("Collect")
            
            if collectPart then
                Status.Text = "Collecting: " .. modelName
                
                -- Teleport langsung ke posisi part "Collect"
                root.CFrame = collectPart.CFrame
                
                -- Memaksa sentuhan (Auto Collect)
                task.wait(0.2)
                if firetouchinterest then
                    firetouchinterest(root, collectPart, 0) -- Touch began
                    task.wait(0.1)
                    firetouchinterest(root, collectPart, 1) -- Touch ended
                end
                task.wait(1.5) -- Delay agar tidak kick/banned
            else
                print("Part Collect tidak ketemu di " .. modelName)
            end
        end
    end
    Status.Text = "Status: Selesai!"
    StartBtn.Active = true
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end

StartBtn.MouseButton1Click:Connect(function()
    task.spawn(StartQuest)
end)
