-- [[ TaigaHub V8.0 - Fixed UI & Load System ]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local States = {
    LockedBase = nil, -- Kaydettiğin konum
    Noclip = false,
    Speed = true,
    Flying = false,
    SpeedVal = 100,
    JumpVal = 50,
    IsBlinking = false
}

-- Tuş Atamaları Tablosu
local Keybinds = {
    TPBase = Enum.KeyCode.R,       -- 1. Yeşil Buton: Direkt Işınlanma
    BlinkKey = Enum.KeyCode.T,     -- 2. Buton: Gidip Hızlıca Geri Dönme (Blink)
    SetBaseKey = Enum.KeyCode.X,   -- Konum Sabitleme
    TPForward = Enum.KeyCode.Q,
    NoclipKey = Enum.KeyCode.N,
    SpeedKey = Enum.KeyCode.Z,
    FlyKey = Enum.KeyCode.F
}

-- O anki konumu sabitleyen fonksiyon
local function SetCustomBase()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        States.LockedBase = char.HumanoidRootPart.CFrame
        print("TaigaHub: Konum başarıyla sabitlendi!")
    end
end

-- Eski menü varsa temizle
if PlayerGui:FindFirstChild("TaigaHub_v8") then
    PlayerGui.TaigaHub_v8:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TaigaHub_v8"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Sürükleme Fonksiyonu
local function MakeDraggable(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ==================== AÇMA/KAPAMA BUTONU ====================
local ToggleButton = Instance.new("Frame", ScreenGui)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
ToggleButton.Position = UDim2.new(0.03, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 190, 0, 46)
ToggleButton.Active = true
ToggleButton.Draggable = false
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)
local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(255, 70, 70)
ToggleStroke.Thickness = 1.5
MakeDraggable(ToggleButton)

local ToggleBtnText = Instance.new("TextButton", ToggleButton)
ToggleBtnText.Size = UDim2.new(1, 0, 1, 0)
ToggleBtnText.BackgroundTransparency = 1
ToggleBtnText.Text = " ⚡ TAIGA HUB v8.0"
ToggleBtnText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtnText.Font = Enum.Font.GothamBold
ToggleBtnText.TextSize = 12
ToggleBtnText.TextXAlignment = Enum.TextXAlignment.Left

-- ==================== ANA MENÜ ====================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Position = UDim2.new(0.03, 0, 0.24, 0)
MainFrame.Size = UDim2.new(0, 265, 0, 460)
MainFrame.Visible = false
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(230, 40, 40)
MainStroke.Thickness = 1.5
MakeDraggable(MainFrame)

ToggleBtnText.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local HeaderFrame = Instance.new("Frame", MainFrame)
HeaderFrame.Size = UDim2.new(1, -20, 0, 42)
HeaderFrame.Position = UDim2.new(0, 10, 0, 10)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Instance.new("UICorner", HeaderFrame).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", HeaderFrame)
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "TAIGA HUB (CLICK TO REBIND)"
TitleLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 10

local ScrollContainer = Instance.new("ScrollingFrame", MainFrame)
ScrollContainer.Position = UDim2.new(0, 0, 0, 60)
ScrollContainer.Size = UDim2.new(1, 0, 1, -85)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(230, 40, 40)

local UIList = Instance.new("UIListLayout", ScrollContainer)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local FooterLabel = Instance.new("TextLabel", MainFrame)
FooterLabel.Size = UDim2.new(1, -16, 0, 20)
FooterLabel.Position = UDim2.new(0, 0, 1, -22)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text = "TikTok: @taigaa_34"
FooterLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
FooterLabel.Font = Enum.Font.GothamBold
FooterLabel.TextSize = 10
FooterLabel.TextXAlignment = Enum.TextXAlignment.Right

-- ==================== FONKSİYONLAR ====================

-- 1. Yeşil Buton: Kaydedilen konuma direkt ışınlan (Geri dönmez, orada kalır)
local function TPToLockedBase()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not States.LockedBase then
        print("TaigaHub: Önce bir konum kaydetmelisin! (Set Current Pos)")
        return
    end
    
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    hrp.CFrame = States.LockedBase
end

-- 2. Yeşil Butonun Altındaki: Kaydedilen konuma gidip anında eski yerine geri dönme (Çok hızlı Blink)
local function BlinkToLockedBase()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not States.LockedBase then
        print("TaigaHub: Önce bir konum kaydetmelisin! (Set Current Pos)")
        return
    end
    if States.IsBlinking then return end
    
    States.IsBlinking = true
    local originalPos = hrp.CFrame
    
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    -- Hedefe git
    hrp.CFrame = States.LockedBase
    RunService.Heartbeat:Wait()
    
    -- Hiç bekletmeden anında orijinal yerine dön
    if hrp and originalPos then
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = originalPos
    end
    
    States.IsBlinking = false
end

local function TPForward()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -12)
    end
end

-- Omni-Man Uçuş Sistemi
local BodyVelocity, BodyGyro
local function StartFlying()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    States.Flying = not States.Flying
    if States.Flying then
        BodyVelocity = Instance.new("BodyVelocity", hrp)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        BodyGyro = Instance.new("BodyGyro", hrp)
        BodyGyro.CFrame = hrp.CFrame
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.P = 10000
        
        task.spawn(function()
            while States.Flying do
                local camera = workspace.CurrentCamera
                local moveDir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
                
                BodyVelocity.Velocity = moveDir * 120
                BodyGyro.CFrame = camera.CFrame
                task.wait()
            end
            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end
        end)
    end
end

-- Tuş Değiştirme ve GUI Buton Tıklama Sistemi
local bindingKeyName = nil
local function CreateRebindableButton(baseText, keyNameRef, isGreen, onClickCustom)
    local btn = Instance.new("TextButton", ScrollContainer)
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.BackgroundColor3 = isGreen and Color3.fromRGB(0, 160, 75) or Color3.fromRGB(30, 30, 40)
    btn.Text = baseText .. " [" .. Keybinds[keyNameRef].Name .. "]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = isGreen and Color3.fromRGB(0, 210, 100) or Color3.fromRGB(50, 50, 70)
    btnStroke.Thickness = 1
    
    btn.MouseButton1Click:Connect(function()
        if bindingKeyName then return end
        if onClickCustom then
            onClickCustom()
        end
    end)
    
    btn.MouseButton2Click:Connect(function()
        bindingKeyName = keyNameRef
        btn.Text = baseText .. " [TUŞA BAS...]"
    end)
    
    return btn, function(newKeyName)
        Keybinds[keyNameRef] = newKeyName
        btn.Text = baseText .. " [" .. newKeyName.Name .. "]"
    end
end

-- Arayüz Sıralaması
local _, updateTPBaseText = CreateRebindableButton("TP to Locked Pos", "TPBase", true, TPToLockedBase)
local _, updateBlinkText = CreateRebindableButton("Instant Blink (Go & Back)", "BlinkKey", true, BlinkToLockedBase)
local _, updateSetBaseText = CreateRebindableButton("Set Current Pos", "SetBaseKey", false, SetCustomBase)
local _, updateTPFwdText = CreateRebindableButton("TP Forward", "TPForward", false, TPForward)
local _, updateNoclipText = CreateRebindableButton("NoClip", "NoclipKey", false, function() States.Noclip = not States.Noclip end)
local _, updateSpeedText = CreateRebindableButton("Speed", "SpeedKey", false, function() States.Speed = not States.Speed end)
local _, updateFlyText = CreateRebindableButton("Omni-Man Fly", "FlyKey", false, StartFlying)

-- Klavye Tuş Algılama ve Rebind (Tuş Atama)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard or input.KeyCode ~= Enum.KeyCode.Unknown then
        if bindingKeyName then
            Keybinds[bindingKeyName] = input.KeyCode
            if bindingKeyName == "TPBase" then updateTPBaseText(input.KeyCode)
            elseif bindingKeyName == "BlinkKey" then updateBlinkText(input.KeyCode)
            elseif bindingKeyName == "SetBaseKey" then updateSetBaseText(input.KeyCode)
            elseif bindingKeyName == "TPForward" then updateTPFwdText(input.KeyCode)
            elseif bindingKeyName == "NoclipKey" then updateNoclipText(input.KeyCode)
            elseif bindingKeyName == "SpeedKey" then updateSpeedText(input.KeyCode)
            elseif bindingKeyName == "FlyKey" then updateFlyText(input.KeyCode)
            end
            bindingKeyName = nil
            return
        end
        
        if gameProcessed then return end
        
        if input.KeyCode == Keybinds.TPBase then
            TPToLockedBase()
        elseif input.KeyCode == Keybinds.BlinkKey then
            task.spawn(BlinkToLockedBase)
        elseif input.KeyCode == Keybinds.SetBaseKey then
            SetCustomBase()
        elseif input.KeyCode == Keybinds.TPForward then
            TPForward()
        elseif input.KeyCode == Keybinds.NoclipKey then
            States.Noclip = not States.Noclip
        elseif input.KeyCode == Keybinds.SpeedKey then
            States.Speed = not States.Speed
        elseif input.KeyCode == Keybinds.FlyKey then
            StartFlying()
        end
    end
end)

-- Fizik ve Hız Döngüsü
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    if States.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = States.Speed and States.SpeedVal or 16
        hum.JumpPower = States.JumpVal
    end
end)

-- İnteraktif Prompt Sistemi
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    prompt.HoldDuration = 0
    if fireproximityprompt then
        fireproximityprompt(prompt)
    end
end)

print("TaigaHub v8.0 başarıyla yüklendi ve arayüz oluşturuldu!")
