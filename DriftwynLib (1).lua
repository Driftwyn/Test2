-- DriftwynUI Library Module

local DriftwynUI = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local configFile = "DriftwynConfig.json"
local config = {}

local function saveConfig()
    if writefile then
        writefile(configFile, HttpService:JSONEncode(config))
    end
end

local function loadConfig()
    if isfile and isfile(configFile) then
        local data = readfile(configFile)
        config = HttpService:JSONDecode(data)
    end
end

loadConfig()

function DriftwynUI:CreateWindow(titleText)
    local gui = Instance.new("ScreenGui", gethui and gethui() or player:WaitForChild("PlayerGui"))
    gui.Name = "DriftwynExploitUI"

    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.BackgroundColor3 = Color3.fromRGB(45, 0, 70)
    window.Active = true
    window.Draggable = true
    window.Parent = gui
    Instance.new("UICorner", window).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", window)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = titleText or "Driftwyn UI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)

    local tabBar = Instance.new("Frame", window)
    tabBar.Size = UDim2.new(0, 120, 1, -40)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

    local contentFrame = Instance.new("Frame", window)
    contentFrame.Position = UDim2.new(0, 130, 0, 45)
    contentFrame.Size = UDim2.new(1, -140, 1, -55)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
    contentFrame.ClipsDescendants = true
    Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

    local function clearContent()
        for _, child in pairs(contentFrame:GetChildren()) do
            if not child:IsA("UICorner") then
                child:Destroy()
            end
        end
    end

    local self = {}

    function self:AddTab(tabName)
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(1, 0, 0, 40)
        tab.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
        tab.Text = tabName
        tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.Font = Enum.Font.GothamBold
        tab.TextSize = 14
        tab.Parent = tabBar
        Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 6)

        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 1, 0)
        section.BackgroundTransparency = 1
        section.Parent = contentFrame
        section.Visible = false

        tab.MouseButton1Click:Connect(function()
            clearContent()
            section.Visible = true
        end)

        local t = {}

        function t:AddLabel(text)
            local lbl = Instance.new("TextLabel", section)
            lbl.Size = UDim2.new(1, -20, 0, 30)
            lbl.Position = UDim2.new(0, 10, 0, #section:GetChildren() * 35)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.TextSize = 16
            return lbl
        end

        function t:AddButton(text, callback)
            local btn = Instance.new("TextButton", section)
            btn.Size = UDim2.new(0, 200, 0, 30)
            btn.Position = UDim2.new(0, 10, 0, #section:GetChildren() * 35)
            btn.Text = text
            btn.BackgroundColor3 = Color3.fromRGB(100, 0, 130)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.MouseButton1Click:Connect(callback)
            return btn
        end

        function t:AddTextbox(placeholder, callback)
            local box = Instance.new("TextBox", section)
            box.Size = UDim2.new(0, 200, 0, 30)
            box.Position = UDim2.new(0, 10, 0, #section:GetChildren() * 35)
            box.PlaceholderText = placeholder
            box.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.Font = Enum.Font.Gotham
            box.TextSize = 14
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                callback(box.Text)
            end)
            return box
        end

        function t:AddToggle(labelText, default, callback)
            local toggle = Instance.new("TextButton", section)
            toggle.Size = UDim2.new(0, 200, 0, 30)
            toggle.Position = UDim2.new(0, 10, 0, #section:GetChildren() * 35)
            toggle.Text = default and labelText .. ": ON" or labelText .. ": OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 130)
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Font = Enum.Font.GothamBold
            toggle.TextSize = 14
            Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)
            local state = default
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = state and labelText .. ": ON" or labelText .. ": OFF"
                callback(state)
            end)
            return toggle
        end

        self[tabName] = t
        return t
    end

    return self
end

return DriftwynUI
