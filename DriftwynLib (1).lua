-- DriftwynUI Library Module (Tab System Only, using cfg.Name)

local DriftwynUI = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer

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

    local tabListLayout = Instance.new("UIListLayout", tabBar)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 4)

    local contentFrame = Instance.new("Frame", window)
    contentFrame.Position = UDim2.new(0, 130, 0, 45)
    contentFrame.Size = UDim2.new(1, -140, 1, -55)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
    contentFrame.ClipsDescendants = true
    Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

    local tabSections = {}
    local tabButtons = {}
    local self = {}

    function self:SetActiveTab(name)
        for tabName, section in pairs(tabSections) do
            section.Visible = (tabName == name)
            tabButtons[tabName].BackgroundColor3 = (tabName == name) and Color3.fromRGB(100, 0, 140) or Color3.fromRGB(80, 0, 120)
        end
    end

    function self:AddTab(cfg)
        local name = cfg.Name or "Tab"
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 30)
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        btn.BorderSizePixel = 0
        btn.Parent = tabBar

        local content = Instance.new("ScrollingFrame")
        content.Name = name .. "_Content"
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.Visible = false
        content.ScrollBarThickness = 4
        content.CanvasSize = UDim2.new(0, 0, 5, 0)
        content.Parent = contentFrame

        local layout = Instance.new("UIListLayout", content)
        layout.Padding = UDim.new(0, 10)

        tabSections[name] = content
        tabButtons[name] = btn

        btn.MouseButton1Click:Connect(function()
            self:SetActiveTab(name)
        end)

        -- Auto-select first tab
        if #tabBar:GetChildren() == 2 then
            self:SetActiveTab(name)
        end

        return content
    end

    return self
end

return DriftwynUI
