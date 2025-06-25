-- DriftwynUI Library Module (Tab System Only)

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

    local function showTab(tabName)
        for name, section in pairs(tabSections) do
            section.Visible = (name == tabName)
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
            showTab(tabName)
        end)

        tabSections[tabName] = section

        return section
    end

    return self
end

return DriftwynUI
