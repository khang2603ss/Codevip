--[[
    👑 GHOST MOBILE V38 - BYPASS BAC_4 EDITION
    🛠️ FIX: CHỐNG KICK BAC_4, TỐI ƯU TELEPORT AN TOÀN
    🚀 FULL: AUTO SHOOT, JITTER, HIGH TELE, NAME ESP, AUTO EQUIP
]]

if getgenv().V38Executed then return end
getgenv().V38Executed = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

getgenv().V38 = {
    Target = nil,
    Active = false,
    NeDan = false,
    AutoShoot = false,
    AutoEquip = true,
    Visible = true
}

-- // --- 🛡️ HỆ THỐNG BYPASS ELITE ---
local function BypassBAC()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old_nc = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        -- Chặn các Remote gửi dữ liệu kiểm tra vị trí/vận tốc
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            if tostring(self):find("Check") or tostring(self):find("Detect") or tostring(self):find("BAC") then
                return nil
            end
        end
        return old_nc(self, ...)
    end)
    setreadonly(mt, true)
    
    -- Chặn trạng thái nhân vật bất thường
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end
pcall(BypassBAC)

-- // --- UI MOBILE (CUSTOM) ---
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size, OpenBtn.Position = UDim2.new(0, 45, 0, 45), UDim2.new(0, 10, 0, 150)
OpenBtn.BackgroundColor3, OpenBtn.Text = Color3.fromRGB(0, 255, 100), "V38"
OpenBtn.Font, OpenBtn.Draggable = Enum.Font.SourceSansBold, true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 220, 0, 430), UDim2.new(0.5, -110, 0.5, -215)
Main.BackgroundColor3, Main.BorderSizePixel = Color3.fromRGB(15, 15, 15), 0
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 40), "GHOST ELITE V38"
Title.BackgroundColor3, Title.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size, Scroll.Position = UDim2.new(1, -10, 1, -180), UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency, Scroll.AutomaticCanvasSize = 1, Enum.AutomaticSize.Y
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

-- Nút chức năng
local function AddToggle(txt, color, var)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = txt .. ": OFF"
    btn.Font, btn.TextColor3 = Enum.Font.SourceSansBold, Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        getgenv().V38[var] = not getgenv().V38[var]
        btn.Text = txt .. ": " .. (getgenv().V38[var] and "ON" or "OFF")
        btn.BackgroundColor3 = getgenv().V38[var] and Color3.fromRGB(0, 180, 0) or color
    end)
    btn.Parent = Main -- Sắp xếp thủ công cho đẹp
    Instance.new("UICorner", btn)
    return btn
end

local shootBtn = AddToggle("AUTO SHOOT", Color3.fromRGB(100, 100, 0), "AutoShoot")
shootBtn.Position = UDim2.new(0, 10, 1, -135)
local jitterBtn = AddToggle("NÉ ĐẠN", Color3.fromRGB(60, 60, 60), "NeDan")
jitterBtn.Position = UDim2.new(0, 10, 1, -90)
local killBtn = AddToggle("TRUY SÁT", Color3.fromRGB(150, 0, 0), "Active")
killBtn.Position = UDim2.new(0, 10, 1, -45)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- // --- LOGIC TRUY SÁT (SMOOTH TELEPORT) ---
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local target = getgenv().V38.Target
    
    if getgenv().V38.Active and target and target.Character and root then
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if tRoot and target.Character.Humanoid.Health > 0 then
            -- Tự động lấy vũ khí
            if getgenv().V38.AutoEquip then
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if tool then LocalPlayer.Character.Humanoid:EquipTool(tool) end
            end
            
            -- Vị trí High-Back an toàn
            local goal = (tRoot.CFrame * CFrame.new(0, 5, 4)).Position
            root.Velocity = Vector3.new(0,0,0)
            -- Dùng Lerp nhẹ để tránh BAC phát hiện dịch chuyển tức thời
            root.CFrame = root.CFrame:Lerp(CFrame.new(goal, tRoot.Position), 0.5)
        else
            getgenv().V38.Active = false
        end
    end
    -- Né đạn mạnh
    if getgenv().V38.NeDan and root then
        root.CFrame *= CFrame.new(math.sin(tick() * 35) * 2.8, 0, 0)
    end
end)

-- // --- AUTO SHOOT ---
task.spawn(function()
    while task.wait(0.08) do
        if getgenv().V38.AutoShoot and getgenv().V38.Target then
            pcall(function()
                local tChar = getgenv().V38.Target.Character
                if tChar then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.03)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
        end
    end
end)

-- // --- ESP & DANH SÁCH TÊN (FIXED) ---
task.spawn(function()
    while task.wait(1.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                pcall(function()
                    if not p.Character.Head:FindFirstChild("Tag") then
                        local b = Instance.new("BillboardGui", p.Character.Head)
                        b.Name, b.Size, b.AlwaysOnTop = "Tag", UDim2.new(0,100,0,50), true
                        b.StudsOffset = Vector3.new(0,3,0)
                        local l = Instance.new("TextLabel", b)
                        l.Size, l.BackgroundTransparency, l.Text = UDim2.new(1,0,1,0), 1, p.Name
                        l.TextColor3, l.Font, l.TextSize = Color3.fromRGB(255,255,0), "SourceSansBold", 14
                        l.TextStrokeTransparency = 0
                    end
                    if not p.Character:FindFirstChild("HL") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name, h.FillColor = "HL", Color3.fromRGB(255,0,0)
                    end
                end)
            end
        end
        -- Cập nhật List chọn tên
        pcall(function()
            for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local b = Instance.new("TextButton", Scroll)
                    b.Size, b.Text = UDim2.new(1,0,0,30), p.Name
                    b.BackgroundColor3, b.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
                    b.MouseButton1Click:Connect(function() getgenv().V38.Target = p end)
                end
            end
        end)
    end
end)

print("V38 BYPASS BAC_4 LOADED")
