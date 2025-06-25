-- DriftwynLib - Full UI Library (With Toggle, Keybind, Textbox, Theme support)

local Players     = game:GetService("Players")
local UIS         = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService= game:GetService("TweenService")
local RunService  = game:GetService("RunService")
local player      = Players.LocalPlayer

-- Preloader UI
local loader = Instance.new("ScreenGui")
loader.Name = "DriftwynUILoader"
loader.ResetOnSpawn = false
loader.IgnoreGuiInset = true
loader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loader.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bg.BorderSizePixel = 0
bg.Parent = loader

local txt = Instance.new("TextLabel")
txt.AnchorPoint = Vector2.new(0.5, 0.5)
txt.Position = UDim2.new(0.5, 0, 0.5, 0)
txt.Size = UDim2.new(0, 240, 0, 50)
txt.BackgroundTransparency = 1
txt.TextColor3 = Color3.new(1, 1, 1)
txt.Font = Enum.Font.GothamBold
txt.TextSize = 20
txt.Text = "Driftwyn Hub Loading..."
txt.Parent = bg

for i = 1, 3 do
    txt.Text = "Driftwyn Hub Loading" .. string.rep(".", i)
    wait(0.5)
end

txt.Text = "Loading Complete!"
wait(0.6)
loader:Destroy()

local DriftwynLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

function DriftwynLib:CreateWindow(config)
    local self = {}
    self.Title = config.Name or "Driftwyn UI"
    self.Tabs = {}
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local DriftwynUI = Instance.new("ScreenGui")
    DriftwynUI.Name = "DriftwynUI"
    DriftwynUI.Parent = playerGui
    DriftwynUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.828697443, -250, 0.961538434, -175)
    MainFrame.Size = UDim2.new(0, 618, 0, 350)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = DriftwynUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

	local TopFrame = Instance.new("Frame")
TopFrame.Name = "TopFrame"
TopFrame.Parent = MainFrame
TopFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TopFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
TopFrame.BorderSizePixel = 0
TopFrame.Size = UDim2.new(0, 623, 0, 6)

	local LeftFrame = Instance.new("Frame")
LeftFrame.Name = "LeftFrame"
LeftFrame.Parent = MainFrame
LeftFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LeftFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftFrame.BorderSizePixel = 0
LeftFrame.Position = UDim2.new(0, 0, 0.0171428565, 0)
LeftFrame.Size = UDim2.new(0, 8, 0, 338)

	local ButtomFrame = Instance.new("Frame")
ButtomFrame.Name = "ButtomFrame"
ButtomFrame.Parent = MainFrame
ButtomFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ButtomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtomFrame.BorderSizePixel = 0
ButtomFrame.Position = UDim2.new(0, 0, 0.982857168, 0)
ButtomFrame.Size = UDim2.new(0, 618, 0, 6)

	local RightFrame = Instance.new("Frame")
RightFrame.Name = "RightFrame"
RightFrame.Parent = MainFrame
RightFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RightFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
RightFrame.BorderSizePixel = 0
RightFrame.Position = UDim2.new(0.995326877, 0, 0.0171428565, 0)
RightFrame.Size = UDim2.new(0, 8, 0, 344)

    
    -- Mobile-only toggle button
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        local ToggleButton = Instance.new("ImageButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 40, 0, 40)
        ToggleButton.Position = UDim2.new(0, 10, 0, 10)
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Image = "rbxassetid://6031091002"
        ToggleButton.Parent = DriftwynUI
    
        local draggingToggle; local dragStart; local startPos
        ToggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingToggle = true
                dragStart = input.Position
                startPos = ToggleButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then 
                        draggingToggle = false 
                    end
                end)
            end
        end)
    
        UserInputService.InputChanged:Connect(function(input)
            if draggingToggle and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                local delta = input.Position - dragStart
                ToggleButton.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    
        local isVisible = true
        local hideTween = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0)
        })
        local showTween = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
    
        ToggleButton.MouseButton1Click:Connect(function()
            if isVisible then hideTween:Play() else showTween:Play() end
            isVisible = not isVisible
        end)
    end
    
    -- Make main frame draggable
    local dragging; local dragStart2; local startPos2
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart2 = input.Position
            startPos2 = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart2
            MainFrame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
        end
    end)
    
    -- Title label and content frames
    local Title = Instance.new("TextLabel")
    Title.Text = self.Title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.013, 0, 0.017, 0)
    Title.Size = UDim2.new(0.6, 0, 0, 40)
    Title.Parent = MainFrame
    
    local TabButtonsFrame = Instance.new("ScrollingFrame")
    TabButtonsFrame.Name = "TabButtons"
    TabButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
    TabButtonsFrame.Size = UDim2.new(0, 120, 1, -40)
    TabButtonsFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
    TabButtonsFrame.ScrollBarThickness = 4
    TabButtonsFrame.Parent = MainFrame
    Instance.new("UIListLayout", TabButtonsFrame")

	local LeftFrame = Instance.new("Frame")
LeftFrame.Name = "LeftFrame"
LeftFrame.Parent = MainFrame
LeftFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LeftFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftFrame.BorderSizePixel = 0
LeftFrame.Position = UDim2.new(0, 0, 0.0171428565, 0)
LeftFrame.Size = UDim2.new(0, 8, 0, 338)
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Position = UDim2.new(0, 130, 0, 40)
    ContentFrame.Size = UDim2.new(1, -140, 1, -50)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 6)
    
    -- Switch visible tab
    function self:SetActiveTab(name)
        for _, t in ipairs(self.Tabs) do
            local active = (t.Name == name)
            t.Content.Visible = active
            t.Button.BackgroundColor3 = active and Color3.fromRGB(70,70,100) or Color3.fromRGB(45,45,60)
        end
    end
    
    -- Add a new tab
    function self:AddTab(cfg)
        local tab = {Name = cfg.Name or "Tab"}
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 30)
        btn.Text = tab.Name
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(45,45,60)
        btn.BorderSizePixel = 0
        btn.Parent = TabButtonsFrame
    
        local content = Instance.new("ScrollingFrame")
        content.Name = tab.Name.."_Content"
        content.Size = UDim2.new(1,0,1,0)
        content.BackgroundTransparency = 1
        content.Visible = false
        content.ScrollBarThickness = 4
        content.CanvasSize = UDim2.new(0,0,5,0)
        content.Parent = ContentFrame
    
        local layout = Instance.new("UIListLayout", content)
        layout.Padding = UDim.new(0,10)
    
        tab.Button = btn
        tab.Content = content
    
        btn.MouseButton1Click:Connect(function()
            self:SetActiveTab(tab.Name)
        end)
    
        function tab:AddSection(cfg2)
            local section = {}
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1,-10,0,0)
            frame.AutomaticSize = Enum.AutomaticSize.Y
            frame.BackgroundColor3 = Color3.fromRGB(40,40,60)
            frame.BorderSizePixel = 0
            frame.Parent = content
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
            Instance.new("UIListLayout", frame).Padding = UDim.new(0,6)
    
            local title = Instance.new("TextLabel")
            title.Text = cfg2.Name or "Section"
            title.Font = Enum.Font.GothamBold
            title.TextSize = 16
            title.TextColor3 = Color3.fromRGB(255,255,255)
            title.BackgroundTransparency = 1
            title.Size = UDim2.new(1,-20,0,25)
            title.Parent = frame
    
            -- UI functions
            function section:AddButton(o)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1,-20,0,30)
                b.Text = o.Name or "Button"
                b.Font = Enum.Font.Gotham
                b.TextSize = 14
                b.TextColor3 = Color3.fromRGB(255,255,255)
                b.BackgroundColor3 = Color3.fromRGB(60,60,85)
                b.Parent = frame
                Instance.new("UICorner", b)
                if o.Callback then b.MouseButton1Click:Connect(o.Callback) end
            end
    
            function section:AddToggle(o)
                local state = o.Default or false
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1,-20,0,30)
                b.Text = (state and "[✓] " or "[ ] ")..o.Name
                b.Font = Enum.Font.Gotham
                b.TextSize = 14
                b.TextColor3 = Color3.fromRGB(255,255,255)
                b.BackgroundColor3 = Color3.fromRGB(60,60,85)
                b.Parent = frame
                Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(function()
                    state = not state
                    b.Text = (state and "[✓] " or "[ ] ")..o.Name
                    if o.Callback then o.Callback(state) end
                end)
            end
    
            function section:AddTextbox(o)
                local tb = Instance.new("TextBox")
                tb.Size = UDim2.new(1,-20,0,30)
                tb.PlaceholderText = o.Name
                tb.Font = Enum.Font.Gotham
                tb.TextSize = 14
                tb.BackgroundColor3 = Color3.fromRGB(60,60,85)
                tb.TextColor3 = Color3.fromRGB(255,255,255)
                tb.Parent = frame
                Instance.new("UICorner", tb)
                if o.Callback then tb.FocusLost:Connect(function() o.Callback(tb.Text) end) end
            end

            function section:AddLabel(o)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Text = o.Text or "Label"
    label.Font = o.Font or Enum.Font.Gotham
    label.TextSize = o.TextSize or 14
    label.TextWrapped = true
    label.TextColor3 = o.TextColor or Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Parent = frame
end
    
            function section:AddKeybind(o)
                local key = o.Default or Enum.KeyCode.F
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1,-20,0,30)
                b.Text = o.Name.. ": "..key.Name
                b.Font = Enum.Font.Gotham
                b.TextSize = 14
                b.TextColor3 = Color3.fromRGB(255,255,255)
                b.BackgroundColor3 = Color3.fromRGB(60,60,85)
                b.Parent = frame
                Instance.new("UICorner", b)
                local rebinding = false
    
                b.MouseButton1Click:Connect(function()
                    b.Text = "Press any key..."
                    rebinding = true
                end)
    
                UserInputService.InputBegan:Connect(function(i, gp)
                    if not gp and rebinding and i.UserInputType == Enum.UserInputType.Keyboard then
                        key = i.KeyCode
                        b.Text = o.Name..": "..key.Name
                        rebinding = false
                    elseif i.KeyCode == key and not rebinding then
                        if o.Callback then o.Callback() end
                    end
                end)
            end
    
            function section:AddSlider(cfg)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Text = cfg.Name .. ": " .. tostring(cfg.Default or 0)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Parent = frame -- ✅ Correct parent

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
    sliderBg.Parent = frame -- ✅ Correct parent
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

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    -- Set default
    local default = cfg.Default or 0
    local min = cfg.Min or 0
    local max = cfg.Max or 100
    local defaultPct = (default - min) / (max - min)
    fill.Size = UDim2.new(defaultPct, 0, 1, 0)
end
    
            function section:AddDropdown(o)
                local state = false
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1,-20,0,30)
                b.Text = o.Name
                b.Font = Enum.Font.Gotham
                b.TextSize = 14
                b.TextColor3 = Color3.fromRGB(255,255,255)
                b.BackgroundColor3 = Color3.fromRGB(60,60,85)
                b.Parent = frame
                Instance.new("UICorner", b)
    
                local list = Instance.new("Frame")
                list.BackgroundColor3 = Color3.fromRGB(70,70,100)
                list.Size = UDim2.new(1,-20,0,0)
                list.Visible = false
                list.Parent = frame
                local layout = Instance.new("UIListLayout", list)
    
                b.MouseButton1Click:Connect(function()
                    state = not state
                    list.Visible = state
                    list.Size = UDim2.new(1,-20,0,#o.Options*30)
                end)
    
                for _, opt in ipairs(o.Options or {}) do
                    local optb = Instance.new("TextButton")
                    optb.Size = UDim2.new(1,0,0,30)
                    optb.Text = opt
                    optb.Font = Enum.Font.Gotham
                    optb.TextSize = 14
                    optb.TextColor3 = Color3.fromRGB(255,255,255)
                    optb.BackgroundColor3 = Color3.fromRGB(80,80,110)
                    optb.Parent = list
    
                    optb.MouseButton1Click:Connect(function()
                        b.Text = o.Name..": "..opt
                        state = false
                        list.Visible = false
                        if o.Callback then o.Callback(opt) end
                    end)
                end
            end -- end dropdown
    
            return section
        end -- end AddSection
    
        self.Tabs[#self.Tabs+1] = tab

-- Auto set the first tab as default
if #self.Tabs == 1 then
    self:SetActiveTab(tab.Name)
end

return tab

    end -- end Create Tab
    
    self.SetActiveTab = self.SetActiveTab
    self.AddTab = self.AddTab
    return self
end -- end CreateWindow

function DriftwynLib:ShowProgress(duration, text)
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screen = Instance.new("ScreenGui", playerGui)
    screen.Name = "ProgressBarGui"
    screen.ResetOnSpawn = false

    local barBackground = Instance.new("Frame", screen)
    barBackground.Size = UDim2.new(0, 300, 0, 30)
    barBackground.Position = UDim2.new(0.5, -150, 0.85, 0)
    barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    barBackground.BorderSizePixel = 0
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 6)

    local barFill = Instance.new("Frame", barBackground)
    barFill.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
    barFill.BorderSizePixel = 0
    barFill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", barBackground)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Text = text or "Loading..."

    -- Run progress
    task.spawn(function()
        for i = 1, duration do
            local pct = i / duration
            local blocks = math.floor(pct * 20)
            local barString = "[" .. string.rep("█", blocks) .. string.rep(" ", 20 - blocks) .. "] " .. i .. "/" .. duration .. " seconds"
            print(barString)
            barFill:TweenSize(UDim2.new(pct, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            wait(1)
        end
        screen:Destroy()
    end)
end

return DriftwynLib
