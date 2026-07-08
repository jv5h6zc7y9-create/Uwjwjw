-- BROSA ESP - СКЕЛЕТ + НИК ЧЕРЕЗ СТЕНЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")

local GUI = Instance.new("ScreenGui")
GUI.Name = "BrosaESP"
GUI.ResetOnSpawn = false
GUI.Parent = LocalPlayer.PlayerGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 45, 0, 45)
btn.Position = UDim2.new(0, 15, 0, 150)
btn.BackgroundColor3 = Color3.fromRGB(255, 106, 193)
btn.BorderSizePixel = 0
btn.Text = "ESP"
btn.Font = Enum.Font.GothamBlack
btn.TextSize = 12
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.AutoButtonColor = false
btn.Parent = GUI
Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

local enabled = false

btn.MouseButton1Click:Connect(function()
    enabled = not enabled
    btn.BackgroundColor3 = enabled and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(255, 106, 193)
end)

-- Части скелета (соединения)
local bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

spawn(function()
    while true do
        if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
                        local hum = plr.Character.Humanoid
                        if hum.Health > 0 then
                            local char = plr.Character
                            
                            -- Скелет (кости)
                            for _, bone in ipairs(bones) do
                                local part1 = char:FindFirstChild(bone[1])
                                local part2 = char:FindFirstChild(bone[2])
                                
                                if part1 and part2 then
                                    local line = Drawing.new("Line")
                                    line.From = part1.Position
                                    line.To = part2.Position
                                    line.Color = Color3.fromRGB(255, 255, 255)
                                    line.Thickness = 1.5
                                    line.Transparency = 0.7
                                    line.Visible = true
                                    
                                    delay(0.03, function()
                                        line:Remove()
                                    end)
                                end
                            end
                            
                            -- Голова (точка)
                            local head = char.Head
                            local headCircle = Drawing.new("Circle")
                            headCircle.Position = head.Position
                            headCircle.Radius = 0.5
                            headCircle.Color = Color3.fromRGB(255, 106, 193)
                            headCircle.Thickness = 1
                            headCircle.Filled = true
                            headCircle.Transparency = 0.5
                            headCircle.Visible = true
                            
                            -- Ник над головой
                            local nameText = Drawing.new("Text")
                            nameText.Text = plr.Name
                            nameText.Position = head.Position + Vector3.new(0, 1.8, 0)
                            nameText.Color = Color3.fromRGB(255, 255, 255)
                            nameText.Size = 14
                            nameText.Center = true
                            nameText.Outline = true
                            nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
                            nameText.Visible = true
                            
                            -- HP под ником
                            local hpText = Drawing.new("Text")
                            hpText.Text = "[" .. math.floor(hum.Health) .. " HP]"
                            hpText.Position = head.Position + Vector3.new(0, 0.5, 0)
                            hpText.Color = Color3.fromRGB(52, 199, 89)
                            hpText.Size = 12
                            hpText.Center = true
                            hpText.Outline = true
                            hpText.OutlineColor = Color3.fromRGB(0, 0, 0)
                            hpText.Visible = true
                            
                            delay(0.03, function()
                                headCircle:Remove()
                                nameText:Remove()
                                hpText:Remove()
                            end)
                        end
                    end
                end
            end)
        end
        wait(0.03)
    end
end)

print("BROSA ESP SKELETON + NAME загружен!")
