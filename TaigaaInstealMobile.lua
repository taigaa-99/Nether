local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.Text = "TaigaHub"
Label.TextColor3 = Color3.fromRGB(245, 245, 245)
Label.Parent = Frame
