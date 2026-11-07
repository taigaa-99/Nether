-- TAIGA HUB | Respawn + Die TP (Oyun İçi Tuş Değiştirme Panelli)

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local playerGui = player:WaitForChild("PlayerGui")

local deathPos = nil

-- Aktif Tuş Değişkenleri (Varsayılanlar)
local currentKeys = {
    Toggle = Enum.KeyCode.K,
    Respawn = Enum.KeyCode.R,
    DieTP = Enum.KeyCode.F
}

local waitingForKey = nil -- Hangi tuşun değiştirilmesi için bekleniyor?

-- Eski GUI varsa temizle
pcall(function()
    playerGui.RespawnGui:Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "RespawnGui"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. ANA MENÜ
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 180)
frame.Position = UDim2.new(0.5, -115, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Visible = false

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 14)

-- RESPAWN BUTTON
local respawnBtn = Instance.new("TextButton", frame)
respawnBtn.Size = UDim2.new(1, -20, 0, 35)
respawnBtn.Position = UDim2.new(0, 10, 0, 15)
respawnBtn.Text = "Respawn [R]"
respawnBtn.TextScaled = true
respawnBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
respawnBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", respawnBtn)

-- DIE TP BUTTON
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, -20, 0, 35)
tpBtn.Position = UDim2.new(0, 10, 0, 58)
tpBtn.Text = "Die TP [F]"
tpBtn.TextScaled = true
tpBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
tpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBtn)

-- TUŞLARI DEĞİŞTİRME PANELİNİ AÇMA BUTONU
local settingsBtn = Instance.new("TextButton", frame)
settingsBtn.Size = UDim2.new(1, -20, 0, 30)
settingsBtn.Position = UDim2.new(0, 10, 0, 101)
settingsBtn.Text = "Tuşları Değiştir"
settingsBtn.TextScaled = true
settingsBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
settingsBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", settingsBtn)

-- CREDIT
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -22)
credit.BackgroundTransparency = 1
credit.Text = "Tiktok: taigaa_99"
credit.TextScaled = true
credit.TextColor3 = Color3.fromRGB(200,200,200)

-- 2. TUŞ SEÇME PENCERESİ (Ayarlara basınca açılır)
local settingsFrame = Instance.new("Frame", gui)
settingsFrame.Size = UDim2.new(0, 220, 0, 170)
settingsFrame.Position = UDim2.new(0.5, -110, 0.5, -85)
settingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 14)

local settingsTitle = Instance.new("TextLabel", settingsFrame)
settingsTitle.Size = UDim2.new(1, 0, 0, 30)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Bir Tuş Seçin"
settingsTitle.TextScaled = true
settingsTitle.TextColor3 = Color3.new(1,1,1)

local bindRespawnBtn = Instance.new("TextButton", settingsFrame)
bindRespawnBtn.Size = UDim2.new(1, -20, 0, 35)
bindRespawnBtn.Position = UDim2.new(0, 10, 0, 40)
bindRespawnBtn.Text = "Respawn Tuşu: R"
bindRespawnBtn.TextScaled = true
bindRespawnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
bindRespawnBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", bindRespawnBtn)

local bindTpBtn = Instance.new("TextButton", settingsFrame)
bindTpBtn.Size = UDim2.new(1, -20, 0, 35)
bindTpBtn.Position = UDim2.new(0, 10, 0, 80)
bindTpBtn.Text = "Die TP Tuşu: F"
bindTpBtn.TextScaled = true
bindTpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
bindTpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", bindTpBtn)

local closeSettingsBtn = Instance.new("TextButton", settingsFrame)
closeSettingsBtn.Size = UDim2.new(1, -20, 0, 30)
closeSettingsBtn.Position = UDim2.new(0, 10, 0, 125)
closeSettingsBtn.Text = "Geri Dön"
closeSettingsBtn.TextScaled = true
closeSettingsBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
closeSettingsBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeSettingsBtn)

-- 3. DIŞ EKRAN "T" LOGO BUTONU
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 20, 0.5, -30)
openBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
openBtn.Text = "T"
openBtn.TextSize = 38
openBtn.TextColor3 = Color3.fromRGB(210, 25, 25)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.BorderSizePixel = 0

local stroke = Instance.new("UIStroke", openBtn)
stroke.Color = Color3.fromRGB(210, 25, 25)
stroke.Thickness = 4
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- FONKSİYONLAR
local function triggerRespawn()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        deathPos = player.Character.HumanoidRootPart.CFrame
        player.Character:BreakJoints()
    end
end

local function triggerDieTP()
    if deathPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = deathPos
    end
end

respawnBtn.MouseButton1Click:Connect(triggerRespawn)
tpBtn.MouseButton1Click:Connect(triggerDieTP)

settingsBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    settingsFrame.Visible = true
end)

closeSettingsBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
    frame.Visible = true
end)

-- Tuş değiştirme tetikleyicileri
bindRespawnBtn.MouseButton1Click:Connect(function()
    bindRespawnBtn.Text = "Bir tuşa basın..."
    waitingForKey = "Respawn"
end)

bindTpBtn.MouseButton1Click:Connect(function()
    bindTpBtn.Text = "Bir tuşa basın..."
    waitingForKey = "DieTP"
end)

-- SÜRÜKLEME SİSTEMİ
local function makeDraggable(obj)
    local dragging = false
    local dragStart, startPos

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(frame)
makeDraggable(settingsFrame)
makeDraggable(openBtn)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    settingsFrame.Visible = false
end)

-- KLAVYE DİNLEME VE TUŞ ATAMA MANTIĞI
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if waitingForKey then
            -- Yeni tuş atanıyor
            currentKeys[waitingForKey] = input.KeyCode
            if waitingForKey == "Respawn" then
                respawnBtn.Text = "Respawn [" .. input.KeyCode.Name .. "]"
                bindRespawnBtn.Text = "Respawn Tuşu: " .. input.KeyCode.Name
            elseif waitingForKey == "DieTP" then
                tpBtn.Text = "Die TP [" .. input.KeyCode.Name .. "]"
                bindTpBtn.Text = "Die TP Tuşu: " .. input.KeyCode.Name
            end
            waitingForKey = nil
        elseif not gameProcessed then
            -- Normal tuş kontrolleri
            if input.KeyCode == currentKeys.Toggle then
                frame.Visible = not frame.Visible
                settingsFrame.Visible = false
            elseif input.KeyCode == currentKeys.Respawn then
                triggerRespawn()
            elseif input.KeyCode == currentKeys.DieTP then
                triggerDieTP()
            end
        end
    end
end)
