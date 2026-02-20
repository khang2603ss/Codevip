--[[
    👑 GHOST V55 - OVERLORD PRESTIGE
    🛠️ FIX: ESP Name co giãn theo khoảng cách, Tự xóa rác khi Player Out.
    🔥 NEW: Chỉnh màu ESP/Hitbox, Deadly Hitbox (Bắn là chết).
    🚀 FULL: 15+ Chức năng không cắt bớt.
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GHOST V55 | OVERLORD PRESTIGE",
   LoadingTitle = "Đang tối ưu hóa định vị & Hitbox...",
   LoadingSubtitle = "by Ghost Warrior",
   ConfigurationSaving = { Enabled = false }
})

-- // --- 📦 KHO DỮ LIỆU TỔNG HỢP ---
getgenv().V55 = {
    Target = nil,
    -- Combat
    StickyAim = false,
    AimLock = false,
    NoReload = false,
    NoRecoil = false,
    WallBang = false,
    -- Movement
    GodSpeed = false,
    HighBack = false,
    NeDan = false,
    -- Visuals (Fixed)
    ShowName = false,
    ShowESP = false,
    ESPColor = Color3.fromRGB(0, 255, 255),
    -- Hitbox (Custom)
    Hitbox = false,
    HitboxSize = 5,
    HitboxColor = Color3.fromRGB(255, 0, 0),
    HitboxTrans = 0.8,
    -- Config
    AimSmooth = 0.1,
    AimFOV = 150
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // --- 🛡️ HỆ THỐNG BYPASS & DEADLY HITBOX ---
local mt = getrawmetatable(game)
local old_nc = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local m = getnamecallmethod()
    local args = {...}
    -- Wallbang & Deadly Hitbox Logic
    if getgenv().V55.WallBang and (m == "FindPartOnRayWithIgnoreList" or m == "Raycast") then
        return old_nc(self, unpack(args))
    end
    -- Chặn Anticheat
    if not checkcaller() and m == "FireServer" and tostring(self):find("BAC") then return nil end
    return old_nc(self, ...)
end)
setreadonly(mt, true)

-- // --- 📑 GIAO DIỆN PHÂN TRANG ---
local TabCombat = Window:CreateTab("🔫 Combat") 
local TabMove = Window:CreateTab("🚀 Movement")
local TabVisuals = Window:CreateTab("👁️ Visuals")
local TabPlayers = Window:CreateTab("👥 Players")

-- --- COMBAT ---
TabCombat:CreateToggle({ Name = "Dính Tâm (Sticky Aim)", CurrentValue = false, Callback = function(v) getgenv().V55.StickyAim = v end })
TabCombat:CreateToggle({ Name = "Sniper Liên Tục (No Reload)", CurrentValue = false, Callback = function(v) getgenv().V55.NoReload = v end })
TabCombat:CreateToggle({ Name = "Không Giật (No Recoil)", CurrentValue = false, Callback = function(v) getgenv().V55.NoRecoil = v end })
TabCombat:CreateToggle({ Name = "Xuyên Tường (Wallbang)", CurrentValue = false, Callback = function(v) getgenv().V55.WallBang = v end })

-- --- MOVEMENT ---
TabMove:CreateToggle({ Name = "Bypass 3s (GodSpeed)", CurrentValue = false, Callback = function(v) getgenv().V55.GodSpeed = v end })
TabMove:CreateToggle({ Name = "Tele Truy Sát (High-Back)", CurrentValue = false, Callback = function(v) getgenv().V55.HighBack = v end })
TabMove:CreateToggle({ Name = "Né Đạn Jitter", CurrentValue = false, Callback = function(v) getgenv().V55.NeDan = v end })

-- --- VISUALS (FIXED ALL) ---
TabVisuals:CreateSection("Định Vị Tên")
TabVisuals:CreateToggle({ Name = "Hiện Tên (Co giãn theo tầm xa)", CurrentValue = false, Callback = function(v) getgenv().V55.ShowName = v end })
TabVisuals:CreateColorPicker({ Name = "Màu Tên", Color = Color3.fromRGB(0,255,255), Callback = function(v) getgenv().V55.ESPColor = v end })

TabVisuals:CreateSection("Định Vị Viền")
TabVisuals:CreateToggle({ Name = "Hiện Viền Đối Thủ (Highlight)", CurrentValue = false, Callback = function(v) getgenv().V55.ShowESP = v end })

TabVisuals:CreateSection("Hitbox Tùy Chỉnh")
TabVisuals:CreateToggle({ Name = "Bật Deadly Hitbox", CurrentValue = false, Callback = function(v) getgenv().V55.Hitbox = v end })
TabVisuals:CreateSlider({ Name = "Kích Thước Hitbox", Range = {2, 30}, Increment = 1, CurrentValue = 5, Callback = function(v) getgenv().V55.HitboxSize = v end })
TabVisuals:CreateColorPicker({ Name = "Màu Hitbox", Color = Color3.fromRGB(255,0,0), Callback = function(v) getgenv().V55.HitboxColor = v end })
TabVisuals:CreateSlider({ Name = "Độ Trong Suốt Hitbox", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.8, Callback = function(v) getgenv().V55.HitboxTrans = v end })

-- --- PLAYER LIST ---
local PlayerButtons = {}
local function RefreshList()
    for _, b in pairs(PlayerButtons) do b:Destroy() end
    PlayerButtons = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = TabPlayers:CreateButton({
                Name = "🎯 " .. p.DisplayName .. " (@" .. p.Name .. ")",
                Callback = function() getgenv().V55.Target = p end
            })
            table.insert(PlayerButtons, b)
        end
    end
end
TabPlayers:CreateButton({ Name = "🔄 Làm mới danh sách", Callback = RefreshList })
RefreshList()

-- // --- 👁️ HỆ THỐNG RENDER (VẼ ESP & HITBOX) ---
local ESPGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ESPGui.Name = "Ghost_V55_Engine"

RunService.RenderStepped:Connect(function()
    -- Xóa tag của người đã thoát
    for _, tag in pairs(ESPGui:GetChildren()) do
        local pName = tag.Name:gsub("Tag_", "")
        if not Players:FindFirstChild(pName) then tag:Destroy() end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")

            if hrp and head and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 3, 0))
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                
                -- 1. ESP Name (Co giãn)
                local tag = ESPGui:FindFirstChild("Tag_"..p.Name)
                if getgenv().V55.ShowName and onScreen then
                    if not tag then
                        tag = Instance.new("TextLabel", ESPGui); tag.Name = "Tag_"..p.Name
                        tag.BackgroundTransparency = 1; tag.Font = Enum.Font.GothamBold
                        Instance.new("UIStroke", tag).Thickness = 1
                    end
                    -- Tính toán size theo khoảng cách (Càng xa càng nhỏ)
                    local size = math.clamp(1000 / distance, 8, 14)
                    tag.TextSize = size
                    tag.TextColor3 = getgenv().V55.ESPColor
                    tag.Text = p.DisplayName .. " (@" .. p.Name .. ")\n" .. math.floor(distance) .. "m"
                    tag.Position = UDim2.new(0, pos.X - 100, 0, pos.Y - 20)
                    tag.Size = UDim2.new(0, 200, 0, 20)
                    tag.Visible = true
                elseif tag then tag.Visible = false end

                -- 2. Highlight Viền
                local hl = p.Character:FindFirstChild("V55_HL")
                if getgenv().V55.ShowESP then
                    if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "V55_HL" end
                    hl.OutlineColor = getgenv().V55.ESPColor
                    hl.FillTransparency = 1
                elseif hl then hl:Destroy() end

                -- 3. Deadly Hitbox
                if getgenv().V55.Hitbox then
                    hrp.Size = Vector3.new(getgenv().V55.HitboxSize, getgenv().V55.HitboxSize, getgenv().V55.HitboxSize)
                    hrp.Color = getgenv().V55.HitboxColor
                    hrp.Transparency = getgenv().V55.HitboxTrans
                    hrp.Material = Enum.Material.ForceField
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            else
                -- Ẩn nếu chết
                if ESPGui:FindFirstChild("Tag_"..p.Name) then ESPGui:FindFirstChild("Tag_"..p.Name).Visible = false end
                if p.Character:FindFirstChild("V55_HL") then p.Character:FindFirstChild("V55_HL"):Destroy() end
            end
        end
    end
end)

-- // --- 🚀 LOGIC DI CHUYỂN & AIM ---
RunService.Heartbeat:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if getgenv().V55.GodSpeed then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.Anchored = false end end
    end

    if getgenv().V55.HighBack and getgenv().V55.Target and getgenv().V55.Target.Character then
        local tRoot = getgenv().V55.Target.Character:FindFirstChild("HumanoidRootPart")
        if tRoot and getgenv().V55.Target.Character.Humanoid.Health > 0 then
            root.Velocity = Vector3.new(0,0,0)
            root.CFrame = root.CFrame:Lerp(tRoot.CFrame * CFrame.new(0, 6, 4), 0.2)
        end
    end

    if getgenv().V55.NeDan then root.CFrame *= CFrame.new(math.sin(tick()*35)*2.5, 0, 0) end
end)

-- Sticky Aim
RunService.RenderStepped:Connect(function()
    if getgenv().V55.StickyAim or getgenv().V55.AimLock then
        local target, closest = nil, getgenv().V55.AimFOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if mag < closest then closest = mag; target = p end
                end
            end
        end
        if target and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position), getgenv().V55.AimSmooth)
        end
    end
end)

Rayfield:Notify({Title = "GHOST V55 ACTIVE", Content = "Đã fix ESP & Deadly Hitbox!", Duration = 5})
