--[[
    👑 GHOST MOBILE V37 - IMMORTAL EDITION
    🚀 FULL: AUTO SHOOT, MAX JITTER, HIGH TELE, ESP NAME
    🛡️ SECURITY: ANTI-KICK, ANTI-BAN, METATABLE SPOOFER
]]

if getgenv().V37Executed then return end
getgenv().V37Executed = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

-- // --- CẤU HÌNH HỆ THỐNG ---
getgenv().V37 = {
    Target = nil,
    Active = false,
    NeDan = false,
    AutoShoot = false,
    Bypass = true,
    Visible = true
}

-- // --- 🛡️ LỚP BẢO MẬT ANTI-BAN/KICK ---
local function ProtectSystem()
    local mt = getrawmetatable(game)
    local old_nc = mt.__namecall
    local old_idx = mt.__index
    setreadonly(mt, false)

    -- Chặn lệnh Kick
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "Kick" or method == "kick") then 
            return nil 
        end
        return old_nc(self, ...)
    end)

    -- Che giấu thông số (Spoofing)
    mt.__index = newcclosure(function(t, k)
        if not checkcaller() and t:IsA("Humanoid") then
            if k == "WalkSpeed" then return 16 end
            if k == "JumpPower" then return 50 end
            if k == "Health" then return 100 end
        end
        return old_idx(t, k)
    end)
    setreadonly(mt, true)
end
pcall(ProtectSystem)

-- // --- UI MOBILE CẢM ỨNG ---
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0, 150)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
OpenBtn.Text = "V37"
OpenBtn.Font = Enum.Font.SourceSansBold
local btnCorner = Instance.new("UICorner", OpenBtn)
btnCorner.CornerRadius = UDim.new(1, 0)
OpenBtn.Draggable = true

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 450)
Main.Position = UDim2.new(0.5, -110, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = true
local mainCorner = Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "IMMORTAL GHOST V37"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Font = Enum.Font.SourceSansBold

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -210)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)

-- Nút Chức năng
local function CreateButton(text, pos, color, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(callback)
    local bc = Instance.new("UICorner", btn)
    return btn
end

local ShootBtn = CreateButton("AUTO SHOOT: OFF", UDim2.new(0, 10, 1, -150), Color3.fromRGB(80, 80, 0), function(self)
    getgenv().V37.AutoShoot = not getgenv().V37.AutoShoot
    self.Text = getgenv().V37.AutoShoot and "AUTO SHOOT: ON" or "AUTO SHOOT: OFF"
    self.BackgroundColor3 = getgenv().V37.AutoShoot and Color3.fromRGB(255, 180, 0) or Color3.fromRGB(80, 80, 0)
end)

local JitterBtn = CreateButton("NÉ ĐẠN: OFF", UDim2.new(0, 10, 1, -100), Color3.fromRGB(60, 60, 60), function(self)
    getgenv().V37.NeDan = not getgenv().V37.NeDan
    self.Text = getgenv().V37.NeDan and "NÉ ĐẠN: ON" or "NÉ ĐẠN: OFF"
    self.BackgroundColor3 = getgenv().V37.NeDan and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(60, 60, 60)
end)

local KillBtn = CreateButton("TRUY SÁT: OFF", UDim2.new(0, 10, 1, -50), Color3.fromRGB(150, 0, 0), function(self)
    getgenv().V37.Active = not getgenv().V37.Active
    self.Text = getgenv().V37.Active and "TRUY SÁT: ON" or "TRUY SÁT: OFF"
    self.BackgroundColor3 = getgenv().V37.Active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- // --- 🔫 AUTO SHOOT LOGIC ---
task.spawn(function()
    while task.wait(0.07) do
        if getgenv().V37.AutoShoot then
            pcall(function()
                local char = LocalPlayer.Character
                local target = getgenv().V37.Target
                if target and target.Character and char:FindFirstChild("HumanoidRootPart") then
                    local dot = char.HumanoidRootPart.CFrame.LookVector:Dot((target.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Unit)
                    if dot > 0.85 then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.03)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                end
            end)
        end
    end
end)

-- // --- 🚀 TELEPORT & DESYNC LOGIC ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local target = getgenv().V37.Target
    
    if char and root then
        -- Bypass Đóng băng (Anti-Freeze)
        if getgenv().V37.Bypass then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Anchored = false end end
        end
        -- Teleport Truy Sát
        if getgenv().V37.Active and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if target.Character.Humanoid.Health > 0 then
                local goal = (target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4.5, 3.5)).Position
                root.Velocity = Vector3.new(0, 0, 0)
                root.CFrame = CFrame.new(goal, target.Character.HumanoidRootPart.Position)
            else
                getgenv().V37.Active = false
            end
        end
        -- Né Đạn (Max Jitter)
        if getgenv().V37.NeDan then
            root.CFrame = root.CFrame * CFrame.new(math.sin(tick() * 35) * 2.8, 0, 0)
        end
    end
end)

-- // --- 🏷️ HIỆN TÊN & DANH SÁCH ---
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            pcall(function()
                local head = p.Character:FindFirstChild("Head")
                if head and not head:FindFirstChild("V37_Name") then
                    local bg = Instance.new("BillboardGui", head)
                    bg.Name = "V37_Name"
                    bg.Size, bg.AlwaysOnTop = UDim2.new(0, 100, 0, 50), true
                    bg.StudsOffset = Vector3.new(0, 3, 0)
                    local lbl = Instance.new("TextLabel", bg)
                    lbl.Size, lbl.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
                    lbl.Text, lbl.TextColor3, lbl.Font = p.Name, Color3.fromRGB(255, 255, 0), Enum.Font.SourceSansBold
                    lbl.TextSize, lbl.TextStrokeTransparency = 15, 0
                end
                if not p.Character:FindFirstChild("V37_HL") then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "V37_HL"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end)
        end
    end
end

task.spawn(function()
    while task.wait(2) do
        UpdateESP()
        pcall(function()
            for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local b = Instance.new("TextButton", Scroll)
                    b.Size, b.Text = UDim2.new(1, 0, 0, 30), p.Name
                    b.BackgroundColor3, b.TextColor3 = Color3.fromRGB(40, 40, 40), Color3.fromRGB(255,255,255)
                    b.MouseButton1Click:Connect(function() getgenv().V37.Target = p end)
                end
            end
        end)
    end
end)

print("IMMORTAL V37 FULL LOADED")
