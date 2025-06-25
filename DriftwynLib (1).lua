-- DriftwynUI Library Module (UI Updated to Match Full Library Appearance)

local DriftwynUI = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

function DriftwynUI:CreateWindow(titleText)
    local gui = Instance.new("ScreenGui", gethui and gethui() or player:WaitForChild("PlayerGui"))
    gui.Name = "DriftwynExploitUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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

    local tabBar = Instance.new("ScrollingFrame", window)
    tabBar.Size = UDim2.new(0, 120, 1, -40)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabBar.ScrollBarThickness = 4
    tabBar.CanvasSize = UDim2.new(0, 0, 5, 0)
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

    local tabListLayout = Instance.new("UIListLayout", tabBar)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 4)

    local contentFrame = Instance.new("Frame", window)
    contentFrame.Position = UDim2.new(0, 130, 0, 45)
    contentFrame.Size = UDim2.new(1, -140, 1, -55)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    contentFrame.ClipsDescendants = true
    Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

    local tabSections = {}
    local tabButtons = {}
    local self = {}

    local function showTab(tabName)
        for name, section in pairs(tabSections) do
            section.Visible = (name == tabName)
            local button = tabButtons[name]
            local goalColor = name == tabName and Color3.fromRGB(70,70,100) or Color3.fromRGB(45,45,60)
            TweenService:Create(button, TweenInfo.new(0.25), {BackgroundColor3 = goalColor}):Play()
        end
    end

    function self:AddTab(cfg)
        local tabName = cfg.Name or "Tab"

        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(1, -8, 0, 30)
        tab.BackgroundColor3 = Color3.fromRGB(45,45,60)
        tab.Text = tabName
        tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.Font = Enum.Font.Gotham
        tab.TextSize = 14
        tab.BorderSizePixel = 0
        tab.Parent = tabBar
        Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 6)

        local section = Instance.new("ScrollingFrame")
        section.Size = UDim2.new(1, 0, 1, 0)
        section.BackgroundTransparency = 1
        section.ScrollBarThickness = 4
        section.CanvasSize = UDim2.new(0, 0, 5, 0)
        section.Visible = false
        section.Parent = contentFrame

        local layout = Instance.new("UIListLayout", section)
        layout.Padding = UDim.new(0, 10)

        tabSections[tabName] = section
        tabButtons[tabName] = tab

        tab.MouseButton1Click:Connect(function()
            showTab(tabName)
        end)

        if not next(tabSections, tabName) then
            showTab(tabName)
        end

        -- Inject UI elements into section
        function section:AddButton(cfg)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 30)
    b.Text = cfg.Name or "Button"
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
    b.Parent = section
    Instance.new("UICorner", b)

    if cfg.Callback then
        b.MouseButton1Click:Connect(cfg.Callback)
    end
end

        function section:AddTextbox(cfg)
            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(1, -20, 0, 30)
            tb.PlaceholderText = cfg.Name or "Textbox"
            tb.Font = Enum.Font.Gotham
            tb.TextSize = 14
            tb.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
            tb.TextColor3 = Color3.fromRGB(255, 255, 255)
            tb.Parent = section
            Instance.new("UICorner", tb)
            if cfg.Callback then
                tb.FocusLost:Connect(function()
                    cfg.Callback(tb.Text)
                end)
            end
        end

        function section:AddSlider(cfg)
             local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Text = cfg.Name .. ": " .. tostring(cfg.Default or 0)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
            label.Parent = section

            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -20, 0, 8)
            sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
            sliderBg.Parent = section
            sliderBg.BorderSizePixel = 0
            Instance.new("UICorner", sliderBg)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
            fill.BorderSizePixel = 0
            fill.Parent = sliderBg
            Instance.new("UICorner", fill)

            local dragging = false
            local function updateSlider(input)
                local rel = input.Position.X - sliderBg.AbsolutePosition.X
                local pct = math.clamp(rel / sliderBg.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                local value = math.floor((cfg.Min or 0) + ((cfg.Max or 100) - (cfg.Min or 0)) * pct)
                label.Text = cfg.Name .. ": " .. tostring(value)
                if cfg.Callback then cfg.Callback(value) end
            end

            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local default = cfg.Default or min
            local pct = (default - min) / (max - min)
            fill.Size = UDim2.new(pct, 0, 1, 0)
        end

        function section:AddDropdown(cfg)
        local state = false
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,-20,0,30)
            b.Text = cfg.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.BackgroundColor3 = Color3.fromRGB(60,60,85)
            b.Parent = section
            Instance.new("UICorner", b)

            local list = Instance.new("Frame")
            list.BackgroundColor3 = Color3.fromRGB(70,70,100)
            list.Size = UDim2.new(1,-20,0,0)
            list.Visible = false
            list.Parent = section
            local layout = Instance.new("UIListLayout", list)

            b.MouseButton1Click:Connect(function()
                state = not state
                list.Visible = state
                list.Size = UDim2.new(1,-20,0,#cfg.Options*30)
            end)
        end

        function section:AddMultiDropdown(cfg)
            local selected = {}
            local state = false

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -20, 0, 30)
            b.Text = cfg.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
            b.Parent = section
            Instance.new("UICorner", b)

            local list = Instance.new("Frame")
            list.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
            list.Size = UDim2.new(1, -20, 0, 0)
            list.Visible = false
            list.Parent = section

            local layout = Instance.new("UIListLayout", list)

            local function updateText()
                local entries = {}
                for name in pairs(selected) do
                    table.insert(entries, name)
                end
                b.Text = cfg.Name .. ": " .. table.concat(entries, ", ")
            end

            b.MouseButton1Click:Connect(function()
                state = not state
                list.Visible = state
                list.Size = UDim2.new(1, -20, 0, #cfg.Options * 30)
            end)

            for _, opt in ipairs(cfg.Options or {}) do
                local optb = Instance.new("TextButton")
                optb.Size = UDim2.new(1, 0, 0, 30)
                optb.Text = "[ ] " .. opt
                optb.Font = Enum.Font.Gotham
                optb.TextSize = 14
                optb.TextColor3 = Color3.fromRGB(255, 255, 255)
                optb.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
                optb.Parent = list

                if cfg.Defaults and table.find(cfg.Defaults, opt) then
                    selected[opt] = true
                    optb.Text = "[✓] " .. opt
                    updateText()
                end

                optb.MouseButton1Click:Connect(function()
                    if selected[opt] then
                        selected[opt] = nil
                        optb.Text = "[ ] " .. opt
                    else
                        selected[opt] = true
                        optb.Text = "[✓] " .. opt
                    end
                    updateText()
                    local selectedList = {}
                    for key in pairs(selected) do
                        table.insert(selectedList, key)
                    end
                    if cfg.Callback then cfg.Callback(selectedList) end
        end

        return section
    end

    return self
end

return DriftwynUI
